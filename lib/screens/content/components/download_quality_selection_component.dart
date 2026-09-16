import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/subscription/components/subscribe_card.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class DownloadQualitySelectionComponent extends StatelessWidget {
  final bool hasContentAccess;
  final List<DownloadQualities> availableDownloadQualities;
  final Function(DownloadQualities selectedQuality) onQualitySelected;
  final Rx<DownloadQualities> selectedQuality = DownloadQualities().obs;

  DownloadQualitySelectionComponent({
    required this.onQualitySelected,
    required this.availableDownloadQualities,
    required this.hasContentAccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Text(
          locale.value.selectDownloadQuality,
          style: commonW500PrimaryTextStyle(size: 20),
        ),
        8.height,
        Text(
          locale.value.chooseTheQualityForDownloadingThisContent,
          style: commonSecondaryTextStyle(),
        ),
        20.height,
        ...availableDownloadQualities.map(
          (quality) {
            final bool isSupported = checkDownloadQualitySupported(quality.quality, hasContentAccess);

            return SettingItemWidget(
              splashColor: appScreenBackgroundDark,
              highlightColor: appScreenBackgroundDark,
              hoverColor: appScreenBackgroundDark,
              subTitleTextStyle: commonSecondaryTextStyle(),
              title: quality.quality == QualityConstants.defaultQualityKey ? locale.value.defaultLabel : quality.quality,
              padding: const EdgeInsets.symmetric(vertical: 12),
              titleTextStyle: commonPrimaryTextStyle(
                color: isSupported ? primaryTextColor : darkGrayTextColor,
              ),
              leading: CachedImageWidget(
                url: quality.quality.getQualityIcon(),
                radius: 4,
                height: 20,
                width: 20,
                color: isSupported ? white : darkGrayTextColor,
              ),
              trailing: isSupported
                  ? Obx(
                      () => IconWidget(imgPath: Assets.iconsCheck, size: 20, color: appColorPrimary).visible(selectedQuality.value.quality == quality.quality),
                    )
                  : SubscribeCard(showUpgrade: isSupported),
              borderRadius: 8,
              onTap: () {
                if (isSupported) {
                  selectedQuality(quality);
                } else {
                  Get.back();
                  if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
                    toast(locale.value.kidsProfileCannotAccessSubscription);
                    return;
                  }
                  Get.to(() => SubscriptionScreen(launchDashboard: false));
                }
              },
            );
          },
        ).toList(),
        20.height,
        Obx(
          () => AppButton(
            width: double.infinity,
            text: locale.value.download,
            color: checkDownloadQualitySupported(selectedQuality.value.quality, hasContentAccess) ? appColorPrimary : cardColor,
            disabledColor: btnColor,
            textStyle: appButtonTextStyleWhite,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: radius(defaultAppButtonRadius / 2),
            ),
            onTap: checkDownloadQualitySupported(selectedQuality.value.quality, hasContentAccess)
                ? () async {
                    Get.back();
                    onQualitySelected(selectedQuality.value);
                  }
                : null,
          ),
        ),
        10.height,
      ],
    );
  }
}