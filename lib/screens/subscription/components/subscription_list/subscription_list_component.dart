import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';

import '../../../../utils/common_functions.dart';
import '../../model/subscription_plan_model.dart';
import 'subscription_card.dart';

class SubscriptionListComponent extends StatelessWidget {
  final List<SubscriptionPlanModel> planList;

  final SubscriptionController subscriptionController;

  const SubscriptionListComponent({super.key, required this.planList, required this.subscriptionController});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      itemCount: planList.length,
      listAnimationType: commonListAnimationType,
      itemBuilder: (context, index) {
        return Obx(
          () {
            return SubscriptionCard(
              planDet: planList[index],
              isSelected: subscriptionController.selectPlan.value.id == planList[index].id,
              onSelect: () {
                subscriptionController.selectPlan(planList[index]);
                subscriptionController.calculateTotalPrice();
              },
            ).paddingBottom(16);
          },
        );
      },
    );
  }
}