import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/payment/payment_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/video_players/component/common/rent_detail_bottomsheet_controller.dart';

import '../../../main.dart';
import '../../../screens/auth/model/about_page_res.dart';
import '../../../utils/constants.dart';

class RentalDetailsComponent extends StatelessWidget {
  final ContentModel contentData;

  final RentalData rentalData;

  final VoidCallback onWatchNow;
  final bool showWatchNow;
  final void Function()? onPaymentReturnCallBack;

  final VoidCallback onPauseCurrentVideo;

  RentalDetailsComponent({
    super.key,
    required this.rentalData,
    required this.contentData,
    required this.onWatchNow,
    this.showWatchNow = true,
    this.onPaymentReturnCallBack,
    required this.onPauseCurrentVideo,
  });

  final RentDetailsController rentDetailsController = Get.find<RentDetailsController>();

  @override
  Widget build(BuildContext context) {
    final AboutDataModel? aboutDataModel = appPageList.firstWhereOrNull((element) => element.slug == AppPages.termsAndCondition);

    return Column(
      mainAxisSize: MainAxisSize.min,
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
        if (!contentData.details.hasContentAccess.getBoolInt() && selectedAccountProfile.value.isChildProfile.validate() != 1) ...[
          Row(
            children: [
              Obx(
                () => Checkbox(
                  value: rentDetailsController.isChecked.value,
                  onChanged: (bool? newValue) {
                    rentDetailsController.isChecked.value = newValue ?? false;
                  },
                  checkColor: Colors.white,
                  activeColor: appColorPrimary,
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: secondaryTextStyle(),
                    children: [
                      TextSpan(text: locale.value.byRentingYouAgreeToOur, style: secondaryTextStyle(size: 12)),
                      TextSpan(
                        text: locale.value.termsOfUse,
                        style: aboutDataModel?.url.validate().isNotEmpty == true ? boldTextStyle(size: 12, decoration: TextDecoration.underline) : secondaryTextStyle(size: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (aboutDataModel == null) return;
                            if (aboutDataModel.url.validate().isNotEmpty) launchUrlCustomURL(aboutDataModel.url.validate());
                          },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (selectedAccountProfile.value.isChildProfile.validate() != 1)
            rentAndPaidButton(
              rentData: rentalData,
              callBack: () {
                if (!rentDetailsController.isChecked.value) {
                  toast(locale.value.pleaseAgreeToThe);
                  return;
                } else {
                  Get.back();
                  Get.to(
                    () => PaymentScreen(),
                    arguments: [
                      contentData,
                      rentalData,
                    ],
                  )?.then((value) => onPaymentReturnCallBack?.call());
                }
              },
            ),
        ],
        if (showWatchNow && contentData.details.hasContentAccess.getBoolInt())
          watchNowButton(
            pauseCurrentVideo: onPauseCurrentVideo,
            contentData: contentData,
            callBack: () {
              onWatchNow.call();
            },
            onPaymentReturnCallBack: () {
              onWatchNow.call();
            },
          ).paddingSymmetric(vertical: 8),
      ],
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