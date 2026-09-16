import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/models/ad_config.dart';
import 'package:streamit_laravel/ads/models/overlay_ad.dart';
import 'package:streamit_laravel/ads/vast/vast_parser.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/video_players/helper/player_manager.dart';

enum AdSlotType { preRoll, midRoll, postRoll, banner, player }

class AdManager with WidgetsBindingObserver {
  final PlayerManager playerManager;
  final VastParser _vastParser = VastParser();

  // State
  final RxBool isAdPlaying = false.obs;
  final RxBool isSkippable = false.obs;
  final RxInt skipTimer = 0.obs;
  final Rx<AdConfig?> currentAd = Rx<AdConfig?>(null);
  final Rx<OverlayAd?> currentOverlay = Rx<OverlayAd?>(null);
  final Rx<AdSlotType> activeSlot = AdSlotType.preRoll.obs;
  final RxInt overlayTimer = 0.obs;
  final RxInt midRollCountdown = 0.obs;

  // Ad Counters
  final RxInt totalAdCount = 0.obs;
  final RxInt currentAdIndex = 0.obs;

  // Progressive loading state
  final RxBool isFirstAdReady = false.obs;
  final RxBool isLoadingAds = false.obs;

  // Ad Lists
  List<AdConfig> preRollAds = [];
  final RxList<AdConfig> midRollAds = <AdConfig>[].obs;
  List<AdConfig> postRollAds = [];
  final RxList<OverlayAd> overlayAds = <OverlayAd>[].obs;

  // Internal
  Timer? _skipTimer;
  Timer? _overlayTimer;
  Timer? _imageAdTimer;
  StreamSubscription? _adCompletedSub;
  bool _midRollsLoaded = false;

  AdManager(this.playerManager);

  // --- Getters for UI ---

  VideoController? get adVideoController => playerManager.adVideoController;

  bool get canSkipAd => isSkippable.value && skipTimer.value == 0;

  RxBool get isAdMuted => playerManager.isAdAudioMuted;

  // --- Initialization ---

  Future<void> initialize(ContentModel videoModel, {Duration? totalDuration}) async {
    if (!videoModel.isAdsAvailable) return;
    WidgetsBinding.instance.addObserver(this);

    final adsData = videoModel.adsData?.vastAds;
    if (adsData == null) return;

    isLoadingAds(true);

    // Reset counters
    totalAdCount.value = adsData.preRoleAdUrl.length;
    currentAdIndex.value = 0;

    // Load Pre-rolls progressively with callback for first ad
    _loadAds(
      adsData.preRoleAdUrl,
      preRollAds,
      onFirstAdReady: () {
        isFirstAdReady(true);
        isLoadingAds(false);
      },
    ).catchError((e) {
      log('Pre-roll loading failed: $e');
      isLoadingAds(false);
    });

    // Update total count
    totalAdCount.value = preRollAds.length;

    // If we added player ads but no VAST pre-rolls were loading, we need to signal ready
    if (preRollAds.isNotEmpty && adsData.preRoleAdUrl.isEmpty) {
      isFirstAdReady(true);
      isLoadingAds(false);
    }

    // Load overlays in background (don't wait)
    _loadOverlays(adsData.overlayAdUrl, overlayAds);

    // Load Mid/Post roll in background
    _loadAds(adsData.midRoleAdUrl, midRollAds).then((_) {
      _midRollsLoaded = true;
      if (totalDuration != null && totalDuration.inSeconds > 0) {
        _scheduleMidRolls(totalDuration.inSeconds);
      } else {}
    });
    _loadAds(adsData.postRoleAdUrl, postRollAds);
  }

  void _scheduleMidRolls(int totalSeconds) {
    if (midRollAds.isEmpty) return;

    // Distribute evenly if no start time is present
    final segmentDuration = totalSeconds / (midRollAds.length + 1);
    for (var i = 0; i < midRollAds.length; i++) {
      if (midRollAds[i].startAtSeconds == null) {
        // Create a new AdConfig with the scheduled time (since fields are final)
        final scheduledTime = (segmentDuration * (i + 1)).toInt();
        midRollAds[i] = AdConfig(
          url: midRollAds[i].url,
          isSkippable: midRollAds[i].isSkippable,
          skipAfterSeconds: midRollAds[i].skipAfterSeconds,
          clickThroughUrl: midRollAds[i].clickThroughUrl,
          type: midRollAds[i].type,
          trackingEvents: midRollAds[i].trackingEvents,
          clickTrackingUrls: midRollAds[i].clickTrackingUrls,
          adTitle: midRollAds[i].adTitle,
          adSystem: midRollAds[i].adSystem,
          errorUrls: midRollAds[i].errorUrls,
          impressionUrls: midRollAds[i].impressionUrls,
          durationSeconds: midRollAds[i].durationSeconds,
          redirectUrl: midRollAds[i].redirectUrl,
          trackingUrl: midRollAds[i].trackingUrl,
          startAtSeconds: scheduledTime,
        );
      }
    }
  }

  Future<void> _loadAds(
    List<String> urls,
    List<AdConfig> targetList, {
    Function()? onFirstAdReady,
  }) async {
    if (urls.isEmpty) return;

    // Launch all fetches concurrently
    bool firstAdNotified = false;
    final futures = urls.map((url) async {
      final adConfig = await _fetchSingleAd(url);
      if (adConfig != null) {
        targetList.add(adConfig);

        // Notify on first successful ad
        if (!firstAdNotified && onFirstAdReady != null) {
          firstAdNotified = true;
          onFirstAdReady();
        }
      }
    }).toList();

    // Wait for all to complete (but don't block initialization)
    await Future.wait(futures, eagerError: false);
  }

  Future<AdConfig?> _fetchSingleAd(String url) async {
    try {
      final vast = await _vastParser.fetchVastMedia(url);
      if (vast != null && vast.mediaUrls.isNotEmpty) {
        return AdConfig(
          url: vast.mediaUrls.first,
          isSkippable: vast.skipDuration != null,
          skipAfterSeconds: vast.skipDuration ?? 5,
          clickThroughUrl: vast.clickThroughUrls.firstOrNull,
          durationSeconds: vast.linearDurationSeconds ?? 30,
          type: '',
          adTitle: vast.adTitle,
        );
      }
    } catch (e) {
      log('Error fetching ad from $url: $e');
    }
    return null;
  }

  Future<void> _loadOverlays(List<String> urls, List<OverlayAd> targetList) async {
    for (final url in urls) {
      try {
        final vast = await _vastParser.fetchVastMedia(url);
        if (vast == null) {
          log('AdManager: VastParser returned null for overlay URL: $url');
          continue;
        }

        log('AdManager: Parsing VAST Overlay response for: $url');

        // Use nullable vars (null == not present)
        String? chosenImage;
        String? chosenHtml;
        String? chosenVideo;
        String? chosenClick;

        // Prefer explicit non-linear fields from VastMedia (parser should have cleaned CDATA)
        if (vast.nonLinearVideoUrl != null && vast.nonLinearVideoUrl!.trim().isNotEmpty) {
          chosenVideo = vast.nonLinearVideoUrl!.trim();
        }

        if (chosenVideo == null && vast.nonLinearHtmlResource != null && vast.nonLinearHtmlResource!.trim().isNotEmpty) {
          chosenHtml = vast.nonLinearHtmlResource!.trim();
        }

        if (chosenVideo == null && chosenHtml == null && vast.nonLinearImageUrl != null && vast.nonLinearImageUrl!.trim().isNotEmpty) {
          chosenImage = vast.nonLinearImageUrl!.trim();
        }

        // fallback: if nothing found in non-linear, use first linear media (could be a poster / creative)
        if (chosenVideo == null && chosenHtml == null && chosenImage == null && vast.mediaUrls.isNotEmpty) {
          // choose first media, but only if it looks like an image OR we assume it's an image creative
          final first = vast.mediaUrls.first.trim();
          if (first.isNotEmpty) {
            chosenImage = first;
          }
        }

        // Build click URL preference: NonLinearClickThrough -> ClickThroughs -> empty
        chosenClick = (vast.nonLinearClickThroughUrl?.trim().isNotEmpty == true) ? vast.nonLinearClickThroughUrl!.trim() : (vast.clickThroughUrls.isNotEmpty ? vast.clickThroughUrls.first.trim() : '');

        // If no creative found, skip
        if ((chosenVideo == null || chosenVideo.isEmpty) && (chosenHtml == null || chosenHtml.isEmpty) && (chosenImage == null || chosenImage.isEmpty)) {
          log('AdManager: No valid overlay creative found for VAST: $url - skipping.');
          continue;
        }

        // Determine type
        final OverlayAdType forcedType = (chosenVideo != null && chosenVideo.isNotEmpty)
            ? OverlayAdType.video
            : (chosenHtml != null && chosenHtml.isNotEmpty)
                ? OverlayAdType.html
                : OverlayAdType.image;

        // duration/skip: prefer nonLinearDurationSeconds, fallback to vast.skipDuration, fallback 5/15
        final int duration = vast.nonLinearDurationSeconds ?? (forcedType == OverlayAdType.video ? (vast.linearDurationSeconds ?? 30) : 15);
        final int skipDuration = vast.nonLinearDurationSeconds ?? vast.skipDuration ?? 5;

        // startTime: VAST NonLinear usually doesn't define start time; default to 10s (player will schedule)
        final int startTime = 10;

        final overlay = OverlayAd(
          imageUrl: chosenImage ?? '',
          htmlContent: chosenHtml ?? '',
          videoUrl: chosenVideo,
          clickThroughUrl: chosenClick,
          startTime: startTime,
          duration: duration,
          skipDuration: skipDuration,
          type: forcedType,
        );

        // Safety check again
        if (overlay.imageUrl.isEmpty && overlay.htmlContent.isEmpty && (overlay.videoUrl == null || overlay.videoUrl!.isEmpty)) {
          log('AdManager: Overlay created but content empty -> skipping. VAST: $url');
          continue;
        }

        log('AdManager: Added OverlayAd -> type:${overlay.type}, start:$startTime, duration:${overlay.duration}, skip:${overlay.skipDuration}, click:${overlay.primaryClickUrl ?? '[none]'}');
        targetList.add(overlay);
      } catch (e, st) {
        log('AdManager: Error loading overlay from $url -> $e\n$st');
      }
    }
  }

  Future<void> loadAndPlayAd(String url) async {
    await _finishAd(); // Ensure previous ad is finished

    final ad = currentAd.value;
    final isImage = ad != null && (ad.type == 'image' || ad.url.isImage);

    if (isImage) {
      log('Playing Image Ad: $url');
      _startImageAdTimer(ad.durationSeconds ?? 10);
    } else {
      await playerManager.playAd(url);
      // Listen for completion
      handleAdFinished();
    }

    isAdPlaying(true);
    _startSkipTimer();
  }

  /// Plays the next pre-roll ad from the queue
  Future<bool> playNextPreRollAd() async {
    if (preRollAds.isEmpty) return false;

    final ad = preRollAds.removeAt(0);
    currentAd.value = ad;
    activeSlot.value = AdSlotType.preRoll;

    // Increment counter
    currentAdIndex.value++;

    final isImage = ad.type == 'image' || ad.url.isImage;

    if (isImage) {
      _startImageAdTimer(ad.durationSeconds ?? 10);
    } else {
      await playerManager.playAd(ad.url);
      // Listen for completion
      handleAdFinished();
    }

    isAdPlaying(true);
    isSkippable.value = ad.isSkippable;
    skipTimer.value = ad.skipAfterSeconds;
    _startSkipTimer();

    return true;
  }

  void handleAdFinished() {
    _adCompletedSub?.cancel();
    _adCompletedSub = playerManager.adVideoController?.player.stream.completed.listen((completed) {
      if (completed) {
        _finishAd();
      }
    });
  }

  Future<void> skipAd() async {
    if (!isAdPlaying.value) return;
    await _finishAd();
  }

  void toggleAdMute() {
    playerManager.setAdMute(!isAdMuted.value);
  }

  Future<void> _finishAd() async {
    if (!isAdPlaying.value) return; // Prevent multiple calls

    _skipTimer?.cancel();
    _imageAdTimer?.cancel();
    _adCompletedSub?.cancel();
    await playerManager.stopAd();
    isAdPlaying(false);
    currentAd.value = null;

    if (activeSlot.value == AdSlotType.preRoll) {
      // Try to play next pre-roll
      final hasMore = await playNextPreRollAd();
      if (!hasMore) {
        // No more pre-rolls, start content
        log('AdManager: All pre-rolls finished. Starting content.');
        await playerManager.play();
      }
    } else if (activeSlot.value == AdSlotType.postRoll) {
      // Try to play next post-roll
      final hasMore = await playNextPostRollAd();
      if (!hasMore) {
        log('AdManager: All post-rolls finished.');
      }
    } else {
      // Mid-roll or others -> Resume content
      log('AdManager: Ad finished. Resuming content.');
      await playerManager.play();
    }
  }

  void _startSkipTimer() {
    _skipTimer?.cancel();
    // Default to 5 seconds if no config
    int duration = currentAd.value?.skipAfterSeconds ?? 5;
    skipTimer.value = duration;
    isSkippable.value = true; // Assume skippable for now or check config

    _skipTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (skipTimer.value > 0) {
        skipTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> dismissOverlay() async {
    log('AdManager: dismissOverlay called');
    _overlayTimer?.cancel();
    final wasVideo = currentOverlay.value?.isVideo ?? false;
    currentOverlay.value = null;

    if (wasVideo) {
      await playerManager.play();
    }
  }

  // --- Lifecycle ---

  void onContentProgress(Duration position, Duration duration) {
    if (isAdPlaying.value) return;

    // Check Mid-rolls
    if (_midRollsLoaded && midRollAds.isNotEmpty) {
      final adToPlay = midRollAds.firstWhereOrNull((ad) {
        final start = ad.startAtSeconds ?? -1;
        if (start == -1) return false;
        final diff = (position.inSeconds - start).abs();
        return diff <= 1; // 1 second window
      });

      if (adToPlay != null) {
        midRollAds.remove(adToPlay);
        _playMidRoll(adToPlay);
        return;
      }
    }

    // Check Overlays
    if (overlayAds.isNotEmpty) {
      final overlay = overlayAds.firstWhereOrNull((ad) {
        final diff = (position.inSeconds - ad.startTime).abs();
        return diff <= 1;
      });

      if (overlay != null) {
        overlayAds.remove(overlay); // Show once
        _showOverlay(overlay);
      }
    }
  }

  Future<void> _playMidRoll(AdConfig ad) async {
    // Pause content
    await playerManager.pause();

    currentAd.value = ad;
    activeSlot.value = AdSlotType.midRoll;
    currentAdIndex.value = 1;
    totalAdCount.value = 1;

    await loadAndPlayAd(ad.url);

    isSkippable.value = ad.isSkippable;
    skipTimer.value = ad.skipAfterSeconds;
    _startSkipTimer();
  }

  Future<void> _showOverlay(OverlayAd overlay) async {
    log('AdManager: showing overlay (Type: ${overlay.type})');
    currentOverlay.value = overlay;

    // Cancel any existing overlay timer first
    _overlayTimer?.cancel();

    // Start timer for dismissal (countdown)
    // We update the observable timer so UI can show it
    final int totalDuration = overlay.duration > 0 ? overlay.duration : 10;
    overlayTimer.value = totalDuration;

    _overlayTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (overlayTimer.value > 0) {
        overlayTimer.value--;
      } else {
        timer.cancel();
        log('AdManager: Overlay timer finished, dismissing.');
        dismissOverlay();
      }
    });

    if (overlay.isVideo) {
      log('AdManager: Pausing content for video overlay');
      await playerManager.pause();
    }
  }

  /// Plays the next post-roll ad
  Future<bool> playNextPostRollAd() async {
    if (postRollAds.isEmpty) return false;

    if (activeSlot.value != AdSlotType.postRoll) {
      currentAdIndex.value = 0;
      totalAdCount.value = postRollAds.length;
    }

    final ad = postRollAds.removeAt(0);
    currentAd.value = ad;
    activeSlot.value = AdSlotType.postRoll;
    currentAdIndex.value++;

    final isImage = ad.type == 'image' || ad.url.isImage;
    if (isImage) {
      _startImageAdTimer(ad.durationSeconds ?? 10);
    } else {
      await playerManager.playAd(ad.url);
      handleAdFinished();
    }

    isAdPlaying(true);
    isSkippable.value = ad.isSkippable;
    skipTimer.value = ad.skipAfterSeconds;
    _startSkipTimer();

    return true;
  }

  void _startImageAdTimer(int duration) {
    _imageAdTimer?.cancel();
    _imageAdTimer = Timer(Duration(seconds: duration), () {
      _finishAd();
    });
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _skipTimer?.cancel();
    _overlayTimer?.cancel();
    _imageAdTimer?.cancel();
    _adCompletedSub?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isAdPlaying.value) {
        final ad = currentAd.value;
        final isImage = ad != null && (ad.type == 'image' || ad.url.isImage);

        if (!isImage) {
          log('App Resumed: Resuming Ad Playback');
          playerManager.resumeAd();
        }
      }
    }
  }
}