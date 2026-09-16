import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/ads/managers/ad_manager.dart';
import 'package:streamit_laravel/ads/video_player_ads/mid_roll_ad_widget.dart';
import 'package:streamit_laravel/ads/video_player_ads/overlay_ad_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';

class PlayerAdStack extends StatelessWidget {
  final Widget content;
  final AdManager adManager;

  const PlayerAdStack({
    super.key,
    required this.content,
    required this.adManager,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final overlay = adManager.currentOverlay.value;
      final isAdPlaying = adManager.isAdPlaying.value;

      return Stack(
        children: [
          // Main Content (Always in tree)
          content,

          // Full Screen Ad
          if (isAdPlaying)
            Container(
              color: appScreenBackgroundDark,
              child: XMLAdWidget(adManager: adManager),
            ),

          // Overlay Ad (Only if needed and no full screen ad)
          if (!isAdPlaying && overlay != null)
            Positioned(
              bottom: 48,
              left: 24,
              child: OverlayAdWidget(
                overlayAd: overlay,
                remainingSeconds: adManager.overlayTimer.value,
                onClose: adManager.dismissOverlay,
              ),
            ),
        ],
      );
    });
  }
}