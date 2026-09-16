import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/continue_watching_list/components/remove_continue_watching_component.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/continue_watching_item_component.dart';
import 'continue_watching_list_controller.dart';
import 'continue_watching_list_shimmer.dart';

class ContinueWatchingListScreen extends StatelessWidget {
  ContinueWatchingListScreen({super.key});

  final ContinueWatchingListController continueWatchingListCont = Get.find<ContinueWatchingListController>();

  @override
  Widget build(BuildContext context) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 2);
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: continueWatchingListCont.scrollController,
      isLoading: continueWatchingListCont.isLoading,
      currentPage: continueWatchingListCont.currentPage,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.continueWatching,
      onRefresh: continueWatchingListCont.onRefresh,
      body: SnapHelperWidget(
        future: continueWatchingListCont.listContentFuture.value,
        initialData: cachedContinueWatchList.isNotEmpty ? cachedContinueWatchList : null,
        loadingWidget: const ShimmerContinueWatchingListScreen(),
        errorBuilder: (error) {
          return AppNoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: continueWatchingListCont.onRetry,
          ).center().visible(!continueWatchingListCont.isLoading.value);
        },
        onSuccess: (res) {
          return Obx(
            () => continueWatchingListCont.listContent.isEmpty
                ? continueWatchingListCont.isLoading.value
                    ? const ShimmerContinueWatchingListScreen()
                    : AppNoDataWidget(
                        title: locale.value.noContinueWatchingTitle,
                        subTitle: locale.value.noContinueWatchingSubtitle,
                        retryText: locale.value.explore,
                        onRetry: () {
                          Get.back();
                          Get.find<DashboardController>().currentIndex(1);
                        },
                        imageWidget: IconWidget(imgPath: Assets.iconsPlayFill, size: 85),
                      ).paddingSymmetric(horizontal: 16)
                : AnimatedWrap(
                    spacing: dynamicCardsDimensions.$2,
                    runSpacing: dynamicCardsDimensions.$2,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    itemCount: continueWatchingListCont.listContent.length,
                    itemBuilder: (p0, index) {
                      PosterDataModel continueWatchData = continueWatchingListCont.listContent[index];
                      return ContinueWatchingItemComponent(
                        width: dynamicCardsDimensions.$1,
                        continueWatchData: continueWatchData,
                        onRemoveTap: () {
                          handleRemoveFromContinueWatchClick(
                            continueWatchData.id,
                            continueWatchData.details.name,
                            continueWatchData.details.type,
                          );
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }

  Future<void> handleRemoveFromContinueWatchClick(int id, String title, String typeLabel) async {
    if (continueWatchingListCont.isLoading.value) return;
    Get.bottomSheet(
      AppDialogWidget(
        image: Assets.iconsTrash,
        imageColor: appColorPrimary,
        child: RemoveContinueWatchingComponent(
          onRemoveTap: () async {
            Get.back();
            await continueWatchingListCont.removeFromContinueWatching(id);
          },
          title: locale.value.removeFromContinueWatchingTitle(title, typeLabel.getContentTypeTitleSingular()),
        ),
      ),
    );
  }
}