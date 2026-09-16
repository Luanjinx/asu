import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/components/person_component/person_card.dart';
import 'package:streamit_laravel/screens/person/person_list/person_list_screen.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_widget.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../components/app_scaffold.dart';
import 'coming_soon_details_controller.dart';
import 'model/coming_soon_response.dart';

class ComingSoonDetailScreen extends StatelessWidget {
  final ComingSoonModel comingSoonData;
  final ComingSoonDetailsController detailsCont = Get.put(ComingSoonDetailsController());
  final Rx<bool> isReminderMe = false.obs;

  ComingSoonDetailScreen({
    super.key,
    required this.comingSoonData,
  }) {
    isReminderMe.value = comingSoonData.isRemind.getBoolInt();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Clean up trailer when navigating back
          if (detailsCont.currentTrailerData.value.id != 0) {
            detailsCont.removeTrailerControllerIfAlreadyExist(detailsCont.currentTrailerData.value.id);
          }
        }
      },
      child: Obx(() {
        final currentData = detailsCont.getUpdatedItem(comingSoonData.id) ?? comingSoonData;
        final contentDetailModel = detailsCont.contentDetail.value;
        bool hasContentDetail = contentDetailModel != null && contentDetailModel.id != 0;
        bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        return NewAppScaffold(
          applyLeadingBackButton: !isLandscape,
          scrollController: detailsCont.scrollController,
          isLoading: detailsCont.isLoading,
          bodyPadding: EdgeInsets.zero,
          isScrollableWidget: !isLandscape,
          onRefresh: detailsCont.onRefresh,
          appBarTitleText: isLandscape ? '' : currentData.name,
          expandedHeight: isLandscape ? Get.height : Get.height * 0.32,
          collapsedHeight: detailsCont.showTrailer.value && hasContentDetail && contentDetailModel.isTrailerAvailable && detailsCont.currentTrailerData.value.id != 0
              ? isLandscape
                  ? Get.height
                  : Get.height * 0.32
              : null,
          isPinnedAppbar: true,
          hideAppBar: false,
          scaffoldBackgroundColor: appScreenBackgroundDark,
          statusBarColor: appColorSecondary,
          topbarChild: Obx(
            () => detailsCont.isLoading.value
                ? ShimmerWidget(
                    height: detailsCont.showTrailer.value ? Get.height * 0.36 : Get.height * 0.42,
                    width: Get.width,
                  )
                : hasContentDetail
                    ? Stack(
                        alignment: AlignmentGeometry.bottomCenter,
                        key: ValueKey(contentDetailModel.id),
                        children: [
                          detailsCont.showTrailer.value && contentDetailModel.isTrailerAvailable && detailsCont.currentTrailerData.value.id != 0
                              ? Obx(
                                  () {
                                    final isTrailer = detailsCont.isDefaultTrailerPlaying;
                                    return TrailerWidget(
                                      cardHeight: isLandscape ? Get.height : Get.height * 0.26,
                                      tag: '${detailsCont.currentTrailerData.value.id}',
                                      showTrailerLabel: isTrailer,
                                      onTrailerCompleted: () {
                                        if (detailsCont.showTrailer.value) {
                                          detailsCont.removeTrailerControllerIfAlreadyExist(detailsCont.currentTrailerData.value.id);
                                        }
                                      },
                                      title: contentDetailModel.details.name,
                                      trailerData: detailsCont.currentTrailerData.value,
                                    );
                                  },
                                )
                              : Hero(
                                  tag: 'thumbnail_${contentDetailModel.details.thumbnailImage}',
                                  child: CachedImageWidget(
                                    height: Get.height * 0.42,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    url: contentDetailModel.details.thumbnailImage,
                                  ),
                                ),
                          IgnorePointer(
                            ignoring: true,
                            child: Container(
                              height: Get.height * 0.42,
                              width: Get.width,
                              foregroundDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    black.withValues(alpha: 0.001),
                                    black.withValues(alpha: 0.002),
                                    black.withValues(alpha: 0.003),
                                    black.withValues(alpha: 0.006),
                                    black.withValues(alpha: 0.1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Hero(
                        tag: 'thumbnail_${comingSoonData.thumbnailImage}',
                        child: CachedImageWidget(
                          height: Get.height * 0.42,
                          width: Get.width,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          url: comingSoonData.thumbnailImage,
                        ),
                      ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    currentData.type.validate().toLowerCase().getContentTypeTitleSingular(),
                    style: commonSecondaryTextStyle(color: context.primaryColor),
                  ),
                  12.width,
                  if (currentData.isRestricted)
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius(4)),
                      child: Text(
                        locale.value.ua18.suffixText(value: "+"),
                        style: commonSecondaryTextStyle(),
                      ),
                    ),
                ],
              ),
              12.height,
              if (currentData.genres.isNotEmpty)
                Marquee(
                  child: Text(currentData.genre.validate(), style: commonSecondaryTextStyle()),
                ),
              4.height,
              Text(
                currentData.name.validate(),
                style: commonW500PrimaryTextStyle(size: 20),
              ),
              12.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (currentData.seasonName.isNotEmpty) ...[
                    Text(currentData.seasonName, style: commonSecondaryTextStyle()),
                    12.width,
                  ],
                  if (currentData.duration.isNotEmpty) ...[
                    IconWidget(imgPath: Assets.iconsClock, size: 14, color: iconColor),
                    6.width,
                    Text(currentData.duration.validate(), style: commonSecondaryTextStyle(size: 14)),
                  ],
                  if (currentData.language.isNotEmpty) ...[
                    12.width,
                    IconWidget(imgPath: Assets.iconsTranslate, size: 14, color: iconColor),
                    6.width,
                    Text(
                      currentData.language.capitalizeFirstLetter(),
                      style: commonSecondaryTextStyle(),
                    ),
                  ],
                  if (currentData.imdbRating.isNotEmpty) ...[
                    12.width,
                    IconWidget(
                      imgPath: Assets.iconsStarFill,
                      size: 14,
                      color: yellowColor,
                    ),
                    6.width,
                    Text(
                      currentData.imdbRating.validate().suffixText(value: ' (IMDB)'),
                      style: commonSecondaryTextStyle(size: 12),
                    ),
                  ]
                ],
              ).fit(),
              12.height,
              if (currentData.contentRating.isNotEmpty)
                Text(
                  "${currentData.contentRating}",
                  style: commonSecondaryTextStyle(),
                ),
              if (currentData.releaseDate.validate().isNotEmpty) ...[
                12.height,
                Container(
                  decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radius(4)),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    "${locale.value.comingSoon.capitalizeEachWord()} on ${currentData.releaseDate.validate()} , ${formatRemainingReleaseDays(currentData.remainingReleaseDays.validate())}",
                    style: commonSecondaryTextStyle(color: Colors.white),
                  ),
                ),
              ],

              12.height,
              if (currentData.description.isNotEmpty) ...[
                readMoreTextWidget(currentData.description),
                12.height,
              ],
              Row(
                spacing: 16,
                children: [
                  if (!(detailsCont.contentDetail.value?.isEpisode ?? true)) ...[
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      color: cardColor,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      onPressed: () {
                        if (!isLoggedIn.value) removeCurrentTrailer();
                        doIfLogin(
                          onLoggedIn: () {
                            detailsCont.likeContent(context, detailsCont.contentDetail.value!.id);
                          },
                        );
                      },
                      icon: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 6,
                        children: [
                          AnimatedSwitcher(
                            duration: Duration(seconds: 1),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(scale: animation, child: child);
                            },
                            child: Obx(
                              () => IconWidget(
                                color: detailsCont.contentDetail.value!.details.isLiked.getBoolInt() ? appColorPrimary : primaryIconColor,
                                size: 20,
                                imgPath: detailsCont.contentDetail.value!.details.isLiked.getBoolInt() ? Assets.iconsHeartFill : Assets.iconsHeart,
                              ),
                            ),
                          ),
                          Text(
                            locale.value.like.capitalizeFirstLetter(),
                            style: commonPrimaryTextStyle(size: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    color: cardColor,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    onPressed: () {
                      shareVideo(type: detailsCont.contentDetail.value!.details.type, name: detailsCont.contentDetail.value!.details.name);
                    },
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 6,
                      children: [
                        IconWidget(
                          imgPath: Assets.iconsShareFat,
                          size: 20,
                          color: primaryIconColor,
                        ),
                        Text(
                          locale.value.share.capitalizeFirstLetter(),
                          style: commonPrimaryTextStyle(size: ResponsiveSize.getFontSize(14)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              12.height,
              Obx(
                () {
                  final updatedData = detailsCont.getUpdatedItem(comingSoonData.id) ?? comingSoonData;
                  if (isReminderMe.value != updatedData.isRemind.getBoolInt()) {
                    isReminderMe.value = updatedData.isRemind.getBoolInt();
                  }

                  return Row(
                    spacing: 16,
                    children: [
                      AppButton(
                        padding: EdgeInsets.zero,
                        color: isReminderMe.value ? appColorPrimary : btnColor,
                        disabledColor: btnColor,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                        onTap: () {
                          removeCurrentTrailer();
                          doIfLogin(
                            onLoggedIn: () {
                              if (isLoggedIn.isTrue) {
                                if (isReminderMe.value) {
                                  detailsCont.deleteRemind(comingSoonData: updatedData);
                                  isReminderMe.value = false;
                                  return;
                                }
                                detailsCont.saveRemind(isRemind: isReminderMe.value, comingSoonData: updatedData);
                                isReminderMe.value = true;
                              }
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getRemindIcon(),
                            Text(
                              isReminderMe.value ? locale.value.remind : locale.value.remindMe,
                              style: commonW600PrimaryTextStyle(size: 14),
                            ),
                          ],
                        ),
                      ).expand(),
                      AppButton(
                        padding: EdgeInsets.zero,
                        color: updatedData.isInWatchList.getBoolInt() ? appColorPrimary : btnColor,
                        disabledColor: btnColor,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
                        onTap: () {
                          removeCurrentTrailer();
                          doIfLogin(
                            onLoggedIn: () async {
                              if (isLoggedIn.isTrue) {
                                await detailsCont.saveWatchList(comingSoonData: updatedData);
                              }
                            },
                          );
                        },
                        child: Row(
                          spacing: 6,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconWidget(
                              imgPath: updatedData.isInWatchList.getBoolInt() ? Assets.iconsCheck : Assets.iconsListPlus,
                              size: 14,
                            ),
                            Text(
                              locale.value.watchlist,
                              style: commonW600PrimaryTextStyle(size: 14),
                            ),
                          ],
                        ),
                      ).expand(),
                    ],
                  );
                },
              ),

              // Actors Section
              if (hasContentDetail && contentDetailModel.isCastDetailsAvailable) ...[
                16.height,
                _buildActorsSection(contentDetailModel),
              ],
              // Directors Section
              if (hasContentDetail && contentDetailModel.isDirectorDetailsAvailable) ...[
                16.height,
                _buildDirectorsSection(contentDetailModel),
              ],
              // Clips Section
              if (hasContentDetail && contentDetailModel.isTrailerAvailable && (contentDetailModel.trailerData.length > 1 || contentDetailModel.isVideo)) ...[
                16.height,
                _buildClipsSection(detailsCont.contentDetail.value!)
              ],
            ],
          ).paddingAll(12),
        );
      }),
    );
  }

  Widget _buildActorsSection(ContentModel contentModel) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewAllWidget(
          labelSize: 16,
          label: locale.value.cast,
          isSymmetricPaddingEnable: false,
          showViewAll: contentModel.cast.length > 4,
          onButtonPressed: () {
            removeCurrentTrailer();
            Get.to(
              () => PersonListScreen(title: locale.value.cast),
              arguments: ArgumentModel(stringArgument: '${ApiRequestKeys.entertainmentIdKey}=${contentModel.entertainmentId}&${ApiRequestKeys.typeKey}=${ApiRequestKeys.actorKey}'),
            );
          },
        ),
        HorizontalList(
          runSpacing: dynamicCardsDimensions.$2,
          spacing: dynamicCardsDimensions.$2,
          itemCount: contentModel.cast.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final Cast cast = contentModel.cast[index];
            return PersonCard(
              castData: cast,
              width: dynamicCardsDimensions.$1,
              height: dynamicCardsDimensions.$1,
              onNavigated: () {
                removeCurrentTrailer();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDirectorsSection(ContentModel contentModel) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        viewAllWidget(
          labelSize: 16,
          isSymmetricPaddingEnable: false,
          label: locale.value.directors,
          showViewAll: contentModel.directors.length > 4,
          onButtonPressed: () {
            removeCurrentTrailer();
            Get.to(
              () => PersonListScreen(title: locale.value.directors),
              arguments: ArgumentModel(stringArgument: '${ApiRequestKeys.entertainmentIdKey}=${contentModel.entertainmentId}&${ApiRequestKeys.typeKey}=${ApiRequestKeys.directorKey}'),
            );
          },
        ),
        HorizontalList(
          padding: EdgeInsets.zero,
          runSpacing: dynamicCardsDimensions.$2,
          spacing: dynamicCardsDimensions.$2,
          itemCount: contentModel.directors.length,
          itemBuilder: (context, index) {
            final Cast director = contentModel.directors[index];
            return PersonCard(
              castData: director,
              width: dynamicCardsDimensions.$1,
              height: dynamicCardsDimensions.$1,
              onNavigated: () {
                removeCurrentTrailer();
              },
            );
          },
        ),
      ],
    );
  }

  void removeCurrentTrailer() {
    if (detailsCont.showTrailer.value) {
      detailsCont.removeTrailerControllerIfAlreadyExist(detailsCont.currentTrailerData.value.id);
    }
  }

  Widget _buildClipsSection(ContentModel contentModel) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.clips, style: boldTextStyle()),
        HorizontalList(
          spacing: 16,
          runSpacing: 16,
          padding: EdgeInsets.zero,
          crossAxisAlignment: WrapCrossAlignment.start,
          wrapAlignment: WrapAlignment.start,
          itemCount: contentModel.isVideo ? contentModel.trailerData.length : contentModel.trailerData.sublist(1).length,
          itemBuilder: (context, index) {
            VideoData trailerClips = contentModel.isVideo ? contentModel.trailerData[index] : contentModel.trailerData.sublist(1)[index];
            return GestureDetector(
              onTap: () async {
                removeCurrentTrailer();
                detailsCont.updateTrailerData(trailerClips);
                detailsCont.scrollController.animateTo(
                  0,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },
              child: Stack(
                children: [
                  CachedImageWidget(
                    url: trailerClips.posterImage,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    width: Get.width / 2.5,
                    height: Get.height * 0.10,
                    radius: 8,
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: Obx(
                      () => Container(
                        width: Get.width / 2.5,
                        height: Get.height * 0.10,
                        foregroundDecoration: BoxDecoration(
                          border: detailsCont.showTrailer.value && detailsCont.currentTrailerData.value.id == trailerClips.id ? Border.all(color: appColorPrimary) : null,
                          gradient: LinearGradient(
                            colors: [
                              black.withValues(alpha: 0.001),
                              black.withValues(alpha: 0.002),
                              black.withValues(alpha: 0.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: radius(8),
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 2,
                    start: 4,
                    end: 4,
                    child: Text(
                      trailerClips.title,
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget getRemindIcon() {
    try {
      return Lottie.asset(Assets.lottieRemind, height: 24, repeat: isReminderMe.value ? false : true);
    } catch (e) {
      return const CachedImageWidget(url: Assets.iconsBell, height: 14, width: 14);
    }
  }
}