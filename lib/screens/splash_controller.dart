import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';
import 'package:streamit_laravel/screens/walk_through/model/walkthrough_model.dart';
import 'package:streamit_laravel/screens/walk_through/walk_through_screen.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/addon_bridge/short_drama/short_drama_bridge.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../utils/constants.dart';
import 'dashboard/dashboard_screen.dart';

class SplashScreenController extends BaseListController<WalkthroughModel> {
  RxBool appNotSynced = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onReady() {
    try {
      Get.changeThemeMode(ThemeMode.dark);
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }
    super.onReady();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    await CoreServiceApis.getOnboardingData().then(
      (value) {
        if (value.isNotEmpty) {
          listContent(value);
        } else {
          getDefaultWalkthroughPageList();
        }
      },
    ).catchError((e) {
      getDefaultWalkthroughPageList();
    });
  }

  void getDefaultWalkthroughPageList() {
    listContent.clear();
    listContent.add(WalkthroughModel(title: locale.value.walkthroughTitle1, image: Assets.walkthroughImagesWalkImage1, description: locale.value.walkthroughDesp1));
    listContent.add(WalkthroughModel(title: locale.value.walkthroughTitle2, image: Assets.walkthroughImagesWalkImage2, description: locale.value.walkthroughDesp2));
    listContent.add(WalkthroughModel(title: locale.value.walkthroughTitle3, image: Assets.walkthroughImagesWalkImage3, description: locale.value.walkthroughDesp3));
  }

  Future<void> init({bool isRedirect = true}) async {
    if (await getBoolFromLocal(SharedPreferenceConst.IS_FIRST_TIME, defaultValue: true)) {
      await getListData();
    }

    await Future.wait(
      [
        getCacheData(),
        getDeviceInfo(),
        getAppConfigurations().then(
          (value) async {
            await Future.delayed(
              Duration(seconds: 2),
              () async {
                if (ShortDramaBridge.deepLinkHandledThisLaunch) return;

                if ((await getBoolFromLocal(SharedPreferenceConst.IS_FIRST_TIME, defaultValue: true)) && isRedirect) {
                  Get.off(() => WalkThroughScreen(walkthroughPageList: listContent));
                  await setBoolToLocal(SharedPreferenceConst.IS_FIRST_TIME, false);
                } else if ((await getBoolFromLocal(SharedPreferenceConst.IS_LOGGED_IN, defaultValue: false) || isLoggedIn.value) && isRedirect) {
                  Get.off(() => WatchingProfileScreen(), arguments: true);
                } else {
                  if(isRedirect) {
                    Get.offAll(() => DashboardScreen(), duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                  }
                }
              },
            );
          },
        ).catchError((e) async {
          appNotSynced(!await getBoolFromLocal(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE));
        }),
      ],
    ).catchError((e) {
      throw e;
    });

    try {
      if(kReleaseMode) {
        if(isScreenShotAllowed) {
          await removeSecureScreen();
        } else {
          await secureScreen();
        }
      } else {
        await removeSecureScreen();
      }
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }
  }

  void handleDeepLinking({required String deepLink}) {
    if (deepLink.contains('short-drama')) {
      ShortDramaBridge.handleDeepLink(deepLink);
      return;
    }

    if (deepLink.split("/")[2] == "${VideoType.movie}-details" || deepLink.split("/")[2] == "${VideoType.episode}-details" || deepLink.split("/")[2] == "${VideoType.tvshow}-details" || deepLink.split("/")[2] == "${VideoType.video}-details") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => ContentDetailsScreen(), arguments: PosterDataModel(id: int.parse(deepLink.split("/").last), details: ContentData(type: deepLink.split("/")[2].replaceAll("-details", ""))));
      });
    }
  }
}