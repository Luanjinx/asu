import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../components/app_scaffold.dart';
import '../../../generated/assets.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final DashboardController dashboardController = Get.find();
          dashboardController.addDataOnBottomNav();
          dashboardController.currentIndex(0);
          Get.offAll(() => DashboardScreen());
        }
      },
      child: AppScaffold(
        appBarTitleText: locale.value.subscriptionSuccessful,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        leadingWidget: backButton(onBackPressed: () => Get.offAll(DashboardScreen())),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
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
                locale.value.subscriptionSuccessfulSubtitle,
                textAlign: TextAlign.center,
                style: primaryTextStyle(),
              ),
              16.height,
              Text(
                locale.value.startEnjoyingContent,
                textAlign: TextAlign.center,
                style: secondaryTextStyle(color: secondaryTextColor),
              ),
              48.height,
              AppButton(
                width: Get.width - 32,
                text: locale.value.done,
                color: appColorPrimary,
                textStyle: appButtonTextStyleWhite,
                disabledColor: btnColor,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                onTap: () {
                  final DashboardController dashboardController = Get.find();
                  dashboardController.addDataOnBottomNav();
                  dashboardController.currentIndex(0);
                  Get.offAll(() => DashboardScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}