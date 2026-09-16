import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import 'model/device_model.dart';

class DeviceComponent extends StatelessWidget {
  final DeviceData deviceDetail;

  final VoidCallback onDeviceLogout;

  const DeviceComponent({super.key, required this.deviceDetail, required this.onDeviceLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: boxDecorationDefault(
        color: cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  getDeviceIconByPlatform(
                    deviceName: deviceDetail.deviceName,
                    platform: deviceDetail.platform,
                  ),
                  color: appColorPrimary,
                  size: 32,
                ),
                8.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        deviceDetail.deviceName.capitalizeEachWord(),
                        style: commonW600PrimaryTextStyle(),
                        softWrap: true,
                      ),
                      6.height,
                      if (deviceDetail.updatedAt.isNotEmpty || deviceDetail.deviceId == currentDevice.value.deviceId)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.history, color: iconColor, size: 14),
                            4.width,
                            Expanded(
                              child: Text(
                                formatDateWithDaySuffix(
                                  deviceDetail.updatedAt.isNotEmpty ? deviceDetail.updatedAt : DateTime.now().toUtc().toIso8601String(),
                                ),
                                style: commonSecondaryTextStyle(),
                              ),
                            ),
                            8.width,
                            if (deviceDetail.deviceId == currentDevice.value.deviceId)
                              Text(
                                locale.value.currentDevice,
                                style: commonSecondaryTextStyle(color: rentedColor),
                              )
                            else
                              Text(
                                locale.value.logout,
                                style: primaryTextStyle(
                                  color: appColorPrimary,
                                ).copyWith(decoration: TextDecoration.underline, decorationColor: appColorPrimary),
                              ).onTap(onDeviceLogout),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
