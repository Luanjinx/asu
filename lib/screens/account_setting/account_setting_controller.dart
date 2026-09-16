import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/account_setting/components/otp_verification_bottom_sheet.dart';
import 'package:streamit_laravel/screens/account_setting/model/account_setting_response.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import 'components/parental_lock_pin_component.dart';

class AccountSettingController extends BaseController<AccountSettingModel> {
  RxBool isOTPSent = false.obs;

  RxBool isOTPVerificationLoading = false.obs;
  RxString otp = "".obs;
  RxString oldPin = "".obs;
  RxString newPin = "".obs;
  RxString confirmPin = "".obs;

  List<String> filterTabs = [
    accountSettings,
    purchaseSettings,
    deviceSettings,
  ];

  //endRegion

  @override
  void onInit() {
    getAccountSetting(showLoader: false);
    initScrollListener();
    super.onInit();
  }

  Future<void> getAccountSetting({bool showLoader = true}) async {
    await getContent(
      showLoader: showLoader,
      contentApiCall: () => CoreServiceApis.getAccountSettingsResponse(
        deviceId: currentDevice.value.deviceId,
      ),
      onSuccess: (data) {
        content(data);
        if (data.otherDevice.isNotEmpty) {
          data.otherDevice.removeWhere(
            (element) {
              return element.deviceId == currentDevice.value.deviceId;
            },
          );
        }

        content.value = data; // keep content updated

        currentSubscription(data.planDetails);
        appParentalLockEnabled(data.isParentalLockEnabled == 1);
        setBoolToLocal(SettingsLocalConst.PARENTAL_CONTROL, data.isParentalLockEnabled == 1);

        if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty && currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
          isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
        } else {
          isCastingSupported(false);
        }
      },
    );
  }

  Future<void> deviceLogOut({required String device}) async {
    setLoading(true);
    Get.back();
    await AuthServiceApis.deviceLogoutApi(deviceId: device).then((value) {
      successSnackBar(value.message);

      getAccountSetting();
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() {
      setLoading(false);
    });
  }

  Future<void> deleteAccountPermanently() async {
    if (isLoading.value) return;
    setLoading(true);
    await AuthServiceApis.deleteAccountCompletely().then((value) async {
      await clearAppData(isFromDeleteAcc: true);
      setLoading(false);
    }).catchError((e) {
      setLoading(false);
      errorSnackBar(error: e);
    });
  }

  Future<void> handleParentalLock(bool isEnable, {bool showMessage = true}) async {
    if (isLoading.value) return;
    setLoading(true);

    final Map<String, dynamic> request = {
      ApiRequestKeys.isParentalLockKey: isEnable ? 1 : 0,
    };
    await CoreServiceApis.updateParentalLock(request).then((value) {
      appParentalLockEnabled(isEnable);
      setBoolToLocal(SettingsLocalConst.PARENTAL_CONTROL, isEnable);
      if (showMessage) successSnackBar(locale.value.successfullyUpdated);
    }).catchError((e) {
      if (showMessage) errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleChangePin() async {
    if (isLoading.value) return;
    setLoading(true);

    await CoreServiceApis.getPinChangeOTP().then((value) {
      Get.bottomSheet(
        AppDialogWidget(child: ParentalLockOTPVerificationComponent()),
        isScrollControlled: true,
      );
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => setLoading(false));
  }

  Future<void> handleVerifyOTP() async {
    if (isLoading.value) return;
    isOTPVerificationLoading(true);

    await CoreServiceApis.verifyOtp({
      ApiRequestKeys.userIdKey: loginUserData.value.id,
      ApiRequestKeys.otpKey: otp.value,
    }).then((value) {
      if (value.status == true) {
        Get.back();
        successSnackBar(value.message);
        Get.bottomSheet(
          AppDialogWidget(child: ParentalLockPinComponent()),
          isScrollControlled: true,
        );
      } else {
        handleErrorOTPVerification(value.message);
      }
    }).catchError((e) {
      handleErrorOTPVerification(e);
    }).whenComplete(() => isOTPVerificationLoading(false));
  }

  handleErrorOTPVerification(dynamic e) {
    Get.back();
    errorSnackBar(error: e);
    Get.bottomSheet(
      AppDialogWidget(
        child: ParentalLockOTPVerificationComponent(),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> setParentalLockPin() async {
    if (newPin.value.isEmpty) {
      toast(locale.value.pleaseEnterNewPIN);
    } else if (confirmPin.value == "") {
      toast(locale.value.pleaseEnterConfirmPin);
    } else {
      if (isLoading.value) return;
      if (newPin.value == confirmPin.value) {
        setLoading(true);

        await CoreServiceApis.changePin(
          {
            ApiRequestKeys.pinKey: newPin.value,
            ApiRequestKeys.confirmPinKey: confirmPin.value,
          },
        ).then((value) {
          Get.back();
          toast(locale.value.newPinSuccessfullySaved);
          selectedAccountProfile.value.profilePin = newPin.value;
          oldPin.value = "";
          newPin.value = "";
          confirmPin.value = "";
          Get.back();
          selectedAccountProfile.refresh();
        }).catchError((e) {
          errorSnackBar(error: e);
        }).whenComplete(() => setLoading(false));
      } else {
        toast(locale.value.pinNotMatched);
      }
    }
  }
}