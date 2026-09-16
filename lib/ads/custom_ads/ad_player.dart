import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/custom_ads/ad_player_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/colors.dart';

class AdPlayer extends StatefulWidget {
  final String videoUrl;

  final String redirectUrl;
  final String adType;
  final double? height;
  final double? width;
  final bool isFromPlayerAd;
  final ValueChanged<RxBool>? startSkipTimer;

  const AdPlayer({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
    this.isFromPlayerAd = false,
    this.startSkipTimer,
    required this.redirectUrl,
    this.adType = '',
    this.onVideoCompleted,
    this.onVideoStarted,
    this.onVideoError,
  });

  final VoidCallback? onVideoCompleted;
  final VoidCallback? onVideoStarted;
  final VoidCallback? onVideoError;

  @override
  State<AdPlayer> createState() => _AdPlayerState();
}

class _AdPlayerState extends State<AdPlayer> {
  late final String tag;

  @override
  void initState() {
    super.initState();
    tag = widget.videoUrl;
  }

  @override
  void dispose() {
    // Force deletion of the controller to free native resources immediately
    Get.delete<AdPlayerController>(tag: tag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    // Using tag to allow multiple instances if needed (though unlikely for ads)
    final controller = Get.put(
      AdPlayerController(
        videoUrl: widget.videoUrl,
        isFromPlayerAd: widget.isFromPlayerAd,
        startSkipTimer: widget.startSkipTimer,
        adType: widget.adType,
        onVideoCompleted: widget.onVideoCompleted,
        onVideoStarted: widget.onVideoStarted,
        onVideoError: widget.onVideoError,
      ),
      tag: tag,
    );

    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: appScreenBackgroundDark,
        ),
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Obx(() {
          if (controller.hasError.value) return _errorWidget();
          return SizedBox(
            height: widget.height ?? Get.height * 0.15,
            width: widget.width ?? Get.width,
            child: GestureDetector(
              onTap: () {
                if (widget.redirectUrl.isNotEmpty) {
                  launchUrlCustomURL(widget.redirectUrl);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (controller.isPlayerReady.value)
                    Video(
                      controller: controller.videoController!,
                      controls: (state) => const SizedBox.shrink(),
                      height: widget.height,
                      width: widget.width ?? Get.width,
                      aspectRatio: 16 / 9,
                      pauseUponEnteringBackgroundMode: true,
                      wakelock: true,
                      fit: BoxFit.cover,
                      resumeUponEnteringForegroundMode: true,
                    ).cornerRadiusWithClipRRect(6),
                  Obx(
                    () => controller.isBuffering.value ? LoaderWidget() : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _errorWidget() {
    return Container(
      height: 200,
      width: Get.width,
      decoration: boxDecorationDefault(color: appScreenBackgroundDark),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconWidget(imgPath: Assets.iconsWarning, size: 34, color: primaryIconColor),
          10.height,
          Text(
            locale.value.videoNotFound,
            style: boldTextStyle(),
          ),
        ],
      ),
    );
  }
}