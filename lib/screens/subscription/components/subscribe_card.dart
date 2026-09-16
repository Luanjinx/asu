import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/shimmer/shimmer.dart';

class SubscribeCard extends StatelessWidget {
  final bool showUpgrade;

  const SubscribeCard({super.key, required this.showUpgrade});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return InkWell(
      onTap: () {
        if (isLandscape) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
        doIfLogin(
          onLoggedIn: () {
            if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
              toast(locale.value.kidsProfileCannotAccessSubscription);
              return;
            }
            Get.to(() => SubscriptionScreen(launchDashboard: true));
          },
        );
      },
      child: Shimmer.fromColors(
        baseColor: goldColor.withValues(alpha: 1),
        highlightColor: goldAnimatedColor,
        enabled: true,
        direction: ShimmerDirection.ltr,
        period: const Duration(seconds: 2),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: boxDecorationDefault(
            color: goldColor.withValues(alpha: 0.00),
            border: Border.all(color: goldColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Obx(
            () => Text(
              showUpgrade ? locale.value.updrade.toUpperCase() : locale.value.subscribe.toUpperCase(),
              style: boldTextStyle(size: 10, color: goldColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}