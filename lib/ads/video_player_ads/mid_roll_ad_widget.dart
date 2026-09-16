import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/managers/ad_manager.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:url_launcher/url_launcher.dart';

class XMLAdWidget extends StatelessWidget {
  final AdManager adManager;
  final bool isSplitView;

  const XMLAdWidget({
    super.key,
    required this.adManager,
    this.isSplitView = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final controller = adManager.adVideoController;
    final currentAd = adManager.currentAd.value;
    final isImage = currentAd != null && (currentAd.type == 'image' || currentAd.url.isImage);

    final visitUrl = adManager.currentAd.value?.clickThroughUrl;

    return GestureDetector(
      onTap: () {
        if (visitUrl != null && visitUrl.trim().isNotEmpty) {
          _openUrl(visitUrl);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isImage)
            CachedImageWidget(
              url: currentAd.url,
              height: Get.height,
              width: Get.width,
              fit: BoxFit.cover,
            )
          else
            Video(
              controller: controller!,
              controls: (state) => const SizedBox.shrink(),
              width: Get.width,
              aspectRatio: 16 / 9,
              pauseUponEnteringBackgroundMode: true,
              resumeUponEnteringForegroundMode: true,
              wakelock: true,
              fit: BoxFit.cover,
            ),
          _buildGradient(),
          Obx(() => adManager.playerManager.isBuffering.value ? LoaderWidget() : const SizedBox.shrink()),
          PositionedDirectional(
            top: isLandscape ? 32 : 10,
            start: isLandscape ? 56 : 16,
            child: _buildBadge(),
          ),
          PositionedDirectional(
            top: 12,
            end: 12,
            child: _buildSkipButton(),
          ),
          PositionedDirectional(
            bottom: isLandscape ? 32 : 16,
            end: isLandscape ? 48 : 16,
            child: _buildMuteButton(),
          ),
          PositionedDirectional(
            bottom: isLandscape ? 40 : 16,
            start: isLandscape ? 56 : 16,
            end: isLandscape ? 100 : 70, // Avoid mute button
            child: _buildProgressBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildGradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appScreenBackgroundDark.withValues(alpha: 0.35),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Obx(() {
      final currentAd = adManager.currentAd.value;
      final isImage = currentAd != null && (currentAd.type == 'image' || currentAd.url.isImage);

      if (isImage) return const SizedBox.shrink();

      final position = adManager.playerManager.currentPosition.value;
      final duration = adManager.playerManager.currentVideoDuration.value;

      final remaining = duration - position;
      // Avoid negative or weird values
      final remainingSeconds = remaining.inSeconds.clamp(0, duration.inSeconds);

      final minutes = (remainingSeconds ~/ 60).toString();
      final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: appScreenBackgroundDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Ad ${adManager.currentAdIndex.value}/${adManager.totalAdCount.value}',
                    style: boldTextStyle(size: 12, color: Colors.white),
                  ),
                  TextSpan(
                    text: ' • $minutes:$seconds',
                    style: commonW600PrimaryTextStyle(
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  if (currentAd?.adTitle != null && currentAd!.adTitle!.isNotEmpty)
                    TextSpan(
                      text: ' • ${currentAd.adTitle}',
                      style: commonW600PrimaryTextStyle(
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSkipButton() {
    return Obx(() {
      final remaining = adManager.skipTimer.value;
      final canSkip = adManager.canSkipAd;
      return ElevatedButton(
        onPressed: canSkip ? () => adManager.skipAd() : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: appScreenBackgroundDark.withValues(alpha: 0.65),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          visualDensity: VisualDensity.compact,
        ),
        child: Text(
          canSkip ? locale.value.skipAd : '${locale.value.skipIn(remaining)}',
          style: commonW600PrimaryTextStyle(size: 12),
        ),
      );
    });
  }

  Widget _buildMuteButton() {
    return Obx(() {
      final currentAd = adManager.currentAd.value;
      final isImage = currentAd != null && (currentAd.type == 'image' || currentAd.url.isImage);

      if (isImage) return const SizedBox.shrink();

      final isMuted = adManager.isAdMuted.value;
      return InkWell(
        onTap: () => adManager.toggleAdMute(),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: appScreenBackgroundDark.withValues(alpha: 0.55),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white24),
          ),
          child: Icon(
            isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    });
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final currentAd = adManager.currentAd.value;
      final isImage = currentAd != null && (currentAd.type == 'image' || currentAd.url.isImage);

      if (isImage) return const SizedBox.shrink();

      final position = adManager.playerManager.currentPosition.value.inMilliseconds;
      final duration = adManager.playerManager.currentVideoDuration.value.inMilliseconds;

      final double progress = (duration > 0) ? (position / duration).clamp(0.0, 1.0) : 0.0;

      return SizedBox(
        height: 6, // Slightly clearer
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(yellowColor),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    });
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {}
    }
  }
}