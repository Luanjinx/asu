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
  final int? episodeIndex;

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
    this.episodeIndex,
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
        episodeIndex = null,
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

    return SizedBox(
      width: Get.width * 0.45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: boxDecorationDefault(
              color: Colors.transparent,
              borderRadius: radius(6),
              border: Border.all(
                color: isSelected ? appColorPrimary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: radius(5),
              child: Stack(
                children: [
                  Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: CachedImageWidget(
                          url: episodeData.posterImage,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          topLeftRadius: 0,
                          topRightRadius: 0,
                        ),
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
                      // Removed gradient container
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
                      end: 4,
                      child: premiumTagWidget(),
                    )
                  else if (episodeData.details.access == MovieAccess.payPerView || episodeData.details.access == MovieAccess.oneTimePurchase)
                    PositionedDirectional(
                      top: 4,
                      end: 4,
                      child: rentalTagWidget(
                        hasAccess: episodeData.details.hasContentAccess.getBoolInt(),
                        size: 8,
                      ),
                    )
                ],
              ),
            ),
          ),
          Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    episodeIndex != null 
                        ? 'Ep ${episodeIndex! + 1}: ${episodeData.details.name.capitalizeEachWord()}'
                        : episodeData.details.name.capitalizeEachWord(),
                    style: commonW600PrimaryTextStyle(size: 14, color: isSelected ? appColorPrimary : textPrimaryColorGlobal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(vertical: 8),
        ],
      ),
    );
  }
}
