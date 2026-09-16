import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pod_player/pod_player.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/video_players/component/player/embeded_video_player_component.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_controller.dart';

class TrailerWidget extends StatelessWidget {
  final String? tag;
  final bool showTrailerLabel;
  final double? cardHeight;
  final String title;
  final VideoData trailerData;
  final VoidCallback? onTrailerSkip;
  final VoidCallback? onTrailerCompleted;

  /// If tag is not provided, a unique tag is generated per instance to ensure
  /// a unique controller so multiple PageViews never share the same Controller.
  late final String _instanceTag = tag ?? UniqueKey().toString();

  late TrailerController controller;

  TrailerWidget({
    super.key,
    required this.title,
    required this.trailerData,
    this.onTrailerSkip,
    this.cardHeight,
    required this.tag,
    this.showTrailerLabel = true,
    this.onTrailerCompleted,
  }) {
    // Ensure controller is registered
    if (!Get.isRegistered<TrailerController>(tag: _instanceTag)) {
      controller = Get.put(
        TrailerController(
          videoData: trailerData,
          onTrailerCompleted: onTrailerCompleted,
        ),
        tag: _instanceTag,
      );
    } else {
      controller = Get.find<TrailerController>(tag: _instanceTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      child: GetBuilder<TrailerController>(
        tag: _instanceTag,
        builder: (trailerController) {
          return SizedBox(
            height: isLandscape ? Get.height : cardHeight ?? Get.height * 0.35,
            width: Get.width,
            child: Stack(
              children: [
                // Video Player Content
                _buildVideoPlayer(controller, isLandscape),

                // Error State
                _buildErrorState(controller),

                // Initial Loading State (Thumbnail + Loader)
                Obx(() {
                  if (controller.playerManager.isPlaying.value) return const SizedBox.shrink();
                  return CachedImageWidget(
                    url: controller.videoData.posterImage.validate(),
                    width: Get.width,
                    height: Get.height,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  );
                }),

                Obx(
                  () => LoaderWidget().visible(controller.playerManager.isBuffering.value),
                ),

                // Back Button (Top Start) - Fullscreen or landscape
                

                // Trailer Tag (Top Start)
                if (showTrailerLabel)
                  PositionedDirectional(
                    top: isLandscape ? ResponsiveSize.getTop(28) : ResponsiveSize.getTop(16),
                    start: isLandscape ? ResponsiveSize.getStart(64) : ResponsiveSize.getStart(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                        color: btnColor,
                      ),
                      child: Text(
                        locale.value.trailer,
                        style: commonSecondaryTextStyle(color: white),
                      ),
                    ),
                  ),

                _buildControlsOverlay(trailerController, isLandscape),
                // Mute Button (Top End)
                PositionedDirectional(
                  top: 16,
                  end: isLandscape ? 24 : 16,
                  child: _buildMuteButton(controller),
                ),
                if (isLandscape)
                  PositionedDirectional(
                    top: ResponsiveSize.getTop(16),
                    start: ResponsiveSize.getStart(16),
                    child: backButton(
                      context: context,
                      onBackPressed: () {
                        if (isLandscape) {
                          SystemChrome.setPreferredOrientations(
                              [DeviceOrientation.portraitUp]);
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.edgeToEdge);
                        } else {
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.immersiveSticky);
                          SystemChrome.setPreferredOrientations(
                            [
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.landscapeRight,
                            ],
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= VIDEO PLAYER RESOLUTION =================

  Widget _buildVideoPlayer(TrailerController trailerController, bool isLandscape) {
    return Obx(() {
      final videoType = trailerController.videoData.urlType.toLowerCase();

      if (trailerController.isInitialized.value) {
        if (trailerController.playerManager.isPlayInPodPlayer(videoType)) {
          return _buildPodPlayer(trailerController, isLandscape);
        } else if (trailerController.playerManager.isPlayInWebviewPlayer(videoType)) {
          return _buildWebViewPlayer(trailerController, isLandscape);
        }

        return _buildErrorState(trailerController);
      } else
        return Offstage();
    });
  }

  Widget _buildWebViewPlayer(TrailerController trailerController, bool isLandscape) {
    return EmbeddedVideoPlayer(
      playerManager: trailerController.playerManager,
    );
  }

  Widget _buildPodPlayer(TrailerController trailerController, bool isLandscape) {
    final manager = trailerController.playerManager;
    return manager.podController != null && manager.podController!.isInitialised
        ? GestureDetector(
            onTap: () => manager.handleUserInteraction(),
            child: PodVideoPlayer(
              key: ValueKey(trailerController.videoData.url),
              controller: manager.podController!,
              alwaysShowProgressBar: false,
              videoTitle: Text(title, style: boldTextStyle()),
              videoAspectRatio: 16 / 9,
              frameAspectRatio: 16 / 9,
              overlayBuilder: (options) {
                return SizedBox();
              },
              podProgressBarConfig: const PodProgressBarConfig(
                circleHandlerColor: appColorPrimary,
                backgroundColor: borderColor,
                playingBarColor: appColorPrimary,
                bufferedBarColor: appColorSecondary,
                circleHandlerRadius: 6,
                height: 2.6,
                padding: EdgeInsets.only(bottom: 16, left: 8, right: 8),
              ),
              videoThumbnail: trailerController.getThumbnailImage(),
              onVideoError: () => _buildErrorState(trailerController),
              onLoading: (_) => LoaderWidget(loaderColor: appColorPrimary.withValues(alpha: 0.4)),
            ),
          )
        : const Offstage();
  }

  Widget _buildControlsOverlay(TrailerController trailerController, bool isLandscape) {
    if (!trailerController.isInitialized.value) {
      return const Offstage();
    }

    if (trailerController.isBuffering.value || !trailerController.isInitialized.value) {
      return const Offstage();
    }

    final playerManager = trailerController.playerManager;

    return Obx(
      () => GestureDetector(
        onTap: () => playerManager.handleUserInteraction(),
        child: AnimatedOpacity(
          opacity: playerManager.isVisible.value ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: isLandscape ? Get.height : cardHeight ?? Get.height * 0.35,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      appScreenBackgroundDark,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Obx(
                () => IconButton(
                  icon: IconWidget(
                    imgPath: controller.playerManager.isPlaying.value ? Assets.iconsPauseCircle : Assets.iconsPlayFill,
                    size: 28,
                  ),
                  onPressed: () {
                    if (controller.playerManager.isPlaying.value) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
              ),
              if (showTrailerLabel)
                PositionedDirectional(
                  bottom: Platform.isIOS ? 25 : 12,
                  start: isLandscape ? 24 : 16,
                  child: GestureDetector(
                    onTap: onTrailerSkip,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: boxDecorationDefault(
                        color: Colors.transparent,
                        borderRadius: radius(24),
                        border: Border.all(color: primaryTextColor),
                      ),
                      child: Text(
                        locale.value.skip,
                        style: boldTextStyle(),
                      ),
                    ),
                  ),
                ),
              PositionedDirectional(
                bottom: Platform.isIOS ? 25 : 12,
                end: isLandscape ? 24 : 16,
                child: GestureDetector(
                  child: IconWidget(imgPath: isLandscape ? Assets.iconsCornersIn : Assets.iconsCornersOut, size: 22),
                  onTap: () {
                    if (isLandscape) {
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    } else {
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                      SystemChrome.setPreferredOrientations(
                        [
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMuteButton(TrailerController trailerController) {
    final manager = trailerController.playerManager;

    return Obx(() {
      if (trailerController.isBuffering.value || !trailerController.isInitialized.value) {
        return const Offstage();
      }
      return GestureDetector(
        onTap: () => manager.toggleMute(),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: boxDecorationDefault(
            color: cardColor,
            shape: BoxShape.circle,
          ),
          child: IconWidget(
            imgPath: manager.isMuted.value ? Assets.iconsSpeakerSimpleX : Assets.iconsSpeakerHigh,
          ),
        ),
      );
    });
  }

  Widget _buildErrorState(TrailerController trailerController) {
    return Obx(() {
      if (!trailerController.hasError.value) {
        return const Offstage();
      }
      return Container(
        height: Get.height,
        width: Get.width,
        decoration: boxDecorationDefault(color: appScreenBackgroundDark),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconWidget(imgPath: Assets.iconsWarning, size: 34, color: white),
            10.height,
            Text(
              locale.value.videoNotFound,
              style: boldTextStyle(),
            ),
          ],
        ),
      );
    });
  }
}