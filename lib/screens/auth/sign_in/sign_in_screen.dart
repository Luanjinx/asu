import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_logo_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../../utils/common_base.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../sign_in/sign_in_controller.dart';
import '../sign_up/signup_screen.dart';
import 'component/social_auth.dart';

class SignInScreen extends StatelessWidget {
  // ignore: use_super_parameters
  final bool showBackButton;
  final String? title;

  SignInScreen({super.key, this.showBackButton = true, this.title});

  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      hideAppBar: true,
      scrollController: signInController.scrollController,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: signInController.isLoading,
      expandedHeight: Get.height * 0.06,
      isScrollableWidget: false,
      bodyPadding: EdgeInsets.zero,
      body: Form(
        key: signInController.signInformKey,
        child: Column(
          children: [
            120.height,
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0, tileMode: TileMode.mirror),
              child: Column(
                children: [
                  const AppLogoWidget(),
                  Text(locale.value.welcomeBackToStreamIt, style: boldTextStyle(size: ResponsiveSize.getFontSize(20))),
                  8.height,
                  Text(title ?? locale.value.weHaveEagerlyAwaitedYourReturn, style: commonSecondaryTextStyle(color: title != null ? appColorPrimary : null, size: title != null ? 15 : null), textAlign: TextAlign.center),
                  48.height,
                  Obx(() => signInController.isNormalLogin.value ? formFieldComponent(context) : otpLoginComponent(context)),
                ],
              ),
            ),
            16.height,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: locale.value.dontHaveAnAccount, style: commonSecondaryTextStyle(size: 12)),
                  TextSpan(
                    text: locale.value.signUp.prefixText(value: ' '),
                    style: commonSecondaryTextStyle(size: 12, color: appColorPrimary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        var res = await Get.to(() => SignUpScreen());
                        if (res == true) {
                          Get.off(() => WatchingProfileScreen(), arguments: Get.arguments);
                        }
                      },
                  ),
                ],
              ),
            ),
            40.height,
            Row(
              children: [
                Divider(
                  indent: 24,
                  endIndent: 24,
                  height: 4,
                  color: borderColor,
                ).expand(),
                Text(locale.value.or, style: commonSecondaryTextStyle()),
                Divider(
                  indent: 24,
                  endIndent: 24,
                  height: 8,
                  color: borderColor,
                ).expand(),
              ],
            ),
            28.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                if (appConfigs.value.isOtpLoginEnabled)
                  Obx(() {
                    return SocialIconWidget(
                      icon: signInController.isNormalLogin.value ? Assets.iconsPhone : Assets.iconsEnvelopeSimple,
                      iconColor: primaryIconColor,
                      buttonWidth: Get.width,
                      iconSize: Size(22, 22),
                      text: signInController.isNormalLogin.value ? locale.value.loginWithOtp : locale.value.loginWithEmail,
                      onTap: () {
                        signInController.isNormalLogin(!signInController.isNormalLogin.value);
                      },
                    );
                  }),
                SocialAuthComponent(),
              ],
            ),
            48.height,
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }

  Widget formFieldComponent(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          textStyle: commonPrimaryTextStyle(),
          controller: signInController.emailCont,
          focus: signInController.emailFocus,
          nextFocus: signInController.passwordFocus,
          textFieldType: TextFieldType.EMAIL_ENHANCED,
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
            hintText: locale.value.email,
            contentPadding: const EdgeInsets.only(top: 14),
            prefixIcon: IconWidget(imgPath: Assets.iconsEnvelopeSimple, color: iconColor, size: 12).paddingAll(14),
          ),
          onChanged: (value) {
            signInController.getBtnEnable();
          },
        ),
        16.height,
        AppTextField(
          textStyle: commonPrimaryTextStyle(),
          controller: signInController.passwordCont,
          focus: signInController.passwordFocus,
          obscureText: true,
          textFieldType: TextFieldType.PASSWORD,
          errorThisFieldRequired: locale.value.passwordIsRequired,
          decoration: inputDecoration(
            context,
            hintText: locale.value.password,
            contentPadding: const EdgeInsets.only(top: 14),
            prefixIcon: IconWidget(imgPath: Assets.iconsLock, color: iconColor, size: 12).paddingAll(14),
          ),
          suffixPasswordVisibleWidget: IconWidget(imgPath: Assets.iconsEye, color: iconColor, size: 12).paddingAll(14),
          suffixPasswordInvisibleWidget: IconWidget(imgPath: Assets.iconsEyeSlash, color: iconColor, size: 12).paddingAll(14),
          onChanged: (value) {
            signInController.getBtnEnable();
          },
        ),
        24.height,
        Row(
          children: [
            Obx(
              () => InkWell(
                onTap: () {
                  signInController.isRememberMe.value = !signInController.isRememberMe.value;
                },
                child: Container(
                  padding: const EdgeInsets.all(1.2),
                  decoration: boxDecorationDefault(
                    borderRadius: BorderRadius.circular(2),
                    color: signInController.isRememberMe.isTrue ? appColorPrimary : appScreenBackgroundDark,
                    border: Border.all(color: appColorPrimary),
                  ),
                  child: IconWidget(
                    imgPath: Assets.iconsCheck,
                    color: signInController.isRememberMe.isTrue ? primaryIconColor : appScreenBackgroundDark,
                    size: 12,
                  ),
                ),
              ),
            ),
            14.width,
            Text(
              locale.value.rememberMe,
              style: commonSecondaryTextStyle(color: white.withValues(alpha: 0.6), size: 12),
            ).onTap(
              () {
                signInController.isRememberMe.value = !signInController.isRememberMe.value;
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ).expand(),
            InkWell(
              onTap: () {
                Get.to(() => ForgotPassword());
              },
              child: Text(
                locale.value.forgotPassword,
                style: commonPrimaryTextStyle(
                  size: 12,
                  color: appColorPrimary,
                ),
              ),
            ),
          ],
        ),
        30.height,
        Obx(
          () => AppButton(
            width: double.infinity,
            text: locale.value.signIn,
            disabledColor: btnColor,
            color: appColorPrimary,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
            onTap: () {
              if (signInController.signInformKey.currentState!.validate()) {
                signInController.saveForm(isNormalLogin: true);
              }
            },
          ),
        ),
        16.height,
      ],
    );
  }

  Widget otpLoginComponent(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: signInController.phoneCont,
              textFieldType: TextFieldType.PHONE,
              errorThisFieldRequired: locale.value.mobileNumberIsRequired,
              decoration: inputDecoration(
                context,
                border: InputBorder.none,
                hintText: locale.value.mobileNumber,
                contentPadding: EdgeInsets.only(left: 8, bottom: 12),
                prefixIcon: InkWell(
                  onTap: () {
                    signInController.changeCountry(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      8.width,
                      Obx(
                        () => Wrap(
                          spacing: 4,
                          children: [
                            Text(
                              signInController.selectedCountry.value.flagEmoji,
                              style: commonPrimaryTextStyle(size: 16),
                            ),
                            Text(
                              "+${signInController.countryCode.value}",
                              style: commonPrimaryTextStyle(size: 16),
                            ),
                          ],
                        ),
                      ),
                      6.width,
                      IconWidget(imgPath: Assets.iconsCaretDown, size: 16),
                      8.width,
                      VerticalDivider(
                        color: appColorPrimary,
                        width: 2,
                      ),
                      8.width,
                      Container(height: 18, width: 1, color: cardColor),
                    ],
                  ),
                ),
              ),
              textStyle: commonPrimaryTextStyle(),
              onChanged: (value) {
                if (value.isNotEmpty) signInController.getBtnEnable();
              },
            ),
          ],
        ),
        30.height,
        Obx(
          () => AppButton(
            width: double.infinity,
            text: locale.value.getVerificationCode,
            color: appColorPrimary,
            disabledColor: btnColor,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
            onTap: () {
              if (signInController.signInformKey.currentState!.validate()) {
                hideKeyboard(context);
                signInController.onLoginPressed(isFromSignIn: true);
              }
            },
          ),
        ),
        16.height,
        MediaQuery.of(context).viewInsets.bottom.toInt().height,
      ],
    );
  }
}