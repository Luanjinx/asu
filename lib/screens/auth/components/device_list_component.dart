import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/screens/account_setting/components/logout_account_component.dart';
import 'package:streamit_laravel/screens/device/device_component.dart';
import 'package:streamit_laravel/screens/device/model/device_model.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';

class DeviceListComponent extends StatelessWidget {
  final List<DeviceData> loggedInDeviceList;
  final Function(bool logoutAll, String deviceId, String deviceName) onLogout;

  const DeviceListComponent({
    super.key,
    required this.loggedInDeviceList,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                locale.value.otherDevices,
                style: boldTextStyle(),
              ).expand(),
              16.width,
              TextButton(
                onPressed: () {
                  Get.bottomSheet(
                    isDismissible: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    AppDialogWidget(
                      child: LogoutAccountComponent(
                        device: '',
                        deviceName: '',
                        logOutAll: true,
                        onLogout: (logoutAll) {
                          onLogout.call(true, '', '');
                        },
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
          12.height,
          ...List.generate(
            loggedInDeviceList.length,
            (index) {
              if (loggedInDeviceList[index].deviceId.isEmpty) {
                return const Offstage();
              } else {
                return DeviceComponent(
                  deviceDetail: loggedInDeviceList[index],
                  onDeviceLogout: () {
                    Get.bottomSheet(
                      isDismissible: true,
                      isScrollControlled: true,
                      enableDrag: false,
                      AppDialogWidget(
                        child: LogoutAccountComponent(
                          device: loggedInDeviceList[index].deviceId,
                          deviceName: loggedInDeviceList[index].deviceName,
                          logOutAll: false,
                          onLogout: (logoutAll) {
                            onLogout.call(false, loggedInDeviceList[index].deviceId, loggedInDeviceList[index].deviceName);
                          },
                        ),
                      ),
                    );
                  },
                ).paddingBottom(8);
              }
            },
          ),
        ],
      ),
    );
  }
}