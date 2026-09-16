import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../sign_in_controller.dart';

class SocialAuthComponent extends StatelessWidget {
  SocialAuthComponent({super.key});

  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 16,
      children: [
        if (appConfigs.value.isGoogleLoginEnabled)
          SocialIconWidget(
            icon: Assets.socialMediaGoogle,
            buttonWidth: Get.width,
            text: locale.value.signInWithGoogle,
            onTap: () {
              signInController.googleSignIn();
            },
          ),
        if (Platform.isIOS && appConfigs.value.isAppleSocialLoginEnabled)
          SocialIconWidget(
            buttonWidth: Get.width,
            icon: Assets.socialMediaApple,
            text: locale.value.signInWithApple,
            onTap: () {
              signInController.appleSignIn();
            },
          ),
      ],
    );
  }
}

class SocialIconWidget extends StatelessWidget {
  final String icon;
  final Function()? onTap;

  final Color? iconColor;
  final Size? iconSize;
  final double? buttonWidth;
  final String? text;

  const SocialIconWidget({super.key, required this.icon, this.onTap, this.text, this.iconColor, this.iconSize, this.buttonWidth});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: onTap,
      splashColor: appColorPrimary.withValues(alpha: 0.3),
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(4),
        side: BorderSide(color: borderColor),
      ),
      elevation: 1,
      padding: EdgeInsets.zero,
      color: cardColor,
      height: 50,
      width: 50,
      child: CachedImageWidget(
        url: icon,
        color: iconColor,
        height: iconSize?.height ?? 18,
        width: iconSize?.width ?? 18,
      ),
    );
  }
}