import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_logo_widget.dart';
import 'package:streamit_laravel/components/no_internet_widget.dart';
import 'package:streamit_laravel/controllers/connectivity_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../components/app_scaffold.dart';
import '../utils/colors.dart';
import 'splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final String deepLink;
  final bool? link;

  SplashScreen({super.key, this.deepLink = "", this.link});

  final SplashScreenController splashController = Get.find<SplashScreenController>();

  @override
  Widget build(BuildContext context) {
    if (link == true) {
      splashController.handleDeepLinking(deepLink: deepLink);
    }
    ConnectivityController.instance.onInternetRestored = () async {
      await getAppConfigurations(
        loaderOnOff: (bool isLoading) {
          splashController.setLoading(isLoading);
        },
      ).then((value) => splashController.init(isRedirect: false));
    };
    return NewAppScaffold(
      scrollController: splashController.scrollController,
      hideAppBar: true,
      applyLeadingBackButton: false,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      isLoading: splashController.isLoading,
      isScrollableWidget: false,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SnapHelperWidget(
              future: ConnectivityController.instance.checkInternetConnection(),
              loadingWidget: const Offstage(),
              onSuccess: (hasInternet) {
                return Column(
                  children: [
                    if (hasInternet) const AppLoaderWidget(size: Size(140, 140)).visible(!splashController.isLoading.value) else NoInternetComponent().visible(!splashController.isLoading.value),
                    Obx(
                      () => TextButton(
                        child: Text(locale.value.reload, style: boldTextStyle(color: appColorPrimary)),
                        onPressed: () async {
                          hasInternet = await ConnectivityController.instance.checkInternetConnection();
                          if (hasInternet)
                            await getAppConfigurations(
                              loaderOnOff: (bool isLoading) {
                                splashController.setLoading(isLoading);
                              },
                            ).then(
                              (value) {
                                splashController.init();
                              },
                            ).catchError((e) {
                              throw e;
                            });
                          else {
                            toast(locale.value.pleaseCheckYourMobileInternetConnection);
                          }
                        },
                      ).visible(((splashController.appNotSynced.value && !splashController.isLoading.value)) || !hasInternet),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}