import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/screens/setting/faq/components/f_a_q_card.dart';
import 'package:streamit_laravel/screens/setting/faq/faq_list_controller.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/empty_error_state_widget.dart';

class FAQScreen extends StatelessWidget {
  final FAQListController settingController = Get.find<FAQListController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: settingController.scrollController,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.faqs,
      isLoading: settingController.isLoading,
      onRefresh: settingController.onRefresh,
      body: Obx(
        () {
          return SnapHelperWidget(
            future: settingController.listContentFuture.value,
            loadingWidget: _buildShimmer(),
            errorBuilder: (error) {
              return AppNoDataWidget(
                title: error,
                retryText: locale.value.retry,
                onRetry: () {
                  settingController.onRetry();
                },
                imageWidget: const EmptyStateWidget(),
              );
            },
            onSuccess: (data) {
              if (settingController.listContent.isEmpty && !settingController.isLoading.value) {
                return AppNoDataWidget(
                  title: locale.value.noFAQsfound,
                  retryText: locale.value.reload,
                  onRetry: () {
                    settingController.onRetry();
                  },
                  imageWidget: const EmptyStateWidget(),
                ).paddingSymmetric(horizontal: 16).center();
              }
              return AnimatedWrap(
                itemCount: settingController.listContent.length,
                itemBuilder: (context, index) {
                  return FAQCard(faqData: settingController.listContent[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return AnimatedWrap(
      spacing: 12,
      runSpacing: 12,
      itemCount: 16,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(8)),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: Get.width / 2,
                radius: 6,
              ),
              ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: Get.width,
                radius: 6,
              ),
              ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: Get.width,
                radius: 6,
              ),
            ],
          ),
        );
      },
    );
  }
}