import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/managers/ad_manager.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/component/common/thumbnail_component.dart';
import 'package:streamit_laravel/video_players/helper/player_manager.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../main.dart';

enum VideoPlayerStage { loading, playing, error, adPlaying }

class VideoPlayersController extends GetxController with WidgetsBindingObserver {
  //region Variables
  // --- Core Dependencies ---
  final PlayerManager playerManager = PlayerManager();
  late final AdManager adManager;
  final ThumbnailController thumbnailController = ThumbnailController();

  // --- State Variables ---
  Rx<VideoPlayerStage> stage = VideoPlayerStage.loading.obs;
  RxBool isInitialized = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;
  RxBool isBuffering = false.obs;

  // --- Video Data ---
  late ContentModel videoModel;
  Rx<VideoData> currentQuality = VideoData().obs;
  RxString currentVideoUrl = ''.obs;
  RxString currentVideoType = ''.obs;
  Rx<SubtitleModel> currentSubtitle = SubtitleModel().obs;
  RxList<PosterDataModel> remainingEpisodes = <PosterDataModel>[].obs;

  final Function(ContentModel newEpisodeData)? onEpisodeChanged;

  // --- UI Controls ---
  RxBool showSkipIntro = false.obs;
  RxBool showNextEpisode = false.obs;

  // --- Internal State ---
  Duration? introStart;
  Duration? introEnd;
  Duration _lastSavedPosition = Duration.zero;
  RxString subtitleText = ''.obs;
  bool isFromDownloads = false;

  //endregion

  VideoPlayersController({
    List<PosterDataModel>? remainingEpisodes,
    this.isFromDownloads = false,
    this.onEpisodeChanged,
  }) {
    if (remainingEpisodes != null) {
      this.remainingEpisodes.assignAll(remainingEpisodes);
    }
  }

  //region Initialization
  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    adManager = AdManager(playerManager);

    // Assign callbacks
    playerManager.onProgress = _onProgress;
    playerManager.onEvent = _onPlayerEvent;

    // Get arguments
    if (Get.arguments is ContentModel) {
      videoModel = Get.arguments;
      initializeVideo();
    } else {
      hasError(true);
      isBuffering(false);
      errorMessage("No video data provided");
    }

    // Set up PiP mode change handler (Android) so we get callbacks when user exits PiP
    if (Platform.isAndroid) {
      platform.setMethodCallHandler((MethodCall call) async {
        if (call.method == 'onPipModeChanged') {
          final bool newPipMode = call.arguments as bool;
          if (isPipModeOn.value != newPipMode) {
            isPipModeOn.value = newPipMode;
            if (!newPipMode) {
              await Future.delayed(const Duration(milliseconds: 300));
              LiveStream().emit(VIDEO_PLAYER_REFRESH_EVENT);
            }
          }
        }
      });
    }
  }

  Future<void> initializeVideo() async {
    // Check device support before initializing
    if (!isSupportedDevice.value) {
      hasError(true);
      errorMessage('Device not supported');
      stage(VideoPlayerStage.error);
      return;
    }

    try {
      stage(VideoPlayerStage.loading);
      hasError(false);
      errorMessage('');

      // Parse Intro/Outro
      _parseIntroOutro();

      // Set initial quality
      currentQuality(videoModel.defaultQuality);

      // Skip ads if playing from downloads
      if (!isFromDownloads && videoModel.isAdsAvailable) {
        final duration = parseDuration(videoModel.details.duration);
        adManager.initialize(
          videoModel,
          totalDuration: duration,
        );

        // Wait for first ad or timeout (max 2 seconds)
        await Future.any(
          [
            adManager.isFirstAdReady.stream.firstWhere((ready) => ready),
            Future.delayed(const Duration(seconds: 2)),
          ],
        );

        // Play first pre-roll ad if available
        if (adManager.preRollAds.isNotEmpty) {
          stage(VideoPlayerStage.adPlaying);
          await adManager.playNextPreRollAd();

          // Wait for ad to finish, then play remaining pre-rolls
          await _waitForAdToFinish();

          // Play remaining pre-roll ads
          while (adManager.preRollAds.isNotEmpty) {
            await adManager.playNextPreRollAd();
            await _waitForAdToFinish();
          }
        }
      }

      // Initialize Player
      Duration? startAt;

      isBuffering(true);
      if (isFromDownloads) {
        (String, String) downloadedFiles = await hiveService.getFileTypeForDownloadedContent(videoModel.id);
        if (isClosed) return;
        if (downloadedFiles.$2.isNotEmpty && downloadedFiles.$1.isNotEmpty) {
          currentVideoUrl(downloadedFiles.$2);
          currentVideoType(downloadedFiles.$1.toLowerCase());
        }

        // Get saved position from Hive
        final savedItem = hiveService.getContentFromContentBox(videoModel.id);
        if (savedItem != null && savedItem.watchedDuration > 0) {
          startAt = Duration(seconds: savedItem.watchedDuration);
        }
      } else {
        currentVideoUrl(videoModel.defaultQuality.url);
        currentVideoType(videoModel.defaultQuality.urlType.toLowerCase());
        startAt = parseDuration(videoModel.details.watchedDuration);
      }

      if (isClosed) return;

      await playerManager
          .initialize(
        url: currentVideoUrl.value,
        type: currentVideoType.value,
        startAt: startAt,
        thumbnail: videoModel.details.thumbnailImage,
        adBreaks: getAllAdBreaks(),
      )
          .then(
        (value) {
          isInitialized(true);
          isBuffering(false);
          stage(VideoPlayerStage.playing);
        },
      ).catchError(
        (error) {
          hasError(true);
          isBuffering(false);
          errorMessage(locale.value.videoNotFound);
          stage(VideoPlayerStage.error);
        },
      );

      if (isClosed) return;

      WakelockPlus.enable();

      // Ensure playback starts
      await playerManager.play();

      if (videoModel.subtitleList.any((element) => element.isDefaultLanguage.getBoolInt())) {
        currentSubtitle(videoModel.subtitleList.firstWhere((element) => element.isDefaultLanguage.getBoolInt()));
        playerManager.setSubtitle(currentSubtitle.value.subtitleFileURL);
      }

      if (videoModel.details.watchedDuration.isEmpty && !isFromDownloads && isLoggedIn.value) {
        if (videoModel.isOneTimePurchase)
          CoreServiceApis.startDate(
            request: {
              ApiRequestKeys.entertainmentIdKey: videoModel.id,
              ApiRequestKeys.entertainmentTypeKey: videoModel.details.type,
              ApiRequestKeys.userIdKey: loginUserData.value.id,
            },
          );

        CoreServiceApis.storeViewDetails(
          request: {
            ApiRequestKeys.entertainmentIdKey: videoModel.id,
            ApiRequestKeys.entertainmentTypeKey: videoModel.details.type,
            ApiRequestKeys.userIdKey: loginUserData.value.id,
          },
        );
      }
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
      isBuffering(false);
      stage(VideoPlayerStage.error);
    }
  }

  void _parseIntroOutro() {
    if (videoModel.details.introStartsAt.isNotEmpty) {
      introStart = parseDuration(videoModel.details.introStartsAt);
    }
    if (videoModel.details.introEndsAt.isNotEmpty) {
      introEnd = parseDuration(videoModel.details.introEndsAt);
    }
  }

  DecorationImage? getThumbnailImage() {
    final url = videoModel.details.thumbnailImage;
    if (url.isNotEmpty && !url.contains("/data/user")) {
      return DecorationImage(
        image: NetworkImage(url),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(appScreenBackgroundDark.withValues(alpha: 0.4), BlendMode.darken),
      );
    } else if (url.contains("/data/user") && File(url).existsSync()) {
      return DecorationImage(
        image: FileImage(File(url)),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(appScreenBackgroundDark.withValues(alpha: 0.4), BlendMode.darken),
      );
    }
    return null;
  }

  Duration? parseDuration(String? durationString) {
    if (durationString == null || durationString.isEmpty) return null;
    try {
      var parts = durationString.split(':');
      if (parts.length == 3) {
        return Duration(
          hours: int.parse(parts[0]),
          minutes: int.parse(parts[1]),
          seconds: int.parse(parts[2].split('.')[0]),
        );
      } else if (parts.length == 2) {
        return Duration(
          minutes: int.parse(parts[0]),
          seconds: int.parse(parts[1].split('.')[0]),
        );
      }
    } catch (e) {
      log("Error parsing duration: $e");
    }
    return null;
  }

  /// Waits for the current ad to finish playing
  Future<void> _waitForAdToFinish() async {
    await adManager.isAdPlaying.stream.firstWhere((playing) => !playing);
  }

  List<Duration> getAllAdBreaks() {
    List<Duration> breaks = [];

    // Add Mid-rolls
    for (var ad in adManager.midRollAds) {
      if (ad.startAtSeconds != null) {
        breaks.add(Duration(seconds: ad.startAtSeconds!));
      }
    }

    // Add Overlays (if they should be marked on timeline)
    for (var ad in adManager.overlayAds) {
      if (ad.startTime > 0) {
        breaks.add(Duration(seconds: ad.startTime));
      }
    }

    // Sort breaks
    breaks.sort();

    return breaks;
  }

  //endregion

  //region Save Progress
  Future<void> saveContentToContinueWatch() async {
    if (videoModel.id > 0 && !isFromDownloads && (videoModel.details.type == VideoType.episode || videoModel.details.type == VideoType.movie || videoModel.details.type == VideoType.video)) {
      String watchedTime = '';
      String totalWatchedTime = '';
      if (playerManager.currentPosition.value.inSeconds == playerManager.currentVideoDuration.value.inSeconds) {
        return;
      }
      if (playerManager.currentPosition.value != Duration.zero) {
        watchedTime = _formatDuration(playerManager.currentPosition.value);
        totalWatchedTime = _formatDuration(playerManager.currentVideoDuration.value);
      }

      if (watchedTime.isEmpty || totalWatchedTime.isEmpty) {
        return;
      }

      await CoreServiceApis.saveContinueWatch(
        request: {
          ApiRequestKeys.entertainmentIdKey: videoModel.entertainmentId,
          ApiRequestKeys.watchedTimeKey: watchedTime,
          ApiRequestKeys.totalWatchedTimeKey: totalWatchedTime,
          ApiRequestKeys.entertainmentTypeKey: getTypeForContinueWatch(type: videoModel.details.type.toLowerCase()),
          if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
          if (videoModel.details.type.toLowerCase() == VideoType.episode) ApiRequestKeys.episodeIdKey: videoModel.id,
        },
      ).catchError((e) {
        log("Error ==> $e");
        throw e;
      });
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> _saveOfflineProgress() async {
    if (!isFromDownloads) return;
    try {
      final item = hiveService.contentBox.get(videoModel.id);
      if (item != null) {
        final int durationSec = playerManager.currentVideoDuration.value.inSeconds <= 0 ? 1 : playerManager.currentVideoDuration.value.inSeconds;
        final int positionSec = playerManager.currentPosition.value.inSeconds.clamp(0, durationSec);
        final double percent = ((positionSec / durationSec) * 100).clamp(0, 100).toDouble();
        item.watchedDuration = positionSec;
        item.totalDuration = durationSec;
        item.watchedProgress = percent;
        await hiveService.saveContent(item);
      }
    } catch (_) {}
  }

  Future<void> _markOfflineCompleted() async {
    if (!isFromDownloads) return;
    final item = hiveService.contentBox.get(videoModel.id);
    if (item != null) {
      item.watchedDuration = playerManager.currentPosition.value.inSeconds;
      item.totalDuration = playerManager.currentVideoDuration.value.inSeconds;
      item.watchedProgress = calculatePendingPercentage(
        playerManager.currentVideoDuration.value.toString(),
        playerManager.currentVideoDuration.value.toString(),
      ).$1;
      await hiveService.saveContent(item);
    }
  }

  //endregion

  //region PlayBack Controls
  Future<void> play() => playerManager.play();

  Future<void> pause() => playerManager.pause();

  Future<void> seekTo(Duration pos) {
    return playerManager.seekTo(pos);
  }

  Future<void> skipIntro() async {
    if (introEnd != null) {
      await seekTo(introEnd!);
      showSkipIntro(false);
    }
  }

  Future<void> playNextEpisode() async {
    if (remainingEpisodes.isEmpty) return;

    // Stop current playback
    await playerManager.stop();

    await getEpisodeContentData(episodeData: remainingEpisodes.first);
  }

  //endregion

  //region Quality Control
  Future<void> changeQuality(VideoData videoData) async {
    if (currentQuality.value.quality == videoData.quality) return;

    // Pause current playback
    if (playerManager.currentPosition.value != Duration.zero) {
      await playerManager.pause();
    }

    // Update quality
    currentQuality(videoData);
    currentVideoUrl(videoData.url);
    currentVideoType(videoData.urlType.toLowerCase());

    // Re-initialize player with new quality
    isBuffering(true);
    await playerManager
        .initialize(
      url: currentVideoUrl.value,
      type: currentVideoType.value.toLowerCase(),
      startAt: playerManager.currentPosition.value,
      thumbnail: videoModel.details.thumbnailImage,
      adBreaks: getAllAdBreaks(),
    )
        .then(
      (value) async {
        isBuffering(false);
      },
    ).catchError(
      (error) {
        hasError(true);
        isBuffering(false);
        errorMessage(locale.value.videoNotFound);
        stage(VideoPlayerStage.error);
      },
    );
  }

  //endregion

  //region Event Handlers
  // --- Event Handlers ---

  void _onProgress(Duration pos, Duration dur) {
    if (introStart != null && introEnd != null) {
      if (pos >= introStart! && pos <= introEnd!) {
        if (!showSkipIntro.value) {
          showSkipIntro(true);
        }
      } else {
        if (showSkipIntro.value) {
          showSkipIntro(false);
        }
      }
    }

    // Check for Next Episode
    if (remainingEpisodes.isNotEmpty && isInitialized.value && dur.inSeconds > 0) {
      // Show next episode prompt 30 seconds before end
      if (dur - pos <= const Duration(seconds: 30)) {
        if (!showNextEpisode.value) {
          showNextEpisode(true);
          thumbnailController.start(() {
            playNextEpisode();
          });
        }
      } else {
        if (showNextEpisode.value) {
          showNextEpisode(false);
          if (thumbnailController.countdown.value > 0) {
            thumbnailController.reset();
          }
        }
      }
    }

    // Update Subtitle
    subtitleText(playerManager.currentSubtitle.value);

    // Notify AdManager
    adManager.onContentProgress(pos, dur);

    // Save Progress Periodically (every 10 seconds)
    if ((pos - _lastSavedPosition).inSeconds.abs() >= 10) {
      _lastSavedPosition = pos;
      if (isFromDownloads) _saveOfflineProgress();
    }
  }

  void _onPlayerEvent(String event) {
    if (event == 'ended') {
      _handleVideoEnd();
      return;
    }

    if (event.startsWith('adBreak:')) {
      // Pause video
      playerManager.pause();

      stage(VideoPlayerStage.adPlaying);
      return;
    }

    if (event == 'error') {
      hasError(true);
      errorMessage('An error occurred while playing the video.');
      stage(VideoPlayerStage.error);
    }
  }

  Future<void> _handleVideoEnd() async {
    if (adManager.postRollAds.isNotEmpty && !isFromDownloads) {
      stage(VideoPlayerStage.adPlaying);
      // Play all post-rolls
      while (adManager.postRollAds.isNotEmpty) {
        await adManager.playNextPostRollAd();
        await _waitForAdToFinish();
      }
    }

    if (!isFromDownloads) storeViewCompleted();
    if (isFromDownloads) await _markOfflineCompleted();
  }

  Future<void> storeViewCompleted() async {
    final Map<String, dynamic> request = {
      ApiRequestKeys.entertainmentIdKey: videoModel.id,
      ApiRequestKeys.userIdKey: loginUserData.value.id,
      ApiRequestKeys.entertainmentTypeKey: videoModel.details.type,
      ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
    };

    await CoreServiceApis.saveViewCompleted(request: request);
  }

  //endregion

  //region Next Episode
  Future<void> getEpisodeContentData({bool showLoader = true, required PosterDataModel episodeData}) async {
    showNextEpisode(false);
    playerManager.isBuffering(true);
    playerManager.currentPosition(Duration.zero);
    playerManager.currentVideoDuration(Duration.zero);

    stage(VideoPlayerStage.loading);

    await CoreServiceApis.getContentDetails(
      contentId: episodeData.id,
      type: episodeData.details.type,
    ).whenComplete(() {
      playerManager.isBuffering(false);
      stage(VideoPlayerStage.playing);
    }).then(
      (value) {
        videoModel = value;
        onEpisodeChanged?.call(value);
        remainingEpisodes.removeWhere((element) => element.id == episodeData.id);
        _parseIntroOutro();
        thumbnailController.reset();
        update([videoModel, remainingEpisodes]);
        if (videoModel.details.hasContentAccess.getBoolInt())
          initializeVideo();
        else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      },
    );
  }

  //endregion

  //region Cleanup & App Lifecycle
  // --- Lifecycle ---

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (Platform.isAndroid && !adManager.isAdPlaying.value) {
        _enterPipOnBackground();
        return;
      }
      pause();
      if (adManager.isAdPlaying.value) {
        adManager.playerManager.pauseAd();
      }
      if (playerManager.isPlaying.value) {
        playerManager.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (isPipModeOn.value) return; // Video kept playing in PiP, no need to resume
      if (adManager.isAdPlaying.value) {
        adManager.playerManager.resumeAd();
      }
      if (playerManager.isPlaying.value) {
        playerManager.play();
      }
    }
  }

  /// Tries to enter Picture-in-Picture on Android when app goes to background.
  /// Returns true if PiP was entered (caller should not pause); false otherwise.
  Future<void> _enterPipOnBackground() async {
    try {
      final bool isPipEnabled =
          await platform.invokeMethod<bool>('showNativeView') ?? false;
      if (isPipEnabled) {
        isPipModeOn.value = true;
      } else {
        pause();
        if (playerManager.isPlaying.value) playerManager.pause();
      }
    } catch (_) {
      pause();
      if (playerManager.isPlaying.value) playerManager.pause();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  @override
  Future<void> onClose() async {
    if (isLoggedIn.value) {
      await saveContentToContinueWatch();
      await _saveOfflineProgress();
    }

    playerManager.dispose();
    adManager.dispose();
    thumbnailController.onClose();

    WakelockPlus.disable();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.onClose();
  }
//endregion
}