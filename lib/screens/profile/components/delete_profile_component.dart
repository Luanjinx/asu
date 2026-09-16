import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';

class DeleteProfileComponent extends StatelessWidget {
  final String profileName;
  final VoidCallback onDeleteAccount;

  const DeleteProfileComponent({super.key, required this.onDeleteAccount, required this.profileName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CachedImageWidget(
          url: Assets.iconsTrash,
          height: 73,
          width: 100,
          color: appColorPrimary,
        ),
        40.height,
        Text(
          locale.value.doYouWantToDeleteProfile(profileName),
          style: commonW600PrimaryTextStyle(),
        ),
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppButton(
              width: double.infinity,
              text: locale.value.cancel,
              color: lightBtnColor,
              disabledColor: btnColor,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
              onTap: () {
                Get.back();
              },
            ).expand(),
            16.width,
            AppButton(
              width: double.infinity,
              text: locale.value.proceed,
              disabledColor: btnColor,
              color: appColorPrimary,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
              onTap: onDeleteAccount,
            ).expand(),
          ],
        ),
      ],
    );
  }
}