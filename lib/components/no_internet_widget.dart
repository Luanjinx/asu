import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/downloads/download_screen.dart';

import '../utils/empty_error_state_widget.dart';

class NoInternetComponent extends StatelessWidget {
  final bool showDownloadsButton;

  final double? height;
  final VoidCallback? onRetry;

  const NoInternetComponent({
    super.key,
    this.showDownloadsButton = true,
    this.onRetry,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AppNoDataWidget(
      height: height ?? Get.height * 0.30,
      title: locale.value.noInternetAvailable,
      subTitle: showDownloadsButton ? locale.value.pleaseCheckYourMobileInternetConnection : 'Please check your connection and try again',
      retryText: showDownloadsButton ? locale.value.goToYourDownloads : locale.value.retry,
      imageWidget: const EmptyStateWidget(noDataImage: Assets.iconsWifiSlash),
      onRetry: () async {
        Get.to(() => DownloadScreen());
      },
    );
  }
}