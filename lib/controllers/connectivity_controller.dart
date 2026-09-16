import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ConnectivityController extends GetxController {
  static ConnectivityController get instance => Get.find();

  RxBool hasConnection = true.obs;

  @override
  void onInit() {
    super.onInit();

    Connectivity().onConnectivityChanged.listen((result) async {
      bool newStatus = result != ConnectivityResult.none;

      if (newStatus) {
        newStatus = await checkInternetConnection();
      }

      // Auto trigger actions if connection is restored
      if (!hasConnection.value && newStatus) {
        onInternetRestored?.call();
      }

      hasConnection.value = newStatus;
    });
  }

  /// Callback you can set from SplashScreen
  VoidCallback? onInternetRestored;

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
