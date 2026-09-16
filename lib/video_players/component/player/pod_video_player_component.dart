import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/component/common/custom_overlay.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';

class PodVideoPlayerComponent extends StatelessWidget {
  final VideoPlayersController controller;

  const PodVideoPlayerComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final podController = controller.playerManager.podController;
    if (podController == null) return const SizedBox.shrink();

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return PodVideoPlayer(
      controller: podController,
      alwaysShowProgressBar: false,
      matchVideoAspectRatioToFrame: false,
      matchFrameAspectRatioToVideo: false,
      videoThumbnail: controller.getThumbnailImage(),
      overlayBuilder: (options) {
        return Obx(() {
          final duration = controller.playerManager.currentVideoDuration.value;
          final position = controller.playerManager.currentPosition.value;
          final hasTimeline =
              (duration.inSeconds > 0 || position.inSeconds > 0) ||
                  controller.videoModel.details.type == VideoType.liveTv;

          if (!hasTimeline || controller.adManager.isAdPlaying.value) {
            return const Offstage();
          }

          return CustomPodPlayerControlOverlay(
            position: controller.playerManager.currentPosition.value,
            duration: controller.playerManager.currentVideoDuration.value,
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
                    duration: controller.playerManager.currentVideoDuration.value,
                    preRollAds: controller.adManager.preRollAds,
                    midRollAds: controller.adManager.midRollAds,
                    postRollAds: controller.adManager.postRollAds,
                  );
                },
              );
            },
            showSettingsButton: !controller.isFromDownloads &&
                controller.stage.value != VideoPlayerStage.adPlaying &&
                controller.stage.value == VideoPlayerStage.playing &&
                controller.videoModel.details.type != VideoType.liveTv,
            onSettings: () {
              Scaffold.of(context).openDrawer();
            },
            showMuteButton: !controller.isFromDownloads && controller.stage.value != VideoPlayerStage.adPlaying && controller.stage.value == VideoPlayerStage.playing,
            isMuted: controller.playerManager.isMuted.value,
            onToggleMute: () {
              controller.playerManager.toggleMute();
            },
          );
        });
      },
    );
  }
}