import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';

import '../utils/colors.dart';
import '../utils/common_base.dart';
import 'cached_image_widget.dart';

class AppDialogWidget extends StatelessWidget {
  final String title;

  final String subTitle;

  final String image;

  final String positiveText;

  final String negativeText;

  final VoidCallback? onAccept;

  final VoidCallback? onCancel;

  final Widget? child;

  final Color? imageColor;

  const AppDialogWidget({
    super.key,
    this.image = '',
    this.title = '',
    this.child,
    this.subTitle = '',
    this.onAccept,
    this.onCancel,
    this.positiveText = '',
    this.negativeText = '',
    this.imageColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: boxDecorationDefault(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            border: Border(top: BorderSide(color: borderColor.withValues(alpha: 0.8))),
            color: appScreenBackgroundDark,
          ),
          child: child ??
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image.isNotEmpty) ...[
                    CachedImageWidget(
                      url: image,
                      height: Get.height * 0.06,
                      fit: BoxFit.cover,
                      color: imageColor,
                    ),
                    24.height,
                  ],
                  Text(
                    title,
                    style: boldTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  12.height,
                  Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: commonSecondaryTextStyle(),
                  ),
                  24.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppButton(
                        width: Get.width / 2,
                        text: negativeText.isNotEmpty ? negativeText : locale.value.cancel,
                        color: lightBtnColor,
                        textStyle: appButtonTextStyleWhite,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                        onTap: onCancel ??
                            () {
                              Get.back();
                            },
                      ).expand(),
                      16.width,
                      AppButton(
                        width: Get.width / 2,
                        text: positiveText.isNotEmpty ? positiveText : locale.value.confirm,
                        color: appColorPrimary,
                        textStyle: appButtonTextStyleWhite,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                        onTap: () {
                          Get.back();
                          onAccept?.call();
                        },
                      ).expand(),
                    ],
                  ),
                ],
              ),
        ),
      ),
    );
  }
}