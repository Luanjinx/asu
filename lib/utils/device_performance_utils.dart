import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:streamit_laravel/utils/constants.dart';

enum DevicePerformanceClass { low, mid, high }

class DevicePerformanceUtils {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<DevicePerformanceClass> getPerformanceClass() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        int sdkInt = androidInfo.version.sdkInt;
        String hardware = androidInfo.hardware.toLowerCase();

        // Low tier: Very old SDKs or known budget chipsets
        if (sdkInt < 24 ||
            hardware.contains('mt65') ||
            hardware.contains('mt673') ||
            hardware.contains('unisoc')) {
          return DevicePerformanceClass.low;
        }

        // Mid tier: Mid-range devices from 5-6 years ago
        if (sdkInt < 26) {
          return DevicePerformanceClass.mid;
        }

        // High tier: Modern Android 8.0+ devices generally handle 1080p/4K well
        return DevicePerformanceClass.high;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        String model = iosInfo.utsname.machine.toLowerCase();

        // iPhone 7 or older
        if (model.contains('iphone7,') ||
            model.contains('iphone6,') ||
            model.contains('iphone8,')) {
          return DevicePerformanceClass.low;
        }

        // iPhone X, 11 and newer are all high performance for video
        return DevicePerformanceClass.high;
      }
    } catch (e) {
      debugPrint("Error detecting device performance: $e");
    }

    return DevicePerformanceClass.high;
  }

  static String getMaxSupportedQuality(
      DevicePerformanceClass performanceClass) {
    switch (performanceClass) {
      case DevicePerformanceClass.low:
        return QualityConstants.low; // 480p
      case DevicePerformanceClass.mid:
        return QualityConstants.high; // 1080p (UPGRADED)
      case DevicePerformanceClass.high:
        return QualityConstants.ultra8K; // No restriction
    }
  }

  static int getQualityPriority(String quality) {
    final q = quality.toLowerCase();
    if (q.contains('8k')) return 8;
    if (q.contains('4k') || q.contains('2160p')) return 7;
    if (q.contains('2k') || q.contains('1440p')) return 6;
    if (q.contains('1080p')) return 5;
    if (q.contains('720p')) return 4;
    if (q.contains('480p')) return 3;
    if (q.contains('360p')) return 2;
    return 1; // Auto/Default
  }

  static String getMaxQualityByScreen(double physicalHeight) {
    if (physicalHeight >= 4320) return QualityConstants.ultra8K;
    if (physicalHeight >= 2160) return QualityConstants.ultra4K;
    if (physicalHeight >= 1440) return QualityConstants.veryHigh;
    if (physicalHeight >= 1080) return QualityConstants.high;
    if (physicalHeight >= 720) return QualityConstants.medium;
    return QualityConstants.low;
  }

  static bool isSupported(String quality,
      DevicePerformanceClass performanceClass, String screenMaxQuality) {
    if (quality.isEmpty || quality == QualityConstants.defaultQualityKey) {
      return true; // Auto is always supported
    }

    int requested = getQualityPriority(quality);
    int performanceLimit =
        getQualityPriority(getMaxSupportedQuality(performanceClass));
    int displayLimit = getQualityPriority(screenMaxQuality);

    // Final limit is the minimum of decoding power and physical screen resolution
    int finalLimit =
        performanceLimit < displayLimit ? performanceLimit : displayLimit;

    return requested <= finalLimit;
  }
}
