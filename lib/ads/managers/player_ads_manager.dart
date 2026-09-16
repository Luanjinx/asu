import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/custom_ads/custom_ads.dart';
import 'package:streamit_laravel/ads/vast/vast_parser.dart';

class PlayerAdsManager extends GetxController {
  final List<CustomAds> ads;
  final VastParser _vastParser = VastParser();

  // State
  final Rx<CustomAds?> currentAd = Rx<CustomAds?>(null);
  final RxBool isLoading = false.obs;
  final RxBool showSkip = false.obs;
  final RxInt skipCountdown = 5.obs;
  final RxInt currentIndex = 0.obs;

  // Internal
  Timer? _skipTimer;
  Timer? _imageTimer;

  PlayerAdsManager({required this.ads});

  @override
  void onInit() {
    super.onInit();
    loadCurrentAd();
  }

  @override
  void onClose() {
    _cancelTimers();
    super.onClose();
  }

  void _cancelTimers() {
    _skipTimer?.cancel();
    _imageTimer?.cancel();
  }

  Future<void> loadCurrentAd() async {
    _cancelTimers();

    if (currentIndex.value >= ads.length) {
      Get.back(result: true); // All ads finished
      return;
    }

    final rawAd = ads[currentIndex.value];

    // Reset state
    showSkip.value = false;
    skipCountdown.value = 5;
    currentAd.value = null; // Clear current ad while loading/processing

    if (rawAd.url.trim().toLowerCase().endsWith('.xml')) {
      isLoading.value = true;
      try {
        final vastMedia = await _vastParser.fetchVastMedia(rawAd.url);
        isLoading.value = false;

        if (vastMedia != null && vastMedia.mediaUrls.isNotEmpty) {
          final resolvedAd = CustomAds(
            type: 'video',
            url: vastMedia.mediaUrls.first,
            redirectUrl: vastMedia.clickThroughUrls.isNotEmpty ? vastMedia.clickThroughUrls.first : rawAd.redirectUrl,
            size: rawAd.size,
          );
          currentAd.value = resolvedAd;
          // Note: Video ads start logic is triggered by the widget callbacks

          // Helper: If VAST parsing succeeded but we need to track things, we might do it here.
          // For now, we trust the CustomAdWidget to play the URL.
        } else {
          // Failed to parse or no media, skip to next
          handleNext();
          return;
        }
      } catch (e) {
        isLoading.value = false;
        log('PlayerAdsManager: Error parsing VAST: $e');
        handleNext();
        return;
      }
    } else {
      // Standard Direct Ad
      currentAd.value = rawAd;

      // If image, schedule timer immediately
      if (isImage(rawAd)) {
        startAdLogic();
      }
    }
  }

  void startAdLogic() {
    // Reset skip state
    showSkip.value = false;

    final ad = currentAd.value;
    if (ad != null && !isImage(ad)) {
      skipCountdown.value = 15;
    } else {
      skipCountdown.value = 5;
    }

    _cancelTimers();

    _skipTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (skipCountdown.value > 0) {
        skipCountdown.value--;
      } else {
        t.cancel();
        showSkip.value = true;
      }
    });

    if (ad != null && isImage(ad)) {
      _imageTimer = Timer(const Duration(seconds: 15), () {
        handleNext();
      });
    }
  }

  void handleNext() {
    _cancelTimers();
    currentIndex.value++;
    loadCurrentAd();
  }

  bool isImage(CustomAds ad) {
    return ad.type == 'image' || ad.url.isImage;
  }
}