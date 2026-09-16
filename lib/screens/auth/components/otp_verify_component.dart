import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../main.dart';
import '../../../utils/common_base.dart';

class OTPVerifyComponent extends StatelessWidget {
  OTPVerifyComponent({super.key});

  final SignInController verificationCont = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            20.height,
            Text(
              locale.value.oTPVerification,
              style: commonW500PrimaryTextStyle(size: 20),
            ),
            8.height,
            Text(
              locale.value.weHaveSentVerificationCodeToMobileNumber,
              style: commonSecondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            20.height,
            SizedBox(
              height: 50,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const pinCount = 6;
                  const marginPerSide = 8.0;
                  final availableWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : MediaQuery.of(context).size.width;
                  final totalSpacing = (pinCount * (marginPerSide * 2)) - 8;
                  final computedFieldWidth = (((availableWidth - totalSpacing) / pinCount).clamp(36.0, 45.0)).toDouble();

                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: OTPTextField(
                      pinLength: pinCount,
                      fieldWidth: computedFieldWidth,
                      cursorColor: appColorPrimary,
                      textStyle: boldTextStyle(size: ResponsiveSize.getFontSize(18)),
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        contentPadding: const EdgeInsets.only(bottom: 4),
                        fillColor: cardColor,
                        filled: true,
                        focusColor: primaryTextColor,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: appColorPrimary, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: borderColor, width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      boxDecoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: borderColor, width: 1.0),
                      ),
                      onChanged: (value) {
                        if (value.length == pinCount) {
                          verificationCont.getVerifyBtnEnable();
                          verificationCont.isOTPVerify(true);
                        } else {
                          verificationCont.isOTPVerify(false);
                          verificationCont.isVerifyBtn(false);
                        }
                      },
                      onCompleted: (code) {
                        verificationCont.verifyCont.text = code;
                        verificationCont.getVerifyBtnEnable();
                        if (verificationCont.isVerifyBtn.isTrue && verificationCont.codeResendTime.value != 0) {
                          verificationCont.onVerifyPressed();
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            Obx(() => verificationCont.codeResendTime.value != 0 ? 20.height : 0.height),
            Obx(() {
              final secondsLeft = verificationCont.codeResendTime.value;
              return secondsLeft == 0
                  ? const SizedBox.shrink()
                  : Text(
                      locale.value.resendOtpCountText(secondsLeft),
                      style: commonW500PrimaryTextStyle(size: 14, color: context.primaryColor),
                    );
            }),
            10.height,
            Obx(() {
              if (verificationCont.codeResendTime.value > 0) return const SizedBox.shrink();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    locale.value.didntGetTheOTP,
                    style: commonSecondaryTextStyle(),
                  ),
                  InkWell(
                    onTap: () {
                      verificationCont.verifyCont.clear();
                      verificationCont.verificationId('');
                      verificationCont.verificationCode("");
                      verificationCont.onLoginPressed();
                    },
                    child: Text(
                      locale.value.resendOTP.prefixText(value: ' '),
                      style: commonSecondaryTextStyle(color: appColorPrimary),
                    ),
                  ),
                ],
              );
            }),
            20.height,
            Obx(
              () => AppButton(
                width: double.infinity,
                text: locale.value.verify,
                color: verificationCont.isVerifyBtn.value ? appColorPrimary : lightBtnColor,
                disabledColor: btnColor,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                onTap: verificationCont.verifyCont.text.length == 6
                    ? () {
                        if (verificationCont.isOTPLoading.value) return;
                        verificationCont.onVerifyPressed();
                      }
                    : null,
              ),
            ),
            20.height,
          ],
        ).paddingSymmetric(horizontal: 12),
        Obx(
          () => verificationCont.isOTPLoading.isTrue
              ? const PositionedDirectional(
                  start: 0,
                  end: 0,
                  top: 0,
                  bottom: 0,
                  child: LoaderWidget(),
                )
              : const Offstage(),
        ),
      ],
    );
  }
}