import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/genres/genres_details/genres_details_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../../components/app_scaffold.dart';
import '../model/genres_model.dart';
import 'components/genre_profile_component.dart';

class GenresDetailsScreen extends StatelessWidget {
  final GenreModel genreDetails;

  GenresDetailsScreen({super.key, required this.genreDetails});

  final GenresDetailsController contentListController = Get.find<GenresDetailsController>();

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: contentListController.scrollController,
      appBarTitleText: genreDetails.name,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      expandedHeight: Get.height * 0.45,
      topbarChild: GenreProfileComponent(genreDetail: genreDetails),
      appBarBottomWidget: contentListController.availableFilter.isNotEmpty
          ? Align(
              alignment: Alignment.centerLeft,
              child: HorizontalList(
                itemCount: contentListController.availableFilter.length,
                itemBuilder: (context, index) {
                  String tab = contentListController.availableFilter[index];
                  return Obx(
                    () => Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: boxDecorationDefault(
                        color: contentListController.currentFilterIndex.value == index ? appColorPrimary : Colors.transparent,
                        borderRadius: radius(20),
                        border: Border.all(color: contentListController.currentFilterIndex.value == index ? appColorPrimary : iconColor),
                      ),
                      child: Text(
                        tab.getContentTypeTitle(),
                        style: primaryTextStyle(size: 14),
                      ),
                    ).onTap(
                      () {
                        if(contentListController.isLoading.value) return;
                        contentListController.currentFilterIndex.value = index;
                        contentListController.init();
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  );
                },
              ),
            )
          : null,
      onRefresh: () => contentListController.init(),
      isBodyFullScreen: true,
      bodySlivers: [
        SliverPadding(
          padding: EdgeInsets.only(left: 12, right: 12, top: 12),
          sliver: Obx(
            () {
              final isLoading = contentListController.isLoading.value;
              final list = contentListController.listContent;
              final length = contentListController.listContent.length;
              final isPageOver = contentListController.isLastPage.value;
              if (list.isEmpty && isLoading) {
                return SliverToBoxAdapter(
                  child: ContentListShimmer(
                    width: dynamicSpacing.$1,
                    spacing: dynamicSpacing.$2,
                  ),
                );
              }
              if (list.isEmpty && !isLoading) {
                return SliverToBoxAdapter(
                  child: AppNoDataWidget(
                    title: locale.value.noContentInGenre,
                    subTitle: locale.value.noContentAvailableInThisGenre,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () => contentListController.init(),
                  ),
                );
              }
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: dynamicSpacing.$2,
                  mainAxisSpacing: dynamicSpacing.$2,
                  childAspectRatio: 0.70,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if(index >= length) {
                      return ShimmerWidget(radius: 6);
                    }
                    final PosterDataModel content = list[index];
                    return ContentListComponent(contentData: content);
                  },
                  childCount: length + (isPageOver ? 0 : 3 - (length % 3)),
                ),
              );
            },
          ),
        ),
        Obx(() {
          final isLoading = contentListController.isLoading.value;
          final list = contentListController.listContent;
          if (isLoading && list.isNotEmpty)
            return SliverPadding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 12),
              sliver: SliverToBoxAdapter(
                child: ContentListShimmer(
                  width: dynamicSpacing.$1,
                  spacing: dynamicSpacing.$2,
                  length: 9,
                ),
              ),
            );
          return SliverToBoxAdapter(
            child: const SizedBox.shrink(),
          );
        })
      ],
    );
  }
}