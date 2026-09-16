import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/live_tv/components/live_card.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import 'custom_progress_bar.dart';

class CustomPodPlayerControlOverlay extends StatelessWidget {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final List<Duration> adBreaks;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final ValueChanged<Duration> onSeek;
  final VoidCallback? onReplay;
  final VoidCallback? onForward;
  final Widget? overlayAd;
  final bool isVisible;
  final bool isFullScreen;
  final bool showSkipButton;
  final String skipButtonLabel;
  final VoidCallback? onSkipButtonPressed;
  final bool isLiveTv;
  final VoidCallback? onBack;
  final VoidCallback? onCast;
  final VoidCallback? onSettings;
  final VoidCallback? onToggleMute;
  final VoidCallback? onUserInteract;

  final bool showBackButton;
  final bool showCastButton;
  final bool showSettingsButton;
  final bool showMuteButton;

  final bool isMuted;

  final String thumbnailUrl;

  const CustomPodPlayerControlOverlay({
    super.key,
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.adBreaks,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onSeek,
    this.onReplay,
    this.onForward,
    this.overlayAd,
    this.showSkipButton = false,
    this.skipButtonLabel = '',
    this.onSkipButtonPressed,
    this.isLiveTv = false,
    this.onBack,
    this.onCast,
    this.onSettings,
    this.onToggleMute,
    this.showBackButton = false,
    this.showCastButton = false,
    this.showSettingsButton = false,
    this.showMuteButton = false,
    this.isMuted = false,
    required this.isFullScreen,
    this.onUserInteract,
    this.isVisible = false,
    this.thumbnailUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        if (thumbnailUrl.isNotEmpty && !isPlaying)
          CachedImageWidget(
            url: thumbnailUrl,
            fit: BoxFit.cover,
          ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onUserInteract?.call,
                onDoubleTap: () {
                  if (Directionality.of(context) == TextDirection.rtl) {
                    onForward?.call();
                  } else {
                    onReplay?.call();
                  }
                  onUserInteract?.call();
                },
                child: Container(color: Colors.transparent),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onUserInteract?.call,
                onDoubleTap: () {
                  if (Directionality.of(context) == TextDirection.rtl) {
                    onReplay?.call();
                  } else {
                    onForward?.call();
                  }
                  onUserInteract?.call();
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
        IgnorePointer(
          ignoring: !isVisible,
          child: AnimatedOpacity(
            opacity: isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (showBackButton)
                  PositionedDirectional(
                    top: Platform.isIOS ? 25 : 16,
                    start: 16,
                    child: backButton(context: context),
                  ),

                PositionedDirectional(
                  top: Platform.isIOS ? 25 : 16,
                  end: isFullScreen ? 24 : 12,
                  child: Row(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showCastButton)
                        GestureDetector(
                          onTap: () {
                            onCast?.call();
                            onUserInteract?.call();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Obx(
                              () => IconWidget(
                                imgPath: appScreenCastConnected.value ? Assets.iconsScreencastFill : Assets.iconsScreencast,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      if (showMuteButton)
                        GestureDetector(
                          onTap: () {
                            onToggleMute?.call();
                            onUserInteract?.call();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: IconWidget(
                              imgPath: isMuted ? Assets.iconsSpeakerSimpleX : Assets.iconsSpeakerHigh,
                            ),
                          ),
                        ),
                      if (showSettingsButton)
                        GestureDetector(
                          onTap: () {
                            onSettings?.call();
                            onUserInteract?.call();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: IconWidget(imgPath: Assets.iconsGear),
                          ),
                        ),
                    ],
                  ),
                ),

                // --- Center Controls ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: TextIcon(
                        prefix: IconWidget(imgPath: Assets.iconsRewind),
                        text: '-${appConfigs.value.backwardSeekSeconds.toString()}',
                        textStyle: primaryTextStyle(),
                      ),
                      onPressed: () {
                        onReplay?.call();
                        onUserInteract?.call();
                      },
                    ),
                    IconButton(
                      icon: IconWidget(
                        imgPath: isPlaying ? Assets.iconsPauseCircle : Assets.iconsPlayFill,
                        size: 28,
                      ),
                      onPressed: () {
                        onPlayPause();
                        onUserInteract?.call();
                      },
                    ),
                    IconButton(
                      icon: TextIcon(
                        suffix: IconWidget(imgPath: Assets.iconsFastForward),
                        text: '+${appConfigs.value.forwardSeekSeconds.toString()}',
                        textStyle: primaryTextStyle(),
                      ),
                      onPressed: () {
                        onForward?.call();
                        onUserInteract?.call();
                      },
                    ),
                  ],
                ),

                // --- Bottom Controls ---
                PositionedDirectional(
                  bottom: Platform.isIOS ? 25 : 12,
                  start: 8,
                  end: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          if (showSkipButton && onSkipButtonPressed != null)
                            GestureDetector(
                              onTap: () {
                                onSkipButtonPressed?.call();
                                onUserInteract?.call();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: boxDecorationDefault(
                                  color: Colors.transparent,
                                  borderRadius: radius(24),
                                  border: Border.all(color: primaryTextColor),
                                ),
                                child: Text(
                                  skipButtonLabel,
                                  style: boldTextStyle(),
                                ),
                              ),
                            ),
                          if (showSkipButton && onSkipButtonPressed != null) 12.width,
                          if (isLiveTv)
                            LiveCard()
                          else
                            Text(
                              '${formatDuration(position)} / ${formatDuration(duration)}',
                              style: boldTextStyle(size: 14),
                            ).flexible(),
                        ],
                      ),
                      8.height,
                      CustomProgressBar(
                        position: position,
                        duration: duration,
                        adBreaks: adBreaks,
                        isAdPlaying: false,
                        onSeek: (duration) {
                          onSeek(duration);
                          onUserInteract?.call();
                        },
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  bottom: Platform.isIOS ? 45 : 32,
                  end: 24,
                  child: GestureDetector(
                    child: IconWidget(imgPath: isFullScreen ? Assets.iconsCornersIn : Assets.iconsCornersOut, size: 22),
                    onTap: () {
                      if (isFullScreen) {
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
                      onUserInteract?.call();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        overlayAd ?? const SizedBox.shrink(),
      ],
    );
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) return '$hours:$minutes:$seconds';
    return '$minutes:$seconds';
  }
}