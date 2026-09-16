import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

class ContinueWatchingItemComponent extends StatelessWidget {
  final PosterDataModel continueWatchData;
  final double? width;
  final VoidCallback? onRemoveTap;

  const ContinueWatchingItemComponent({super.key, required this.continueWatchData, this.width, this.onRemoveTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (continueWatchData.isTvShow) {
          continueWatchData.details.type = VideoType.episode;
        }
        Get.to(() => ContentDetailsScreen(), arguments: continueWatchData);
      },
      child: Container(
        width: width ?? Get.width / 2,
        decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(4), color: cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CachedImageWidget(
                  url: continueWatchData.details.thumbnailImage.isNotEmpty ? continueWatchData.details.thumbnailImage : continueWatchData.posterImage,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  topRightRadius: 4,
                  topLeftRadius: 4,
                  alignment: Alignment.topCenter,
                ),
                IgnorePointer(
                  ignoring: true,
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          black.withValues(alpha: 0.0),
                          black.withValues(alpha: 0.4),
                          black.withValues(alpha: 0.6),
                          black.withValues(alpha: 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 0,
                  end: 0,
                  child: GestureDetector(
                    onTap: onRemoveTap,
                    child: Container(
                      height: 18,
                      width: 18,
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadius.circular(4),
                        color: appColorPrimary,
                      ),
                      alignment: Alignment.center,
                      child: IconWidget(imgPath: Assets.iconsX, size: 14, color: white),
                    ),
                  ),
                ),
              ],
            ),
            LinearProgressIndicator(
              value: calculatePendingPercentage(
                continueWatchData.details.duration,
                continueWatchData.details.watchedDuration,
              ).$1, // Extracts the first value (percentage) from the returned tuple
              minHeight: 2,
              valueColor: const AlwaysStoppedAnimation<Color>(appColorPrimary),
              backgroundColor: appColorSecondary,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  continueWatchData.details.type == VideoType.tvshow && continueWatchData.details.tvShowData?.episodeName.isNotEmpty == true
                      ? continueWatchData.details.tvShowData!.episodeName
                      : continueWatchData.details.name,
                  style: commonSecondaryTextStyle(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  calculatePendingPercentage(
                    continueWatchData.details.duration,
                    continueWatchData.details.watchedDuration,
                  ).$2,
                  style: commonSecondaryTextStyle(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ).paddingSymmetric(horizontal: 8, vertical: 8),
          ],
        ),
      ),
    );
  }
}