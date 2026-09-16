import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/lib.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/cast/controller/fc_cast_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../main.dart';

class FlutterChromeCastWidget extends StatelessWidget {
  final FCCast chromeCastController;

  const FlutterChromeCastWidget({super.key, required this.chromeCastController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        StreamBuilder<GoogleCastSession?>(
          stream: GoogleCastSessionManager.instance.currentSessionStream,
          builder: (context, snapshot) {
            final bool isConnected = GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected;
            final String deviceName = chromeCastController.device?.friendlyName ?? 'Chromecast Device';

            return Obx(() => Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isConnected ? successColor.withValues(alpha: 0.08) : iconColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: appScreenBackgroundDark.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconWidget(
                        imgPath: isConnected ? Assets.iconsScreencastFill : Assets.iconsScreencast,
                        size: 60,
                        color: isConnected ? appColorPrimary : iconColor,
                      ),
                      20.height,
                      Text(
                        isConnected ? "${locale.value.connectTo} $deviceName." : locale.value.readyToCastToYourDevice,
                        style: boldTextStyle(size: 18),
                        textAlign: TextAlign.center,
                      ),
                      8.height,
                      if (!isConnected)
                        Text(
                          locale.value.castConnectInfo,
                          style: commonSecondaryTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      if (chromeCastController.errorMessage.value != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            chromeCastController.errorMessage.value!,
                            style: commonPrimaryTextStyle(size: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      24.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: chromeCastController.isLoading.value ? null : () => chromeCastController.handleConnect(isConnected),
                            icon: Icon(
                              isConnected ? Icons.link_off : Icons.cast,
                              color: appColorPrimary,
                            ),
                            label: Text(
                              isConnected ? locale.value.disconnect : locale.value.connect,
                              style: commonPrimaryTextStyle(color: appColorPrimary),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: appColorPrimary,
                              side: const BorderSide(color: appColorPrimary),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ).expand(),
                          if (isConnected && chromeCastController.device != null) ...[
                            16.width,
                            OutlinedButton.icon(
                              onPressed: chromeCastController.isLoading.value ? null : chromeCastController.handlePlay,
                              icon: IconWidget(imgPath: Assets.iconsPlay, color: appColorPrimary),
                              label: Text(
                                locale.value.playOnTV,
                                style: commonPrimaryTextStyle(color: appColorPrimary),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: appColorPrimary,
                                side: BorderSide(color: appColorPrimary),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ).expand(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ));
          },
        ),
        GoogleCastMiniController(
          theme: GoogleCastPlayerTheme(
            backgroundColor: appScreenBackgroundDark,
            titleTextStyle: boldTextStyle(),
            deviceTextStyle: boldTextStyle(size: 12),
            iconColor: appColorPrimary,
            imageBorderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(16),
          showDeviceName: true,
        ),
        Obx(
          () => chromeCastController.isLoading.value
              ? LoaderWidget(
                  isBlurBackground: true,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}