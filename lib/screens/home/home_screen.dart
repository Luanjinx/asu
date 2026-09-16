import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/routes/app_routes.dart';
import 'package:streamit_laravel/screens/auth/other/notification_screen.dart';
import 'package:streamit_laravel/screens/home/shimmer_home.dart';
import 'package:streamit_laravel/screens/slider/banner_widget.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/addon_bridge/short_drama/short_drama_bridge.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../main.dart';
import 'components/category_list_component.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeController get homeScreenController => Get.find<HomeController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sliderCtrl = homeScreenController.sliderController;
      final bool showBanner = sliderCtrl.isLoading.value || sliderCtrl.listContent.isNotEmpty;

      final Widget? shortDramaToggle =
          ShortDramaBridge.buildToggle(homeScreenController);

      final shouldShowBanner = ShortDramaBridge.shouldShowBanner(
        homeScreenController,
        showBanner,
      );

      return Scaffold(
        backgroundColor: appScreenBackgroundDark,
        appBar: AppBar(
          backgroundColor: appScreenBackgroundDark,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight,
          title: Row(
            children: [
              Image.asset(
                APP_MINI_LOGO_URL,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Text(
                APP_NAME.toUpperCase(),
                style: TextStyle(
                  color: appColorPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                doIfLogin(
                  onLoggedIn: () {
                    if (selectedAccountProfile.value.isChildProfile
                            .validate() ==
                        1) {
                      toast(locale.value.kidsProfileCannotAccessSubscription);
                      return;
                    }
                    Get.to(() => SubscriptionScreen(launchDashboard: true));
                  },
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color(0xFFD4AF37), width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Obx(
                  () => Text(
                    currentSubscription.value.level > 0
                        ? locale.value.updrade.toUpperCase()
                        : locale.value.subscribe.toUpperCase(),
                    style: TextStyle(
                      color: const Color(0xFFD4AF37),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 4),
            if (isLoggedIn.value &&
                selectedAccountProfile.value.isChildProfile.validate() == 0)
              IconButton(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                constraints: const BoxConstraints(),
                onPressed: () {
                  doIfLogin(
                    onLoggedIn: () {
                      Get.to(() => NotificationScreen());
                    },
                  );
                },
                icon: Obx(() {
                  return Badge.count(
                    maxCount: 10,
                    isLabelVisible: appUnReadNotificationCount.value > 0,
                    textStyle: commonW500PrimaryTextStyle(size: 10),
                    padding: EdgeInsets.zero,
                    backgroundColor: appColorPrimary,
                    count: appUnReadNotificationCount.value > 0
                        ? appUnReadNotificationCount.value
                        : 0,
                    child: IconWidget(
                      imgPath: Assets.iconsBell,
                      size: 22,
                      color: Colors.white,
                    ),
                  );
                }),
              ),
            SizedBox(width: 14)
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            if (ShortDramaBridge.isShortDramaSelected(homeScreenController)) {
              await ShortDramaBridge.refreshHome(homeScreenController);
            } else {
              await homeScreenController.init(isOtherDetailLoad: true);
            }
          },
          color: appColorPrimary,
          backgroundColor: appScreenBackgroundDark,
          strokeWidth: 3.0,
          displacement: 40.0,
          child: SingleChildScrollView(
            controller: homeScreenController.scrollController,
            child: Column(
              children: [
                if (shortDramaToggle != null)
                  Container(
                    width: double.infinity,
                    color: appScreenBackgroundDark,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: shortDramaToggle,
                  ),
                if (shouldShowBanner)
                  BannerWidget(
                    sliderController: sliderCtrl,
                    tag: AppRoutes.home,
                  ),
                ShortDramaBridge.buildContent(
                  homeScreenController,
                  Obx(
                    () => AnimatedWrap(
                      listAnimationType: commonListAnimationType,
                      children: [
                        SnapHelperWidget(
                          future:
                              homeScreenController.dashboardDetailsFuture.value,
                          initialData: cachedDashboardDetailResponse,
                          loadingWidget: const ShimmerHome(),
                          errorBuilder: (error) {
                            return const SizedBox.shrink();
                          },
                          onSuccess: (res) {
                            return CategoryListComponent(
                              categoryList: homeScreenController
                                  .dashboardOtherDetailsSectionList,
                              onRemoveAd: (mainIndex, listIndex) {
                                homeScreenController.removeAdFromSection(
                                    mainIndex, listIndex);
                              },
                            );
                          },
                        ),
                        Obx(
                          () => ShimmerHome().visible(
                              homeScreenController.showCategoryShimmer.value),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 120)
              ],
            ),
          ),
        ),
      );
    });
  }
}
