import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

class SubscriptionHistoryCard extends StatelessWidget {
  final SubscriptionPlanModel planDet;
  final VoidCallback onDownloadClick;

  const SubscriptionHistoryCard({
    super.key,
    required this.planDet,
    required this.onDownloadClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        borderRadius: radius(8),
        color: cardColor,
        border: Border.all(color: borderColorDark),
      ),
      child: Column(
        children: [
          Container(
            decoration: boxDecorationDefault(color: Colors.transparent, borderRadius: radius(22)),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Text(planDet.name, style: boldTextStyle()).expand(),
                PriceWidget(
                  price: planDet.totalAmount,
                  size: 22,
                  color: primaryTextColor,
                ),
              ],
            ),
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 16,
            children: [
              if (planDet.startDate.isNotEmpty && planDet.endDate.isNotEmpty)
                TextIcon(
                  prefix: IconWidget(
                    imgPath: Assets.iconsClock,
                    color: iconColor,
                    size: 16,
                  ),
                  useMarquee: true,
                  expandedText: true,
                  edgeInsets: EdgeInsets.zero,
                  text: "${locale.value.validity}: ${planDet.startDate} to ${planDet.endDate}",
                  textStyle: commonSecondaryTextStyle(size: 12),
                ).expand(),
              if (getSubscriptionPlanStatus(planDet.status).isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: boxDecorationDefault(
                    borderRadius: radius(18),
                    color: planDet.status == SubscriptionStatus.active ? discountColor.withValues(alpha: 0.3) : appColorPrimary.withValues(alpha: 0.4),
                    border: Border.all(color: planDet.status == SubscriptionStatus.active ? discountColor.withValues(alpha: 0.3) : appColorPrimary.withValues(alpha: 0.4)),
                  ),
                  child: Marquee(
                    child: Text(
                      getSubscriptionPlanStatus(planDet.status),
                      style: commonPrimaryTextStyle(size: 12, fontStyle: FontStyle.italic),
                    ),
                  ),
                )
            ],
          ),
          if (planDet.planType.isNotEmpty) ...[
            12.height,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: planDet.planType.length,
              itemBuilder: (context, index) {
                return subscriptionBenefitsTile(planType: planDet.planType[index]).paddingBottom(8);
              },
            ),
          ],
          12.height,
          Divider(
            color: borderColorDark,
            height: 8,
          ),
          TextButton(
            onPressed: onDownloadClick,
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              visualDensity: VisualDensity.compact,
            ),
            child: TextIcon(
              spacing: 12,
              prefix: IconWidget(
                imgPath: Assets.iconsDownload,
                color: appColorPrimary,
                size: 16,
              ),
              text: locale.value.downloadInvoice,
              textStyle: boldTextStyle(color: appColorPrimary),
            ),
          ),
        ],
      ),
    );
  }
}