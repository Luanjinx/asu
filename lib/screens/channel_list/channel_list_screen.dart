import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'channel_list_controller.dart';

class ChannelListScreen extends StatelessWidget {
  final String title;

  ChannelListScreen({super.key, required this.title});

  final ChannelListController contentListController = Get.find<ChannelListController>();

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 2);
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: contentListController.scrollController,
      isLoading: contentListController.isLoading,
      currentPage: contentListController.currentPage,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: title.validate(),
      onRefresh: contentListController.onRefresh,
      body: SnapHelperWidget<List<PosterDataModel>>(
        future: contentListController.listContentFuture.value,
        loadingWidget: ContentListShimmer(
          width: dynamicSpacing.$1,
          spacing: dynamicSpacing.$2,
          height: Get.height * 0.12,
        ),
        onSuccess: (response) {
          return Obx(
            () {
              if (contentListController.listContent.isEmpty && !contentListController.isLoading.value) {
                return AppNoDataWidget(
                  title: locale.value.noChannelsFound,
                  subTitle: "${locale.value.noChannelsAreAvailableInThisCategory}",
                  retryText: locale.value.reload,
                  imageWidget: const EmptyStateWidget(),
                  onRetry: contentListController.onRetry,
                );
              }
              return AnimatedWrap(
                listAnimationType: commonListAnimationType,
                runSpacing: 12,
                spacing: 12,
                itemCount: contentListController.listContent.length,
                itemBuilder: (context, index) {
                  final PosterDataModel content = contentListController.listContent[index];
                  return ContentListComponent(
                    contentData: content,
                    isHorizontalList: true,
                  );
                },
              );
            },
          );
        },
        errorBuilder: (error) {
          return AppNoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: contentListController.onRetry,
          ).center().visible(!contentListController.isLoading.value);
        },
      ),
    );
  }
}