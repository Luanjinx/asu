import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';

import '../../network/core_api.dart';
import '../../utils/common_base.dart';

class QRScannerController extends BaseController {
  RxBool isProcessing = false.obs;

  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: [BarcodeFormat.qrCode],
    autoStart: true,
  );

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing.value) return;

    final String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null) return;

    late final Map<String, dynamic> qrData;

    try {
      qrData = jsonDecode(rawValue);
    } catch (e) {
      errorSnackBar(error: 'Invalid QR code');
      return;
    }

    final String? sessionId = qrData['session_id'];
    String type = '';

    if (qrData.containsKey(ApiRequestKeys.typeKey) && qrData[ApiRequestKeys.typeKey] is String) {
      type = qrData[ApiRequestKeys.typeKey];
    } else {
      type = '';
    }

    if (sessionId == null) {
      errorSnackBar(error: 'Unsupported QR code');
      return;
    }

    isProcessing(true);
    setLoading(true);

    final Map<String, dynamic> request = {
      ApiRequestKeys.sessionIdKey: sessionId,
      if (type.isNotEmpty) ApiRequestKeys.typeKey: type,
    };

    await CoreServiceApis.linkWebAndTv(request: request).then((value) {
      successSnackBar(value.message);
      Get.back();
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      isProcessing(false);
      setLoading(false);
    });
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}