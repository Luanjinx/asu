import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_pin_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class ProfilePinComponent extends StatelessWidget {
  final String profilePin;
  final VoidCallback onVerificationCompleted;
  final String? buttonText;

  ProfilePinComponent({
    super.key,
    required this.profilePin,
    required this.onVerificationCompleted,
    this.buttonText,
  });

  final ProfilePinController profilePinController = Get.find<ProfilePinController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        20.height,
        Text(
          locale.value.parentalLock,
          style: commonW500PrimaryTextStyle(size: 20),
        ),
        8.height,
        Text(
          locale.value.enter4DigitParentalControlPIN,
          style: secondaryTextStyle(),
        ),
        20.height,
        SizedBox(
          height: 42,
          child: OTPTextField(
            pinLength: 4,
            fieldWidth: 42,
            cursorColor: appColorPrimary,
            textStyle: primaryTextStyle(),
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
            onChanged: (String code) {
              profilePinController.pinController.text = code;
            },
            onCompleted: (String verificationCode) {
              hideKeyboard(context);
              profilePinController.pinController.text = verificationCode;
            },
          ),
        ),
        20.height,
        AppButton(
          text: buttonText ?? locale.value.submit,
          color: appColorPrimary,
          disabledColor: btnColor,
          textStyle: appButtonTextStyleWhite,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: radius(defaultAppButtonRadius / 2),
          ),
          onTap: () {
            hideKeyboard(context);
            if (profilePinController.pinController.text.isEmpty) {
              toast(locale.value.enter4DigitParentalControlPIN);
              return;
            } else if (profilePinController.pinController.text != profilePin) {
              toast(locale.value.invalidPIN);
              return;
            } else if (profilePinController.pinController.text == profilePin) {
              Get.back();
              onVerificationCompleted.call();
            } else {
              toast(locale.value.invalidPIN);
            }
          },
        ),
        20.height,
      ],
    );
  }
}