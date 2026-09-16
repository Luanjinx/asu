import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_logo_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/successfull_dialogbox.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_screen.dart';

import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/common_functions.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  final ChangePasswordController changePassController = Get.find<ChangePasswordController>();

  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: changePassController.isLoading,
      appBarTitleText: locale.value.changePassword,
      isPinnedAppbar: true,
      body: Form(
        key: changePassController.changePassFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const AppLogoWidget(),
            8.height,
            Text(
              locale.value.yourNewPasswordMust,
              textAlign: TextAlign.center,
              style: commonSecondaryTextStyle(
                size: 12,
                color: darkGrayTextColor,
              ),
            ).paddingSymmetric(horizontal: 20),
            30.height,
            AppTextField(
              textStyle: commonPrimaryTextStyle(),
              controller: changePassController.oldPasswordCont,
              focus: changePassController.oldPasswordFocus,
              nextFocus: changePassController.newPasswordFocus,
              obscureText: true,
              textFieldType: TextFieldType.PASSWORD,
              isValidationRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return locale.value.oldPasswordIsRequired;
                }
                return null;
              },
              decoration: inputDecoration(
                context,
                hintText: locale.value.oldPassword,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: IconWidget(imgPath: Assets.iconsLock, color: iconColor, size: 12).paddingAll(16),
              ),
              suffixPasswordVisibleWidget: IconWidget(imgPath: Assets.iconsEye, color: iconColor, size: 12).paddingAll(16),
              suffixPasswordInvisibleWidget: IconWidget(imgPath: Assets.iconsEyeSlash, color: iconColor, size: 12).paddingAll(16),
            ),
            16.height,
            AppTextField(
              textStyle: commonPrimaryTextStyle(),
              isValidationRequired: true,
              controller: changePassController.newPasswordCont,
              focus: changePassController.newPasswordFocus,
              nextFocus: changePassController.confirmPasswordFocus,
              obscureText: true,
              textFieldType: TextFieldType.PASSWORD,
              validator: (value) {
                return validatePassword(value, isNewPassword: true);
              },
              decoration: inputDecoration(
                context,
                hintText: locale.value.newPassword,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: IconWidget(imgPath: Assets.iconsLock, color: iconColor, size: 12).paddingAll(16),
              ),
              suffixPasswordVisibleWidget: IconWidget(imgPath: Assets.iconsEye, color: iconColor, size: 12).paddingAll(16),
              suffixPasswordInvisibleWidget: IconWidget(imgPath: Assets.iconsEyeSlash, color: iconColor, size: 12).paddingAll(16),
            ),
            16.height,
            AppTextField(
              textStyle: commonPrimaryTextStyle(),
              controller: changePassController.confirmPasswordCont,
              focus: changePassController.confirmPasswordFocus,
              obscureText: true,
              textFieldType: TextFieldType.PASSWORD,
              isValidationRequired: true,
              validator: (value) {
                if (value != changePassController.newPasswordCont.text) {
                  return locale.value.yourNewPasswordDoesnT;
                }
                return validatePassword(value, isConfirmPassword: true);
              },
              decoration: inputDecoration(
                context,
                hintText: locale.value.confirmNewPassword,
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: IconWidget(imgPath: Assets.iconsLock, color: iconColor, size: 12).paddingAll(16),
              ),
              suffixPasswordVisibleWidget: IconWidget(imgPath: Assets.iconsEye, color: iconColor, size: 12).paddingAll(16),
              suffixPasswordInvisibleWidget: IconWidget(imgPath: Assets.iconsEyeSlash, color: iconColor, size: 12).paddingAll(16),
            ),
            30.height,
            Obx(
              () => AppButton(
                width: Get.width,
                text: locale.value.submit,
                color: appColorPrimary,
                disabledColor: btnColor,
                enabled: !changePassController.isLoading.value,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                onTap: () async {
                  hideKeyboard(context);
                  if (changePassController.changePassFormKey.currentState!.validate()) {
                    changePassController.changePassFormKey.currentState!.save();
                    changePassController.saveForm(
                      () {
                        final logoutCompleter = Completer<bool>();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) {
                            return PopScope(
                              canPop: true,
                              onPopInvokedWithResult: (didPop, result) {
                                if (didPop && !logoutCompleter.isCompleted) {
                                  logoutCompleter.complete(true);
                                  handleLogoutAndNavigateToLogin(
                                    onFormReset: () {
                                      changePassController.changePassFormKey.currentState?.reset();
                                    },
                                    onFormClear: () {
                                      changePassController.clearForm();
                                    },
                                    onLoadingStateChange: (isLoading) {
                                      changePassController.isLoading(isLoading);
                                    },
                                  );
                                }
                              },
                              child: SuccessDialogueComponent(
                                title: locale.value.yourPasswordHasBeen,
                                subtitle: locale.value.youCanNowLog,
                                buttonText: locale.value.logOutAll,
                                onButtonClick: () {
                                  if (!logoutCompleter.isCompleted) {
                                    logoutCompleter.complete(true);
                                    Navigator.of(dialogContext).pop();
                                    handleLogoutAndNavigateToLogin(
                                      onFormReset: () {
                                        changePassController.changePassFormKey.currentState?.reset();
                                      },
                                      onFormClear: () {
                                        changePassController.clearForm();
                                      },
                                      onLoadingStateChange: (isLoading) {
                                        changePassController.isLoading(isLoading);
                                      },
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ).then((_) {
                          // Handle dialog dismissal (when user taps outside)
                          if (!logoutCompleter.isCompleted) {
                            logoutCompleter.complete(true);
                            handleLogoutAndNavigateToLogin(
                              onFormReset: () {
                                changePassController.changePassFormKey.currentState?.reset();
                              },
                              onFormClear: () {
                                changePassController.clearForm();
                                Get.offAll(() => SignInScreen(title: locale.value.changePasswordMessage));
                              },
                              onLoadingStateChange: (isLoading) {
                                changePassController.isLoading(isLoading);
                              },
                            );
                          }
                        });
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}