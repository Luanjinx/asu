import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';

class ThumbnailComponent extends StatelessWidget {
  final String thumbnailImage;
  final int nextEpisodeNumber;
  final String nextEpisodeName;
  final VoidCallback? onTap;
  final ThumbnailController thumbnailController;

  const ThumbnailComponent({
    super.key,
    required this.thumbnailImage,
    required this.nextEpisodeName,
    required this.nextEpisodeNumber,
    required this.thumbnailController,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // User tapped - stop timer and call callback immediately
        thumbnailController.stop();
        onTap?.call();
      },
      child: Container(
        width: Get.width * 0.30,
        height: Get.width * 0.18,
        decoration: boxDecorationDefault(color: cardColor, border: Border.all(color: dividerColor)),
        child: Stack(
          alignment: AlignmentGeometry.topCenter,
          children: [
            CachedImageWidget(
              url: thumbnailImage,
              fit: BoxFit.cover,
              radius: defaultRadius,
              width: Get.width * 0.30,
              height: Get.width * 0.18,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, appScreenBackgroundDark.withValues(alpha: 0.7)],
                ),
              ),
            ),
            PositionedDirectional(
              top: 8,
              child: Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  // Countdown Text
                  Obx(
                    () => thumbnailController.countdown.value > 0
                        ? AnimatedOpacity(
                            opacity: thumbnailController.visible.value ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              "${thumbnailController.countdown.value}",
                              style: boldTextStyle(size: 24),
                            ),
                          )
                        : const Offstage(),
                  ),

                  // Progress Circle
                  Obx(
                    () => thumbnailController.countdown.value > 0
                        ? SizedBox(
                            height: 32,
                            width: 32,
                            child: CircularProgressIndicator(
                              value: thumbnailController.progress.value,
                              strokeWidth: 4,
                              valueColor: const AlwaysStoppedAnimation<Color>(appColorPrimary),
                              backgroundColor: Colors.white24,
                            ),
                          )
                        : const Offstage(),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              start: 8,
              end: 8,
              bottom: 8,
              child: Text(
                nextEpisodeName,
                style: boldTextStyle(size: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ThumbnailController extends GetxController {
  RxInt countdown = 0.obs;
  RxDouble progress = 0.0.obs;
  RxBool visible = false.obs;

  Timer? _timer;
  int _totalDurationSeconds = 0;

  void reset() {
    countdown.value = 0;
    progress.value = 0.0;
    visible(false);
    _timer?.cancel();
    _timer = null;
    _totalDurationSeconds = 0;
  }

  void resume() {
    if (_timer == null && countdown.value > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        countdown.value -= 1;
        progress.value = _totalDurationSeconds == 0 ? 0 : countdown.value / _totalDurationSeconds;

        if (countdown.value <= 0) {
          stop();
        }
      });
      visible(true);
    }
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    visible(false);
  }

  void start(VoidCallback onComplete, {int countdownSeconds = 30}) {
    if (_timer != null) return; // prevent multiple starts

    visible(true);
    _totalDurationSeconds = countdownSeconds;
    countdown.value = countdownSeconds;
    progress.value = 1.0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value -= 1;
      progress.value = _totalDurationSeconds == 0 ? 0 : countdown.value / _totalDurationSeconds;

      if (countdown.value <= 0) {
        stop();
        onComplete();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    visible(false);
    _totalDurationSeconds = 0;
  }

  @override
  void onClose() {
    stop();
    super.onClose();
  }
}