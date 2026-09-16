import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_logo_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'forgot_pass_controller.dart';

class ForgotPassword extends StatelessWidget {
  final ForgotPasswordController forgetPassController = Get.find<ForgotPasswordController>();

  ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isScrollableWidget: false,
      isLoading: forgetPassController.isLoading,
      body: Form(
        key: forgetPassController.forgotPassFormKey,
        child: Column(
          children: [
            16.height,
            const AppLogoWidget(),
            16.height,
            Text(
              locale.value.forgotPassword,
              textAlign: TextAlign.center,
              style: boldTextStyle(),
            ),
            8.height,
            Text(
              locale.value.resetPasswordLinkSentToYourEmail,
              textAlign: TextAlign.center,
              style: commonSecondaryTextStyle(
                size: 12,
                color: darkGrayTextColor,
              ),
            ).paddingSymmetric(horizontal: 20),
            30.height,
            AppTextField(
              textStyle: commonPrimaryTextStyle(),
              controller: forgetPassController.emailCont,
              textFieldType: TextFieldType.EMAIL_ENHANCED,
              cursorColor: white,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.value.emailIsARequiredField;
                } else if (!value.isValidEmail()) {
                  return locale.value.pleaseEnterValidEmailAddress;
                }
                return null;
              },
              decoration: inputDecoration(
                context,
                contentPadding: const EdgeInsets.only(top: 15),
                hintText: locale.value.email,
                prefixIcon: IconWidget(imgPath: Assets.iconsEnvelopeSimple, color: iconColor, size: 12).paddingAll(14),
              ),
              onChanged: (value) {
                forgetPassController.getBtnEnable();
                if (forgetPassController.isResetLinSent.isTrue) {
                  forgetPassController.isResetLinSent(false);
                }
              },
              onFieldSubmitted: (p0) {
                if (forgetPassController.forgotPassFormKey.currentState!.validate()) {
                  forgetPassController.saveForm();
                }
              },
            ),
            30.height,
            Obx(
              () => AppButton(
                width: double.infinity,
                text: locale.value.sendResetLink,
                color: appColorPrimary,
                textStyle: appButtonTextStyleWhite,
                disabledColor: btnColor,
                enabled: forgetPassController.isLoading.isFalse,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                onTap: () {
                  if (forgetPassController.forgotPassFormKey.currentState!.validate()) {
                    forgetPassController.saveForm();
                  }
                },
              ),
            ),
            30.height,
            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(6), border: Border.all(color: borderColor), color: cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      locale.value.linkSentToYourEmail,
                      style: boldTextStyle(
                        size: 12,
                        color: primaryTextColor,
                      ),
                    ),
                    4.height,
                    Text(
                      locale.value.checkYourInboxAndChangePassword,
                      textAlign: TextAlign.center,
                      style: commonSecondaryTextStyle(
                        size: 12,
                        color: darkGrayTextColor,
                      ),
                    ),
                  ],
                ),
              ).visible(forgetPassController.isResetLinSent.isTrue),
            )
          ],
        ),
      ),
    );
  }
}