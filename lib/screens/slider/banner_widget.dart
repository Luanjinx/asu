import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/components/auto_slider_component.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/live_tv/components/live_card.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_controller.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_screen.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class BannerWidget extends StatelessWidget {
  final String tag;

  final SliderController sliderController;
  final bool isFromWatchingProfile;
  final double? collapsedHeight;
  final double? expandedHeight;

  const BannerWidget({
    super.key,
    required this.sliderController,
    this.isFromWatchingProfile = false,
    required this.tag,
    this.collapsedHeight,
    this.expandedHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (sliderController.listContent.isEmpty && !sliderController.isLoading.value) {
          return const Offstage();
        }

        if (sliderController.isLoading.value && sliderController.listContent.isEmpty) {
          return ShimmerWidget(
            height: expandedHeight ?? Get.height * 0.42,
            width: Get.width,
          );
        }

        return AutoSliderComponent(
          tag: tag,
          height: expandedHeight ?? Get.height * 0.42,
          sliderLength: sliderController.listContent.length,
          sliderChildren: List.generate(
            sliderController.listContent.length,
            (index) {
              PosterDataModel data = sliderController.listContent[index];
              return GestureDetector(
                onTap: () {
                  if (!isFromWatchingProfile) {
                    if (data.details.type == VideoType.liveTv) {
                      if (Get.isRegistered<LiveContentDetailsController>()) {
                        Get.delete<LiveContentDetailsController>();
                      }
                      Get.to(() => LiveContentDetailsScreen(), arguments: data);
                    } else {
                      if (Get.isRegistered<ContentDetailsController>()) {
                        Get.delete<ContentDetailsController>();
                      }
                      Get.to(() => ContentDetailsScreen(), arguments: data);
                    }
                  }
                },
                child: Stack(
                  children: [
                    CachedImageWidget(
                      url: data.posterImage,
                      width: Get.width,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      height: expandedHeight ?? Get.height * 0.45,
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: expandedHeight ?? Get.height * 0.45,
                        width: Get.width,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              black.withValues(alpha: 0.2),
                              black.withValues(alpha: 0.5),
                              black.withValues(alpha: 0.8),
                              black.withValues(alpha: 0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    if (data.details.type == VideoType.liveTv)
                      PositionedDirectional(
                        top: ResponsiveSize.getTop(14),
                        start: ResponsiveSize.getStart(46),
                        child: const LiveCard(),
                      ),
                    sliderDetails(context, sliderController, data, index),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  PositionedDirectional sliderDetails(
    BuildContext context,
    SliderController sliderController,
    PosterDataModel contentData,
    int index, {
    Color? buttonColor,
  }) {
    final bool isPromotionalBanner = sliderController.sliderType.value == BannerType.promotional;
    final String displayTitle = isPromotionalBanner ? (contentData.details.name.trim().isNotEmpty ? contentData.details.name : locale.value.walkthroughTitle2) : contentData.details.name;
    final String displayDescription =
        isPromotionalBanner ? (contentData.details.description.trim().isNotEmpty ? contentData.details.description : locale.value.walkthroughDesp2) : contentData.details.description;

    return PositionedDirectional(
      bottom: ResponsiveSize.getBottom(20),
      start: 0,
      end: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (contentData.details.genres.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                contentData.details.genres.join(' • '),
                style: commonSecondaryTextStyle(size: 12),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          if (contentData.details.genres.isNotEmpty) 4.height,
          Text(
            displayTitle,
            style: commonW500PrimaryTextStyle(size: isFromWatchingProfile ? 18 : 20),
            textAlign: TextAlign.center,
          ),
          if (isPromotionalBanner && displayDescription.trim().isNotEmpty) ...[
            8.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                displayDescription,
                style: commonSecondaryTextStyle(size: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (contentData.details.releaseDate.isNotEmpty) ...[
                const CachedImageWidget(
                  url: Assets.iconsCalendar,
                  height: 14,
                  width: 14,
                  color: iconColor,
                ),
                6.width,
                Text(
                  contentData.details.releaseDate.isNotEmpty ? contentData.details.releaseYear : "",
                  style: commonSecondaryTextStyle(size: 12),
                ),
                24.width,
              ],
              if (contentData.details.language.isNotEmpty && contentData.details.type != VideoType.video)
                const CachedImageWidget(
                  url: Assets.iconsTranslate,
                  height: 14,
                  width: 14,
                  color: iconColor,
                ),
              6.width,
              if (contentData.details.language.isNotEmpty && contentData.details.type != VideoType.video)
                Text(
                  contentData.details.language.capitalizeFirst!.validate(),
                  style: commonSecondaryTextStyle(size: 12),
                ),
              if (contentData.details.language.isNotEmpty && contentData.details.type != VideoType.video) 24.width,
              if (contentData.details.duration.isNotEmpty)
                const CachedImageWidget(
                  url: Assets.iconsClock,
                  height: 12,
                  width: 12,
                  color: iconColor,
                ),
              if (contentData.details.duration.isNotEmpty) 6.width,
              if (contentData.details.duration.isNotEmpty)
                Text(
                  contentData.details.duration.validate(),
                  style: commonSecondaryTextStyle(size: 12),
                ),
              if (contentData.details.imdbRating.isNotEmpty) 24.width,
              if (contentData.details.imdbRating.isNotEmpty)
                const CachedImageWidget(
                  url: Assets.iconsStar,
                  height: 10,
                  width: 10,
                  color: iconColor,
                ),
              if (contentData.details.imdbRating.isNotEmpty) 6.width,
              if (contentData.details.imdbRating.isNotEmpty)
                Text(
                  "${contentData.details.imdbRating} ${locale.value.imdb}",
                  style: commonSecondaryTextStyle(size: 12),
                ),
            ],
          ),
          if (!isFromWatchingProfile) ...[
            12.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (contentData.details.type != VideoType.liveTv)
                  IconButton(
                    icon: Container(
                      decoration: boxDecorationDefault(
                        shape: BoxShape.circle,
                        color: contentData.details.isInWatchList.getBoolInt() ? appColorPrimary : (buttonColor ?? context.cardColor),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        contentData.details.isInWatchList.getBoolInt() ? Icons.check : Icons.playlist_add,
                        color: contentData.details.isInWatchList.getBoolInt() ? white : iconColor,
                      ),
                    ),
                    onPressed: () {
                      doIfLogin(onLoggedIn: () {
                        sliderController.saveWatchLists(
                          index,
                          addToWatchList: !contentData.details.isInWatchList.getBoolInt(),
                        );
                      });
                    },
                  ),
                16.width,
                AppButton(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  disabledColor: btnColor,
                  color: appColorPrimary,
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onTap: () {
                    if (contentData.details.releaseDate.isNotEmpty && isComingSoon(contentData.details.releaseDate)) {
                      if (contentData.details.releaseDate.isNotEmpty && isComingSoon(contentData.details.releaseDate)) {
                        final DashboardController comingSoonCont = Get.find<DashboardController>();
                        comingSoonCont.currentIndex(2);
                      } else if (contentData.details.type == VideoType.liveTv) {
                        Get.to(() => LiveContentDetailsScreen(), arguments: contentData);
                      } else {
                        Get.to(() => ContentDetailsScreen(), arguments: contentData);
                      }
                    } else if (contentData.details.type == VideoType.liveTv) {
                      Get.to(() => LiveContentDetailsScreen(), arguments: contentData);
                    } else {
                      Get.to(() => ContentDetailsScreen(), arguments: contentData);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconWidget(imgPath: Assets.iconsPlayFill),
                      12.width,
                      Text(locale.value.watchNow, style: appButtonTextStyleWhite),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}