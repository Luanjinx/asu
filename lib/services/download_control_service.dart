import 'dart:io';

import 'package:path/path.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_content_model.dart';

import 'download_service.dart';

enum DownloadControlState { none, inProgress, paused }

class DownloadPauseSnapshot {
  final int contentId;
  final String downloadId;
  final String url;
  final String tempPath;
  final int downloadedBytes;
  final int? totalBytes;
  final bool encrypt;

  const DownloadPauseSnapshot({
    required this.contentId,
    required this.downloadId,
    required this.url,
    required this.tempPath,
    required this.downloadedBytes,
    required this.encrypt,
    this.totalBytes,
  });

  DownloadPauseSnapshot copyWith({int? totalBytes}) {
    return DownloadPauseSnapshot(
      contentId: contentId,
      downloadId: downloadId,
      url: url,
      tempPath: tempPath,
      downloadedBytes: downloadedBytes,
      encrypt: encrypt,
      totalBytes: totalBytes ?? this.totalBytes,
    );
  }
}

/// Coordinator that manages pause/resume/cancel operations on top of DownloadService
class DownloadControlService {
  DownloadControlService._();
  static final DownloadControlService instance = DownloadControlService._();

  final Map<int, DownloadPauseSnapshot> _pausedByContentId = {};

  // ==================== Public Methods ====================

  bool isPaused(int contentId) => _pausedByContentId.containsKey(contentId);

  DownloadPauseSnapshot? getPauseSnapshot(int contentId) {
    return _pausedByContentId[contentId];
  }

  Future<DownloadPauseSnapshot?> pauseContent({
    required int contentId,
    required String url,
    required double currentProgress,
    bool encrypt = false,
  }) async {
    String ext = '.mp4';
    try {
      ext = extension(url);
      if (ext.isEmpty) {
        ext = '.mp4';
      }
    } catch (e) {}
    final downloadId =
        DownloadService.instance.activeDownloadIdForContent(contentId);
    if (downloadId == null) return null;

    final tempPath =
        await DownloadService.instance.tempFilePathForId(downloadId, ext);

    await DownloadService.instance.pauseDownload(downloadId);
    await Future.delayed(const Duration(milliseconds: 300));

    final downloadedBytes = await _getDownloadedBytes(tempPath);
    if (downloadedBytes == 0) {
      await _cleanupEmptyFile(tempPath);
      DownloadService.instance.clearContentState(contentId);
      return null;
    }

    final totalBytes = _estimateTotalBytes(downloadedBytes, currentProgress);
    final snapshot = DownloadPauseSnapshot(
      contentId: contentId,
      downloadId: downloadId,
      url: url,
      tempPath: tempPath,
      downloadedBytes: downloadedBytes,
      totalBytes: totalBytes,
      encrypt: encrypt,
    );

    _pausedByContentId[contentId] = snapshot;
    DownloadService.instance.clearContentState(contentId);

    return snapshot;
  }

  Future<void> resumeContent({
    required HiveContentModel item,
    required String url,
    bool encrypt = false,
    void Function(double progress)? onProgress,
  }) async {
    final snapshot = _pausedByContentId[item.id];

    if (snapshot == null) {
      await _startFreshDownload(item, url, onProgress, encrypt);
      return;
    }

    if (!await _verifyTempFile(snapshot.tempPath)) {
      _pausedByContentId.remove(item.id);
      await _startFreshDownload(item, url, onProgress, encrypt);
      return;
    }

    await DownloadService.instance.resumeDownload(
      item: item,
      url: url,
      downloadId: snapshot.downloadId,
      tempPath: snapshot.tempPath,
      downloadedBytes: snapshot.downloadedBytes,
      totalBytesHint: snapshot.totalBytes,
      encrypt: encrypt,
      onProgress: onProgress,
    );

    _pausedByContentId.remove(item.id);
  }

  Future<void> cancelContent({required int contentId, required String ext}) async {
    final service = DownloadService.instance;
    final downloadId = service.activeDownloadIdForContent(contentId);
    final pausedSnapshot = _pausedByContentId[contentId];

    if (downloadId != null) {
      await service.cancelDownload(downloadId, ext);
    }

    if (pausedSnapshot != null) {
      await _deletePausedFile(pausedSnapshot.tempPath);
    }

    service.clearContentState(contentId);
    _pausedByContentId.remove(contentId);
  }

  // ==================== Private Helper Methods ====================

  Future<int> _getDownloadedBytes(String tempPath) async {
    final file = File(tempPath);
    return file.existsSync() ? file.lengthSync() : 0;
  }

  Future<void> _cleanupEmptyFile(String tempPath) async {
    final file = File(tempPath);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  int? _estimateTotalBytes(int downloadedBytes, double currentProgress) {
    if (currentProgress > 0 && downloadedBytes > 0) {
      return (downloadedBytes / (currentProgress / 100)).round();
    }
    return null;
  }

  Future<bool> _verifyTempFile(String tempPath) async {
    return File(tempPath).existsSync();
  }

  Future<void> _deletePausedFile(String tempPath) async {
    final file = File(tempPath);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<void> _startFreshDownload(
    HiveContentModel item,
    String url,
    void Function(double progress)? onProgress,
    bool encrypt,
  ) async {
    await DownloadService.instance.startDownload(
      item: item,
      url: url,
      onProgress: onProgress,
      encrypt: encrypt,
    );
  }
}
