import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_logo_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/auth/model/about_page_res.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../../utils/common_base.dart';
import 'sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController signUpController = Get.find<SignUpController>();

  SignUpScreen({super.key});

  final AboutDataModel privacyPage = appPageList.firstWhere((element) => element.slug == AppPages.privacyPolicy, orElse: () => AboutDataModel());
  final AboutDataModel termsAndConditionPage = appPageList.firstWhere((element) => element.slug == AppPages.termsAndCondition, orElse: () => AboutDataModel());

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      scrollController: signUpController.scrollController,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: signUpController.isLoading,
      expandedHeight: Get.height * 0.06,
      applyLeadingBackButton: false,
      hideAppBar: true,
      bodyPadding: EdgeInsets.zero,
      bottomSpace: MediaQuery.of(context).viewPadding.bottom,
      body: Form(
        key: signUpController.signUpFormKey,
        child: Column(
          children: [
            80.height,
            const AppLogoWidget(),
            Text(locale.value.createYourAccount, style: boldTextStyle(size: ResponsiveSize.getFontSize(20))),
            8.height,
            Text(locale.value.completeProfileSubtitle, style: commonSecondaryTextStyle()),
            24.height,
            Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTextField(
                  controller: signUpController.mobileCont,
                  textFieldType: TextFieldType.PHONE,
                  errorThisFieldRequired: locale.value.mobileNumberIsRequired,
                  decoration: inputDecoration(
                    context,
                    border: InputBorder.none,
                    hintText: locale.value.mobileNumber,
                    contentPadding: EdgeInsets.only(left: 8, bottom: 12),
                    prefixIcon: InkWell(
                      onTap: () {
                        signUpController.changeCountry(context);
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
                                  signUpController.selectedCountry.value.flagEmoji,
                                  style: commonPrimaryTextStyle(),
                                ),
                                Text(
                                  "+${signUpController.countryCode.value}",
                                  style: commonPrimaryTextStyle(),
                                ),
                              ],
                            ),
                          ),
                          6.width,
                          IconWidget(imgPath: Assets.iconsCaretDown, size: 16),
                          8.width,
                          Container(height: 18, width: 1, color: cardColor),
                        ],
                      ),
                    ),
                  ),
                  textStyle: commonPrimaryTextStyle(),
                ),
                AppTextField(
                  textStyle: commonPrimaryTextStyle(),
                  controller: signUpController.firstNameCont,
                  focus: signUpController.firstNameFocus,
                  nextFocus: signUpController.lastNameFocus,
                  textFieldType: TextFieldType.NAME,
                  cursorColor: white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return locale.value.firstNameIsRequiredField;
                    }
                    return null;
                  },
                  decoration: inputDecoration(
                    context,
                    contentPadding: const EdgeInsets.only(top: 15),
                    hintText: locale.value.firstName,
                    prefixIcon: IconWidget(
                      imgPath: Assets.iconsUserCircle,
                      color: iconColor,
                      size: 12,
                    ).paddingAll(14),
                  ),
                  onChanged: (value) {
                    signUpController.onBtnEnable();
                  },
                ),
                AppTextField(
                  textStyle: commonPrimaryTextStyle(),
                  controller: signUpController.lastNameCont,
                  focus: signUpController.lastNameFocus,
                  nextFocus: signUpController.emailFocus,
                  textFieldType: TextFieldType.NAME,
                  cursorColor: white,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return locale.value.lastNameIsRequiredField;
                    }
                    return null;
                  },
                  decoration: inputDecoration(
                    context,
                    contentPadding: const EdgeInsets.only(top: 15),
                    hintText: locale.value.lastName,
                    prefixIcon: IconWidget(
                      imgPath: Assets.iconsUserCircle,
                      color: iconColor,
                      size: 12,
                    ).paddingAll(14),
                  ),
                  onChanged: (value) {
                    signUpController.onBtnEnable();
                  },
                ),
                AppTextField(
                  textStyle: commonPrimaryTextStyle(),
                  controller: signUpController.emailCont,
                  focus: signUpController.emailFocus,
                  nextFocus: signUpController.passwordFocus,
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
                    prefixIcon: IconWidget(imgPath: Assets.iconsEnvelopeSimple, color: iconColor, size: 10).paddingAll(14),
                  ),
                  onChanged: (value) {
                    signUpController.onBtnEnable();
                  },
                ),
                if (!signUpController.isPhoneAuth.value) ...[
                  AppTextField(
                    textStyle: commonPrimaryTextStyle(color: white),
                    controller: signUpController.passwordCont,
                    focus: signUpController.passwordFocus,
                    nextFocus: signUpController.confPasswordFocus,
                    obscureText: true,
                    textFieldType: TextFieldType.PASSWORD,
                    cursorColor: white,
                    errorThisFieldRequired: locale.value.passwordIsRequired,
                    validator: (value) => validatePassword(value),
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.password,
                      contentPadding: const EdgeInsets.only(top: 14),
                      prefixIcon: IconWidget(imgPath: Assets.iconsLock, color: iconColor).paddingAll(16),
                    ),
                    suffixPasswordVisibleWidget: IconWidget(
                      imgPath: Assets.iconsEye,
                      color: iconColor,
                    ).paddingAll(16),
                    suffixPasswordInvisibleWidget: IconWidget(
                      imgPath: Assets.iconsEyeSlash,
                      color: iconColor,
                    ).paddingAll(16),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                  AppTextField(
                    textStyle: commonPrimaryTextStyle(color: white),
                    controller: signUpController.confPasswordCont,
                    focus: signUpController.confPasswordFocus,
                    nextFocus: signUpController.dobFocus,
                    obscureText: true,
                    textFieldType: TextFieldType.PASSWORD,
                    cursorColor: white,
                    decoration: inputDecoration(
                      context,
                      hintText: locale.value.confirmPassword,
                      contentPadding: const EdgeInsets.only(top: 14),
                      prefixIcon: IconWidget(imgPath: Assets.iconsLock, color: iconColor).paddingAll(16),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return locale.value.confirmPasswordIsRequired;
                      return signUpController.passwordCont.text == value ? null : locale.value.thePasswordDoesNotMatch;
                    },
                    suffixPasswordVisibleWidget: IconWidget(
                      imgPath: Assets.iconsEye,
                      color: iconColor,
                    ).paddingAll(16),
                    suffixPasswordInvisibleWidget: IconWidget(
                      imgPath: Assets.iconsEyeSlash,
                      color: iconColor,
                    ).paddingAll(16),
                    onChanged: (value) {
                      signUpController.onBtnEnable();
                    },
                  ),
                ],
                16.height,
                AppButton(
                  width: double.infinity,
                  text: locale.value.signUp,
                  color: appColorPrimary,
                  disabledColor: btnColor,
                  textStyle: appButtonTextStyleWhite,
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                  onTap: () {
                    if (signUpController.signUpFormKey.currentState!.validate() && signUpController.mobileCont.text.isNotEmpty) {
                      hideKeyboard(context);
                      signUpController.saveForm();
                    }
                  },
                ),
                4.height,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: locale.value.alreadyHaveAnAccount, style: commonSecondaryTextStyle(size: 12)),
                      TextSpan(
                        text: locale.value.signIn.prefixText(value: ' '),
                        style: commonSecondaryTextStyle(size: 12, color: appColorPrimary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.back();
                          },
                      ),
                    ],
                  ),
                ),
                4.height,
                Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: commonSecondaryTextStyle(color: descriptionTextColor, size: 12),
                        children: [
                          TextSpan(text: locale.value.byCreatingAnAccountYouAgreeTo),
                          TextSpan(
                            text: locale.value.termsConditions,
                            style: commonSecondaryTextStyle(
                              size: 12,
                              color: termsAndConditionPage.url.validate().isNotEmpty ? appColorPrimary : descriptionTextColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (termsAndConditionPage.url.validate().isNotEmpty) {
                                  launchUrlCustomURL(termsAndConditionPage.url.validate());
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: commonSecondaryTextStyle(color: descriptionTextColor, size: 12),
                        children: [
                          TextSpan(text: locale.value.ofAllServicesAnd),
                          TextSpan(
                            text: locale.value.privacyPolicy,
                            style: commonSecondaryTextStyle(
                              size: 12,
                              color: privacyPage.url.validate().isNotEmpty ? appColorPrimary : descriptionTextColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (privacyPage.url.validate().isNotEmpty) {
                                  launchUrlCustomURL(privacyPage.url.validate());
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                16.height,
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
    );
  }
}