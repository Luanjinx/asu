import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/rented_content/rented_content_list_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';

class RentedContentListScreen extends StatelessWidget {
  RentedContentListScreen({super.key});

  final RentedContentListController rentedContentController = Get.find<RentedContentListController>();

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();
    return Obx(
      () => NewAppScaffold(
        scrollController: rentedContentController.scrollController,
        isLoading: rentedContentController.currentPage.value == 1 ? false.obs : rentedContentController.isLoading,
        currentPage: rentedContentController.currentPage,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        onRefresh: rentedContentController.onRefresh,
        isPinnedAppbar: true,
        appBarTitleText: locale.value.yourRentals,
        expandedHeight: MediaQuery.of(context).viewPadding.top,
        appBarBottomWidget: Align(
          alignment: Alignment.centerLeft,
          child: HorizontalList(
            itemCount: rentedContentController.tabs.length,
            itemBuilder: (context, index) {
              String tab = rentedContentController.tabs[index];
              return Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: boxDecorationDefault(
                    color: rentedContentController.selectedTab.value == tab ? appColorPrimary : Colors.transparent,
                    borderRadius: radius(20),
                    border: Border.all(color: rentedContentController.selectedTab.value == tab ? appColorPrimary : Colors.white24),
                  ),
                  child: Text(
                    tab,
                    style: primaryTextStyle(color: Colors.white, size: 14),
                  ),
                ).onTap(() {
                  rentedContentController.selectedTab.value = tab;
                }, splashColor: Colors.transparent, highlightColor: Colors.transparent),
              );
            },
          ),
        ),
        body: Obx(
          () => SnapHelperWidget(
            future: rentedContentController.listContentFuture.value,
            initialData: cachedRentedContentList.isNotEmpty ? cachedRentedContentList : null,
            loadingWidget: ContentListShimmer(
              width: dynamicSpacing.$1,
              spacing: dynamicSpacing.$2,
            ),
            errorBuilder: (error) {
              return AppNoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: CachedImageWidget(url: Assets.imagesRental, color: textSecondaryColorGlobal, height: 120),
                onRetry: rentedContentController.onRetry,
              ).visible(!rentedContentController.isLoading.value);
            },
            onSuccess: (res) {
              return Obx(
                () => rentedContentController.filteredList.isEmpty
                    ? AppNoDataWidget(
                        title: locale.value.noRentedContentFound,
                        subTitle: locale.value.noRentedContentSubtitle,
                        retryText: locale.value.reload,
                        imageWidget: CachedImageWidget(url: Assets.imagesRental, color: textSecondaryColorGlobal, height: 120),
                        onRetry: () {
                          rentedContentController.onSwipeRefresh();
                        },
                      ).center().visible(!rentedContentController.isLoading.value)
                    : AnimatedWrap(
                        spacing: dynamicSpacing.$2,
                        runSpacing: dynamicSpacing.$2,
                        listAnimationType: commonListAnimationType,
                        itemCount: rentedContentController.filteredList.length,
                        itemBuilder: (p0, index) {
                          PosterDataModel poster = rentedContentController.filteredList[index];
                          return ContentListComponent(contentData: poster);
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}