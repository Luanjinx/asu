import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/main.dart' show isNotificationRead;
import 'package:streamit_laravel/screens/coming_soon/coming_soon_screen.dart';
import 'package:streamit_laravel/screens/dashboard/components/menu.dart';
import 'package:streamit_laravel/screens/home/home_screen.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_screen.dart';
import 'package:streamit_laravel/screens/profile/profile_screen.dart';
import 'package:streamit_laravel/screens/search/search_screen.dart';
import 'package:streamit_laravel/services/notification_service.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../utils/colors.dart';
import '../../utils/common_functions.dart';
import 'dashboard_controller.dart';
import 'floting_action_bar/floating_action_button.dart';
import 'floting_action_bar/floating_action_controller.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController get dashboardController => Get.find<DashboardController>();

  FloatingController get floatingController => Get.find<FloatingController>();

  Widget getCurrentScreen(index) {
    if (dashboardController.bottomNavItems[index].type == BottomItem.home.name) return HomeScreen();
    if (dashboardController.bottomNavItems[index].type == BottomItem.search.name) return SearchScreen();
    if (dashboardController.bottomNavItems[index].type == BottomItem.comingsoon.name) return ComingSoonScreen();
    if (dashboardController.bottomNavItems[index].type == BottomItem.livetv.name) return LiveTvScreen();
    if (dashboardController.bottomNavItems[index].type == BottomItem.profile.name)
      return ProfileScreen();
    else
      return SizedBox();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if(isNotificationRead) return;
    isNotificationRead = true;
    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      final data = parseAdditionalData(notification.data);
      onNotificationTap(data);
      return;
    }
    final localNotification = await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
    if(localNotification == null) return;
    if(!localNotification.didNotificationLaunchApp) return;
    if(localNotification.notificationResponse == null) return;
    if(localNotification.notificationResponse!.payload == null) return;
    final data = parseAdditionalData(jsonDecode(localNotification.notificationResponse?.payload ?? '{}'));
    onNotificationTap(data);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Always prevent default pop
      onPopInvokedWithResult: (didPop, result) async {
        if (dashboardController.currentBackPressTime == null || DateTime.now().difference(dashboardController.currentBackPressTime!) > const Duration(seconds: 2)) {
          // First back press → record time
          dashboardController.currentBackPressTime = DateTime.now();
        } else {
          await SystemNavigator.pop(); // closes the app
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: appScreenBackgroundDark,
        extendBodyBehindAppBar: true,
        floatingActionButton: Obx(() {
          if (dashboardController.currentIndex.value == 0) {
            if (!appConfigs.value.enableTvShow && !appConfigs.value.enableMovie && !appConfigs.value.enableVideo) {
              return const Offstage();
            } else {
              return FloatingButton().paddingBottom(16);
            }
          } else {
            return const Offstage();
          }
        }),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Obx(
          () => IgnorePointer(
            ignoring: floatingController.isExpanded.value,
            child: getCurrentScreen(dashboardController.currentIndex.value),
          ),
        ),
        bottomNavigationBar: Blur(
          blur: 20,
          borderRadius: radius(0),
          child: Obx(
            () => NavigationBar(
              height: 65,
              labelPadding: EdgeInsets.zero,
              surfaceTintColor: appScreenBackgroundDark,
              selectedIndex: dashboardController.currentIndex.value,
              backgroundColor: appScreenBackgroundDark.withValues(alpha: 0.7),
              indicatorColor: Colors.transparent,
              animationDuration: GetNumUtils(1000).milliseconds,
              labelTextStyle: WidgetStatePropertyAll(commonW600PrimaryTextStyle(size: 14, color: secondaryTextColor)),
              onDestinationSelected: (index) async {
                dashboardController.currentIndex(index);
                hideKeyboard(context);
                floatingController.isExpanded(false);
              },
              destinations: List.generate(
                dashboardController.bottomNavItems.length,
                (index) {
                  final navBar = dashboardController.bottomNavItems[index];
                  final isSelected = index == dashboardController.currentIndex.value;

                  final isProfileScreenSelected = index == dashboardController.currentIndex.value && navBar.type == BottomItem.profile.name && selectedAccountProfile.value.avatar.isNotEmpty;
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      hideKeyboard(context);
                      floatingController.isExpanded(false);
                      dashboardController.currentIndex(index);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isSelected
                            ? isProfileScreenSelected
                                ? Hero(
                                    tag: '${selectedAccountProfile.value.id}',
                                    child: CachedImageWidget(
                                      url: selectedAccountProfile.value.avatar,
                                      fit: BoxFit.cover,
                                      width: 18,
                                      height: 18,
                                      radius: 2,
                                      firstName: selectedAccountProfile.value.name,
                                    ),
                                  )
                                : IconWidget(
                                    imgPath: navBar.selectedIcon,
                                    size: 18,
                                    color: appColorPrimary,
                                  )
                            : IconWidget(
                                imgPath: navBar.icon,
                                color: iconColor,
                                size: 16,
                              ),
                        4.height,
                        Text(
                          navBar.title(),
                          style: commonW600PrimaryTextStyle(size: 14, color: secondaryTextColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}