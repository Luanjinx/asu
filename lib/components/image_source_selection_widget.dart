import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../main.dart';

class ImageSourceSelectionComponent extends StatelessWidget {
  final VoidCallback onGalleySelected;
  final VoidCallback onCameraSelected;

  const ImageSourceSelectionComponent({super.key, required this.onCameraSelected, required this.onGalleySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        16.height,
        Text(locale.value.chooseImageSource, style: commonPrimaryTextStyle(size: 22)),
        8.height,
        SettingItemWidget(
          splashColor: appScreenBackgroundDark,
          highlightColor: appScreenBackgroundDark,
          hoverColor: appScreenBackgroundDark,
          title: locale.value.gallery,
          leading: IconWidget(imgPath: Assets.iconsImages, color: primaryIconColor),
          titleTextColor: primaryTextColor,
          onTap: onGalleySelected,
        ),
        SettingItemWidget(
          title: locale.value.camera,
          leading: IconWidget(imgPath: Assets.iconsCamera, color: primaryIconColor),
          titleTextColor: white,
          onTap: onCameraSelected,
          splashColor: appScreenBackgroundDark,
          highlightColor: appScreenBackgroundDark,
          hoverColor: appScreenBackgroundDark,
        ),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16);
  }
}