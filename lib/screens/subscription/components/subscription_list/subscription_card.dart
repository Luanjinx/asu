import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';
import 'package:streamit_laravel/utils/price_widget.dart';
import 'package:streamit_laravel/utils/shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../model/subscription_plan_model.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionPlanModel planDet;
  final bool isSelected;

  final VoidCallback onSelect;

  const SubscriptionCard({
    super.key,
    required this.planDet,
    required this.onSelect,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurrentPlan = planDet.planId == currentSubscription.value.planId;

    return Obx(
      () => InkWell(
        onTap: isCurrentPlan ? null : onSelect,
        splashColor: appColorPrimary.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            gradient: isCurrentPlan
                ? LinearGradient(
                    colors: [goldColor.withValues(alpha: 0.1), goldColor.withValues(alpha: 0.2)],
                  )
                : isSelected
                    ? LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          lightRedColor.withValues(alpha: 0.2),
                          darkRedColor.withValues(alpha: 0.4),
                        ],
                      )
                    : null,
            borderRadius: BorderRadius.circular(6),
            color: cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (planDet.discountPercentage > 0) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: boxDecorationDefault(color: appColorPrimary, borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        locale.value.off.prefixText(value: '${planDet.discountPercentage.toString().suffixText(value: '%')}'),
                        style: boldTextStyle(size: 12),
                      ),
                    ),
                    12.width,
                  ],
                  Text(
                    planDet.name.toUpperCase(),
                    style: commonSecondaryTextStyle(
                      size: 12,
                      color: darkGrayTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 100,
                  ).expand(),
                  16.width,
                  if (isCurrentPlan)
                    Shimmer.fromColors(
                        baseColor: goldColor.withValues(alpha: 1),
                        highlightColor: goldAnimatedColor,
                        enabled: true,
                        direction: ShimmerDirection.ltr,
                        period: const Duration(seconds: 2),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: boxDecorationDefault(
                            color: goldColor.withValues(alpha: 0.00),
                            border: Border.all(color: goldColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.center,
                          child: Obx(
                            () => Text(
                              locale.value.currentPlan,
                              style: boldTextStyle(size: ResponsiveSize.getFontSize(10), color: goldColor),
                            ),
                          ),
                        ))
                  else
                    InkWell(
                      onTap: onSelect,
                      child: Icon(
                        isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                        size: isSelected ? 18 : 20,
                        color: isSelected ? appColorPrimary : darkGrayColor,
                      ),
                    ),
                ],
              ),
              if (planDet.discountPercentage > 0) 8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PriceWidget(
                    size: 22,
                    color: primaryTextColor,
                    price: planDet.totalPrice,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: " / ${planDet.durationValue} ",
                          style: commonSecondaryTextStyle(),
                        ),
                        TextSpan(
                          text: planDet.durationValue == 1 ? planDet.duration.singularSubscriptionDuration : planDet.duration.pluralSubscriptionDuration,
                          style: commonSecondaryTextStyle(),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ).expand(),
                ],
              ),
              if (planDet.description.isNotEmpty) 16.height,
              readMoreTextWidget(planDet.description),
              if (planDet.description.isNotEmpty) 16.height,
              if (planDet.planType.isNotEmpty) commonDivider,
              if (planDet.planType.isNotEmpty) 10.height,
              if (planDet.planType.isNotEmpty)
                AnimatedWrap(
                  itemCount: planDet.planType.length,
                  itemBuilder: (context, index) {
                    return subscriptionBenefitsTile(planType: planDet.planType[index]).paddingBottom(8);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}