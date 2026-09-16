import 'dart:ui' as ui show Image;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/load_image.dart' show loadImage;

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/constants.dart';
import '../../live_tv/live_tv_details/live_tv_details_screen.dart';


class ContentListComponent extends StatelessWidget {
  final PosterDataModel contentData;
  final int topTenIndex;
  final bool isLoading;
  final VoidCallback? onTap;
  final bool isHorizontalList;
  final double spacing;

  const ContentListComponent({
    super.key,
    required this.contentData,
    this.topTenIndex = -1,
    this.isLoading = false,
    this.onTap,
    this.isHorizontalList = false,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    // Get dynamic grid size (width + spacing)
    final dynamicSpacing = getDynamicSpacing(
      crossAxisChildrenCount: isHorizontalList ? 2 : 3,
      desiredSpacing: spacing,
    );

    double itemHeight = isHorizontalList ? Get.height * 0.12 : Get.height * 0.20;

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap ??
          () {
            if (isLoading) return;

            if (contentData.details.releaseDate.isNotEmpty && isComingSoon(contentData.details.releaseDate)) {
              final DashboardController comingSoonCont = Get.find<DashboardController>();
              comingSoonCont.currentIndex(2);
            } else if (contentData.details.type == VideoType.liveTv) {
              if (Get.isRegistered<LiveContentDetailsController>()) {
                Get.delete<LiveContentDetailsController>();
              }
              Get.to(() => LiveContentDetailsScreen(), arguments: contentData);
            } else {
              if (Get.isRegistered<ContentDetailsController>()) {
                Get.delete<ContentDetailsController>();
              }

              Get.to(() => ContentDetailsScreen(), arguments: contentData);
            }
          },
      child: Stack(
        children: [
          CachedImageWidget(
            height: itemHeight,
            width: dynamicSpacing.$1,
            url: contentData.posterImage,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            radius: 6,
            firstName: contentData.details.name,
          ),
          if (topTenIndex > -1)
            Container(
              height: itemHeight,
              width: dynamicSpacing.$1,
              decoration: BoxDecoration(
                borderRadius: radius(6),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    black.withValues(alpha: 0.3),
                    black.withValues(alpha: 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          if (!contentData.details.hasContentAccess.getBoolInt()) PositionedDirectional(end: ResponsiveSize.getEnd(6), top: ResponsiveSize.getTop(6), child: premiumTagWidget()),
          if (topTenIndex > -1)
            PositionedDirectional(
              start: 0,
              bottom: 0,
              child: FutureBuilder<ui.Image>(
                future: loadImage(AssetImage(Assets.assetsTexture)),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox(); // or loader
                  }

                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return ImageShader(
                        snapshot.data!,
                        TileMode.clamp,
                        TileMode.clamp,
                        Matrix4.identity().storage,
                      );
                    },
                    child: Text(
                      (topTenIndex + 1).toString(),
                      style: TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 0.9
                      ),
                      
                    ),
                  );
                },
              )
            ),
          if (contentData.details.access == MovieAccess.payPerView)
            PositionedDirectional(
              end: ResponsiveSize.getEnd(6),
              top: ResponsiveSize.getTop(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: boxDecorationDefault(
                  borderRadius: BorderRadius.circular(4),
                  color: rentedColor,
                ),
                child: Row(
                  spacing: 4,
                  children: [
                    IconWidget(
                      imgPath: Assets.iconsFilmReel,
                      size: 8,
                      color: primaryIconColor,
                    ),
                    Text(
                      contentData.details.hasContentAccess.getBoolInt() ? locale.value.rented : locale.value.rent,
                      style: commonSecondaryTextStyle(color: primaryTextColor, size: 10),
                    ),
                  ],
                ),
              ),
            ),
          if (contentData.details.imdbRating.isNotEmpty)
            PositionedDirectional(
              start: ResponsiveSize.getStart(6),
              top: ResponsiveSize.getTop(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: boxDecorationDefault(
                  borderRadius: BorderRadius.circular(4),
                  color: yellowColor,
                ),
                child: Row(
                  spacing: 4,
                  children: [
                    IconWidget(
                      imgPath: Assets.iconsStar,
                      size: 12,
                      color: primaryIconColor,
                    ),
                    Text(
                      contentData.details.imdbRating,
                      style: boldTextStyle(size: 10),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}