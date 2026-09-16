// ignore_for_file: depend_on_referenced_packages

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_controller.dart';
import 'package:streamit_laravel/services/notification_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../configs.dart';
import '../../../utils/common_base.dart';
import '../../../utils/country_picker/country_code.dart';
import '../sign_in/sign_in_screen.dart';

class SignUpController extends BaseController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey();

  TextEditingController firstNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confPasswordCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController dobCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confPasswordFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode dobFocus = FocusNode();

  Rx<Country> selectedCountry = defaultCountry.obs;
  RxBool isPhoneAuth = false.obs;
  RxBool isBtnEnable = false.obs;
  RxString countryCode = defaultCountry.phoneCode.obs;

  @override
  void onInit() {
    initScrollListener();
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['countryCode'] is Country) {
        countryCode.value = (Get.arguments['countryCode'] as Country).phoneCode;
        selectedCountry(Get.arguments['countryCode'] as Country);
      }
      if (Get.arguments['mobile'] is String) {
        mobileCont.text = Get.arguments['mobile'];
      }
    }
    super.onInit();
  }

  Future<void> saveForm() async {
    if (isLoading.isTrue) return;
    setLoading(true);
    hideKeyBoardWithoutContext();
    Map<String, dynamic> req = {
      ApiRequestKeys.email: emailCont.text.trim(),
      ApiRequestKeys.firstName: firstNameCont.text.trim(),
      ApiRequestKeys.lastName: lastNameCont.text.trim(),
      ApiRequestKeys.mobile: '+${countryCode.value}${mobileCont.text.trim()}',
      ApiRequestKeys.countryCode: countryCode.value,
      ApiRequestKeys.username: mobileCont.text.trim(),
      ApiRequestKeys.password: passwordCont.text.trim(),
      ApiRequestKeys.confirmPassword: confPasswordCont.text.trim(),
      ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
      ApiRequestKeys.deviceNameKey: currentDevice.value.deviceName,
      ApiRequestKeys.platformKey: currentDevice.value.platform,
    };

    if (isPhoneAuth.value) req.putIfAbsent(ApiRequestKeys.loginType, () => LoginTypeConst.loginTypeOTP);

    await AuthServiceApis.createUser(request: req).then((value) async {
      if (isPhoneAuth.value) {
        final SignInController verificationController = Get.find<SignInController>();
        verificationController.phoneCont.text = (mobileCont.text);
        verificationController.countryCode(countryCode.value);
        verificationController.phoneSignIn();
      } else {
        try {
          final Map<String, dynamic> req = {
            ApiRequestKeys.email: emailCont.text.trim(),
            ApiRequestKeys.password: passwordCont.text.trim(),
            ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
            ApiRequestKeys.deviceNameKey: currentDevice.value.deviceName,
            ApiRequestKeys.platformKey: currentDevice.value.platform,
            ApiRequestKeys.loginType: LoginTypeConst.loginTypeEmail,
          };
          await AuthServiceApis.loginUser(request: req).then((value) async {
            NotificationService().subscribeTopic();
            Get.back(result: true);
            successSnackBar(locale.value.welcomeUserMessage(APP_NAME, loginUserData.value.fullName));
          }).whenComplete(() {
            setLoading(false);
          }).catchError((e) {
            setLoading(false);
            errorSnackBar(error: e);
            Get.off(() => SignInScreen());
          });
        } catch (e) {
          log('E: $e');
          toast(e.toString(), print: true);
          setLoading(false);
        }
      }
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  void onBtnEnable() {
    if (mobileCont.text.isNotEmpty && firstNameCont.text.isNotEmpty && lastNameCont.text.isNotEmpty && emailCont.text.isNotEmpty && passwordCont.text.isNotEmpty && confPasswordCont.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }

  @override
  void onClose() {
    firstNameCont.clear();
    lastNameCont.clear();
    emailCont.clear();
    passwordCont.clear();
    confPasswordCont.clear();
    mobileCont.clear();
    dobCont.clear();

    firstNameFocus.dispose();
    lastNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confPasswordFocus.dispose();
    mobileFocus.dispose();
    dobFocus.dispose();

    super.onClose();
  }

  Future<void> changeCountry(BuildContext context) async {
    showCustomCountryPicker(
      context: context,
      onSelect: (Country country) {
        countryCode(country.phoneCode);
        selectedCountry(country);
      },
    );
  }
}