import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/account_setting/account_setting_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../main.dart';

class ParentalLockOTPVerificationComponent extends StatelessWidget {
  final AccountSettingController settingCont = Get.find<AccountSettingController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,
        Text(
          locale.value.otpVerification,
          style: commonW500PrimaryTextStyle(size: 22),
        ),
        8.height,
        Text(
          locale.value.weHaveSentYouOTPOnYourRegisterEmailAddress,
          style: secondaryTextStyle(),
        ),
        20.height,
        SizedBox(
          height: 42,
          child: OTPTextField(
            fieldWidth: 42,
            cursorColor: appColorPrimary,
            textStyle: primaryTextStyle(),
            onCompleted: (otp) {
              settingCont.otp(otp);
              settingCont.isOTPSent(true);
            },
            decoration: InputDecoration(
              counter: const Offstage(),
              contentPadding: const EdgeInsets.only(bottom: 8, left: 2),
              fillColor: cardColor,
              focusColor: primaryTextColor,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: borderColor, width: 0.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: transparentColor, width: 0.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: transparentColor, width: 0.0),
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            boxDecoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
        ),
        Obx(
          () => Column(
            children: [
              20.height,
              Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locale.value.didntGetTheOTP,
                    style: secondaryTextStyle(),
                  ),
                  Text(
                    locale.value.resendOTP,
                    style: secondaryTextStyle(color: appColorPrimary),
                  ).onTap(() async {
                    await CoreServiceApis.getPinChangeOTP().then((value) {
                      if (value.status == true) {
                        toast(locale.value.otpSentSuccessfully);
                      }
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
        20.height,
        Obx(
          () => settingCont.isOTPVerificationLoading.value
              ? LoaderWidget()
              : AppButton(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: Get.width / 2 - 24,
                  text: locale.value.verify,
                  color: settingCont.isOTPSent.value ? appColorPrimary : greyBtnColor,
                  disabledColor: btnColor,
                  enabled: settingCont.isOTPSent.value,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(
                    borderRadius: radius(defaultAppButtonRadius / 2),
                  ),
                  onTap: () async {
                    hideKeyboard(context);
                    await settingCont.handleVerifyOTP();
                  },
                ),
        ),
        20.height,
      ],
    );
  }
}