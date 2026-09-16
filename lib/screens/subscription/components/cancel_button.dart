import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          AppDialogWidget(
            title: locale.value.cancelSubscription,
            onAccept: () {
              Get.find<ProfileController>().cancelSubscription();
            },
            image: Assets.iconsCrown,
            imageColor: appColorPrimary,
            positiveText: locale.value.confirm,
            negativeText: locale.value.cancel,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: boxDecorationDefault(
          color: appColorPrimary,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Obx(
          () => Text(
            locale.value.cancel.toUpperCase(),
            style: boldTextStyle(size: 10, color: whiteColor),
          ),
        ),
      ),
    );
  }
}