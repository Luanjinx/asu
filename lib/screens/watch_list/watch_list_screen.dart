// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_controller.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_detail_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/content_list_screen.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_controller.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class WatchListScreen extends StatelessWidget {
  WatchListScreen({super.key});

  final WatchListController watchListCont = Get.find<WatchListController>();

  @override
  Widget build(BuildContext context) {
    // Get dynamic grid size (width + spacing)
    final dynamicSpacing = getDynamicSpacing();
    return Obx(() => NewAppScaffold(
          isPinnedAppbar: true,
          scrollController: watchListCont.scrollController,
          currentPage: watchListCont.currentPage,
          scaffoldBackgroundColor: appScreenBackgroundDark,
          appBarTitleText: locale.value.watchlist,
          appBarBottomWidget: watchListCont.availableFilter.isNotEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: HorizontalList(
                    itemCount: watchListCont.availableFilter.length,
                    itemBuilder: (context, index) {
                      String tab = watchListCont.availableFilter[index];
                      return Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: boxDecorationDefault(
                            color: watchListCont.currentFilterIndex.value == index ? appColorPrimary : Colors.transparent,
                            borderRadius: radius(20),
                            border: Border.all(color: watchListCont.currentFilterIndex.value == index ? appColorPrimary : iconColor),
                          ),
                          child: Text(
                            tab.getContentTypeTitle(),
                            style: primaryTextStyle(size: 14),
                          ),
                        ).onTap(
                          () {
                            watchListCont.currentFilterIndex(index);
                            watchListCont.onRefresh();
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                      );
                    },
                  ),
                )
              : null,
          onRefresh: watchListCont.onRefresh,
          actions: [
            if (watchListCont.listContent.isNotEmpty)
              IconButton(
                onPressed: () {
                  watchListCont.isDelete.value = !watchListCont.isDelete.value;
                  watchListCont.selectedPosters.clear();
                },
                splashColor: appColorPrimary.withValues(alpha: 0.4),
                icon: const CachedImageWidget(
                  url: Assets.iconsTrash,
                  height: 20,
                  width: 20,
                  color: appColorPrimary,
                ),
              ),
            16.width
          ],
          body: SnapHelperWidget(
            future: watchListCont.listContentFuture.value,
            loadingWidget: ContentListShimmer(
              width: dynamicSpacing.$1,
              spacing: dynamicSpacing.$2,
            ),
            errorBuilder: (error) {
              return Obx(
                () => AppNoDataWidget(
                  title: error,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    watchListCont.onRetry();
                  },
                ).visible(!watchListCont.isLoading.value),
              );
            },
            onSuccess: (res) {
              return Obx(
                () {
                  if (watchListCont.isLoading.value) {
                    return ContentListShimmer(
                      width: dynamicSpacing.$1,
                      spacing: dynamicSpacing.$2,
                    );
                  }
                  if (watchListCont.listContent.isEmpty) {
                    return AppNoDataWidget(
                      title: watchListCont.currentFilterType == ApiRequestKeys.allKey
                          ? locale.value.noWatchlistFound
                          : locale.value.noContentAvailableInContentType(
                              watchListCont.currentFilterType.getContentTypeTitle(),
                              locale.value.watchlist,
                            ),
                      subTitle: locale.value.yourWatchlistIsEmpty,
                      retryText: locale.value.explore,
                      imageWidget: EmptyStateWidget(
                        imageSize: 60,
                        noDataImage: Assets.iconsListPlus,
                      ),
                      onRetry: () {
                        Get.find<DashboardController>().currentIndex(0);
                        Get.back();
                      },
                    ).center().visible(!watchListCont.isLoading.value);
                  }
                  return AnimatedWrap(
                    listAnimationType: commonListAnimationType,
                    runSpacing: dynamicSpacing.$2,
                    spacing: dynamicSpacing.$2,
                    itemCount: watchListCont.listContent.length,
                    itemBuilder: (context, index) {
                      final PosterDataModel content = watchListCont.listContent[index];
                      return posterCard(poster: content, index: index);
                    },
                  );
                },
              );
            },
          ),
          widgetsStackedOverBody: [
            Obx(
              () => watchListCont.isDelete.isTrue
                  ? PositionedDirectional(
                      bottom: ResponsiveSize.getBottom(26),
                      start: ResponsiveSize.getStart(16),
                      end: ResponsiveSize.getEnd(16),
                      child: AppButton(
                        text: locale.value.removeFromWatchlist,
                        color: watchListCont.selectedPosters.isNotEmpty ? appColorPrimary : btnColor,
                        enabled: watchListCont.selectedPosters.isNotEmpty,
                        disabledColor: btnColor,
                        textStyle: appButtonTextStyleWhite.copyWith(color: watchListCont.selectedPosters.isNotEmpty ? white : darkGrayTextColor),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                        onTap: () {
                          watchListCont.handleRemoveFromWatchClick(context);
                        },
                      ),
                    )
                  : const Offstage(),
            ),
          ],
        ));
  }

  Widget posterCard({required PosterDataModel poster, required int index}) {
    final dynamicSpacing = getDynamicSpacing();
    return Obx(
      () => Stack(
        children: [
          ContentListComponent(
            contentData: poster,
            onTap: () {
              if (watchListCont.isDelete.value) {
                if (watchListCont.selectedPosters.contains(poster)) {
                  watchListCont.selectedPosters.remove(poster);
                } else {
                  watchListCont.selectedPosters.add(poster);
                }
              } else {
                Get.to(() => ContentDetailsScreen(), arguments: poster);
              }
            },
          ),
          if (watchListCont.isDelete.value) ...[
            InkWell(
              onTap: () {
                if (watchListCont.selectedPosters.contains(poster)) {
                  watchListCont.selectedPosters.remove(poster);
                } else {
                  watchListCont.selectedPosters.add(poster);
                }
              },
              child: Container(
                height: Get.height * 0.20,
                width: dynamicSpacing.$1,
                foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      black.withValues(alpha: 0.0),
                      black.withValues(alpha: 0.2),
                      black.withValues(alpha: 0.5),
                      black.withValues(alpha: 0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            if (watchListCont.isDelete.isTrue)
              PositionedDirectional(
                start: ResponsiveSize.getStart(10),
                top: ResponsiveSize.getTop(10),
                child: InkWell(
                  onTap: () {
                    if (watchListCont.selectedPosters.contains(poster)) {
                      watchListCont.selectedPosters.remove(poster);
                    } else {
                      watchListCont.selectedPosters.add(poster);
                    }
                  },
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: boxDecorationDefault(
                      color: watchListCont.selectedPosters.contains(poster) ? appColorPrimary : cardLightColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    alignment: Alignment.center,
                    child: watchListCont.selectedPosters.contains(poster)
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: cardLightColor,
                          )
                        : null,
                  ),
                ),
              ),
          ]
        ],
      ),
    );
  }
}