import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_toggle_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/account_setting/account_setting_controller.dart';
import 'package:streamit_laravel/screens/account_setting/components/parental_lock_pin_component.dart';
import 'package:streamit_laravel/screens/account_setting/shimmer_account_setting.dart';
import 'package:streamit_laravel/screens/auth/change_password/change_password_screen.dart';
import 'package:streamit_laravel/screens/device/device_management_screen.dart';
import 'package:streamit_laravel/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_banner_component.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/rental_history_screen.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/subscription_history_screen.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/empty_error_state_widget.dart';

class AccountSettingScreen extends StatelessWidget {
  AccountSettingScreen({super.key});

  final AccountSettingController accountSettingController = Get.find<AccountSettingController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          if (selectedAccountProfile.value.profilePin.isEmpty) {
            accountSettingController.handleParentalLock(false, showMessage: false);
          }
        }
      },
      child: NewAppScaffold(
        isPinnedAppbar: true,
        appBarTitleText: locale.value.accountSettings,
        scrollController: accountSettingController.scrollController,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        isLoading: accountSettingController.isLoading,
        applyLeadingBackButton: true,
        onRefresh: () {
          accountSettingController.getAccountSetting();
          profileController.getProfileDetail(showLoader: false);
        },
        body: SnapHelperWidget(
          future: accountSettingController.contentFuture.value,
          loadingWidget: const ShimmerAccountSetting(),
          errorBuilder: (error) {
            return AppNoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                accountSettingController.getAccountSetting();
              },
            ).center().visible(!accountSettingController.isLoading.value);
          },
          onSuccess: (res) {
            return Obx(
              () => Column(
                spacing: 24,
                children: [
                  if (!selectedAccountProfile.value.isChildProfile.getBoolInt())
                    Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return SettingItemWidget(
                            padding: EdgeInsets.zero,
                            splashColor: appScreenBackgroundDark,
                            highlightColor: appScreenBackgroundDark,
                            hoverColor: appScreenBackgroundDark,
                            leading: CachedImageWidget(
                              url: loginUserData.value.profileImage,
                              height: 54,
                              width: 54,
                              circle: true,
                              fit: BoxFit.cover,
                            ),
                            titleTextStyle: boldTextStyle(),
                            title: loginUserData.value.fullName,
                            subTitle: loginUserData.value.email,
                            subTitleTextStyle: commonSecondaryTextStyle(),
                            trailing: IconWidget(
                              imgPath: Assets.iconsPencilSimpleLine,
                              size: 18,
                              color: iconColor,
                            ),
                            onTap: () {
                              Get.to(() => EditProfileScreen(), arguments: loginUserData.value);
                            },
                          );
                        }),
                        if(!isInReview) CurrentSubscriptionDetailsBannerComponent(),
                        Text(locale.value.accountControl, style: commonSecondaryTextStyle()),
                        SnapHelperWidget<bool>(
                          future: getBoolFromLocal(SharedPreferenceConst.IS_DEMO_USER),
                          onSuccess: (data) {
                            if (loginUserData.value.loginType.isEmpty || data)
                              return SettingItemWidget(
                                splashColor: appScreenBackgroundDark,
                                highlightColor: appScreenBackgroundDark,
                                hoverColor: appScreenBackgroundDark,
                                padding: EdgeInsets.zero,
                                leading: IconWidget(imgPath: Assets.iconsPassword),
                                titleTextStyle: commonPrimaryTextStyle(),
                                title: locale.value.changePassword,
                                subTitleTextStyle: commonSecondaryTextStyle(),
                                onTap: () {
                                  Get.to(() => ChangePasswordScreen());
                                },
                              );
                            return SizedBox.shrink();
                          },
                        ),
                        ExpansionTile(
                          controlAffinity: ListTileControlAffinity.trailing,
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          iconColor: iconColor,
                          collapsedIconColor: iconColor,
                          leading: IconWidget(imgPath: Assets.iconsShieldCheck),
                          title: Text(locale.value.parentalControl, style: commonPrimaryTextStyle()),
                          subtitle: Text(
                            locale.value.parentalControlsSubtitle,
                            style: commonSecondaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          showTrailingIcon: true,
                          tilePadding: EdgeInsets.zero,
                          childrenPadding: EdgeInsets.symmetric(vertical: 2),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SettingItemWidget(
                              splashColor: appScreenBackgroundDark,
                              highlightColor: appScreenBackgroundDark,
                              hoverColor: appScreenBackgroundDark,
                              leading: IconWidget(imgPath: Assets.iconsLock),
                              titleTextStyle: commonPrimaryTextStyle(),
                              title: locale.value.parentalLock,
                              subTitleTextStyle: commonSecondaryTextStyle(),
                              trailing: ToggleWidget(
                                onSwitch: (isEnable) {
                                  accountSettingController.handleParentalLock(isEnable);
                                },
                                isSwitched: appParentalLockEnabled.value,
                              ),
                            ),
                            if (appParentalLockEnabled.value) ...[
                              if (selectedAccountProfile.value.profilePin.isNotEmpty)
                                SettingItemWidget(
                                  splashColor: appScreenBackgroundDark,
                                  highlightColor: appScreenBackgroundDark,
                                  hoverColor: appScreenBackgroundDark,
                                  leading: IconWidget(imgPath: Assets.iconsKey),
                                  titleTextStyle: commonPrimaryTextStyle(),
                                  title: locale.value.changePIN,
                                  subTitleTextStyle: commonSecondaryTextStyle(),
                                  onTap: () {
                                    accountSettingController.handleChangePin();
                                  },
                                )
                              else if (selectedAccountProfile.value.profilePin.isEmpty)
                                SettingItemWidget(
                                  splashColor: appScreenBackgroundDark,
                                  highlightColor: appScreenBackgroundDark,
                                  hoverColor: appScreenBackgroundDark,
                                  leading: IconWidget(imgPath: Assets.iconsKey),
                                  titleTextStyle: commonPrimaryTextStyle(),
                                  title: locale.value.setPIN,
                                  subTitleTextStyle: commonSecondaryTextStyle(),
                                  onTap: () {
                                    Get.bottomSheet(
                                      AppDialogWidget(child: ParentalLockPinComponent()),
                                      isScrollControlled: true,
                                    );
                                  },
                                ),
                            ]
                          ],
                        )
                      ],
                    ),
                  if (!isInReview)
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locale.value.subscriptionAndRentals, style: commonSecondaryTextStyle()),
                        SettingItemWidget(
                          splashColor: appScreenBackgroundDark,
                          highlightColor: appScreenBackgroundDark,
                          hoverColor: appScreenBackgroundDark,
                          leading: IconWidget(imgPath: Assets.iconsReceipt),
                          subTitleTextStyle: commonSecondaryTextStyle(),
                          titleTextStyle: commonPrimaryTextStyle(),
                          title: locale.value.subscriptionHistory,
                          subTitle: locale.value.subscriptionHistorySubtitle,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          onTap: () {
                            Get.to(() => SubscriptionHistoryScreen());
                          },
                        ),
                        SettingItemWidget(
                          splashColor: appScreenBackgroundDark,
                          highlightColor: appScreenBackgroundDark,
                          hoverColor: appScreenBackgroundDark,
                          leading: IconWidget(imgPath: Assets.iconsReadCvLogo),
                          titleTextStyle: commonPrimaryTextStyle(),
                          title: locale.value.rentalHistory,
                          subTitle: locale.value.rentalHistorySubtitle,
                          subTitleTextStyle: commonSecondaryTextStyle(),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          onTap: () {
                            Get.to(() => RentalHistoryScreen());
                          },
                        ),
                      ],
                    ),
                  SettingItemWidget(
                    splashColor: appScreenBackgroundDark,
                    highlightColor: appScreenBackgroundDark,
                    hoverColor: appScreenBackgroundDark,
                    padding: EdgeInsets.zero,
                    leading: IconWidget(imgPath: Assets.iconsDevices),
                    titleTextStyle: commonPrimaryTextStyle(),
                    title: locale.value.deviceManagement,
                    subTitle: locale.value.controlYourDevices,
                    subTitleTextStyle: commonSecondaryTextStyle(),
                    trailing: Icon(Icons.arrow_forward_ios, color: iconColor, size: 18),
                    onTap: () {
                      Get.to(() => DeviceManagementScreen());
                    },
                  ),
                ],
              ),
            );
          },
        ),
        widgetsStackedOverBody: [
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Blur(
              child: Container(
                padding: EdgeInsets.all(16),
                alignment: AlignmentGeometry.center,
                decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(0)),
                child: TextButton(
                  onPressed: () {
                    Get.bottomSheet(
                      AppDialogWidget(
                        image: Assets.iconsTrash,
                        imageColor: appColorPrimary,
                        title: locale.value.deleteAccountPermanently,
                        subTitle: locale.value.youCanNotRevertThisActionLater,
                        onAccept: () {
                          accountSettingController.deleteAccountPermanently();
                        },
                        positiveText: locale.value.proceed,
                        negativeText: locale.value.cancel,
                      ),
                      isScrollControlled: true,
                    );
                  },
                  child: Text(locale.value.deleteAccount, style: boldTextStyle(color: appColorPrimary)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}