import 'dart:io';

import '../configs.dart';
import '../utils/common_functions.dart';

class AdHelper {
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return appConfigs.value.bannerAds.androidBannerAdId.isNotEmpty ? appConfigs.value.bannerAds.androidBannerAdId : BANNER_AD_ID;
    } else if (Platform.isIOS) {
      return appConfigs.value.bannerAds.iosBannerAdId.isNotEmpty ? appConfigs.value.bannerAds.iosBannerAdId : IOS_BANNER_AD_ID;
    }
    throw UnsupportedError("Unsupported platform");
  }
}