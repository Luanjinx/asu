import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/video_players/component/common/rent_detail_bottomsheet_controller.dart';

import '../../../main.dart';
import '../../../utils/constants.dart' show MovieAccess;

class ShowRentalDetailsComponent extends StatelessWidget {
  final RentalData rentalData;

  ShowRentalDetailsComponent({
    super.key,
    required this.rentalData,
  });

  final RentDetailsController rentDetailsController = Get.find<RentDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecorationDefault(
        borderRadius: radius(defaultRadius),
        color: cardColor,
      ),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.value.validity,
                  style: boldTextStyle(),
                ),
                Text(
                  '${rentalData.availabilityDays} ${rentalData.availabilityDays > 1 ? locale.value.days : locale.value.day}',
                  style: boldTextStyle(),
                ),
              ],
            ),
            if (rentalData.access != MovieAccess.oneTimePurchase)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.value.watchTime,
                    style: boldTextStyle(),
                  ),
                  Text(
                    ' ${rentalData.accessDuration} ${rentalData.accessDuration > 1 ? locale.value.days : locale.value.day}',
                    style: boldTextStyle(),
                  ),
                ],
              ),
            const Divider(
              color: borderColor,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (rentalData.access != MovieAccess.oneTimePurchase) ...[
                  _buildBulletRow(locale.value.rentedesc(rentalData.availabilityDays, rentalData.accessDuration)),
                  _buildBulletRow(locale.value.youCanWatchThis(rentalData.accessDuration)),
                ] else ...[
                  _buildBulletRow(locale.value.purchaseInfo1(rentalData.availabilityDays)),
                  _buildBulletRow(locale.value.purchaseInfo2),
                ],
                _buildBulletRow(locale.value.thisIsANonRefundable),
                _buildBulletRow(locale.value.thisContentIsOnly),
                _buildBulletRow(locale.value.youCanPlayYour),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBulletRow(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('• ', style: secondaryTextStyle()),
        Expanded(child: Text(text, style: secondaryTextStyle())),
      ],
    ),
  );
}