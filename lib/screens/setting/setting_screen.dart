import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/app_toggle_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/locale/app_localizations.dart';
import 'package:streamit_laravel/locale/languages.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/setting/setting_controller.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({Key? key}) : super(key: key);

  final SettingController settingController = Get.find<SettingController>();

  Future<void> _onLanguageSelected(LanguageDataModel data) async {
    selectedLanguageDataModel = data;
    BaseLanguage temp = await const AppLocalizations().load(Locale(data.languageCode.validate()));
    locale = temp.obs;
    await setStringToLocal(SELECTED_LANGUAGE_CODE, data.languageCode.validate());
    isRTL(Constants.rtlLanguage.contains(data.languageCode));
    selectedLanguageCode(data.languageCode.validate());
    Get.updateLocale(Locale(data.languageCode.validate()));

    final DashboardController dashboardController = Get.find();
    dashboardController.addDataOnBottomNav();
    dashboardController.currentIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      scrollController: settingController.scrollController,
      appBarTitleText: locale.value.settings,
      isPinnedAppbar: true,
      body: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        listAnimationType: commonListAnimationType,
        children: [
          SettingItemWidget(
            splashColor: appScreenBackgroundDark,
            highlightColor: appScreenBackgroundDark,
            hoverColor: appScreenBackgroundDark,
            title: locale.value.appLanguage,
            padding: EdgeInsets.symmetric(vertical: 8),
            titleTextStyle: primaryTextStyle(),
            leading: IconWidget(imgPath: Assets.iconsTranslate, color: primaryTextColor),
            decoration: boxDecorationDefault(color: appScreenBackgroundDark),
            trailing: Obx(
              () {
                final String? selectedCode = selectedLanguageCode.value.isNotEmpty ? selectedLanguageCode.value : (localeLanguageList.isNotEmpty ? localeLanguageList.first.languageCode : null);

                final List<LanguageDataModel> sortedList = List<LanguageDataModel>.from(localeLanguageList)..sort((a, b) => a.name.validate().toLowerCase().compareTo(b.name.validate().toLowerCase()));

                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCode,
                    dropdownColor: cardColor,
                    borderRadius: BorderRadius.circular(8),
                    iconEnabledColor: iconColor,
                    style: primaryTextStyle(),
                    items: sortedList.map((LanguageDataModel data) {
                      return DropdownMenuItem<String>(
                        value: data.languageCode.validate(),
                        child: Row(
                          children: [
                            CachedImageWidget(
                              url: data.flag.validate(),
                              radius: 4,
                              height: 20,
                              width: 20,
                            ),
                            8.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(data.name.validate(), style: primaryTextStyle()),
                                if (data.subTitle.validate().isNotEmpty)
                                  Text(
                                    data.subTitle.validate(),
                                    style: secondaryTextStyle(size: 10),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) async {
                      if (value == null || value == selectedCode) return;
                      final LanguageDataModel? data = sortedList.firstWhereOrNull(
                        (element) => element.languageCode == value,
                      );
                      if (data != null) {
                        await _onLanguageSelected(data);
                      }
                    },
                  ),
                );
              },
            ),
          ),
          SettingItemWidget(
            splashColor: appScreenBackgroundDark,
            highlightColor: appScreenBackgroundDark,
            hoverColor: appScreenBackgroundDark,
            title: locale.value.downloadOverWifiOnly,
            padding: EdgeInsets.symmetric(vertical: 8),
            titleTextStyle: commonPrimaryTextStyle(),
            leading: IconWidget(imgPath: Assets.iconsWifiHigh, color: primaryTextColor),
            decoration: boxDecorationDefault(color: appScreenBackgroundDark),
            trailing: Obx(
              () => ToggleWidget(
                isSwitched: appDownloadOnWifi.value,
                onSwitch: (bool val) {
                  appDownloadOnWifi(val);
                  setBoolToLocal(SettingsLocalConst.IS_DOWNLOAD_WIFI_ENABLED, val);
                },
              ),
            ),
          ),
          SettingItemWidget(
            title: locale.value.autoUpdate,
            //todo:
            splashColor: appScreenBackgroundDark,
            highlightColor: appScreenBackgroundDark,
            hoverColor: appScreenBackgroundDark,
            padding: EdgeInsets.symmetric(vertical: 8),
            titleTextStyle: primaryTextStyle(),
            leading: IconWidget(imgPath: Assets.iconsArrowsClockwise, color: primaryTextColor),
            decoration: boxDecorationDefault(color: appScreenBackgroundDark),
            trailing: Obx(
              () => ToggleWidget(
                isSwitched: appUpdateNotify.value,
                onSwitch: (bool val) {
                  appUpdateNotify(val);
                  setBoolToLocal(SettingsLocalConst.IS_NOTIFY_UPDATE_ENABLED, val);
                },
              ),
            ),
          ),
          SettingItemWidget(
            splashColor: appScreenBackgroundDark,
            highlightColor: appScreenBackgroundDark,
            hoverColor: appScreenBackgroundDark,
            title: locale.value.smartDelete,
            subTitle: locale.value.smartDeleteSubtitle,
            padding: EdgeInsets.symmetric(vertical: 8),
            titleTextStyle: commonPrimaryTextStyle(),
            leading: IconWidget(imgPath: Assets.iconsTrash, color: primaryTextColor),
            decoration: boxDecorationDefault(color: appScreenBackgroundDark),
            trailing: Obx(
              () => ToggleWidget(
                isSwitched: appSmartDownloadDeleteOn.value,
                onSwitch: (bool val) {
                  appSmartDownloadDeleteOn(val);
                  setBoolToLocal(SettingsLocalConst.IS_SMART_DELETE_DOWNLOAD_ENABLED, val);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}