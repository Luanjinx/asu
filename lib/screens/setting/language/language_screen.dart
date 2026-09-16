import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/setting/help_and_support/help_and_support_controller.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../components/app_scaffold.dart';
import '../../../locale/app_localizations.dart';
import '../../../locale/languages.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';

class LanguageScreen extends StatelessWidget {
  final HelpAndSupportController settingController;

  const LanguageScreen({super.key, required this.settingController});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.language,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 30, top: 16),
        itemBuilder: (_, index) {
          final LanguageDataModel data = localeLanguageList[index];

          return SettingItemWidget(
            splashColor: appScreenBackgroundDark,
            highlightColor: appScreenBackgroundDark,
            hoverColor: appScreenBackgroundDark,
            title: data.name.validate(),
            subTitle: data.subTitle,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            titleTextStyle: commonPrimaryTextStyle(),
            leading: IconWidget(imgPath: data.flag.validate()),
            trailing: Obx(
              () => Container(
                padding: const EdgeInsets.all(2),
                decoration: boxDecorationDefault(shape: BoxShape.circle),
                child: IconWidget(imgPath: Assets.iconsCheck, size: 15, color: appScreenBackgroundDark),
              ).visible(selectedLanguageCode.value == data.languageCode.validate()),
            ),
            borderRadius: 8,
            onTap: () async {
              selectedLanguageDataModel = data;
              BaseLanguage temp = await const AppLocalizations().load(Locale(data.languageCode.validate()));
              locale = temp.obs;
              setStringToLocal(SELECTED_LANGUAGE_CODE, data.languageCode.validate());
              isRTL(Constants.rtlLanguage.contains(data.languageCode));
              selectedLanguageCode(data.languageCode.validate());
              Get.updateLocale(Locale(data.languageCode.validate()));
              final DashboardController dashboardController = Get.find();
              dashboardController.addDataOnBottomNav();
              dashboardController.currentIndex(0);
            },
          );
        },
        shrinkWrap: true,
        itemCount: localeLanguageList.length,
      ),
    );
  }
}