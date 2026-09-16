import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/lib.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../main.dart';
import '../empty_error_state_widget.dart';
import 'controller/fc_cast_controller.dart';

class AvailableDevicesForCast extends StatefulWidget {
  final Function(GoogleCastDevice)? onTap;

  const AvailableDevicesForCast({super.key, this.onTap});

  @override
  State<AvailableDevicesForCast> createState() => _AvailableDevicesForCastState();
}

class _AvailableDevicesForCastState extends State<AvailableDevicesForCast> {
  FCCast cast = Get.isRegistered() ? Get.find<FCCast>() : Get.put(FCCast());

  @override
  void initState() {
    super.initState();
    findAvailableDevices();
  }

  Future<void> findAvailableDevices() async {
    cast.startDiscovery();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          spacing: 12,
          children: [
            Row(
              spacing: 12,
              children: [
                Text(
                  locale.value.searchingForDevice,
                  style: commonPrimaryTextStyle(),
                ),
                Obx(
                  () => const LoaderWidget(
                    size: 20,
                  ).visible(cast.isSearchingForDevice.value),
                ),
                Obx(
                  () {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: darkGrayColor)),
                      child: Text(locale.value.retry, style: commonSecondaryTextStyle(size: 12)),
                    ).onTap(() => cast.startDiscovery()).visible(!cast.isSearchingForDevice.value);
                  },
                )
              ],
            ).expand(),
            IconButton(
              onPressed: () {
                Get.back();
              },
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.close,
                color: iconColor,
              ),
            )
          ],
        ),
        StreamBuilder<GoogleCastSession?>(
          stream: GoogleCastSessionManager.instance.currentSessionStream,
          builder: (context, snapshot) {
            final isConnected = GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected;
            if (!isConnected) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16, top: 8),
              padding: const EdgeInsets.all(12),
              decoration: boxDecorationDefault(color: cardColor),
              child: Row(
                children: [
                  IconWidget(imgPath: Assets.iconsScreencastFill, color: rentedColor),
                  16.width,
                  Text("Connected", style: boldTextStyle()).expand(),
                  AppButton(
                    text: locale.value.disconnect,
                    color: redColor,
                    textColor: Colors.white,
                    height: 36,
                    onTap: () {
                      cast.endSession();
                      Get.back();
                    },
                  ),
                ],
              ),
            );
          },
        ),
        StreamBuilder<List<GoogleCastDevice>>(
          stream: GoogleCastDiscoveryManager.instance.devicesStream,
          builder: (context, snapshot) {
            final devices = snapshot.data ?? [];
            if (devices.isEmpty && cast.isSearchingForDevice.isFalse) {
              return AppNoDataWidget(
                title: locale.value.noDeviceAvailable,
                retryText: "",
                imageWidget: const EmptyStateWidget(),
              ).paddingOnly(
                bottom: 28,
              );
            } else {
              return ListView.builder(
                itemCount: devices.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  GoogleCastDevice device = devices[index];
                  return ListTile(
                    hoverColor: appScreenBackgroundDark,
                    selectedTileColor: appColorPrimary,
                    tileColor: cardColor,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      device.friendlyName,
                      style: commonPrimaryTextStyle(),
                    ),
                    subtitle: Text(
                      device.modelName.validate(),
                      style: commonSecondaryTextStyle(),
                    ),
                    onTap: () async {
                      widget.onTap!(device);
                      await GoogleCastSessionManager.instance.startSessionWithDevice(device);
                      appScreenCastConnected(GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected);
                    },
                  );
                },
              );
            }
          },
        ),
      ],
    ).paddingSymmetric(horizontal: 12);
  }
}