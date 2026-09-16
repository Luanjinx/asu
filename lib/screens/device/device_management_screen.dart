import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/account_setting/account_setting_controller.dart';
import 'package:streamit_laravel/screens/device/device_component.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import 'other_devices_component.dart';

class DeviceManagementScreen extends StatelessWidget {
  DeviceManagementScreen({super.key});

  final AccountSettingController accountSettingController = Get.find<AccountSettingController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewAppScaffold(
        isPinnedAppbar: true,
        statusBarColor: yellowColor,
        applyLeadingBackButton: true,
        scrollController: accountSettingController.scrollController,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        isLoading: accountSettingController.isLoading,
        appBarTitleText: locale.value.deviceManagement,
        onRefresh: () {
          accountSettingController.getAccountSetting();
        },
        body: SnapHelperWidget(
          future: accountSettingController.contentFuture.value,
          loadingWidget: const SizedBox.shrink(),
          errorBuilder: (error) {
            return AppNoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                accountSettingController.getAccountSetting();
              },
            ).visible(!accountSettingController.isLoading.value);
          },
          onSuccess: (res) {
            return Column(
              spacing: 16,
              children: [
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DeviceComponent(
                      deviceDetail: accountSettingController.hasContent && accountSettingController.content.value!.yourDevice.deviceId.isNotEmpty
                          ? accountSettingController.content.value!.yourDevice
                          : currentDevice.value,
                      onDeviceLogout: () {},
                    ),
                    if (accountSettingController.hasContent && accountSettingController.content.value!.otherDevice.isNotEmpty)
                      OtherDevicesComponent(
                        devicesDetail: accountSettingController.content.value!.otherDevice,
                        onLogout: (isLogoutAll, device, String deviceName) {
                          if (isLogoutAll) {
                            accountSettingController.isLoading(true);
                            logOutFromAllDevice(
                              loaderOnOff: (isLoading) {
                                accountSettingController.setLoading(isLoading);
                              },
                              showLoader: accountSettingController.isLoading.value,
                            );
                          } else {
                            accountSettingController.deviceLogOut(device: device);
                          }
                        },
                      ),
                  ],
                ),
                Obx(() {
                  final deviceLimitPlan = currentSubscription.value.planType.firstWhereOrNull(
                    (plan) => plan.slug == SubscriptionTitle.deviceLimit && plan.limitationValue.getBoolInt() && plan.limit.value.isNotEmpty,
                  );
                  final deviceLimit = deviceLimitPlan?.limit.value;
                  if (deviceLimit == null) return const SizedBox.shrink();

                  return Column(
                    spacing: 16,
                    children: [
                      Text(
                        "${locale.value.yourCurrentPlanSupports} $deviceLimit ${locale.value.deviceLogins}",
                        style: commonPrimaryTextStyle(),
                      ),
                    ],
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }
}