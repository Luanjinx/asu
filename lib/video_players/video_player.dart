import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/video_player_ads/player_ad_stack.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/device_not_supported_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/components/other_details_component.dart';
import 'package:streamit_laravel/screens/rented_content/component/rent_details_component.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/component/common/custom_overlay.dart';
import 'package:streamit_laravel/video_players/component/common/thumbnail_component.dart';
import 'package:streamit_laravel/video_players/component/player/embeded_video_player_component.dart';
import 'package:streamit_laravel/video_players/component/player/pod_video_player_component.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';
import 'package:streamit_laravel/video_players/video_settings_dialog.dart';

// ignore: must_be_immutable
class VideoPlayersComponent extends StatelessWidget {
  final VideoPlayersController controller;

  const VideoPlayersComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      child: NewAppScaffold(
        isPinnedAppbar: true,
        bodyPadding: EdgeInsets.zero,
        isScrollableWidget: !isLandscape,
        appBarTitleText: controller.videoModel.details.name,
        hideAppBar: isLandscape,
        statusBarColor: isLandscape ? appScreenBackgroundDark : null,
        applyLeadingBackButton: !isLandscape,
        drawer: VideoSettingsDialog(videoPlayerController: controller),
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            isLandscape = MediaQuery.of(scaffoldContext).orientation == Orientation.landscape;
            return AnimatedWrap(
              alignment: WrapAlignment.center,
              runSpacing: 16,
              spacing: 16,
              children: [
                SizedBox(
                  height: !isLandscape ? Get.height * 0.24 : Get.height,
                  width: Get.width,
                  child: Obx(() {
                    if (!isLoggedIn.value) {
                      return GestureDetector(
                        onTap: () {
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          doIfLogin(onLoggedIn: () {});
                        },
                        child: _buildFallbackThumbnail(controller, isLandscape, scaffoldContext),
                      );
                    }

                    if (!isSupportedDevice.value) {
                      return DeviceNotSupportedComponent(
                        title: controller.videoModel.details.name,
                        height: !isLandscape ? Get.height * 0.24 : Get.height,
                        width: !isLandscape ? Get.width : Get.width * 0.90,
                      );
                    }

                    // Check for Access
                    if (!controller.videoModel.details.hasContentAccess.getBoolInt()) {
                      return GestureDetector(
                        onTap: () {
                          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          onSubscriptionLoginCheck(
                            callBack: () {},
                            content: controller.videoModel.details,
                            onPaymentDone: () {
                              controller.getEpisodeContentData(episodeData: controller.remainingEpisodes.first);
                            },
                            onRentalNoRented: () {
                              if (controller.videoModel.rentalData != null) {
                                Get.bottomSheet(
                                  AppDialogWidget(
                                    child: RentalDetailsComponent(
                                      onPauseCurrentVideo: () {
                                        controller.pause();
                                      },
                                      contentData: controller.videoModel,
                                      onWatchNow: () {},
                                      rentalData: controller.videoModel.rentalData!,
                                    ),
                                  ),
                                  isScrollControlled: true,
                                );
                              }
                            },
                          );
                        },
                        child: Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            _buildFallbackThumbnail(controller, isLandscape, scaffoldContext),
                            Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${locale.value.youDoNotHaveAccessToWatch} ${controller.videoModel.details.name}", style: boldTextStyle()),
                                watchNowButton(
                                  contentData: controller.videoModel,
                                  callBack: () {
                                    controller.initializeVideo();
                                  },
                                  onPaymentReturnCallBack: () {
                                    controller.initializeVideo();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    // Main Player Switch
                    return _buildPlayerByStage(scaffoldContext, controller, isLandscape);
                  }),
                ),
                if (!isLandscape)
                  OtherDetailsComponent(
                    contentData: controller.videoModel,
                    onNavigated: () {
                      controller.pause();
                    },
                  ).paddingSymmetric(horizontal: 12),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayerByStage(BuildContext ctx, VideoPlayersController controller, bool isLandscape) {
    switch (controller.stage.value) {
      case VideoPlayerStage.loading:
        return Container(
          color: appScreenBackgroundDark,
          child: _buildFallbackThumbnail(controller, isLandscape, ctx),
        );
      case VideoPlayerStage.error:
        return _buildErrorContainer(isLandscape);
      case VideoPlayerStage.playing:
      case VideoPlayerStage.adPlaying:
        return Stack(
          fit: StackFit.expand,
          children: [
            PlayerAdStack(
              content: _buildActivePlayer(ctx, controller),
              adManager: controller.adManager,
            ),

            Obx(
              () => controller.isBuffering.value
                  ? Align(
                      child: LoaderWidget(),
                    )
                  : const SizedBox.shrink(),
            ),
            Align(
              child: _buildAdCountdownOverlay(controller),
            ),
            // Subtitle Overlay
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildSubtitleOverlay(controller),
            ),

            // Next Episode Thumbnail
            PositionedDirectional(
              bottom: isLandscape ? 48 : 16,
              end: isLandscape ? 42 : 16,
              child: _buildNextEpisodeThumbnail(controller),
            ),
            // Buffering Loader
          ],
        );
    }
  }

  Widget _buildSubtitleOverlay(VideoPlayersController controller) {
    return Obx(() {
      if (controller.subtitleText.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: appScreenBackgroundDark.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          controller.subtitleText.value,
          textAlign: TextAlign.center,
          style: primaryTextStyle(),
        ),
      );
    });
  }

  Widget _buildNextEpisodeThumbnail(VideoPlayersController controller) {
    return Obx(() {
      if (!controller.showNextEpisode.value || controller.remainingEpisodes.isEmpty) {
        return const SizedBox.shrink();
      }

      final nextEpisode = controller.remainingEpisodes.first;

      return ThumbnailComponent(
        thumbnailImage: nextEpisode.posterImage,
        nextEpisodeName: nextEpisode.details.name,
        nextEpisodeNumber: 0,
        // Assuming we don't have explicit episode number in PosterDataModel easily accessible or just pass 0
        thumbnailController: controller.thumbnailController,
        onTap: () => controller.playNextEpisode(),
      );
    });
  }

  Widget _buildActivePlayer(BuildContext ctx, VideoPlayersController controller) {
    bool isLandscape = MediaQuery.of(ctx).orientation == Orientation.landscape;
    final type = controller.currentVideoType.toLowerCase();
    if (controller.playerManager.isPlayInWebviewPlayer(type)) {
      return Stack(
        alignment: Alignment.center,
        children: [
          EmbeddedVideoPlayer(playerManager: controller.playerManager),
          if (!controller.adManager.isAdPlaying.value)
            Obx(
              () => CustomPodPlayerControlOverlay(
                position: controller.playerManager.currentPosition.value,
                duration: controller.playerManager.currentVideoDuration.value,
                thumbnailUrl: controller.videoModel.details.thumbnailImage,
                bufferedPosition: Duration.zero,
                adBreaks: controller.getAllAdBreaks(),
                isPlaying: controller.playerManager.isPlaying.value,
                isLiveTv: controller.videoModel.details.type == VideoType.liveTv,
                showSkipButton: controller.showSkipIntro.value && !controller.adManager.isAdPlaying.value,
                skipButtonLabel: locale.value.skipIntro,
                onSkipButtonPressed: controller.showSkipIntro.value ? controller.skipIntro : null,
                onUserInteract: controller.playerManager.handleUserInteraction,
                isVisible: controller.playerManager.isVisible.value,
                onPlayPause: () {
                  if (controller.playerManager.isPlaying.value) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                onSeek: (d) => controller.seekTo(d),
                onReplay: () => controller.seekTo(controller.playerManager.currentPosition.value - Duration(seconds: appConfigs.value.backwardSeekSeconds)),
                onForward: () => controller.seekTo(controller.playerManager.currentPosition.value + Duration(seconds: appConfigs.value.forwardSeekSeconds)),
                isFullScreen: isLandscape,
                showBackButton: isLandscape,
                onBack: () async {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                },
                showCastButton: isCastingAvailable.value && !controller.isFromDownloads,
                onCast: () {
                  checkCastSupported(
                    onCastSupported: () {
                      controller.playerManager.enableCasting(
                        url: controller.currentQuality.value.url,
                        type: controller.currentQuality.value.urlType,
                        title: controller.videoModel.details.name,
                        thumbnail: controller.videoModel.details.thumbnailImage,
                        releaseDate: controller.videoModel.details.releaseDate,
                        subtitle: controller.subtitleText.value,
                      );
                    },
                  );
                },
                showSettingsButton: !controller.isFromDownloads &&
                    controller.stage.value != VideoPlayerStage.adPlaying &&
                    controller.stage.value == VideoPlayerStage.playing &&
                    controller.videoModel.details.type != VideoType.liveTv,
                onSettings: () {
                  Scaffold.of(ctx).openDrawer();
                },
                showMuteButton: !controller.isFromDownloads && controller.stage.value != VideoPlayerStage.adPlaying && controller.stage.value == VideoPlayerStage.playing,
                isMuted: controller.playerManager.isMuted.value,
                onToggleMute: () {
                  controller.playerManager.toggleMute();
                },
              ).paddingDirectional(end: 16, start: 12),
            ),
        ],
      );
    } else if (controller.playerManager.isPlayInPodPlayer(type)) {
      return PodVideoPlayerComponent(controller: controller);
    } else {
      return _buildErrorContainer(isLandscape);
    }
  }

  Widget _buildAdCountdownOverlay(VideoPlayersController controller) {
    final adManager = controller.adManager;
    return Obx(() {
      final countdown = adManager.midRollCountdown.value;
      if (countdown <= 0 || adManager.isAdPlaying.value) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: appScreenBackgroundDark.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white24, width: 1),
        ),
        child: Text(
          '${locale.value.adsLoadingIn} $countdown',
          style: commonPrimaryTextStyle(size: 12),
        ),
      );
    });
  }

  Widget _buildFallbackThumbnail(VideoPlayersController controller, bool isLandscape, BuildContext context) {
    return SizedBox(
      height: !isLandscape ? Get.height * 0.24 : Get.height,
      width: Get.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedImageWidget(
            url: controller.videoModel.details.thumbnailImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Obx(
            () => controller.isBuffering.value ? LoaderWidget() : const SizedBox.shrink(),
          ),
          if (isLandscape)
            PositionedDirectional(
              top: 16,
              start: 16,
              child: backButton(
                context: context,
                onBackPressed: () {
                  if (isLandscape) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorContainer(bool isLandscape) {
    return Container(
      height: !isLandscape ? Get.height * 0.24 : Get.height,
      width: Get.width,
      decoration: boxDecorationDefault(color: appScreenBackgroundDark),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconWidget(imgPath: Assets.iconsWarning, size: 34, color: primaryIconColor),
          10.height,
          Text(locale.value.videoNotFound, style: boldTextStyle()),
        ],
      ),
    );
  }
}