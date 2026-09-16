import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/subscription/components/rented_history_card.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/rental_history_controller.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/empty_error_state_widget.dart';
import 'shimmer_rental_history_list.dart';

class RentalHistoryScreen extends StatelessWidget {
  RentalHistoryScreen({super.key});

  final RentalHistoryController controller = Get.find<RentalHistoryController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      scrollController: controller.scrollController,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: controller.isLoading,
      isPinnedAppbar: true,
      appBarTitleText: locale.value.rentalHistory,
      onRefresh: controller.onSwipeRefresh,
      body: Obx(() {
        return SnapHelperWidget(
          future: controller.listContentFuture.value,
          loadingWidget: const ShimmerRentalHistoryList(),
          errorBuilder: (error) {
            return AppNoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: controller.onRetry,
            ).visible(!controller.isLoading.value);
          },
          onSuccess: (res) {
            if (controller.listContent.isEmpty && controller.isLoading.isFalse) {
              return AppNoDataWidget(
                height: Get.height * 0.6,
                title: locale.value.noRentalHistoryFound,
                imageWidget: const EmptyStateWidget(),
                retryText: locale.value.reload,
                onRetry: controller.onRetry,
              );
            }
            return AnimatedWrap(
              listAnimationType: commonListAnimationType,
              itemBuilder: (context, index) {
                return RentedHistoryCard(
                  rentalHistory: controller.listContent[index],
                  onDownloadClick: () {
                    controller.downloadInvoice(id: controller.listContent[index].id);
                  },
                );
              },
              runSpacing: 16,
              spacing: 16,
              itemCount: controller.listContent.length,
            );
          },
        );
      }),
    );
  }
}