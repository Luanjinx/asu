import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/account_setting/account_setting_screen.dart';
import 'package:streamit_laravel/screens/account_setting/components/logout_account_component.dart';
import 'package:streamit_laravel/screens/continue_watching_list/continue_watching_list_screen.dart';
import 'package:streamit_laravel/screens/downloads/download_screen.dart';
import 'package:streamit_laravel/screens/qr_scanner/qr_scanner_screen.dart';
import 'package:streamit_laravel/screens/rented_content/rented_content_list_screen.dart';
import 'package:streamit_laravel/screens/setting/help_and_support/help_and_support_screen.dart';
import 'package:streamit_laravel/screens/setting/setting_screen.dart';
import 'package:streamit_laravel/screens/subscription/components/subscription_banner_component.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_screen.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/shimmer/shimmer.dart';

import '../../components/app_scaffold.dart';
import '../../utils/colors.dart';
import '../../utils/common_functions.dart';
import 'components/user_profile_component.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController profileCont = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: profileCont.scrollController,
      applyLeadingBackButton: false,
      appBarTitleText: locale.value.profile,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      statusBarColor: yellowColor,
      isLoading: profileCont.isLoading,
      onRefresh: () async {
        await profileCont.getProfileDetail(showLoader: true);
      },
      body: Obx(
        () => Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(isLoggedIn.value || !isInReview)
              Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedAccountProfile.value.isChildProfile.validate() == 0 && !isInReview) CurrentSubscriptionDetailsBannerComponent(),
                  if (isLoggedIn.value)
                    UserProfileComponent(
                      isLoading: profileCont.showShimmer,
                    )
                ],
              ),
            Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.accountAndActivation, style: commonSecondaryTextStyle()),
                if (isLoggedIn.value && selectedAccountProfile.value.isChildProfile.validate() == 0)
                  ExpansionTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    iconColor: iconColor,
                    collapsedIconColor: iconColor,
                    leading: IconWidget(imgPath: Assets.iconsUserCircleGear),
                    title: Text(locale.value.accountSettings, style: primaryTextStyle()),
                    subtitle: Text(
                      isInReview ? locale.value.accountSettings : locale.value.accountSectionSubtitle,
                      style: secondaryTextStyle(),
                    ),
                    showTrailingIcon: false,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.symmetric(vertical: 2),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    onExpansionChanged: (value) {
                      Get.to(() => AccountSettingScreen());
                    },
                  ),
                SettingItemWidget(
                  splashColor: appScreenBackgroundDark,
                  highlightColor: appScreenBackgroundDark,
                  hoverColor: appScreenBackgroundDark,
                  padding: EdgeInsets.zero,
                  leading: IconWidget(imgPath: Assets.iconsTelevisionSimple),
                  title: locale.value.activateTvWeb,
                  titleTextStyle: commonPrimaryTextStyle(),
                  subTitle: locale.value.activateTvWebSubtitle,
                  subTitleTextStyle: commonSecondaryTextStyle(),
                  onTap: () {
                    doIfLogin(
                      onLoggedIn: () {
                        Get.to(() => QrScannerScreen());
                      },
                    );
                  },
                ),
              ],
            ),
            if (isLoggedIn.value)
              Column(
                spacing: 16,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.value.savedVideos, style: commonSecondaryTextStyle()),
                  ExpansionTile(
                    backgroundColor: appScreenBackgroundDark,
                    controlAffinity: ListTileControlAffinity.trailing,
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    iconColor: iconColor,
                    collapsedIconColor: iconColor,
                    leading: IconWidget(imgPath: Assets.iconsSquaresFour),
                    title: Text(locale.value.myList, style: commonPrimaryTextStyle()),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        locale.value.pickUpWhereYouLeftOff,
                        style: secondaryTextStyle(),
                      ),
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
                        leading: IconWidget(imgPath: Assets.iconsListPlus),
                        titleTextStyle: commonPrimaryTextStyle(),
                        title: locale.value.watchlist,
                        subTitle: locale.value.myListSubtitle,
                        subTitleTextStyle: commonSecondaryTextStyle(),
                        onTap: () {
                          doIfLogin(
                            onLoggedIn: () {
                              Get.to(() => WatchListScreen());
                            },
                          );
                        },
                      ),
                      SettingItemWidget(
                        splashColor: appScreenBackgroundDark,
                        highlightColor: appScreenBackgroundDark,
                        hoverColor: appScreenBackgroundDark,
                        leading: IconWidget(imgPath: Assets.iconsPlayFill),
                        titleTextStyle: commonPrimaryTextStyle(),
                        title: locale.value.continueWatching,
                        subTitle: locale.value.continueWatchingSubtitle,
                        subTitleTextStyle: commonSecondaryTextStyle(),
                        onTap: () {
                          doIfLogin(
                            onLoggedIn: () {
                              Get.to(() => ContinueWatchingListScreen());
                            },
                          );
                        },
                      ),
                      if (!isInReview)
                        SettingItemWidget(
                          splashColor: appScreenBackgroundDark,
                          highlightColor: appScreenBackgroundDark,
                          hoverColor: appScreenBackgroundDark,
                          leading: IconWidget(imgPath: Assets.iconsFilmReel),
                          titleTextStyle: commonPrimaryTextStyle(),
                          title: locale.value.rentals,
                          subTitle: locale.value.rentalsSubtitle,
                          subTitleTextStyle: commonSecondaryTextStyle(),
                          onTap: () {
                            doIfLogin(
                              onLoggedIn: () {
                                Get.to(() => RentedContentListScreen());
                              },
                            );
                          },
                        ),
                      SettingItemWidget(
                        splashColor: appScreenBackgroundDark,
                        highlightColor: appScreenBackgroundDark,
                        hoverColor: appScreenBackgroundDark,
                        leading: IconWidget(imgPath: Assets.iconsDownload),
                        titleTextStyle: commonPrimaryTextStyle(),
                        title: locale.value.downloads,
                        subTitle: locale.value.downloadsSubtitle,
                        subTitleTextStyle: commonSecondaryTextStyle(),
                        onTap: () {
                          doIfLogin(
                            onLoggedIn: () async {
                              Get.to(() => DownloadScreen());
                            },
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.value.settingsAndSupport, style: commonSecondaryTextStyle()),
                SettingItemWidget(
                  splashColor: appScreenBackgroundDark,
                  highlightColor: appScreenBackgroundDark,
                  hoverColor: appScreenBackgroundDark,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  leading: IconWidget(imgPath: Assets.iconsGear),
                  title: locale.value.settings,
                  titleTextStyle: commonPrimaryTextStyle(),
                  subTitle: locale.value.settingsSubtitle,
                  onTap: () {
                    Get.to(() => SettingScreen());
                  },
                ),
                SettingItemWidget(
                  splashColor: appScreenBackgroundDark,
                  highlightColor: appScreenBackgroundDark,
                  hoverColor: appScreenBackgroundDark,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  leading: IconWidget(imgPath: Assets.iconsQuestion),
                  title: locale.value.helpAndSupport,
                  titleTextStyle: primaryTextStyle(),
                  subTitle: locale.value.helpSupportSubtitle,
                  onTap: () {
                    Get.to(() => HelpAndSupportScreen());
                  },
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: appColorPrimary.withValues(alpha: 1),
                      highlightColor: appColorSecondary,
                      enabled: true,
                      direction: ShimmerDirection.ltr,
                      period: const Duration(seconds: 2),
                      child: TextButton(
                        style: ButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            Text(
                              isLoggedIn.value ? locale.value.logout : locale.value.logIn,
                              style: boldTextStyle(color: appColorPrimary),
                            ),
                            Icon(isLoggedIn.value ? Icons.logout : Icons.login, color: appColorPrimary),
                          ],
                        ),
                        onPressed: () {
                          if (isLoggedIn.value) {
                            Get.bottomSheet(
                              isDismissible: true,
                              isScrollControlled: true,
                              enableDrag: false,
                              AppDialogWidget(
                                child: LogoutAccountComponent(
                                  device: currentDevice.value.deviceId,
                                  deviceName: currentDevice.value.deviceName,
                                  onLogout: (logoutAll) async {
                                    profileCont.logoutCurrentUser();
                                  },
                                ),
                              ),
                            );
                          } else {
                            doIfLogin(
                              onLoggedIn: () async {
                                await profileCont.getProfileDetail();
                              },
                            );
                          }
                        },
                      ),
                    ),
                    VersionInfoWidget(prefixText: '${locale.value.appVersionPrefix} ', textStyle: commonSecondaryTextStyle(size: 12)).center(),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}