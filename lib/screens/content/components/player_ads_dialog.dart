import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/custom_ads/custom_ads.dart';
import 'package:streamit_laravel/ads/managers/player_ads_manager.dart';
import 'package:streamit_laravel/ads/video_player_ads/custom_ad_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart' as model;
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class PlayerAdsDialog extends StatefulWidget {
  final List<model.CustomAds> ads;

  const PlayerAdsDialog({super.key, required this.ads});

  @override
  State<PlayerAdsDialog> createState() => _PlayerAdsDialogState();
}

class _PlayerAdsDialogState extends State<PlayerAdsDialog> {
  late PlayerAdsManager controller;
  final String tag = 'player_ads_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    final convertedAds = widget.ads
        .map(
          (e) => CustomAds(
            type: e.type,
            url: e.url,
            redirectUrl: e.redirectUrl,
            size: Get.height * 0.25,
          ),
        )
        .toList();

    controller = Get.put(PlayerAdsManager(ads: convertedAds), tag: tag);
  }

  @override
  void dispose() {
    Get.delete<PlayerAdsManager>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopScope(
        // canPop: controller.showSkip.value,
        onPopInvokedWithResult: (didPop, result) {},
        child: Dialog(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(8)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: Get.width,
                  height: Get.height * 0.25,
                  decoration: boxDecorationDefault(color: appScreenBackgroundDark),
                  child: controller.initialized && controller.currentAd.value != null
                      ? CustomAdWidget(
                          ad: controller.currentAd.value!,
                          onVideoStarted: () {
                            controller.startAdLogic();
                          },
                          onVideoCompleted: () {
                            controller.handleNext();
                          },
                          onVideoError: () {
                            controller.handleNext();
                          },
                        )
                      : const SizedBox(),
                ),
                if (controller.isLoading.value && controller.currentAd.value == null) const Center(child: CircularProgressIndicator()),
                if (!controller.isLoading.value && controller.initialized && controller.currentAd.value != null)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _buildSkipButton(),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSkipButton() {
    return ElevatedButton(
      onPressed: controller.showSkip.value
          ? () {
              controller.handleNext();
            }
          : null,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: Colors.black26,
        backgroundColor: appScreenBackgroundDark.withValues(alpha: 0.50),
        foregroundColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        visualDensity: VisualDensity.compact,
      ),
      child: Text(
        controller.showSkip.value ? locale.value.skipAd : '${locale.value.skipIn(controller.skipCountdown.value)}',
        style: commonW600PrimaryTextStyle(size: 12),
      ),
    );
  }
}