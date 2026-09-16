import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/qr_scanner/qr_scanner_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';

import '../../components/app_scaffold.dart';

class QrScannerScreen extends StatelessWidget {
  QrScannerScreen({super.key});

  final QRScannerController qrScannerScreenController = Get.put(QRScannerController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isLoading: qrScannerScreenController.isLoading,
      appBarTitleText: locale.value.scanTvQrCode,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get bounded constraints - use MediaQuery if constraints are unbounded
          final mediaQuery = MediaQuery.of(context);
          final availableHeight = constraints.maxHeight.isFinite ? constraints.maxHeight : mediaQuery.size.height - kToolbarHeight - mediaQuery.padding.top;
          final availableWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : mediaQuery.size.width;

          return SizedBox(
            height: availableHeight,
            width: availableWidth,
            child: Stack(
              fit: StackFit.expand,
              alignment: AlignmentGeometry.center,
              children: [
                MobileScanner(
                  controller: qrScannerScreenController.scannerController,
                  overlayBuilder: (context, constraints) {
                    return QRScannerOverlay(
                      overlayColour: appScreenBackgroundDark.withValues(alpha: 0.5),
                    );
                  },
                  errorBuilder: (context, scannerException) {
                    return AppNoDataWidget(
                      imageWidget: EmptyStateWidget(noDataImage: Assets.iconsWarning),
                      title: scannerException.errorCode == MobileScannerErrorCode.permissionDenied ? locale.value.permissionNotGranted : locale.value.somethingWentWrong,
                      retryText: locale.value.openSettings,
                      onRetry: () {
                        openAppSettings();
                      },
                    );
                  },
                  onDetect: (BarcodeCapture capture) {
                    qrScannerScreenController.onDetect(capture);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class QRScannerOverlay extends StatelessWidget {
  final Color overlayColour;

  const QRScannerOverlay({super.key, required this.overlayColour});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            overlayColour,
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}