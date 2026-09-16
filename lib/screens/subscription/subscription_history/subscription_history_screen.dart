import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_history_card.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_history_shimmer.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'subscription_history_controller.dart';

class SubscriptionHistoryScreen extends StatelessWidget {
  SubscriptionHistoryScreen({super.key});

  final SubscriptionHistoryController controller = Get.find<SubscriptionHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewAppScaffold(
        scrollController: controller.scrollController,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        isLoading: controller.isLoading,
        isPinnedAppbar: true,
        appBarTitleText: locale.value.subscriptionHistory,
        onRefresh: () => controller.getListData(showLoader: false),
        body: SnapHelperWidget(
          future: controller.listContentFuture.value,
          loadingWidget: SubscriptionHistoryShimmer(),
          errorBuilder: (error) {
            return AppNoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: controller.onRetry,
            ).visible(!controller.isLoading.value);
          },
          onSuccess: (res) {
            return Obx(() {
              if (controller.listContent.isEmpty && !controller.isLoading.value) {
                return AppNoDataWidget(
                  title: locale.value.noSubscriptionHistoryFound,
                  imageWidget: const EmptyStateWidget(),
                  retryText: locale.value.reload,
                  onRetry: controller.onRetry,
                ).paddingSymmetric(horizontal: 16).center();
              } else {
                return AnimatedWrap(
                  runSpacing: 16,
                  spacing: 16,
                  itemCount: controller.listContent.length,
                  listAnimationType: commonListAnimationType,
                  itemBuilder: (context, index) {
                    final item = controller.listContent[index];

                    return SubscriptionHistoryCard(
                      planDet: item,
                      onDownloadClick: () {
                        controller.downloadInvoice(id: item.id);
                      },
                    );
                  },
                );
              }
            });
          },
        ),
      ),
    );
  }
}