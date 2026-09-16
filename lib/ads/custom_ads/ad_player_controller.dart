import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:streamit_laravel/ads/vast/vast_parser.dart';

class AdPlayerController extends GetxController with WidgetsBindingObserver {
  final String videoUrl;
  final bool isFromPlayerAd;
  final ValueChanged<RxBool>? startSkipTimer;
  final String adType;

  AdPlayerController({
    required this.videoUrl,
    this.isFromPlayerAd = false,
    this.startSkipTimer,
    this.adType = '',
    this.onVideoCompleted,
    this.onVideoStarted,
    this.onVideoError,
  });

  final VoidCallback? onVideoCompleted;
  final VoidCallback? onVideoStarted;
  final VoidCallback? onVideoError;

  // Make these nullable to avoid late initialization errors
  Player? player;
  VideoController? videoController;

  // Stream subscriptions for proper disposal
  StreamSubscription<bool>? _bufferingSubscription;
  StreamSubscription<bool>? _playingSubscription;

  final RxBool hasError = false.obs;
  final RxBool isPlaying = true.obs;
  final RxBool isBuffering = true.obs;
  final RxBool isPlayerReady = false.obs;

  // Flag to prevent multiple initializations
  bool _isInitialized = false;

  // Flag to track disposal state
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initPlayer();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _isDisposed = true;
    _disposePlayer();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (player != null && isPlayerReady.value && !hasError.value) {
        // Force resume playback
        player!.play();
      }
    }
  }

  Future<void> _initPlayer() async {
    // Prevent multiple initializations
    if (_isInitialized || _isDisposed) return;

    isBuffering.value = true;

    final resolvedUrl = await _resolveMediaSource(videoUrl);
    if (_isDisposed) return;
    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      hasError.value = true;
      onVideoError?.call();
      return;
    }

    try {
      MediaKit.ensureInitialized();

      player = Player(
        configuration: PlayerConfiguration(muted: true),
      );

      videoController = VideoController(player!);
      isPlayerReady.value = true;

      String urlToPlay = resolvedUrl;
      // Only check for file existence if it's NOT a network URL
      if (!resolvedUrl.startsWith('http') && File(resolvedUrl).existsSync()) {
        urlToPlay = Uri.file(resolvedUrl).toString();
      }

      if (_isDisposed) {
        player?.dispose();
        return;
      }

      if (urlToPlay.isNotEmpty) {
        try {
          await player!.open(Media(urlToPlay), play: true);
          if (_isDisposed) return;
          // Explicitly play to be sure
          await player!.play();
        } catch (e) {
          hasError.value = true;
          onVideoError?.call();
          debugPrint('Error opening media: $e');
        }
      } else {
        hasError.value = true;
        isBuffering.value = false;
        onVideoError?.call();
        return;
      }

      // Subscribe to streams with proper management
      _bufferingSubscription = player!.stream.buffering.listen((buffering) {
        debugPrint('AdPlayerController: Buffering state changed to $buffering');
        // Update buffering state from stream
        isBuffering.value = buffering;
        if (!buffering) {
          if (isFromPlayerAd) {
            startSkipTimer?.call(true.obs);
          }
        }
      });

      _playingSubscription = player!.stream.playing.listen((playing) {
        debugPrint('AdPlayerController: Playing state changed to $playing');
        isPlaying.value = playing;
        if (playing) {
          // If playback started, force buffering off
          isBuffering.value = false;
          onVideoStarted?.call();
        }
      });

      // Listen for completion
      player!.stream.completed.listen((completed) {
        if (completed) {
          debugPrint('AdPlayerController: MediaKit reported completed');
          isBuffering.value = false; // Ensure buffering is hidden on completion
          onVideoCompleted?.call();
        }
      });

      _isInitialized = true;
    } catch (e) {
      hasError.value = true;
      onVideoError?.call();
      // Log error if needed
    }
  }

  Future<String?> _resolveMediaSource(String source) async {
    final trimmed = source.trim();
    if (trimmed.isEmpty) return null;

    if (!_shouldTreatAsXmlSource(trimmed)) {
      return trimmed;
    }

    try {
      final parser = VastParser();
      final bool isInline = _isInlineXmlPayload(trimmed);
      final vastMedia = isInline ? parser.parseXmlString(trimmed) : await parser.fetchVastMedia(trimmed);
      if (vastMedia != null && vastMedia.mediaUrls.isNotEmpty) {
        return vastMedia.mediaUrls.first;
      }
      return null;
    } catch (e) {
      debugPrint('Failed to resolve custom ad XML: $e');
      return null;
    }
  }

  bool _shouldTreatAsXmlSource(String source) {
    final normalizedType = adType.trim().toLowerCase();
    if (normalizedType == 'xml' || normalizedType == 'vast') {
      return true;
    }
    final lower = source.toLowerCase();
    if (_isInlineXmlPayload(lower)) return true;
    if (lower.endsWith('.xml')) return true;
    if (lower.contains('.xml?')) return true;
    return false;
  }

  bool _isInlineXmlPayload(String value) {
    final trimmed = value.trim();
    return trimmed.startsWith('<') && trimmed.contains('</');
  }

  Future<void> _disposePlayer() async {
    // Cancel stream subscriptions immediately to prevent memory leaks
    await _bufferingSubscription?.cancel();
    await _playingSubscription?.cancel();
    _bufferingSubscription = null;
    _playingSubscription = null;

    final currentPlayer = player;
    // Clear references to prevent usage
    player = null;
    videoController = null;

    // Dispose player resources safely
    if (currentPlayer != null) {
      await currentPlayer.stop();
      await currentPlayer.dispose();
    }
  }
}