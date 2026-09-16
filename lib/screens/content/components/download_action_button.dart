import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/components/download_quality_selection_component.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/downloads/download_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/services/download_control_service.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class DownloadActionButton extends StatelessWidget {
  final ContentDetailsController controller;
  final GlobalKey downloadButtonKey;
  final VoidCallback removeTrailer;

  static const _menuValueResume = 'resume';
  static const _menuValuePause = 'pause';
  static const _menuValueCancel = 'cancel';

  const DownloadActionButton({
    super.key,
    required this.controller,
    required this.downloadButtonKey,
    required this.removeTrailer,
  });

  Future<void> _handleMenuSelection(BuildContext context, {required bool isPaused}) async {
    final overlay = Overlay.of(context);
    final buttonContext = downloadButtonKey.currentContext;

    if (buttonContext == null) return;

    final RenderBox buttonBox = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlayBox = overlay.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        buttonBox.localToGlobal(const Offset(0, 100), ancestor: overlayBox),
        buttonBox.localToGlobal(buttonBox.size.bottomRight(Offset.zero), ancestor: overlayBox),
      ),
      Offset.zero & overlayBox.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: [
        if (isPaused)
          PopupMenuItem(
            key: const ValueKey(DOWNLOAD_MENU_RESUME_KEY),
            value: _menuValueResume,
            child: Text(locale.value.resume),
          )
        else
          PopupMenuItem(
            key: const ValueKey(DOWNLOAD_MENU_PAUSE_KEY),
            value: _menuValuePause,
            child: Text(locale.value.pause),
          ),
        PopupMenuItem(
          key: const ValueKey(DOWNLOAD_MENU_CANCEL_KEY),
          value: _menuValueCancel,
          child: Text(locale.value.cancel),
        ),
      ],
    );

    if (selected == _menuValuePause) {
      await controller.pauseActiveDownload();
    } else if (selected == _menuValueResume) {
      await controller.resumePausedDownload();
    } else if (selected == _menuValueCancel) {
      await controller.cancelActiveDownload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDownloaded = controller.isDownloaded.value;
      final progress = controller.downloadProgress.value;
      final controlState = controller.downloadControlState.value;
      final isPaused = controlState == DownloadControlState.paused;
      final isDownloading = controlState == DownloadControlState.inProgress && progress > 0 && progress < 100;

      return IconButton(
        key: downloadButtonKey,
        visualDensity: VisualDensity.compact,
        color: cardColor,
        padding: const EdgeInsets.symmetric(vertical: 8),
        onPressed: () async {
          if (!isLoggedIn.value) removeTrailer();

          if (isDownloading || isPaused) {
            await _handleMenuSelection(context, isPaused: isPaused);
            return;
          }

          doIfLogin(
            onLoggedIn: () {
              if (isDownloaded) {
                removeTrailer();
                Get.to(() => DownloadScreen());
              } else {
                Get.bottomSheet(
                  AppDialogWidget(
                    child: DownloadQualitySelectionComponent(
                      hasContentAccess: controller.content.value!.details.hasContentAccess.getBoolInt(),
                      availableDownloadQualities: controller.content.value!.downloadData.downloadQualities,
                      onQualitySelected: (DownloadQualities selectedQuality) {
                        controller.selectedDownloadQuality(selectedQuality);
                        controller.downloadContent(controller.content.value!.id, controller.content.value, null);
                      },
                    ),
                  ),
                );
              }
            },
          );
        },
        icon: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 6,
          children: [
            if (isDownloading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: (progress / 100).clamp(0.0, 1.0),
                  color: appColorPrimary,
                ),
              )
            else if (isPaused)
              const Icon(
                Icons.pause_circle_filled,
                size: 22,
                color: appColorPrimary,
              )
            else if (isDownloaded)
              IconWidget(
                imgPath: Assets.iconsCheck,
                size: 20,
                color: appColorPrimary,
              )
            else
              IconWidget(
                imgPath: Assets.iconsDownload,
                size: 20,
              ),
            if (isDownloading)
              Text('${progress.clamp(0, 100).toStringAsFixed(0)}%', style: commonPrimaryTextStyle(size: 14))
            else if (isPaused)
              Text(
                locale.value.paused,
                key: const ValueKey(DOWNLOAD_STATUS_PAUSED_KEY),
                style: commonPrimaryTextStyle(size: 14),
              )
            else if (isDownloaded)
              Text(locale.value.downloaded, style: primaryTextStyle(size: 14))
            else
              Text(
                locale.value.download.capitalizeFirstLetter(),
                style: commonPrimaryTextStyle(size: ResponsiveSize.getFontSize(14)),
              ),
          ],
        ),
      );
    });
  }
}