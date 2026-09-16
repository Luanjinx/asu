import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

class PersonDetailsWidget extends StatelessWidget {
  final Cast personDet;

  const PersonDetailsWidget({super.key, required this.personDet});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        height: (Get.height * 0.45),
        alignment: AlignmentDirectional.bottomEnd,
        padding: EdgeInsets.only(left: 12, right: 12, top: Get.height * 0.12, bottom: 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.80, 1.0],
            colors: [
              Colors.transparent,
              appScreenBackgroundDark.withValues(alpha: 0.5),
              appScreenBackgroundDark.withValues(alpha: 0.9),
              appScreenBackgroundDark,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    personDet.name.validate(),
                    style: boldTextStyle(size: 26),
                  ),
                  if (personDet.designation.validate().isNotEmpty)
                    Text(
                      personDet.designation.split(',').first.trim().toUpperCase(),
                      style: boldTextStyle(size: 12, color: appColorPrimary).copyWith(letterSpacing: 2),
                    ),
                ],
              ),
              if (personDet.bio.validate().isNotEmpty) ...[
                8.height,
                readMoreTextWidget(
                  personDet.bio.validate(),
                  trimLines: 3,
                ),
              ],
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CachedImageWidget(
                    url: Assets.iconsCake,
                    height: 16,
                    width: 16,
                    color: iconColor,
                  ).visible(personDet.dob.isNotEmpty || personDet.dob != ""),
                  8.width.visible(personDet.dob.validate().isNotEmpty || personDet.dob != ""),
                  Text(
                    personDet.dob.validate(),
                    style: commonSecondaryTextStyle(),
                  ).visible(personDet.dob != ""),
                  8.width.visible(personDet.dob.validate().isNotEmpty || personDet.dob != ""),
                  const CachedImageWidget(
                    url: Assets.iconsMapPin,
                    height: 16,
                    width: 16,
                    color: iconColor,
                  ).visible(personDet.placeOfBirth.isNotEmpty),
                  8.width.visible(personDet.placeOfBirth.isNotEmpty),
                  Text(
                    personDet.placeOfBirth,
                    style: commonSecondaryTextStyle(),
                  ).expand().visible(personDet.placeOfBirth.isNotEmpty),
                ],
              ),
              16.height,
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (personDet.totalMovies > 0)
                    Container(
                      width: Get.width / 4 - 24,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(4)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Badge.count(
                            count: personDet.totalMovies.toInt(),
                            backgroundColor: cardColor,
                            maxCount: 100,
                            textColor: appColorPrimary,
                            textStyle: boldTextStyle(
                              color: appColorPrimary,
                              size: Constants.labelTextSize.toInt(),
                            ),
                          ),
                          Marquee(
                            child: Text(
                              locale.value.movies,
                              style: boldTextStyle(size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (personDet.totalTvShows > 0)
                    Container(
                      width: Get.width / 4 - 24,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(4)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Badge.count(
                            count: personDet.totalTvShows.toInt(),
                            backgroundColor: cardColor,
                            maxCount: 100,
                            textColor: appColorPrimary,
                            textStyle: boldTextStyle(
                              color: appColorPrimary,
                              size: Constants.labelTextSize.toInt(),
                            ),
                          ),
                          Marquee(
                            child: Text(
                              locale.value.tVShows,
                              style: boldTextStyle(size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (personDet.rating > 0)
                    Container(
                      width: Get.width / 4 - 24,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(4)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Marquee(
                            child: Text(
                              personDet.rating.toString(),
                              style: boldTextStyle(
                                color: appColorPrimary,
                                size: Constants.labelTextSize.toInt(),
                              ),
                            ),
                          ),
                          Marquee(
                            child: Text(
                              locale.value.rating.capitalizeEachWord(),
                              style: boldTextStyle(size: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (personDet.topGenre.isNotEmpty)
                    Container(
                      width: Get.width / 4 - 24,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(4)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Marquee(
                            child: Text(
                              personDet.topGenre.toString(),
                              style: boldTextStyle(
                                color: appColorPrimary,
                                size: Constants.labelTextSize.toInt(),
                              ),
                            ),
                          ),
                          Marquee(
                            child: Text(
                              locale.value.topGenre,
                              style: boldTextStyle(size: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}