import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/account_setting/components/logout_account_component.dart';
import 'package:streamit_laravel/screens/device/device_component.dart';
import 'package:streamit_laravel/screens/device/model/device_model.dart';
import 'package:streamit_laravel/utils/colors.dart';

class OtherDevicesComponent extends StatelessWidget {
  final List<DeviceData> devicesDetail;

  final Function(bool logoutAll, String deviceId, String deviceName) onLogout;

  const OtherDevicesComponent({super.key, required this.devicesDetail, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    if (devicesDetail.validate().isEmpty) {
      return Offstage();
    }

    return Column(
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.value.otherDevices, style: secondaryTextStyle()),
            TextButton(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {
                Get.bottomSheet(
                  isDismissible: true,
                  isScrollControlled: true,
                  enableDrag: false,
                  AppDialogWidget(
                    child: LogoutAccountComponent(
                      logOutAll: true,
                      onLogout: (logoutAll) {
                        onLogout.call(true, '', '');
                      },
                      device: '',
                      deviceName: '',
                    ),
                  ),
                );
              },
              child: Text(
                locale.value.logOutAll,
                style: boldTextStyle(color: appColorPrimary),
              ),
            ),
          ],
        ),
        AnimatedWrap(
          runSpacing: 12,
          spacing: 12,
          itemCount: devicesDetail.length,
          itemBuilder: (context, index) {
            if (devicesDetail[index].deviceId.isEmpty) {
              return const Offstage();
            } else {
              return DeviceComponent(
                deviceDetail: devicesDetail[index],
                onDeviceLogout: () {
                  Get.bottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    AppDialogWidget(
                      child: LogoutAccountComponent(
                        device: devicesDetail[index].deviceId,
                        deviceName: devicesDetail[index].deviceName,
                        logOutAll: false,
                        onLogout: (logoutAll) {
                          onLogout.call(logoutAll, devicesDetail[index].deviceId, devicesDetail[index].deviceName);
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}