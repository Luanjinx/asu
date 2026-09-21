import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/components/banner_ad_component.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/components/auto_slider_component.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/components/download_action_button.dart';
import 'package:streamit_laravel/screens/content/components/download_quality_selection_component.dart';
import 'package:streamit_laravel/screens/content/components/episode_component.dart';
import 'package:streamit_laravel/screens/content/components/other_details_component.dart';
import 'package:streamit_laravel/screens/content/components/player_ads_dialog.dart';
import 'package:streamit_laravel/screens/content/components/review_component.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/content/content_details_shimmer.dart';
import 'package:streamit_laravel/screens/content/content_list_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/downloads/download_screen.dart';
import 'package:streamit_laravel/screens/rented_content/component/rent_details_component.dart';
import 'package:streamit_laravel/services/download_control_service.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_widget.dart';
import 'package:streamit_laravel/video_players/video_screen.dart';
import 'package:streamit_laravel/video_players/video_player.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';
import 'package:streamit_laravel/video_players/video_settings_dialog.dart';

class ContentDetailsScreen extends StatelessWidget {
  final ContentDetailsController contentDetailsController = Get.find<ContentDetailsController>();
  final GlobalKey _mainDownloadButtonKey = GlobalKey(debugLabel: DOWNLOAD_BUTTON_KEY);

  ContentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        return NewAppScaffold(
          applyLeadingBackButton: !isLandscape,
          scrollController: contentDetailsController.scrollController,
          isLoading: contentDetailsController.isLoading,
          expandedHeight: isLandscape ? Get.height : Get.height * 0.32,
          collapsedHeight: contentDetailsController.showTrailer.value
              ? isLandscape
                  ? Get.height
                  : Get.height * 0.32
              : null,
          isPinnedAppbar: true,
          hideAppBar: false,
          scaffoldBackgroundColor: appScreenBackgroundDark,
          statusBarColor: appColorSecondary,
          isScrollableWidget: !isLandscape,
          onRefresh: contentDetailsController.onSwipeRefresh,
          drawer: contentDetailsController.isPlayingMainVideo.value && Get.isRegistered<VideoPlayersController>(tag: 'video_controller_${contentDetailsController.content.value!.id}')
              ? VideoSettingsDialog(
                  videoPlayerController: Get.find<VideoPlayersController>(tag: 'video_controller_${contentDetailsController.content.value!.id}'),
                )
              : null,
          topbarChild: Obx(
            () => contentDetailsController.showShimmer.value
                ? ShimmerWidget(
                    height: contentDetailsController.showTrailer.value ? Get.height * 0.36 : Get.height * 0.42,
                    width: Get.width,
                  )
                : contentDetailsController.hasContent && contentDetailsController.content.value!.id > 0
                    ? Stack(
                        alignment: AlignmentGeometry.bottomCenter,
                        key: ValueKey(contentDetailsController.content.value!.id),
                        children: [
                          if (contentDetailsController.isPlayingMainVideo.value)
                            GetBuilder<VideoPlayersController>(
                              tag: 'video_controller_${contentDetailsController.content.value!.id}',
                              init: Get.put(
                                VideoPlayersController(
                                  remainingEpisodes: contentDetailsController.episodeList.isNotEmpty ? contentDetailsController.episodeList.sublist(contentDetailsController.currentEpisodeIndex.value + 1) : const <PosterDataModel>[],
                                  allEpisodes: contentDetailsController.episodeList,
                                ),
                                tag: 'video_controller_${contentDetailsController.content.value!.id}',
                                permanent: false,
                              ),
                              builder: (videoController) {
                                return VideoPlayersComponent(
                                  controller: videoController,
                                  isEmbedded: true,
                                );
                              },
                            )
                          else if (contentDetailsController.showTrailer.value && contentDetailsController.content.value!.isTrailerAvailable)
                              Obx(
                                  () {
                                    final isTrailer = contentDetailsController.isDefaultTrailerPlaying;
                                    return TrailerWidget(
                                      cardHeight: isLandscape ? Get.height : Get.height * 0.26,
                                      tag: '${contentDetailsController.currentTrailerData.value.id}',
                                      showTrailerLabel: isTrailer,
                                      onTrailerCompleted: removeTrailer,
                                      onTrailerSkip: isTrailer
                                          ? () {
                                              onSubscriptionLoginCheck(
                                                callBack: handleWatchNow,
                                                content: contentDetailsController.content.value!.details,
                                                onPaymentDone: contentDetailsController.onSwipeRefresh,
                                                pauseCurrentVideo: () => removeTrailer(),
                                                onRentalNoRented: () {
                                                  if (contentDetailsController.content.value!.isRentDetailsAvailable) {
                                                    Get.bottomSheet(
                                                      AppDialogWidget(
                                                        child: RentalDetailsComponent(
                                                          onPauseCurrentVideo: () => removeTrailer(),
                                                          contentData: contentDetailsController.content.value!,
                                                          onWatchNow: handleWatchNow,
                                                          rentalData: contentDetailsController.content.value!.rentalData!,
                                                          onPaymentReturnCallBack: contentDetailsController.onSwipeRefresh,
                                                        ),
                                                      ),
                                                      isScrollControlled: true,
                                                    );
                                                  }
                                                },
                                              );
                                            }
                                          : null,
                                      title: contentDetailsController.content.value!.details.name,
                                      trailerData: contentDetailsController.currentTrailerData.value,
                                    );
                                  },
                                )
                              else
                                Hero(
                                  tag: 'thumbnail_${contentDetailsController.content.value!.details.thumbnailImage}',
                                  child: CachedImageWidget(
                                    height: Get.height * 0.42,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    url: contentDetailsController.content.value!.details.thumbnailImage,
                                  ),
                                ),
                          if (!contentDetailsController.isPlayingMainVideo.value)
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
                    : const Offstage(),
          ),
          body: isLandscape
              ? const Offstage()
              : SnapHelperWidget<ContentModel>(
                  future: contentDetailsController.contentFuture.value,
                  errorBuilder: (error) {
                    return AppNoDataWidget(
                      height: Get.height * 0.30,
                      title: contentDetailsController.errorMessage.value,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        contentDetailsController.onSwipeRefresh();
                      },
                    ).center().visible(!contentDetailsController.isLoading.value);
                  },
                  loadingWidget: const ContentDetailsShimmer(),
                  onSuccess: (data) {
                    if (contentDetailsController.hasContent && contentDetailsController.content.value!.id > 0) {
                      return Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (contentDetailsController.content.value!.isEpisode &&
                              contentDetailsController.content.value!.details.isTvShowDetailsAvailable &&
                              contentDetailsController.content.value!.details.tvShowData!.name.isNotEmpty)
                            Text(
                              contentDetailsController.content.value!.details.tvShowData!.name,
                              style: commonSecondaryTextStyle(),
                            ),
                          Text(
                            contentDetailsController.content.value!.details.name,
                            style: boldTextStyle(size: 24),
                          ),
                          if (contentDetailsController.content.value!.details.releaseYear.isNotEmpty || contentDetailsController.content.value!.details.duration.isNotEmpty)
                            Text(
                              [
                                if (contentDetailsController.content.value!.details.releaseYear.isNotEmpty) contentDetailsController.content.value!.details.releaseYear,
                                if (contentDetailsController.content.value!.details.duration.isNotEmpty) contentDetailsController.content.value!.details.duration,
                              ].join(' • '),
                              style: commonSecondaryTextStyle(size: 14),
                            ),
                          if (contentDetailsController.content.value!.isVideoQualitiesAvailable)
                            watchNowButton(
                              width: double.infinity,
                              contentData: contentDetailsController.content.value!,
                              callBack: handleWatchNow,
                              pauseCurrentVideo: () {
                                removeTrailer();
                              },
                              onPaymentReturnCallBack: () {
                                contentDetailsController.onSwipeRefresh();
                              },
                            ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ...contentDetailsController.content.value!.details.genres.map((genre) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.5)),
                                    borderRadius: radius(6),
                                  ),
                                  child: Text(genre, style: commonSecondaryTextStyle(size: 12)),
                                );
                              }),
                              if (contentDetailsController.content.value!.details.language.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.5)),
                                    borderRadius: radius(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.language, size: 14, color: appColorPrimary),
                                      4.width,
                                      Text(contentDetailsController.content.value!.details.language.capitalizeFirst!, style: commonSecondaryTextStyle(size: 12)),
                                    ],
                                  ),
                                ),
                              if (contentDetailsController.content.value!.details.imdbRating.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.5)),
                                    borderRadius: radius(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconWidget(imgPath: Assets.iconsStarFill, color: yellowColor, size: 14),
                                      4.width,
                                      Text(contentDetailsController.content.value!.details.imdbRating, style: commonSecondaryTextStyle(size: 12)),
                                    ],
                                  ),
                                ),
                              if (contentDetailsController.content.value!.details.contentRating.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.5)),
                                    borderRadius: radius(6),
                                  ),
                                  child: Text(contentDetailsController.content.value!.details.contentRating, style: commonSecondaryTextStyle(size: 12)),
                                ),
                              if (contentDetailsController.content.value!.details.isAgeRestrictedContent.getBoolInt())
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textSecondaryColorGlobal.withOpacity(0.5)),
                                    borderRadius: radius(6),
                                  ),
                                  child: Text(locale.value.ua18.suffixText(value: "+"), style: commonSecondaryTextStyle(size: 12)),
                                ),
                            ],
                          ),
                          if (contentDetailsController.content.value!.details.description.isNotEmpty)
                            readMoreTextWidget(
                              contentDetailsController.content.value!.details.description,
                              trimLines: 3,
                            ),
                          Row(
                            spacing: 16,
                            children: [
                              if (!contentDetailsController.content.value!.isEpisode) ...[
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  color: cardColor,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  onPressed: () {
                                    if (!isLoggedIn.value) removeTrailer();
                                    doIfLogin(
                                      onLoggedIn: () {
                                        if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
                                          if(contentDetailsController.content.value!.details.isAgeRestrictedContent == 1) {
                                            Get.back();
                                            return;
                                          }
                                        }
                                        contentDetailsController.watchListContent(context, contentDetailsController.content.value!.id);
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
                                            imgPath: contentDetailsController.content.value!.details.isInWatchList.getBoolInt() ? Assets.iconsCheck : Assets.iconsPlus,
                                            color: contentDetailsController.content.value!.details.isInWatchList.getBoolInt() ? appColorPrimary : null,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        locale.value.watchlist.capitalizeFirstLetter(),
                                        style: commonPrimaryTextStyle(size: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  color: cardColor,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  onPressed: () {
                                    if (!isLoggedIn.value) removeTrailer();
                                    doIfLogin(
                                      onLoggedIn: () {
                                        if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
                                          if(contentDetailsController.content.value!.details.isAgeRestrictedContent == 1) {
                                            Get.back();
                                            return;
                                          }
                                        }
                                        contentDetailsController.likeContent(context, contentDetailsController.content.value!.id);
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
                                            color: contentDetailsController.content.value!.details.isLiked.getBoolInt() ? appColorPrimary : primaryIconColor,
                                            size: 20,
                                            imgPath: contentDetailsController.content.value!.details.isLiked.getBoolInt() ? Assets.iconsHeartFill : Assets.iconsHeart,
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
                              if (contentDetailsController.content.value!.isDownloadDetailsAvailable && contentDetailsController.content.value!.details.access != MovieAccess.payPerView)
                                DownloadActionButton(
                                  controller: contentDetailsController,
                                  downloadButtonKey: _mainDownloadButtonKey,
                                  removeTrailer: removeTrailer,
                                ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                color: cardColor,
                                padding: EdgeInsets.symmetric(vertical: 8),
                                onPressed: () {
                                  shareVideo(type: contentDetailsController.content.value!.details.type, name: contentDetailsController.content.value!.details.name);
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
                              if (contentDetailsController.content.value!.isRentDetailsAvailable)
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  color: cardColor,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  onPressed: () {
                                    Get.bottomSheet(
                                      AppDialogWidget(
                                        child: RentalDetailsComponent(
                                          onPauseCurrentVideo: () => removeTrailer(),
                                          contentData: contentDetailsController.content.value!,
                                          onWatchNow: () {
                                            if (contentDetailsController.content.value!.isTvShow) {
                                              contentDetailsController.playNextEpisode(contentDetailsController.episodeList.first);
                                            } else {
                                              Get.to(
                                                () => VideoScreen(
                                                  remainingEpisodes: contentDetailsController.episodeList.isNotEmpty
                                                      ? contentDetailsController.episodeList.sublist(contentDetailsController.currentEpisodeIndex.value + 1)
                                                      : const <PosterDataModel>[],
                                                  allEpisodes: contentDetailsController.episodeList,
                                                ),
                                                arguments: contentDetailsController.content.value,
                                              )?.then((value) {
                                                if(contentDetailsController.content.value!.isTrailerAvailable && !contentDetailsController.content.value!.isVideo) {
                                                  contentDetailsController.updateTrailerData(contentDetailsController.content.value!.trailerData.first);
                                                }
                                              },);
                                            }
                                          },
                                          rentalData: contentDetailsController.content.value!.rentalData!,
                                          onPaymentReturnCallBack: () {
                                            contentDetailsController.onSwipeRefresh();
                                          },
                                        ),
                                      ),
                                      isScrollControlled: true,
                                    );
                                  },
                                  icon: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 6,
                                    children: [
                                      IconWidget(
                                        imgPath: Assets.iconsInfo,
                                        size: 20,
                                        color: primaryIconColor,
                                      ),
                                      Text(
                                        locale.value.rentalInfo.capitalizeFirstLetter(),
                                        style: commonPrimaryTextStyle(size: ResponsiveSize.getFontSize(14)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          // Moved OtherDetailsComponent from here
                          if (contentDetailsController.content.value!.isAdsAvailable && contentDetailsController.content.value!.adsData!.isBannerAdsAvailable) ...[
                            AutoSliderComponent(
                              height: Get.height * 0.24,
                              isAutoSlide: true,
                              tag: 'details_auto_slider',
                              sliderLength: contentDetailsController.content.value!.adsData!.bannerAds.length,
                              sliderChildren: List.generate(
                                contentDetailsController.content.value!.adsData!.bannerAds.length,
                                (index) {
                                  final CustomAds data = contentDetailsController.content.value!.adsData!.bannerAds[index];

                                  return BannerAdComponent(
                                    bannerHeight: Get.height * 0.20,
                                    adUrl: data.url,
                                    adType: data.type,
                                    redirectUrl: data.redirectUrl,
                                    onVideoStarted: () {
                                      if (Get.isRegistered<AutoSliderController>(tag: 'details_auto_slider')) {
                                        Get.find<AutoSliderController>(tag: 'details_auto_slider').stopAutoSlider();
                                      }
                                    },
                                    onVideoCompleted: () {
                                      if (Get.isRegistered<AutoSliderController>(tag: 'details_auto_slider')) {
                                        Get.find<AutoSliderController>(tag: 'details_auto_slider').startAutoSlider();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                          if (contentDetailsController.content.value!.details.isSeasonAvailable || contentDetailsController.argumentData.isEpisode || contentDetailsController.argumentData.isTvShow)
                            Obx(() {
                              final bool isEpisodeListShimmering = contentDetailsController.showEpisodeListShimmer.value;
                              final episodeItems = contentDetailsController.episodeList;

                              return Column(
                                spacing: 16,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  8.height,
                                  if (episodeItems.isNotEmpty || contentDetailsController.content.value!.details.isSeasonAvailable)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          locale.value.episodes,
                                          style: boldTextStyle(size: 18),
                                        ),
                                        if (contentDetailsController.content.value!.details.isSeasonAvailable)
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                backgroundColor: cardColor,
                                                isScrollControlled: true,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                                ),
                                                builder: (context) {
                                                  return Container(
                                                    padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
                                                    constraints: BoxConstraints(maxHeight: Get.height * 0.6),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text('Season', style: boldTextStyle(size: 20)),
                                                        16.height,
                                                        Flexible(
                                                          child: SingleChildScrollView(
                                                            child: Column(
                                                              children: List.generate(
                                                                contentDetailsController.content.value!.details.seasonList.length,
                                                                (index) {
                                                                  SeasonData seasonData = contentDetailsController.content.value!.details.seasonList[index];
                                                                  bool isSelected = contentDetailsController.selectedSeason.value.id == seasonData.id;
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      Get.back();
                                                                      if (!isSelected) {
                                                                        contentDetailsController.setSeasonData(seasonData);
                                                                      }
                                                                    },
                                                                    borderRadius: radius(8),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                                                      margin: const EdgeInsets.only(bottom: 8),
                                                                      decoration: boxDecorationDefault(
                                                                        color: isSelected ? appColorPrimary.withOpacity(0.1) : context.scaffoldBackgroundColor,
                                                                        borderRadius: radius(8),
                                                                      ),
                                                                      child: Row(
                                                                        children: [
                                                                          Text(
                                                                            seasonData.name, 
                                                                            style: commonW600PrimaryTextStyle(
                                                                              color: isSelected ? appColorPrimary : textPrimaryColorGlobal,
                                                                            ),
                                                                          ).expand(),
                                                                          if (isSelected) Icon(Icons.check_circle, color: appColorPrimary, size: 20),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            borderRadius: radius(6),
                                            child: Container(
                                              height: 36,
                                              decoration: boxDecorationDefault(
                                                color: cardColor,
                                                borderRadius: radius(6),
                                              ),
                                              padding: const EdgeInsets.only(left: 16, right: 12),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth: Get.width * 0.3),
                                                    child: Marquee(
                                                      child: Text(
                                                        'Season', 
                                                        style: boldTextStyle(color: appColorPrimary, size: 14),
                                                      ),
                                                    ),
                                                  ),
                                                  4.width,
                                                  Icon(Icons.keyboard_arrow_down, size: 20, color: textPrimaryColorGlobal),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  if (episodeItems.isNotEmpty)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(episodeItems.length, (index) {
                                          PosterDataModel episodeData = episodeItems[index];
                                          final downloadData = episodeData.downloadData;
                                          final bool isEpisodeDownloadable = downloadData != null &&
                                              downloadData.downloadEnable.getBoolInt() &&
                                              downloadData.isDownloadQualitiesAvailable &&
                                              episodeData.details.access != MovieAccess.payPerView;
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                if (contentDetailsController.isLoading.value) return;
                                                removeTrailer();
                                                contentDetailsController.playNextEpisode(episodeData);
                                              },
                                              child: Obx(
                                                () {
                                                  final bool isEpisodeDownloading = contentDetailsController.activeDownloads.contains(episodeData.id);
                                                  final double episodeDownloadProgress = contentDetailsController.episodeProgress[episodeData.id] ?? 0.0;

                                                  final bool isEpisodeDownloaded = contentDetailsController.downloadedEpisodeIds.contains(episodeData.id);
                                                  final bool isEpisodePaused = contentDetailsController.episodeStates[episodeData.id] == DownloadControlState.paused;

                                                  return EpisodeComponent(
                                                    episodeData: episodeData,
                                                    episodeIndex: index,
                                                    isSelected: contentDetailsController.currentEpisodeIndex.value == index,
                                                    showDownloadButton: isEpisodeDownloadable && contentDetailsController.currentEpisodeIndex.value != index,
                                                    isDownloaded: isEpisodeDownloaded,
                                                    isDownloading: isEpisodeDownloading,
                                                    isPaused: isEpisodePaused,
                                                    downloadProgress: episodeDownloadProgress,
                                                    onDownloadTap: isEpisodeDownloadable
                                                        ? () {
                                                            if (contentDetailsController.isLoading.value) return;
                                                            final episodeDownloadData = downloadData;
                                                            if (!episodeDownloadData.downloadEnable.getBoolInt()) return;
                                                            removeTrailer();
                                                            doIfLogin(
                                                              onLoggedIn: () {
                                                                if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
                                                                  if(contentDetailsController.content.value!.details.isAgeRestrictedContent == 1) {
                                                                    Get.back();
                                                                    return;
                                                                  }
                                                                }
                                                                if (isEpisodeDownloaded)
                                                                  Get.to(() => DownloadScreen());
                                                                else
                                                                  Get.bottomSheet(
                                                                    AppDialogWidget(
                                                                      child: DownloadQualitySelectionComponent(
                                                                        hasContentAccess: episodeData.details.hasContentAccess.getBoolInt(),
                                                                        availableDownloadQualities: episodeDownloadData.downloadQualities,
                                                                        onQualitySelected: (DownloadQualities selectedQuality) {
                                                                          contentDetailsController.selectedDownloadQuality(selectedQuality);
                                                                          episodeData.details.thumbnailImage = episodeData.posterImage;
                                                                          episodeData.details.tvShowData = contentDetailsController.content.value!.isTvShow
                                                                              ? TvShowData(
                                                                                  id: contentDetailsController.content.value!.id,
                                                                                  name: contentDetailsController.content.value!.details.name,
                                                                                )
                                                                              : contentDetailsController.content.value!.details.tvShowData;
                                                                          episodeData.details.seasonList = contentDetailsController.content.value!.details.seasonList;
                                                                          final ContentModel episodeContent = ContentModel(
                                                                            id: episodeData.id,
                                                                            details: episodeData.details,
                                                                            downloadData: episodeDownloadData,
                                                                            trailerData: episodeData.trailerData,
                                                                          );
                                                                          contentDetailsController.downloadContent(episodeData.id, episodeContent, episodeData.id);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                              },
                                                            );
                                                          }
                                                        : null,
                                                    onPauseTap: () => contentDetailsController.pauseEpisodeDownload(episodeData.id),
                                                    onResumeTap: () => contentDetailsController.resumePausedEpisodeDownload(episodeData.id),
                                                    onCancelTap: () => contentDetailsController.cancelEpisodeDownload(episodeData.id),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  if (isEpisodeListShimmering)
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: List.generate(4, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(right: 12.0),
                                            child: EpisodeComponent.shimmer(),
                                          );
                                        }),
                                      ),
                                    ),
                                  if (episodeItems.isEmpty && !isEpisodeListShimmering)
                                    AppNoDataWidget(
                                      height: Get.height * .16,
                                      imageWidget: EmptyStateWidget(
                                        noDataImage: Assets.iconsConfetti,
                                        imageSize: 60,
                                      ),
                                      title: "${locale.value.episodesAreNotAvailableYet} ${locale.value.stayTuned}",
                                      subTitle: "${locale.value.weArePreparingExcitingEpisodesForThisSeason}.\n${locale.value.checkBackAgainShortly}",
                                    ),
                                  if (!isEpisodeListShimmering && episodeItems.isNotEmpty)
                                    Row(
                                      key: contentDetailsController.viewShowLessKey,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 16,
                                      children: [
                                        if (contentDetailsController.episodePage.value > 1 && episodeItems.length > Constants.episodePerPage)
                                          TextButton(
                                            onPressed: () {
                                              contentDetailsController.onPreviousEpisode();
                                            },
                                            child: Text(locale.value.viewLess, style: boldTextStyle()),
                                          ),
                                        if (!contentDetailsController.isLastPage.value)
                                          TextButton(
                                            onPressed: () {
                                              contentDetailsController.handleNextEpisode();
                                            },
                                            child: Text(locale.value.viewMore, style: boldTextStyle()),
                                          ),
                                      ],
                                    )
                                ],
                              );
                            }),
                          if (!contentDetailsController.argumentData.details.isVideo)
                            OtherDetailsComponent(
                              contentData: contentDetailsController.content.value!,
                              onNavigated: () {
                                removeTrailer();
                              },
                            ),
                          if (contentDetailsController.content.value!.isTrailerAvailable &&
                              (contentDetailsController.content.value!.trailerData.length > 1 || contentDetailsController.content.value!.isVideo)) ...[
                            Column(
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
                                  itemCount: contentDetailsController.content.value!.isVideo
                                      ? contentDetailsController.content.value!.trailerData.length
                                      : contentDetailsController.content.value!.trailerData.sublist(1).length,
                                  itemBuilder: (context, index) {
                                    VideoData trailerClips = contentDetailsController.content.value!.isVideo
                                        ? contentDetailsController.content.value!.trailerData[index]
                                        : contentDetailsController.content.value!.trailerData.sublist(1)[index];
                                    return GestureDetector(
                                      onTap: () async {
                                        contentDetailsController.updateTrailerData(trailerClips);
                                        contentDetailsController.scrollController.animateTo(
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
                                                  border: contentDetailsController.showTrailer.value && contentDetailsController.currentTrailerData.value.id == trailerClips.id
                                                      ? Border.all(color: appColorPrimary)
                                                      : null,
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
                                6.height,
                              ],
                            ),
                          ],
                          ReviewComponent(controller: contentDetailsController),
                          if (contentDetailsController.content.value!.isSuggestedContentAvailable)
                            Column(
                              spacing: 12,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                6.height,
                                viewAllWidget(
                                  label: locale.value.moreLikeThis,
                                  labelSize: 16,
                                  isSymmetricPaddingEnable: false,
                                  showViewAll: contentDetailsController.content.value!.suggestedContent.length > 3,
                                  onButtonPressed: () {
                                    removeTrailer();
                                    Get.to(
                                      () => ContentListScreen(
                                        title: contentDetailsController.content.value!.details.type.getContentTypeTitle(),
                                      ),
                                      arguments: ArgumentModel(stringArgument: contentDetailsController.content.value!.details.type, extra: {
                                        'banner': true,
                                      }),
                                    );
                                  },
                                ),
                                HorizontalList(
                                  runSpacing: 12,
                                  spacing: 12,
                                  padding: EdgeInsets.zero,
                                  itemCount: contentDetailsController.content.value!.suggestedContent.length,
                                  itemBuilder: (context, index) {
                                    final suggestedContent = contentDetailsController.content.value!.suggestedContent[index];
                                    return ContentListComponent(
                                      contentData: suggestedContent,
                                      onTap: () async {
                                        contentDetailsController.showTrailer(false);
                                        contentDetailsController.uniqueTrailerKey = UniqueKey();
                                        contentDetailsController.argumentData = suggestedContent;
                                        contentDetailsController.update([contentDetailsController.argumentData]);
                                        await contentDetailsController.getContentData();
                                        // Scroll to top after loading new content
                                        contentDetailsController.scrollController.animateTo(
                                          0,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            )
                        ],
                      );
                    }
                    return AppNoDataWidget(
                      height: Get.height * 0.24,
                      title: locale.value.noContentDetails,
                      subTitle: locale.value.contentInformationIsNotAvailable,
                      retryText: locale.value.reload,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () {
                        contentDetailsController.onSwipeRefresh();
                      },
                    ).center().visible(!contentDetailsController.isLoading.value);
                  },
                ),
        );
      },
    );
  }

  void removeTrailer() {
    if (contentDetailsController.showTrailer.value) {
      contentDetailsController.removeTrailerControllerIfAlreadyExist(contentDetailsController.currentTrailerData.value.id);
    }
  }

  void handleWatchNow() async {
    if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
      if(contentDetailsController.content.value!.details.isAgeRestrictedContent == 1) {
        toast(locale.value.contectRestrictedForKidProfile);
        Get.back();
        return;
      }
    }
    removeTrailer();
    if (contentDetailsController.content.value!.isTvShow) {
      if (contentDetailsController.episodeList.isEmpty) {
        toast(locale.value.episodesAreNotAvailableYet);
        return;
      }
      final firstEpisode = contentDetailsController.episodeList.first;
      contentDetailsController.playNextEpisode(
        firstEpisode,
        onEpisodeDataUpdated: () {
          showPlayerAds();
        },
      );
    } else {
      showPlayerAds();
    }
  }

  Future<void> showPlayerAds() async {
    if (contentDetailsController.content.value!.isAdsAvailable && contentDetailsController.content.value!.adsData!.isPlayerAdsAvailable) {
      bool isAdsCompleted = await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        animationStyle: AnimationStyle(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 800),
          reverseCurve: Curves.easeInOut,
        ),
        builder: (context) {
          return PlayerAdsDialog(ads: contentDetailsController.content.value!.adsData!.playerAds);
        },
      );

      if (isAdsCompleted) {
        navigateToVideoScreen();
      }
    } else {
      navigateToVideoScreen();
    }
  }

  void navigateToVideoScreen() async {
    contentDetailsController.isPlayingMainVideo(true);
  }
}
