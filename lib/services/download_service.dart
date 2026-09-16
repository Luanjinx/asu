import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_content_model.dart';

import 'encryption_service.dart';

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;
  static DownloadService get instance => _instance;
  DownloadService._internal();

  final Dio _dio = Dio();
  final Map<String, CancelToken> _active = {};
  final Map<int, String> _activeByContentId = {};
  final Map<int, double> _progressByContentId = {};
  final Map<int, void Function(double)> _callbacksByContentId = {};

  // ==================== Public Methods ====================

  Future<String> startDownload({
    required HiveContentModel item,
    required String url,
    void Function(double progress)? onProgress,
    bool encrypt = false,
  }) async {
    String ext = '.mp4';
    try {
      ext = extension(url);
      if (ext.isEmpty) {
        ext = '.mp4';
      }
    } catch (e) {}
    await _cancelExistingDownload(item.id);

    final id = _generateDownloadId(item.id);
    final cancel = CancelToken();
    _registerDownload(id, item.id, cancel);

    final dir = await _downloadsDir();
    final filePath = '${dir.path}/$id${ext}';

    final response = await _dio.get(
      url,
      options: Options(
        responseType: ResponseType.stream,
        receiveTimeout: const Duration(minutes: 30),
      ),
      cancelToken: cancel,
    );

    final contentLength = _parseContentLength(response.headers);

    // Start processing in background (fire and forget from caller's perspective)
    _processDownload(
      filePath: filePath,
      response: response,
      item: item,
      id: id,
      contentLength: contentLength ?? 0,
      onProgress: onProgress,
      encrypt: encrypt,
    );

    return id;
  }

  Future<void> _processDownload({
    required String filePath,
    required Response response,
    required HiveContentModel item,
    required String id,
    required int contentLength,
    void Function(double)? onProgress,
    required bool encrypt,
  }) async {
    try {
      await _streamToFile(
        filePath: filePath,
        stream: response.data?.stream,
        contentId: item.id,
        contentLength: contentLength,
        onProgress: onProgress,
      );

      final dir = await _downloadsDir();
      await _downloadThumbnail(item, id, dir);

      final finalPath = encrypt ? await _encryptAndCleanup(filePath) : filePath;

      await _markAsDownloaded(item, finalPath);

      // Explicitly set progress to 100% ONLY after everything is successfully saved
      _progressByContentId[item.id] = 100;
      if (_callbacksByContentId.containsKey(item.id)) {
        _callbacksByContentId[item.id]!(100);
      }
      onProgress?.call(100);
    } catch (e) {
      // Handle download failure (cleanup?)
      if (e is! DioException || (e.type != DioExceptionType.cancel)) {}
    } finally {
      _unregisterDownload(id, item.id);
    }
  }

  Future<void> resumeDownload({
    required HiveContentModel item,
    required String url,
    required String downloadId,
    required String tempPath,
    required int downloadedBytes,
    int? totalBytesHint,
    void Function(double progress)? onProgress,
    bool encrypt = false,
    bool allowFallbackToFullDownload = true,
  }) async {
    await _cancelExistingDownload(item.id);

    final file = File(tempPath);
    if (!file.existsSync()) {
      throw Exception('Temporary download not found for resume');
    }

    final actualBytes = file.lengthSync();
    final supportsRanges = await serverSupportsRanges(url);

    if (!supportsRanges) {
      if (allowFallbackToFullDownload) {
        await file.delete();
        await startDownload(
          item: item,
          url: url,
          onProgress: onProgress,
          encrypt: encrypt,
        );
        return;
      }
      throw Exception('Server does not support resumable downloads');
    }

    final cancel = CancelToken();
    _registerDownload(downloadId, item.id, cancel);

    final response = await _dio.get(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: {HttpHeaders.rangeHeader: 'bytes=$actualBytes-'},
        receiveTimeout: const Duration(minutes: 30),
        followRedirects: true,
        validateStatus: (status) => status == 200 || status == 206,
      ),
      cancelToken: cancel,
    );

    final isPartial = response.statusCode == HttpStatus.partialContent;

    if (!isPartial) {
      if (allowFallbackToFullDownload) {
        await file.delete();
        _unregisterDownload(downloadId, item.id);
        await startDownload(
          item: item,
          url: url,
          onProgress: onProgress,
          encrypt: encrypt,
        );
        return;
      }
      throw Exception('Server did not honor range request');
    }

    final totalBytes = _calculateTotalBytes(
      response.headers,
      actualBytes,
      totalBytesHint,
    );

    // Continue in background
    _processResume(
      tempPath: tempPath,
      response: response,
      item: item,
      downloadId: downloadId,
      startingBytes: actualBytes,
      totalBytes: totalBytes ?? 0,
      onProgress: onProgress,
      encrypt: encrypt,
    );
  }

  Future<void> _processResume({
    required String tempPath,
    required Response response,
    required HiveContentModel item,
    required String downloadId,
    required int startingBytes,
    required int totalBytes,
    void Function(double)? onProgress,
    required bool encrypt,
  }) async {
    try {
      await _appendToFile(
        filePath: tempPath,
        stream: response.data?.stream,
        contentId: item.id,
        startingBytes: startingBytes,
        totalBytes: totalBytes,
        onProgress: onProgress,
      );

      await _downloadThumbnailIfMissing(item, downloadId);

      final finalPath = encrypt ? await _encryptAndCleanup(tempPath) : tempPath;

      await _markAsDownloaded(item, finalPath);

      // Explicitly set progress to 100% ONLY after everything is successfully saved
      _progressByContentId[item.id] = 100;
      if (_callbacksByContentId.containsKey(item.id)) {
        _callbacksByContentId[item.id]!(100);
      }
      onProgress?.call(100);
    } catch (e) {
      // Log
      print('Resume failed: $e');
    } finally {
      _unregisterDownload(downloadId, item.id);
    }
  }

  Future<void> pauseDownload(String id) async {
    if (_active.containsKey(id)) {
      _active[id]?.cancel('Download paused by user');
      _active.remove(id);
    }
    _removeContentTrackingByDownloadId(id);
  }

  Future<void> cancelDownload(String id, [String ext = '.mp4']) async {
    await pauseDownload(id);

    final tempPath = await tempFilePathForId(id, ext);
    final file = File(tempPath);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  // ==================== State Query Methods ====================

  bool isDownloading(int contentId) =>
      _activeByContentId.containsKey(contentId);

  double? getDownloadProgress(int contentId) => _progressByContentId[contentId];

  String? activeDownloadIdForContent(int contentId) =>
      _activeByContentId[contentId];

  Future<String> tempFilePathForId(String downloadId,
      [String ext = '.mp4']) async {
    final dir = await _downloadsDir();
    return '${dir.path}/$downloadId${ext}';
  }

  void clearContentState(int contentId) {
    _activeByContentId.remove(contentId);
    _progressByContentId.remove(contentId);
    _callbacksByContentId.remove(contentId);
  }

  // ==================== Progress Callbacks ====================

  void registerProgressCallback(int contentId, void Function(double) callback) {
    _callbacksByContentId[contentId] = callback;
    final existing = _progressByContentId[contentId];
    if (existing != null) {
      callback(existing);
    }
  }

  void unregisterProgressCallback(int contentId) {
    _callbacksByContentId.remove(contentId);
  }

  // ==================== Server Capabilities ====================

  Future<int?> contentLength(String url) async {
    final response = await _dio.head(
      url,
      options: Options(receiveTimeout: const Duration(seconds: 10)),
    );
    return _parseContentLength(response.headers);
  }

  Future<bool> serverSupportsRanges(String url) async {
    final response = await _dio.head(
      url,
      options: Options(
        followRedirects: true,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    final acceptRanges = response.headers.value('accept-ranges');
    return acceptRanges != null && acceptRanges.toLowerCase() != 'none';
  }

  // ==================== Private Helper Methods ====================

  String _generateDownloadId(int contentId) {
    return 'dl_${contentId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _registerDownload(String downloadId, int contentId, CancelToken cancel) {
    _active[downloadId] = cancel;
    _activeByContentId[contentId] = downloadId;
  }

  void _unregisterDownload(String downloadId, int contentId) {
    _active.remove(downloadId);
    _activeByContentId.remove(contentId);
    _progressByContentId.remove(contentId);
    _callbacksByContentId.remove(contentId);
  }

  void _removeContentTrackingByDownloadId(String downloadId) {
    for (final entry in _activeByContentId.entries.toList()) {
      if (entry.value == downloadId) {
        _activeByContentId.remove(entry.key);
        _progressByContentId.remove(entry.key);
        _callbacksByContentId.remove(entry.key);
        break;
      }
    }
  }

  Future<void> _cancelExistingDownload(int contentId,
      [String ext = '.mp4']) async {
    if (_activeByContentId.containsKey(contentId)) {
      final existingId = _activeByContentId[contentId];
      await cancelDownload(existingId!, ext);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  int? _parseContentLength(Headers headers) {
    return int.tryParse(headers.value(Headers.contentLengthHeader) ?? '');
  }

  int? _calculateTotalBytes(
    Headers headers,
    int downloadedBytes,
    int? totalBytesHint,
  ) {
    final contentRange = headers.value('content-range');
    if (contentRange != null) {
      final match = RegExp(r'bytes\s+\d+-\d+/(\d+)').firstMatch(contentRange);
      if (match != null) {
        return int.tryParse(match.group(1)!);
      }
    }

    if (totalBytesHint != null) return totalBytesHint;

    final resumedLength = _parseContentLength(headers);
    if (resumedLength != null) {
      return resumedLength + downloadedBytes;
    }

    return null;
  }

  Future<void> _streamToFile({
    required String filePath,
    required Stream<List<int>>? stream,
    required int contentId,
    required int? contentLength,
    required void Function(double)? onProgress,
  }) async {
    final file = File(filePath);
    final raf = file.openSync(mode: FileMode.write);
    int received = 0;

    if (stream == null) {
      await raf.close();
      return;
    }

    await for (final chunk in stream) {
      raf.writeFromSync(chunk);
      raf.flushSync();
      received += chunk.length;

      if (contentLength != null && contentLength > 0) {
        _updateProgress(contentId, received, contentLength, onProgress);
      }
    }

    await raf.flush();
    await raf.close();
  }

  Future<void> _appendToFile({
    required String filePath,
    required Stream<List<int>>? stream,
    required int contentId,
    required int startingBytes,
    required int? totalBytes,
    required void Function(double)? onProgress,
  }) async {
    final file = File(filePath);
    final raf = file.openSync(mode: FileMode.append);
    int received = startingBytes;

    if (stream == null) {
      await raf.close();
      return;
    }

    await for (final chunk in stream) {
      raf.writeFromSync(chunk);
      raf.flushSync();
      received += chunk.length;

      if (totalBytes != null && totalBytes > 0) {
        _updateProgress(contentId, received, totalBytes, onProgress);
      }
    }

    await raf.flush();
    await raf.close();

    await raf.flush();
    await raf.close();

    // Removed explicit 100% callback here to prevent race condition.
    // 100% will be sent by resumeDownload after db update.
  }

  void _updateProgress(
    int contentId,
    int received,
    int total,
    void Function(double)? onProgress,
  ) {
    double progress = (received / total) * 100;
    // Cap progress at 99.9% during internal updates to prevent
    // premature completion handling before database updates are finished
    if (progress >= 100) {
      progress = 99.9;
    }

    _progressByContentId[contentId] = progress;

    if (_callbacksByContentId.containsKey(contentId)) {
      _callbacksByContentId[contentId]!(progress);
    }
    onProgress?.call(progress);
  }

  Future<void> _downloadThumbnail(
    HiveContentModel item,
    String downloadId,
    Directory downloadsDir,
  ) async {
    try {
      if (item.thumbnailImage.isEmpty) return;

      final thumbDir = Directory('${downloadsDir.path}/thumbnails');
      if (!thumbDir.existsSync()) {
        thumbDir.createSync(recursive: true);
      }

      final thumbPath = '${thumbDir.path}/${downloadId}_thumb.jpg';
      await _dio.download(
        item.thumbnailImage,
        thumbPath,
        options: Options(receiveTimeout: const Duration(minutes: 5)),
      );
      item.localThumbnailPath = thumbPath;
    } catch (e) {}
  }

  Future<void> _downloadThumbnailIfMissing(
    HiveContentModel item,
    String downloadId,
  ) async {
    if (item.thumbnailImage.isEmpty ||
        (item.localThumbnailPath?.isNotEmpty ?? false)) {
      return;
    }

    final dir = await _downloadsDir();
    await _downloadThumbnail(item, downloadId, dir);
  }

  Future<String> _encryptAndCleanup(String filePath) async {
    final encryptedPath = await EncryptionService.encryptFile(filePath);
    await File(filePath).delete();
    return encryptedPath;
  }

  Future<void> _markAsDownloaded(
      HiveContentModel item, String finalPath) async {
    item.localFilePath = finalPath;
    item.isDownloaded = true;
    item.downloadDate = DateTime.now().millisecondsSinceEpoch;
    await hiveService.saveContent(item);
  }

  Future<Directory> _downloadsDir() async {
    final doc = await getApplicationDocumentsDirectory();
    final d = Directory('${doc.path}/downloads');
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return d;
  }
}
