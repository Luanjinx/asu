import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';
import '../../../../utils/common_base.dart';

class LogoutAccountComponent extends StatelessWidget {
  final String device;
  final String deviceName;
  final bool logOutAll;
  final bool isCancelButtonShow;
  final String? title;

  final VoidCallback? onCancel;

  final Function(bool logoutAll) onLogout;

  const LogoutAccountComponent({
    super.key,
    required this.device,
    required this.deviceName,
    this.logOutAll = false,
    required this.onLogout,
    this.isCancelButtonShow = true,
    this.onCancel,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        20.height,
        const CachedImageWidget(
          url: Assets.iconsPower,
          height: 50,
          width: 50,
          color: appColorPrimary,
        ),
        16.height,
        Text(
          title ?? (logOutAll ? locale.value.logoutAllConfirmation : "${locale.value.doYouWantToLogoutFrom}$deviceName ${locale.value.device.toLowerCase()}?"),
          style: boldTextStyle(),
          textAlign: TextAlign.center,
        ),
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCancelButtonShow) ...[
              AppButton(
                width: double.infinity,
                text: locale.value.cancel,
                color: lightBtnColor,
                disabledColor: btnColor,
                textStyle: appButtonTextStyleWhite,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                onTap: () {
                  Get.back();
                  onCancel?.call();
                },
              ).expand(),
              16.width,
            ],
            AppButton(
              width: double.infinity,
              text: locale.value.proceed,
              color: appColorPrimary,
              disabledColor: btnColor,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
              onTap: () {
                Get.back(result: true);
                Future.delayed(const Duration(milliseconds: 100), () {
                  onLogout.call(logOutAll);
                });
              },
            ).expand(),
          ],
        ),
      ],
    );
  }
}