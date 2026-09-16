import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/subscription/components/cancel_button.dart';
import 'package:streamit_laravel/screens/subscription/components/subscribe_card.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class CurrentSubscriptionDetailsBannerComponent extends StatelessWidget {
  const CurrentSubscriptionDetailsBannerComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
      child: Row(
        children: [
          const CachedImageWidget(
            url: Assets.iconsCrown,
            height: 25,
            width: 32,
            color: yellowColor,
          ),
          16.width,
          Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Marquee(
                    child: Text(
                      currentSubscription.value.level > -1 ? currentSubscription.value.name.validate() : locale.value.subscribeToEnjoyMore,
                      style: boldTextStyle(size: 14),
                    ),
                  ),
                  2.height,
                  Marquee(
                    child: Text(
                      currentSubscription.value.level > -1
                          ? currentSubscription.value.endDate.isNotEmpty
                              ? "${locale.value.expiringOn} ${currentSubscription.value.endDate}"
                              : ""
                          : locale.value.daysFreeTrail,
                      style: secondaryTextStyle(
                        weight: FontWeight.w500,
                        color: darkGrayTextColor,
                      ),
                    ),
                  ),
                ],
              );
            },
          ).expand(),
          16.width,
          Obx(() {
            return SubscribeCard(showUpgrade: currentSubscription.value.level > 0);
          }),
          Obx(() {
            if (currentSubscription.value.status == 'active') {
              return Row(
                children: [
                  12.width,
                  CancelButton(),
                ],
              );
            }
            return SizedBox.shrink();
          })
        ],
      ),
    );
  }
}