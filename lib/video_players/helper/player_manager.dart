import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chrome_cast/lib.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pod_player/pod_player.dart';
import 'package:streamit_laravel/ads/models/ad_config.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/network/network_utils.dart';
import 'package:streamit_laravel/utils/cast/available_devices_for_cast.dart';
import 'package:streamit_laravel/utils/cast/controller/fc_cast_controller.dart';
import 'package:streamit_laravel/utils/cast/flutter_chrome_cast_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/helper/embedded_player_helper.dart';

class PlayerManager {
  // --- Controllers ---
  Timer? _hideTimer;
  PodPlayerController? podController;
  InAppWebViewController? webViewController;

  // Ad Player (MediaKit)
  Player? _adPlayer;
  VideoController? adVideoController;

  StreamSubscription? _adPositionSub;
  StreamSubscription? _adCompletedSub;
  StreamSubscription? _adBufferingSub;
  StreamSubscription? _adPlayingSub;

  RxBool isVisible = false.obs;

  // --- State ---
  bool isDisposed = false;
  final RxBool isBuffering = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool hasStartedPlaying = false.obs;
  final RxBool isMuted = false.obs;
  final RxBool isAdAudioMuted = false.obs;

  final Rx<Duration> currentPosition = Duration.zero.obs;

  final Rx<Duration> currentVideoDuration = Duration.zero.obs;

  // --- Callbacks ---
  Function(Duration position, Duration duration)? onProgress;
  Function(String event)? onEvent;

  // --- Subtitles ---
  List<SubtitleEntry> _subtitles = [];
  final RxString currentSubtitle = ''.obs;

  // Thumbnail for loader

  // --- Casting ---

  // --- WebView HTML ---
  String? _pendingHtml;
  String? _loadedUrl;
  String? _loadedType;

  PlayerManager() {
    _ensurePodGetXController();
  }

  void _ensurePodGetXController() {
    if (!Get.isRegistered<PodGetXVideoController>()) {
      Get.lazyPut<PodGetXVideoController>(() => PodGetXVideoController(), fenix: true);
    }
  }

  // --- Initialization ---

  Future<void> initialize({
    required String url,
    required String type,
    List<int>? qualities,
    Duration? startAt,
    String? thumbnail,
    List<Duration> adBreaks = const [],
  }) async {
    if (isDisposed) return;
    log('URL ---- ${url}');
    log('Type --- ${type}');
    _startHideTimer();
    isBuffering(true);
    hasStartedPlaying(false);

    _loadedUrl = url;
    _loadedType = type;

    if (isPlayInWebviewPlayer(type)) {
      await _cleanupPlayers(except: 'webview');
      await _initWebView(url, type, startAt);
    } else if (isPlayInPodPlayer(type)) {
      await _cleanupPlayers(except: 'pod');
      await _initPodPlayer(url, type, qualities ?? [], startAt, isMuted.value);
    }
  }

  Future<void> _cleanupPlayers({required String except}) async {
    if (except != 'pod' && podController != null) {
      podController?.removeListener(_onPodUpdate);
      if (podController!.isInitialised) {
        podController!.dispose();
      }
      podController = null;
    }

    if (except != 'webview') {
      try {
        if (webViewController != null) {
          webViewController?.dispose();
          webViewController = null;
        }
      } catch (e) {
        log('Error clearing webview: $e');
      }
    }
  }

  Future<void> _initWebView(
    String url,
    String type,
    Duration? startAt,
  ) async {
    final html = EmbeddedPlayerHelper.getHTML(
      url,
      autoplay: true,
      startAt: startAt,
      mute: isMuted.value,
    );

    if (webViewController != null) {
      await webViewController!.loadData(
        data: html,
        baseUrl: WebUri(DOMAIN_URL),
        mimeType: 'text/html',
        encoding: 'utf-8',
      );
      play();
    }

    _pendingHtml = html;
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;

    // Add JS Handlers
    controller.addJavaScriptHandler(
        handlerName: WEB_VIDEO_VIEW_CHANNEL,
        callback: (args) {
          if (args.isNotEmpty) {
            final message = args[0];
            _onWebViewMessage(message);
          }
        });

    if (_pendingHtml != null) {
      controller.loadData(
        data: _pendingHtml!,
        baseUrl: WebUri(DOMAIN_URL),
        mimeType: 'text/html',
        encoding: 'utf-8',
      );
      _pendingHtml = null;
    } else if (_loadedUrl != null && _loadedType != null && isPlayInWebviewPlayer(_loadedType!)) {
      // Restore session (e.g. after rotation)
      isBuffering(true);
      isPlaying(false); // Reset playing state so thumbnail shows during reload
      final html = EmbeddedPlayerHelper.getHTML(
        _loadedUrl!,
        autoplay: true, // Auto-resume
        startAt: currentPosition.value,
        mute: isMuted.value,
      );
      controller.loadData(
        data: html,
        baseUrl: WebUri(DOMAIN_URL),
        mimeType: 'text/html',
        encoding: 'utf-8',
      );
    }
  }

  Future<void> _initPodPlayer(String url, String type, List<int> qualities, Duration? startAt, bool mute) async {
    isBuffering(true);

    if (podController != null && podController!.isInitialised && podController!.videoPlayerValue != null && podController!.videoPlayerValue!.isInitialized) {
      await podController?.changeVideo(
        playerConfig: PodPlayerConfig(
          autoPlay: true,
          wakelockEnabled: true,
          videoQualityPriority: qualities,
        ),
        playVideoFrom: _getPodVideoFrom(type, url),
      );
    } else {
      podController = PodPlayerController(
        podPlayerConfig: PodPlayerConfig(
          autoPlay: true,
          wakelockEnabled: true,
          videoQualityPriority: qualities,
        ),
        playVideoFrom: _getPodVideoFrom(type, url),
      );
      await podController!.initialise();
    }

    if (isDisposed || podController == null) return;

    if (startAt != null) {
      await podController!.videoSeekTo(startAt);
    }

    if (isMuted.value) {
      await podController?.mute();
    } else {
      await podController?.unMute();
    }

    await play();
    podController!.addListener(_onPodUpdate);
  }

  PlayVideoFrom _getPodVideoFrom(String type, String url) {
    final headers = {'referer': DOMAIN_URL};
    switch (type) {
      case URLTypes.file:
        return PlayVideoFrom.file(File(url));
      default:
        return PlayVideoFrom.network(url, httpHeaders: headers);
    }
  }

  // --- Playback Control ---

  Future<void> play() async {
    if (podController?.isInitialised ?? false) {
      podController!.play();
    } else if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: "playVideo();");
    }
    isPlaying(true);
  }

  Future<void> pause() async {
    if (podController?.isInitialised ?? false) {
      podController!.pause();
    } else if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: "pauseVideo();");
    }
    isPlaying(false);
  }

  Future<void> stop() async {
    if (podController?.isInitialised ?? false) {
      podController?.pause();
    } else if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: "pauseVideo();");
    }

    try {
      webViewController?.loadData(data: '');
    } catch (e) {
      log('Error stopping WebView: $e');
    }

    isPlaying(false);
    isBuffering(false);
    hasStartedPlaying(false);
  }

  Future<void> seekTo(Duration position) async {
    if (podController?.isInitialised ?? false) {
      await podController!.videoSeekTo(position);
    } else if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: "seekTo(${position.inSeconds});");
    }
  }

  Future<void> toggleMute() async {
    handleUserInteraction();
    isMuted(!isMuted.value);

    // Pod Player
    if (podController?.isInitialised ?? false) {
      if (isMuted.value) {
        await podController!.mute();
      } else {
        await podController!.unMute();
      }
      log('Pod player mute toggled');
      return;
    }

    if (webViewController != null) await _webViewToggleMute();
  }

  Future<void> _webViewToggleMute() async {
    if (isMuted.value) {
      await mute();
    } else {
      await unmute();
    }
  }

  Future<void> mute() async {
    if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: "mute();");
    }
  }

  Future<void> unmute() async {
    if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: "unMute();");
    }
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      isVisible(false);
    });
  }

  void handleUserInteraction() {
    isVisible(true);
    _startHideTimer();
  }

  Future<void> setSubtitle(String url) async {
    if (url.isEmpty) {
      _subtitles.clear();
      currentSubtitle('');
      return;
    }

    await loadSubtitle(url);
  }

  Future<void> loadSubtitle(String url) async {
    try {
      // Pass the URL to the compute function
      final parsedSubtitles = await compute(getSubtitleData, url);
      _subtitles = parsedSubtitles;
      log('Subtitle loaded: ${_subtitles.length} entries');
    } catch (e) {
      log('Error loading subtitle: $e');
      _subtitles.clear();
    }
  }

  int _lastSubtitleIndex = -1;

  void _updateSubtitle(Duration position) {
    if (_subtitles.isEmpty) {
      if (currentSubtitle.isNotEmpty) currentSubtitle('');
      return;
    }

    // Optimization: Check the last found subtitle first (common case for sequential playback)
    if (_lastSubtitleIndex >= 0 && _lastSubtitleIndex < _subtitles.length) {
      final lastEntry = _subtitles[_lastSubtitleIndex];
      if (position >= lastEntry.start && position <= lastEntry.end) {
        if (currentSubtitle.value != lastEntry.text) {
          currentSubtitle(lastEntry.text);
        }
        return;
      }
    }

    // Optimization: Check the next subtitle (sequential playback)
    if (_lastSubtitleIndex + 1 < _subtitles.length) {
      final nextEntry = _subtitles[_lastSubtitleIndex + 1];
      if (position >= nextEntry.start && position <= nextEntry.end) {
        _lastSubtitleIndex++;
        if (currentSubtitle.value != nextEntry.text) {
          currentSubtitle(nextEntry.text);
        }
        return;
      }
    }

    // Fallback: Binary search for random seeking
    int low = 0;
    int high = _subtitles.length - 1;
    SubtitleEntry? match;

    while (low <= high) {
      int mid = (low + high) ~/ 2;
      final entry = _subtitles[mid];

      if (entry.start <= position && entry.end >= position) {
        match = entry;
        _lastSubtitleIndex = mid;
        break;
      } else if (entry.start > position) {
        high = mid - 1;
      } else {
        low = mid + 1;
      }
    }

    if (match != null) {
      if (currentSubtitle.value != match.text) {
        currentSubtitle(match.text);
      }
    } else {
      if (currentSubtitle.isNotEmpty) currentSubtitle('');
    }
  }

  // --- Ad Player (MediaKit) ---

  Future<void> initAdPlayer() async {
    if (_adPlayer != null) return;

    // Ensure clean state before creating new instances
    adVideoController = null;

    MediaKit.ensureInitialized();
    _adPlayer = Player();
    adVideoController = VideoController(_adPlayer!);
  }

  Future<void> playAd(String url) async {
    log('Playing Ad: $url');
    isBuffering(true);

    await initAdPlayer();
    await _adPlayer!.open(Media(url));
    await _adPlayer!.play();

    // Cancel previous subscriptions
    _adPositionSub?.cancel();
    _adCompletedSub?.cancel();

    // Ensure we listen to MP4 updates
    _adPositionSub = _adPlayer!.stream.position.listen((pos) {
      if (isAdPlaying()) {
        isBuffering(false);
        _onAdProgress(pos, _adPlayer!.state.duration);
      }
    });
    _adCompletedSub = _adPlayer!.stream.completed.listen((completed) {
      if (completed && isAdPlaying()) {
        onEvent?.call('ended');
      }
    });
  }

  bool isAdPlaying() {
    return adVideoController != null;
  }

  void _onAdProgress(Duration pos, Duration dur) {
    currentPosition(pos);
    currentVideoDuration(dur);
    onProgress?.call(pos, dur);
  }

  Future<void> pauseAd() async {
    await _adPlayer?.pause();
  }

  Future<void> resumeAd() async {
    await _adPlayer?.play();
  }

  Future<void> stopAd() async {
    await _adPlayer?.stop();

    _adPositionSub?.cancel();
    _adCompletedSub?.cancel();
    _adBufferingSub?.cancel();
    _adPlayingSub?.cancel();

    // Reset state
    currentPosition(Duration.zero);
    currentVideoDuration(Duration.zero);
  }

  Future<void> setAdMute(bool mute) async {
    isAdAudioMuted(mute);
    await _adPlayer?.setVolume(mute ? 0 : 100);
  }

  // --- Listeners ---

  void _onPodUpdate() {
    if (podController == null || !podController!.isInitialised) return;

    final value = podController!.videoPlayerValue;
    if (value == null) return;

    isBuffering(podController!.isVideoBuffering);
    isPlaying(podController!.isVideoPlaying);

    if (podController!.isVideoPlaying) {
      hasStartedPlaying(true);
    }

    onProgress?.call(value.position, value.duration);
    currentPosition(value.position);
    currentVideoDuration(value.duration);
    _updateSubtitle(value.position);

    if (value.position == value.duration) {
      onEvent?.call('ended');
    }
  }

  void _onWebViewMessage(dynamic message) {
    try {
      dynamic data;
      if (message is String) {
        try {
          data = jsonDecode(message);
        } catch (_) {
          data = message;
        }
      } else {
        data = message;
      }

      if (data is Map && data['event'] == 'timeUpdate') {
        final currentTime = data['currentTime'];
        final duration = data['duration'];

        final pos = Duration(
          seconds: (currentTime is num ? currentTime : double.tryParse(currentTime.toString()) ?? 0).toInt(),
        );

        final dur = Duration(
          seconds: (duration is num ? duration : double.tryParse(duration.toString()) ?? 0).toInt(),
        );

        hasStartedPlaying(true);
        isBuffering(false);

        onProgress?.call(pos, dur);
        currentPosition(pos);
        currentVideoDuration(dur);
        _updateSubtitle(Duration(seconds: pos.inSeconds + 1)); 
        return;
      }
    } catch (_) {
      // fall through to string events
    }

    // 🔥 STRING MESSAGE HANDLERS
    final msg = message.toString();
    switch (msg) {
      case 'ready':
        isBuffering(false);
        play();
        break;

      case 'playing':
        isPlaying(true);
        hasStartedPlaying(true);
        isBuffering(false);
        break;

      case 'paused':
        isPlaying(false);
        isBuffering(false);
        break;

      case 'buffering':
        isBuffering(true);
        break;

      case 'ended':
        isPlaying(false);
        isBuffering(false);
        onEvent?.call('ended');
        break;
    }
  }

  // --- Casting ---
  void enableCasting({
    required String url,
    required String type,
    String? title,
    String? thumbnail,
    String? releaseDate,
    String subtitle = '',
    Duration? duration,
    List<AdConfig>? preRollAds,
    List<AdConfig>? midRollAds,
    List<AdConfig>? postRollAds,
  }) async {
    FCCast _castController;
    if (Get.isRegistered<FCCast>()) {
      _castController = Get.find<FCCast>();
    } else {
      _castController = Get.put(FCCast());
    }

    _castController.videoURL = url;
    _castController.contentType = type;
    _castController.title = title ?? '';
    _castController.thumbnailImage = thumbnail ?? '';
    _castController.releaseDate = releaseDate ?? '';
    _castController.duration = duration;
    _castController.preRollAds = preRollAds ?? [];
    _castController.midRollAds = midRollAds ?? [];
    _castController.postRollAds = postRollAds ?? [];

    appScreenCastConnected(_castController.isCastingVideo.value);

    if (GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected) {
      Get.bottomSheet(
        AppDialogWidget(child: FlutterChromeCastWidget(chromeCastController: _castController)),
        isScrollControlled: true,
      );
      return;
    }

    // Show Available Devices Dialog
    Get.bottomSheet(
      AppDialogWidget(
        child: AvailableDevicesForCast(
          onTap: (device) {
            Get.back(); // Close bottom sheet
            Get.bottomSheet(
              AppDialogWidget(child: FlutterChromeCastWidget(chromeCastController: _castController)),
              isScrollControlled: true,
            );
          },
        ),
      ),
      backgroundColor: appScreenBackgroundDark,
      isDismissible: true,
      enableDrag: true,
    );
  }

  // --- Helpers ---

  bool isPlayInWebviewPlayer(String type) {
    return type == URLTypes.youtube || type == URLTypes.vimeo || type == URLTypes.embedded;
  }

  bool isPlayInPodPlayer(String type) {
    return type == URLTypes.file || type == URLTypes.local || type == URLTypes.url || type == URLTypes.hls || type == URLTypes.x265; // Fallback
  }

  void dispose() {
    isDisposed = true;
    _cleanupPlayers(except: '');
    _hideTimer?.cancel();
    _adPositionSub?.cancel();
    _adCompletedSub?.cancel();
    _adBufferingSub?.cancel();
    _adPlayingSub?.cancel();
  }
}

// --- Supporting Classes & Functions ---

class PodGetXVideoController extends GetxController {}

class SubtitleEntry {
  final Duration start;
  final Duration end;
  final String text;

  SubtitleEntry({required this.start, required this.end, required this.text});
}

// Top-level function for compute
Future<List<SubtitleEntry>> getSubtitleData(String url) async {
  try {
    final response = await dioClient.get(
      url,
      options: Options(
        responseType: ResponseType.plain,
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; VAST Parser)',
          'Accept': 'application/xml, text/xml, */*',
        },
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      return getSubtitles(response.data.toString());
    } else {
      return [];
    }
  } catch (e) {
    print("SUBTITLE ERROR: $e");
    return [];
  }
}

List<SubtitleEntry> getSubtitles(String content) {
  final List<SubtitleEntry> subtitles = [];
  final RegExp timeRegex = RegExp(r'(\d{2}):(\d{2}):(\d{2})[.,](\d{3}) --> (\d{2}):(\d{2}):(\d{2})[.,](\d{3})');

  // Normalize line endings
  final lines = content.split(RegExp(r'\r\n|\r|\n'));

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i].trim();

    if (timeRegex.hasMatch(line)) {
      final match = timeRegex.firstMatch(line)!;
      final start = Duration(
        hours: int.parse(match.group(1)!),
        minutes: int.parse(match.group(2)!),
        seconds: int.parse(match.group(3)!),
        milliseconds: int.parse(match.group(4)!),
      );
      final end = Duration(
        hours: int.parse(match.group(5)!),
        minutes: int.parse(match.group(6)!),
        seconds: int.parse(match.group(7)!),
        milliseconds: int.parse(match.group(8)!),
      );

      String text = '';
      i++;
      while (i < lines.length && lines[i].trim().isNotEmpty) {
        text += (text.isNotEmpty ? '\n' : '') + lines[i].trim();
        i++;
      }

      // Remove HTML tags if any
      text = text.replaceAll(RegExp(r'<[^>]*>'), '');

      subtitles.add(SubtitleEntry(start: start, end: end, text: text));
    }
  }

  return subtitles;
}