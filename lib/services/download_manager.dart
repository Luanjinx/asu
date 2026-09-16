import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_content_model.dart';

import 'download_service.dart';

enum DownloadStatus { idle, downloading, paused, completed, failed }

class DownloadState {
  final int contentId;
  final String downloadId;
  final double progress;
  final DownloadStatus status;
  final String? error;
  final HiveContentModel? item;

  DownloadState({
    required this.contentId,
    required this.downloadId,
    this.progress = 0.0,
    this.status = DownloadStatus.idle,
    this.error,
    this.item,
  });

  DownloadState copyWith({
    int? contentId,
    String? downloadId,
    double? progress,
    DownloadStatus? status,
    String? error,
    HiveContentModel? item,
  }) {
    return DownloadState(
      contentId: contentId ?? this.contentId,
      downloadId: downloadId ?? this.downloadId,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
      item: item ?? this.item,
    );
  }
}

class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;
  static DownloadManager get instance => _instance;

  DownloadManager._internal();

  final DownloadService _downloadService = DownloadService.instance;

  // Active downloads mapped by content ID
  final RxMap<int, DownloadState> _activeDownloads = <int, DownloadState>{}.obs;

  // Stream controllers for each download
  final Map<int, StreamController<DownloadState>> _progressControllers = {};

  // Expose active downloads as observable
  RxMap<int, DownloadState> get activeDownloads => _activeDownloads;

  Future<void> startDownload({
    required HiveContentModel item,
    required String url,
  }) async {
    final contentId = item.id;

    // Check if already downloading
    if (_activeDownloads.containsKey(contentId)) {
      final state = _activeDownloads[contentId]!;
      if (state.status == DownloadStatus.downloading) {
        return; // Already downloading
      }
    }

    // Create download ID
    final downloadId = 'dl_${contentId}_${DateTime.now().millisecondsSinceEpoch}';

    // Initialize download state
    final initialState = DownloadState(
      contentId: contentId,
      downloadId: downloadId,
      status: DownloadStatus.downloading,
      progress: 0.0,
      item: item,
    );

    _activeDownloads[contentId] = initialState;
    _notifyListeners(contentId, initialState);

    try {
      await _downloadService.startDownload(
        item: item,
        url: url,
        onProgress: (progress) {
          final state = DownloadState(
            contentId: contentId,
            downloadId: downloadId,
            progress: progress,
            status: progress >= 100 ? DownloadStatus.completed : DownloadStatus.downloading,
            item: item,
          );

          _activeDownloads[contentId] = state;
          _notifyListeners(contentId, state);

          // Remove from active downloads when completed
          if (progress >= 100) {
            Future.delayed(const Duration(seconds: 1), () {
              _activeDownloads.remove(contentId);
              _closeStream(contentId);
            });
          }
        },
      );
    } catch (e) {
      final errorState = DownloadState(
        contentId: contentId,
        downloadId: downloadId,
        status: DownloadStatus.failed,
        error: e.toString(),
        item: item,
      );

      _activeDownloads[contentId] = errorState;
      _notifyListeners(contentId, errorState);

      // Remove failed download after a delay
      Future.delayed(const Duration(seconds: 3), () {
        _activeDownloads.remove(contentId);
        _closeStream(contentId);
      });
    }
  }

  DownloadState? getDownloadState(int contentId) {
    return _activeDownloads[contentId];
  }

  void listenToDownload(
    int contentId,
    void Function(DownloadState state) onUpdate,
  ) {
    if (!_progressControllers.containsKey(contentId)) {
      _progressControllers[contentId] = StreamController<DownloadState>.broadcast();
    }

    _progressControllers[contentId]!.stream.listen(onUpdate);

    // Send current state if available
    if (_activeDownloads.containsKey(contentId)) {
      onUpdate(_activeDownloads[contentId]!);
    }
  }

  Future<void> cancelDownload(int contentId) async {
    if (!_activeDownloads.containsKey(contentId)) return;

    final state = _activeDownloads[contentId]!;
    await _downloadService.cancelDownload(state.downloadId);

    _activeDownloads.remove(contentId);
    _closeStream(contentId);
  }

  void _notifyListeners(int contentId, DownloadState state) {
    if (_progressControllers.containsKey(contentId)) {
      if (!_progressControllers[contentId]!.isClosed) {
        _progressControllers[contentId]!.add(state);
      }
    }
  }

  void _closeStream(int contentId) {
    if (_progressControllers.containsKey(contentId)) {
      _progressControllers[contentId]!.close();
      _progressControllers.remove(contentId);
    }
  }

  void dispose() {
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    _progressControllers.clear();
  }
}