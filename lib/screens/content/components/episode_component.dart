import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../content/content_details_controller.dart';
import '../../downloads/download_screen.dart';

class EpisodeComponent extends StatelessWidget {
  final PosterDataModel episodeData;
  final bool isShimmer;

  final bool isSelected;
  final VoidCallback? onDownloadTap;
  final Future<void> Function()? onPauseTap;
  final Future<void> Function()? onResumeTap;
  final Future<void> Function()? onCancelTap;
  final bool showDownloadButton;
  final bool isDownloaded;
  final bool isDownloading;
  final bool isPaused;
  final double downloadProgress;

  EpisodeComponent({
    super.key,
    required this.episodeData,
    this.isSelected = false,
    this.onDownloadTap,
    this.onPauseTap,
    this.onResumeTap,
    this.onCancelTap,
    this.showDownloadButton = false,
    this.isDownloaded = false,
    this.isDownloading = false,
    this.isPaused = false,
    this.downloadProgress = 0.0,
  })  : isShimmer = false,
        _downloadButtonKey = GlobalKey();

  EpisodeComponent.shimmer({super.key})
      : episodeData = PosterDataModel(details: ContentData()),
        isSelected = false,
        showDownloadButton = false,
        onDownloadTap = null,
        onPauseTap = null,
        onResumeTap = null,
        onCancelTap = null,
        isDownloaded = false,
        isDownloading = false,
        isPaused = false,
        downloadProgress = 0.0,
        isShimmer = true,
        _downloadButtonKey = null;

  final GlobalKey? _downloadButtonKey;

  @override
  Widget build(BuildContext context) {
    if (isShimmer) {
      return Container(
        width: Get.width,
        decoration: boxDecorationDefault(
          color: cardColor,
          borderRadius: radius(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            ShimmerWidget(
              height: Get.height * 0.16,
              width: Get.width,
              topLeftRadius: 6,
              topRightRadius: 6,
            ),
            Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.height,
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: Get.width / 3.5,
                  radius: 6,
                ),
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: Get.width,
                  radius: 6,
                ),
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: Get.width,
                  radius: 6,
                ),
              ],
            ).paddingSymmetric(horizontal: 12),
          ],
        ),
      );
    }

    return Container(
      decoration: boxDecorationDefault(
        color: cardColor,
        borderRadius: radius(6),
        border: Border.all(
          color: isSelected ? appColorPrimary : Colors.transparent,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  CachedImageWidget(
                    url: episodeData.posterImage,
                    height: Get.height * 0.16,
                    width: Get.width,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    topLeftRadius: 6,
                    topRightRadius: 6,
                  ),
                  if (isSelected)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Lottie.asset(
                        Assets.lottiePlaying,
                        height: 80,
                        repeat: true,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.color(['**'], value: appColorPrimary),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    height: Get.height * 0.16,
                    width: Get.width,
                    decoration: boxDecorationDefault(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: radiusCircular(6),
                        topEnd: radiusCircular(6),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          black.withValues(alpha: 0.001),
                          black.withValues(alpha: 0.002),
                          black.withValues(alpha: 0.5),
                          black.withValues(alpha: 0.7),
                          black.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  )
                ],
              ),
              if (episodeData.details.duration.isNotEmpty && (episodeData.details.duration != "00:00:00" && episodeData.details.watchedDuration != "00:00:01"))
                PositionedDirectional(
                  bottom: 4,
                  start: 4,
                  end: 4,
                  child: LinearProgressIndicator(
                    value: calculatePendingPercentage(
                      episodeData.details.duration,
                      episodeData.details.watchedDuration,
                    ).$1,
                    minHeight: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(appColorPrimary),
                    backgroundColor: appColorSecondary,
                  ),
                ),
              if (episodeData.details.access == MovieAccess.paidAccess && !episodeData.details.hasContentAccess.getBoolInt())
                PositionedDirectional(
                  top: 4,
                  start: 4,
                  child: premiumTagWidget(),
                )
              else if (episodeData.details.access == MovieAccess.payPerView || episodeData.details.access == MovieAccess.oneTimePurchase)
                PositionedDirectional(
                  top: 4,
                  start: 4,
                  child: rentalTagWidget(
                    hasAccess: episodeData.details.hasContentAccess.getBoolInt(),
                    size: 8,
                  ),
                )
            ],
          ),
          Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    episodeData.details.name.capitalizeEachWord(),
                    style: commonW600PrimaryTextStyle(size: 14),
                  ).expand(),
                  if (showDownloadButton)
                    IconButton(
                      key: _downloadButtonKey,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        // Show control menu when downloading or paused
                        if (isDownloading || isPaused) {
                          final overlay = Overlay.of(context);
                          final buttonContext = _downloadButtonKey?.currentContext;

                          if (buttonContext == null) return;

                          final RenderBox buttonBox = buttonContext.findRenderObject() as RenderBox;
                          final RenderBox overlayBox = overlay.context.findRenderObject() as RenderBox;

                          final RelativeRect position = RelativeRect.fromRect(
                            Rect.fromPoints(
                              buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox),
                              buttonBox.localToGlobal(buttonBox.size.bottomRight(Offset.zero), ancestor: overlayBox),
                            ),
                            Offset.zero & overlayBox.size,
                          );

                          final selected = await showMenu<String>(
                            context: context,
                            position: position,
                            items: [
                              if (isPaused)
                                PopupMenuItem(
                                  value: 'resume',
                                  child: Text(locale.value.resume),
                                )
                              else
                                PopupMenuItem(
                                  value: 'pause',
                                  child: Text(locale.value.pause),
                                ),
                              PopupMenuItem(
                                value: 'cancel',
                                child: Text(locale.value.cancel),
                              ),
                            ],
                          );

                          if (selected == 'pause') {
                            await onPauseTap?.call();
                          } else if (selected == 'resume') {
                            await onResumeTap?.call();
                          } else if (selected == 'cancel') {
                            await onCancelTap?.call();
                          }
                          return;
                        }

                        if (isDownloaded) {
                          await Get.to(() => DownloadScreen());
                          if (Get.isRegistered<ContentDetailsController>()) {
                            Get.find<ContentDetailsController>().refreshDownloadStatus();
                          }
                        } else {
                          onDownloadTap?.call();
                        }
                      },
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isDownloading)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                value: (downloadProgress / 100).clamp(0.0, 1.0),
                                strokeWidth: 2,
                                color: appColorPrimary,
                              ),
                            )
                          else if (isPaused)
                            Icon(
                              Icons.pause_circle_filled,
                              color: appColorPrimary,
                              size: 20,
                            )
                          else
                            IconWidget(
                              imgPath: isDownloaded ? Assets.iconsCheck : Assets.iconsDownload,
                              color: isDownloaded ? appColorPrimary : primaryIconColor,
                              size: 20,
                            ),
                          if (isDownloading)
                            Text(
                              '${downloadProgress.clamp(0, 100).toStringAsFixed(0)}%',
                              style: commonPrimaryTextStyle(size: 10),
                            )
                          else if (isPaused)
                            Text(
                              locale.value.paused,
                              style: commonPrimaryTextStyle(size: 10),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              if (episodeData.details.description.isNotEmpty)
                readMoreTextWidget(
                  episodeData.details.description,
                  trimLines: 3,
                ),
              if (episodeData.details.duration.isNotEmpty)
                TextIcon(
                  edgeInsets: EdgeInsets.zero,
                  prefix: IconWidget(imgPath: Assets.iconsClock, color: iconColor, size: 14),
                  text: episodeData.details.duration,
                  textStyle: commonSecondaryTextStyle(),
                )
            ],
          ).paddingSymmetric(horizontal: 12, vertical: 8),
        ],
      ),
    );
  }
}