import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';

class RemoveContinueWatchingComponent extends StatelessWidget {
  final VoidCallback onRemoveTap;
  final String title;

  const RemoveContinueWatchingComponent({
    super.key,
    required this.onRemoveTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CachedImageWidget(
          url: Assets.iconsTrash,
          height: 72,
          width: 100,
          color: appColorPrimary,
        ),
        30.height,
        Text(
          title,
          style: commonPrimaryTextStyle(),
          textAlign: TextAlign.center,
        ),
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppButton(
              width: double.infinity,
              text: locale.value.no.capitalizeFirstLetter(),
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
              text: locale.value.yes.capitalizeFirstLetter(),
              color: appColorPrimary,
              disabledColor: btnColor,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
              onTap: onRemoveTap,
            ).expand(),
          ],
        ),
      ],
    );
  }
}