import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart' show MovieAccess;
import 'package:streamit_laravel/utils/extension/date_time_extension.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

import '../../../main.dart';
import '../../subscription/model/subscription_plan_model.dart';

class SelectedPlanComponent extends StatelessWidget {
  final SubscriptionPlanModel planDetails;
  final RentalData rentalData;
  final double price;
  final bool isRent;
  final String contentName;

  const SelectedPlanComponent({
    super.key,
    required this.planDetails,
    required this.price,
    this.isRent = false,
    required this.contentName,
    required this.rentalData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: appColorPrimary, width: 0.4),
        color: lightBgRedColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isRent ? "${rentalData.isOneTimePurchase ? locale.value.oneTimePurchase : locale.value.rent} - $contentName" : "${locale.value.subscribe} - ${planDetails.name.validate()}",
                style: boldTextStyle(),
              ).expand(),
              4.width,
              PriceWidget(
                price: price,
                size: 18,
                color: primaryTextColor,
              ),
            ],
          ),
          4.height,
          if (isRent) ...[
            Row(
              children: [
                Text(
                  locale.value.validity,
                  style: commonSecondaryTextStyle(),
                ).expand(),
                4.width,
                Text(
                  '${rentalData.availabilityDays} ${rentalData.availabilityDays > 1 ? locale.value.days : locale.value.day}',
                  style: boldTextStyle(),
                ),
              ],
            ),
            if (rentalData.access != MovieAccess.oneTimePurchase)
              Row(
                children: [
                  Text(
                    locale.value.watchTime,
                    style: commonSecondaryTextStyle(),
                  ).expand(),
                  4.width,
                  Text(
                    ' ${rentalData.accessDuration} ${rentalData.accessDuration > 1 ? locale.value.days : locale.value.day}',
                    style: boldTextStyle(),
                  ),
                ],
              ),
          ] else
            Row(
              children: [
                Text(
                  "${locale.value.validUntil} ${calculateExpirationDate(DateTime.now(), planDetails.duration, planDetails.durationValue).appConfigurationDateFormate()}",
                  style: secondaryTextStyle(size: 12, weight: FontWeight.w600, color: darkGrayTextColor),
                ).expand(),
                4.width,
                Row(
                  children: [
                    Text(
                      '${planDetails.durationValue.toString()} ',
                      style: commonSecondaryTextStyle(size: 12),
                    ),
                    Text(
                      planDetails.durationValue == 1 ? planDetails.duration.singularSubscriptionDuration : planDetails.duration.pluralSubscriptionDuration,
                      style: commonSecondaryTextStyle(size: 12),
                    ),
                  ],
                )
              ],
            ),
        ],
      ),
    );
  }
}