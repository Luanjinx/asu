import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class SuccessDialogueComponent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? imageWidget;
  final Widget? image;
  final String buttonText;
  final VoidCallback? onButtonClick;

  SuccessDialogueComponent({
    required this.title,
    this.subtitle = '',
    this.imageWidget,
    this.image,
    required this.buttonText,
    this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: appScreenBackgroundDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          borderRadius: radius(8),
          image: DecorationImage(
            image: AssetImage(Assets.imagesIcSuccessfulBg),
            fit: BoxFit.cover,
          ),
          gradient: LinearGradient(
            colors: List.generate(
              8,
              (i) => (appColorSecondary).withValues(
                alpha: [0.16, 0.14, 0.12, 0.10, 0.08, 0.04, 0.02, 0.01][i],
              ),
            ),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageWidget ??
                Lottie.asset(
                  Assets.lottieSucess,
                  repeat: false,
                  height: 150,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(['**'], value: appColorPrimary),
                    ],
                  ),
                ),
            Text(
              title,
              style: boldTextStyle(),
              textAlign: TextAlign.center,
            ),
            16.height,
            Text(
              subtitle,
              style: secondaryTextStyle(),
              textAlign: TextAlign.center,
            ),
            20.height,
            AppButton(
              width: Get.width / 2 - 24,
              color: appColorPrimary,
              onTap: () {
                if (onButtonClick != null)
                  onButtonClick?.call();
                else
                  Get.back(result: true);
              },
              child: Text(
                buttonText,
                style: appButtonTextStyleWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
