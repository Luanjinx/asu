import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../coming_soon_controller.dart';
import '../coming_soon_detail_screen.dart';

class ComingSoonComponent extends StatelessWidget {
  final ComingSoonModel comingSoonDet;
  final ComingSoonController comingSoonCont;
  final bool isLoading;
  final VoidCallback onRemindMeTap;
  final VoidCallback onWatchListTap;

  const ComingSoonComponent({
    super.key,
    required this.comingSoonDet,
    required this.onRemindMeTap,
    this.isLoading = false,
    required this.comingSoonCont,
    required this.onWatchListTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ComingSoonDetailScreen(comingSoonData: comingSoonDet),
          arguments: comingSoonDet,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Hero(
                tag: '${comingSoonDet.id}',
                child: CachedImageWidget(
                  fit: BoxFit.cover,
                  url: comingSoonDet.posterImage.validate().isNotEmpty ? comingSoonDet.posterImage : comingSoonDet.thumbnailImage.validate(),
                  height: Get.height * 0.22,
                  width: Get.width,
                  topLeftRadius: 4,
                  topRightRadius: 4,
                ),
              ),
              PositionedDirectional(
                top: 8,
                start: 8,
                child: Container(
                  alignment: AlignmentGeometry.center,
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 4),
                  decoration: boxDecorationDefault(color: btnColor, borderRadius: radius(4)),
                  child: Text(
                    comingSoonDet.releaseDate,
                    style: commonPrimaryTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              PositionedDirectional(
                top: 8,
                end: 8,
                child: GestureDetector(
                  onTap: () {
                    doIfLogin(
                      onLoggedIn: () {
                        comingSoonCont.likeContent(context, comingSoonDet);
                      },
                    );
                  },
                  child: Container(
                    alignment: AlignmentGeometry.center,
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10),
                    decoration: boxDecorationDefault(color: btnColor, borderRadius: radius(4)),
                    child: AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: IconWidget(
                        color: comingSoonDet.isLiked.getBoolInt() ? appColorPrimary : primaryIconColor,
                        size: 20,
                        imgPath: comingSoonDet.isLiked.getBoolInt() ? Assets.iconsHeartFill : Assets.iconsHeart,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: boxDecorationDefault(
              borderRadius: const BorderRadiusDirectional.only(
                bottomStart: Radius.circular(6),
                bottomEnd: Radius.circular(6),
              ),
              color: cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (comingSoonDet.genres.validate().isNotEmpty)
                  Marquee(
                    child: Text(comingSoonDet.genre.validate(), style: commonSecondaryTextStyle()),
                  ),
                4.height,
                Text(
                  comingSoonDet.name.validate(),
                  style: commonW500PrimaryTextStyle(size: 20),
                  maxLines: null,
                  textAlign: TextAlign.start,
                ),
                12.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (comingSoonDet.seasonName.isNotEmpty) ...[
                      Text(comingSoonDet.seasonName, style: commonSecondaryTextStyle()),
                      24.width,
                    ],
                    if (comingSoonDet.language.isNotEmpty) ...[
                      IconWidget(imgPath: Assets.iconsTranslate, size: 14, color: iconColor),
                      6.width,
                      Text(
                        comingSoonDet.language.capitalizeFirstLetter(),
                        style: commonSecondaryTextStyle(),
                      ),
                    ],
                    24.width,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(4)),
                      alignment: Alignment.center,
                      child: Text(
                        locale.value.ua18.suffixText(value: "+"),
                        style: boldTextStyle(size: 10, color: appScreenBackgroundDark),
                      ),
                    ).visible(comingSoonDet.isRestricted),
                  ],
                ).fit(),
                12.height,
                if (comingSoonDet.description.isNotEmpty) ...[
                  readMoreTextWidget(comingSoonDet.description),
                  12.height,
                ],
                Row(
                  spacing: 16,
                  children: [
                    Obx(() {
                      final isRemindLoading = comingSoonCont.loadingRemindItems[comingSoonDet.id] ?? false;
                      return InkWell(
                        onTap: isRemindLoading ? null : onRemindMeTap,
                        child: Container(
                          width: Get.width * 0.32,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(4), color: comingSoonDet.isRemind.getBoolInt() && !isLoading ? appColorPrimary : btnColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              getRemindIcon(),
                              4.width,
                              Flexible(
                                child: Text(
                                  comingSoonDet.isRemind.getBoolInt() ? locale.value.remind : locale.value.remindMe,
                                  style: commonW600PrimaryTextStyle(size: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    Obx(() {
                      final isWatchlistLoading = comingSoonCont.loadingWatchlistItems[comingSoonDet.id] ?? false;
                      return InkWell(
                        onTap: isWatchlistLoading ? null : onWatchListTap,
                        child: Container(
                          width: Get.width * 0.32,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                          decoration: boxDecorationDefault(
                            borderRadius: BorderRadius.circular(4),
                            color: comingSoonDet.isInWatchList.getBoolInt() && !isLoading ? appColorPrimary : btnColor,
                          ),
                          child: Row(
                            spacing: 6,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconWidget(
                                imgPath: comingSoonDet.isInWatchList.getBoolInt() ? Assets.iconsCheck : Assets.iconsListPlus,
                                size: 14,
                              ),
                              Flexible(
                                child: Text(
                                  locale.value.watchlist,
                                  style: commonW600PrimaryTextStyle(size: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getRemindIcon() {
    try {
      return Lottie.asset(Assets.lottieRemind, height: 24, repeat: comingSoonDet.isRemind.getBoolInt() ? false : true);
    } catch (e) {
      return const CachedImageWidget(url: Assets.iconsBell, height: 14, width: 14);
    }
  }
}