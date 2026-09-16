import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/rented_content/rental_list_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class RentalListScreen extends StatelessWidget {
  RentalListScreen({super.key});

  final RentalListController rentedContentController =
      Get.find<RentalListController>();

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();
    return Obx(
      () => NewAppScaffold(
        isPinnedAppbar: true,
        scrollController: rentedContentController.scrollController,
        isLoading: rentedContentController.currentPage.value == 1
            ? false.obs
            : rentedContentController.isLoading,
        currentPage: rentedContentController.currentPage,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        appBarTitleText: locale.value.payPerView,
        appBarBottomWidget: rentedContentController.availableFilter.isNotEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: HorizontalList(
                  itemCount: rentedContentController.availableFilter.length,
                  itemBuilder: (context, index) {
                    String tab = rentedContentController.availableFilter[index];
                    return Obx(
                      () => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: boxDecorationDefault(
                          color: rentedContentController
                                      .currentFilterIndex.value ==
                                  index
                              ? appColorPrimary
                              : Colors.transparent,
                          borderRadius: radius(20),
                          border: Border.all(
                              color: rentedContentController
                                          .currentFilterIndex.value ==
                                      index
                                  ? appColorPrimary
                                  : iconColor),
                        ),
                        child: Text(
                          tab.getContentTypeTitle(),
                          style: primaryTextStyle(size: 14),
                        ),
                      ).onTap(
                        () {
                          rentedContentController.currentFilterIndex(index);
                          rentedContentController.onRefresh();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    );
                  },
                ),
              )
            : null,
        body: Obx(
          () => SnapHelperWidget(
            future: rentedContentController.listContentFuture.value,
            initialData: cachedRentedContentList.isNotEmpty
                ? cachedRentedContentList
                : null,
            loadingWidget: ContentListShimmer(
              width: dynamicSpacing.$1,
              spacing: dynamicSpacing.$2,
            ),
            errorBuilder: (error) {
              return AppNoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: rentedContentController.onRetry,
              ).visible(!rentedContentController.isLoading.value);
            },
            onSuccess: (res) {
              return Obx(() {
                if (rentedContentController.isLoading.value &&
                    rentedContentController.currentPage.value == 1) {
                  return ContentListShimmer(
                    width: dynamicSpacing.$1,
                    spacing: dynamicSpacing.$2,
                  );
                } else if (rentedContentController.listContent.isEmpty) {
                  return AppNoDataWidget(
                    title: locale.value.noPayPerViewContent,
                    subTitle: locale.value.browseAndRentContentToWatchInstantly,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      rentedContentController.onRetry();
                    },
                  ).center().visible(!rentedContentController.isLoading.value);
                }
                return AnimatedWrap(
                  runSpacing: dynamicSpacing.$2,
                  spacing: dynamicSpacing.$2,
                  listAnimationType: commonListAnimationType,
                  itemCount: rentedContentController.listContent.length,
                  itemBuilder: (context, index) {
                    PosterDataModel poster =
                        rentedContentController.listContent[index];
                    return ContentListComponent(contentData: poster);
                  },
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
