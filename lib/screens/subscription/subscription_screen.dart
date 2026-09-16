import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_price_component.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';
import 'package:streamit_laravel/screens/subscription/subscription_list_shimmer.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/subscription_list/subscription_list_component.dart';

class SubscriptionScreen extends StatelessWidget {
  final bool launchDashboard;

  final ContentData? contentData;

  SubscriptionScreen({super.key, required this.launchDashboard, this.contentData});

  final SubscriptionController subscriptionCont = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isPinnedAppbar: true,
      onRefresh: subscriptionCont.onRefresh,
      scrollController: subscriptionCont.scrollController,
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.subscription,
      body: SnapHelperWidget(
        future: subscriptionCont.listContentFuture.value,
        loadingWidget: const ShimmerSubscriptionList(),
        errorBuilder: (error) {
          return AppNoDataWidget(
            title: error,
            retryText: locale.value.reload,
            imageWidget: const ErrorStateWidget(),
            onRetry: () {
              subscriptionCont.onRetry();
            },
          ).visible(!subscriptionCont.isLoading.value);
        },
        onSuccess: (res) {
          return Obx(
            () {
              return subscriptionCont.listContent.isEmpty
                  ? AppNoDataWidget(
                      title: locale.value.noSubscriptionPlans,
                      subTitle: locale.value.noSubscriptionPlansSubtitle,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () {
                        subscriptionCont.onRetry();
                      },
                    ).center().visible(!subscriptionCont.isLoading.value)
                  : SubscriptionListComponent(
                      planList: subscriptionCont.listContent,
                      subscriptionController: subscriptionCont,
                    );
            },
          );
        },
      ),
      widgetsStackedOverBody: [
        PositionedDirectional(
          bottom: 10,
          start: ResponsiveSize.getStart(16),
          end: ResponsiveSize.getEnd(16),
          child: Obx(
            () => PriceComponent(
              subscriptionCont: subscriptionCont,
              contentDetails: contentData,
              buttonColor: subscriptionCont.selectPlan.value.level > 0 ? rentedColor : null,
            ).visible(
              subscriptionCont.selectPlan.value.name.isNotEmpty,
            ),
          ),
        )
      ],
    );
  }
}