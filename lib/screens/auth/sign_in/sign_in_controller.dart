// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/services/notification_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';

import '../../../configs.dart';
import '../../../main.dart';
import '../../../utils/common_base.dart';
import '../../../utils/common_functions.dart';
import '../../../utils/constants.dart';
import '../../../utils/country_picker/country_code.dart';
import '../../../utils/firebase_phone_auth/firebase_auth_util.dart';
import '../../../utils/firebase_phone_auth/firebase_excauth_exception_utils.dart';
import '../components/device_list_component.dart';
import '../components/otp_verify_component.dart';
import '../model/error_model.dart';
import '../services/social_logins.dart';
import '../sign_up/signup_screen.dart';

class SignInController extends BaseController {
  final GlobalKey<FormState> signInformKey = GlobalKey();

  RxBool isOTPSent = false.obs;
  RxBool isVerifyBtn = false.obs;
  RxBool isBtnEnable = false.obs;
  RxBool isRememberMe = true.obs;
  RxBool isNormalLogin = true.obs;

  RxString countryCode = defaultCountry.phoneCode.obs;
  RxBool isOTPVerify = false.obs;
  RxBool isOTPLoading = false.obs;

  Rx<String> verificationCode = ''.obs;
  Rx<String> verificationId = ''.obs;
  Rx<Timer> codeResendTimer = Timer(Duration.zero, () {}).obs;
  Rx<int> codeResendTime = 0.obs;

  set setCodeResendTime(int time) {
    codeResendTime(time);
  }

  TextEditingController phoneCont = TextEditingController();
  TextEditingController countryCodeCont = TextEditingController();
  TextEditingController verifyCont = TextEditingController();

  Rx<Country> selectedCountry = defaultCountry.obs;

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  Worker? _appConfigWorker;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  @override
  void onInit() {
    _appConfigWorker = ever(appConfigs, (_) async {
      await _applyDemoCredentialState();
    });
    init();
    super.onInit();
  }

  Future<void> init() async {
    getBtnEnable();
    getInitialData();
    await _applyDemoCredentialState();
  }

  Future<void> getInitialData() async {
    final isRememberMeValue = await getBoolFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);
    if (isRememberMeValue == true) {
      isRememberMe(true);
      final savedPassword = await getStringFromLocal(SharedPreferenceConst.USER_PASSWORD);
      final savedLoginRequest = await getJsonFromLocal(SharedPreferenceConst.LOGIN_REQUEST);
      if (savedPassword != null && savedPassword.isNotEmpty) {
        passwordCont.text = savedPassword;
      }
      if (savedLoginRequest != null && savedLoginRequest[ApiRequestKeys.email] != null) {
        emailCont.text = savedLoginRequest[ApiRequestKeys.email];
      }
    } else {
      isRememberMe(false);
    }
    getBtnEnable();
  }

  void getBtnEnable() {
    if (phoneCont.text.isNotEmpty && phoneCont.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }

  Future<void> _applyDemoCredentialState() async {
    final bool shouldShowDemoCredentials = appConfigs.value.enableDemoLogin && await isIqonicProduct;

    if (shouldShowDemoCredentials) {
      emailCont.text = Constants.DEFAULT_EMAIL;
      passwordCont.text = Constants.DEFAULT_PASS;
      phoneCont.text = Constants.defaultNumber;
    } else {
      if (emailCont.text == Constants.DEFAULT_EMAIL) emailCont.clear();
      if (passwordCont.text == Constants.DEFAULT_PASS) passwordCont.clear();
      if (phoneCont.text == Constants.defaultNumber) phoneCont.clear();
    }
    getBtnEnable();
  }

  void getVerifyBtnEnable() {
    if (verifyCont.text.isNotEmpty && verifyCont.text.length == 6) {
      hideKeyBoardWithoutContext();
      isVerifyBtn(true);
    } else {
      isVerifyBtn(false);
    }
  }

  Future<void> onLoginPressed({bool isFromSignIn = false}) async {
    if (isLoading.value || isOTPLoading.value) return;
    if(isFromSignIn) {
      setLoading(true);
      try {
        final result = await AuthServiceApis.checkMobileNumberExist(request: {
          ApiRequestKeys.mobile: "+$countryCode${phoneCont.text}",
        });
        if(!result.status) {
          var res = await Get.to(() => SignUpScreen(), arguments: {
            'countryCode': selectedCountry.value,
            'mobile': phoneCont.text,
          });
          if (res == true) {
            Get.off(() => WatchingProfileScreen(), arguments: Get.arguments);
          }
          return;
        }
      } catch (e) {
        var res = await Get.to(() => SignUpScreen(), arguments: {
          'countryCode': selectedCountry.value,
          'mobile': phoneCont.text,
        });
        if (res == true) {
          Get.off(() => WatchingProfileScreen(), arguments: Get.arguments);
        }
        return;
      } finally {
        setLoading(false);
      }
    }
    final bool isResending = Get.isBottomSheetOpen ?? false;
    if (isResending) {
      isOTPLoading(true);
    } else {
      setLoading(true);
    }
    isOTPSent(false);
    final firebaseAuthUtil = FirebaseAuthUtil();

    firebaseAuthUtil.login(
        mobileNumber: "+$countryCode${phoneCont.text}",
        onCodeSent: (value) {
          isOTPSent(true);
          verificationId(value);
          countryCode(countryCode.value);
          initializeCodeResendTimer;
          setLoading(false);
          isOTPLoading(false);

          // Only show bottom sheet if it's not already open (initial OTP send)
          if (!isResending) {
            Future.delayed(const Duration(milliseconds: 200), () {
              Get.bottomSheet(
                isDismissible: false,
                isScrollControlled: true,
                enableDrag: false,
                AppDialogWidget(
                  child: OTPVerifyComponent(),
                ),
              );
            });
          }
        },
        onVerificationFailed: (value) {
          setLoading(false);
          isOTPLoading(false);
          errorSnackBar(error: FirebaseAuthHandleExceptionsUtils().handleException(value));
        });
  }

  handleFailedOTPVerification(FirebaseAuthException? error) {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    isOTPSent(false);
    setLoading(false);
    isOTPLoading(false);
    verifyCont.clear();

    if (error != null) errorSnackBar(error: FirebaseAuthHandleExceptionsUtils().handleException(error));
    Get.bottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      AppDialogWidget(
        child: OTPVerifyComponent(),
      ),
    );
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

  Future<void> loginAPICall({required Map<String, dynamic> request, required bool isSocialLogin, bool isNormalLogin = false}) async {
    await AuthServiceApis.loginUser(request: request, isSocialLogin: isSocialLogin)
        .then((value) async {
          phoneCont.clear();
          verifyCont.clear();
          handleLoginResponse(isSocialLogin: isSocialLogin, isNormalLogin: isNormalLogin);
        })
        .whenComplete(
          () => setLoading(false),
        )
        .catchError((e) async {
          if (e is Map<String, dynamic> && e.containsKey('status_code') && e['status_code'] == 404) {
            var res = await Get.to(() => SignUpScreen(), arguments: {
              'countryCode': selectedCountry.value,
              'mobile': phoneCont.text,
            });
            if (res == true) {
              Get.off(() => WatchingProfileScreen(), arguments: Get.arguments);
            }
          } else {
            errorSnackBar(error: e);

            if (e is Map<String, dynamic> && e.containsKey('status_code') && e['status_code'] == 406 && e.containsKey('response')) {
              final ErrorModel errorData = ErrorModel.fromJson(e['response']);
              Get.bottomSheet(
                isScrollControlled: true,
                enableDrag: false,
                AppDialogWidget(
                  child: DeviceListComponent(
                    loggedInDeviceList: errorData.otherDevice,
                    onLogout: (logoutAll, deviceId, deviceName) {
                      Navigator.pop(Get.context!);
                      if (logoutAll) {
                        logOutAll(errorData.otherDevice.first.userId).then(
                          (value) {
                            loginAPICall(request: request, isSocialLogin: isSocialLogin);
                          },
                        );
                      } else {
                        deviceLogOut(
                          device: deviceId,
                          userId: errorData.otherDevice.first.userId.toInt(),
                        ).then(
                          (value) {
                            loginAPICall(request: request, isSocialLogin: isSocialLogin);
                          },
                        );
                      }
                    },
                  ),
                ),
              );
            }
          }
        });
  }

  Future<void> saveForm({bool isNormalLogin = false}) async {
    if (isLoading.isTrue) return;

    hideKeyBoardWithoutContext();
    setLoading(true);
    final Map<String, dynamic> req = {
      ApiRequestKeys.email: emailCont.text.trim(),
      ApiRequestKeys.password: passwordCont.text.trim(),
      ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
      ApiRequestKeys.deviceNameKey: currentDevice.value.deviceName,
      ApiRequestKeys.platformKey: currentDevice.value.platform,
    };

    await loginAPICall(isSocialLogin: false, request: req, isNormalLogin: isNormalLogin);
  }

  Future<void> phoneSignIn() async {
    setLoading(true);
    final Map<String, dynamic> request = {
      ApiRequestKeys.username: "+${countryCode.value}${phoneCont.text.trim()}",
      ApiRequestKeys.password: "+${countryCode.value}${phoneCont.text.trim()}",
      ApiRequestKeys.mobile: "+${countryCode.value}${phoneCont.text.trim()}",
      ApiRequestKeys.countryCode: countryCode.value,
      ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
      ApiRequestKeys.deviceNameKey: currentDevice.value.deviceName,
      ApiRequestKeys.platformKey: currentDevice.value.platform,
      ApiRequestKeys.loginType: LoginTypeConst.loginTypeOTP,
    };

    Get.back();

    await loginAPICall(isSocialLogin: true, request: request);
  }

  void get initializeCodeResendTimer {
    codeResendTimer.value.cancel();
    codeResendTime(60);
    codeResendTimer.value = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (codeResendTime > 0) {
        setCodeResendTime = --codeResendTime.value;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> onVerifyPressed() async {
    final firebaseAuthUtil = FirebaseAuthUtil();
    isOTPLoading(true);
    isVerifyBtn(false);
    await firebaseAuthUtil.verifyOTPCode(
      verificationId: verificationId.value,
      verificationCode: verifyCont.text,
      onVerificationSuccess: (value) {
        isOTPVerify(true);
        isOTPLoading(false);
        phoneSignIn();
      },
      onCodeVerificationFailed: (value) {
        handleFailedOTPVerification(value);
      },
    );
  }

  Future<void> googleSignIn() async {
    if (isLoading.value) return;
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      toast(locale.value.yourInternetIsNotWorking, print: true);
      return;
    }

    setLoading(true);
    await GoogleSignInAuthService().signInWithGoogle().then((value) async {
      if (value != null) {
        final Map<String, dynamic> request = {
          ApiRequestKeys.email: value.email,
          ApiRequestKeys.password: value.email,
          ApiRequestKeys.firstName: value.firstName,
          ApiRequestKeys.lastName: value.lastName,
          ApiRequestKeys.mobile: value.mobile,
          ApiRequestKeys.fileUrl: value.profileImage,
          ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
          ApiRequestKeys.deviceNameKey: currentDevice.value.deviceName,
          ApiRequestKeys.platformKey: currentDevice.value.platform,
          ApiRequestKeys.loginType: LoginTypeConst.loginTypeGoogle,
        };
        log('signInWithGoogle REQUEST: $request');

        await loginAPICall(request: request, isSocialLogin: true);
      }
    }).catchError((e, stackTrace) {
      setLoading(false);
      String errorMessage = '';
      if (e is GoogleSignInException) {
        if (e.code == GoogleSignInExceptionCode.canceled) {
          // Silently ignore canceled sign-ins
        } else if (e.code == GoogleSignInExceptionCode.uiUnavailable || e.code == GoogleSignInExceptionCode.userMismatch || e.code == GoogleSignInExceptionCode.clientConfigurationError) {
          errorMessage = e.description ?? 'Google sign in failed';
        } else {
          errorMessage = e.description ?? e.toString();
        }
      } else {
        errorMessage = e.toString();
      }

      if (errorMessage.isNotEmpty) {
        errorSnackBar(error: errorMessage);
      }
    }).whenComplete(() {
      log('--- Controller googleSignIn COMPLETE ---');
      setLoading(false);
    });
  }

  Future<void> appleSignIn() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      toast(locale.value.yourInternetIsNotWorking, print: true);
      return;
    }
    setLoading(true);
    await GoogleSignInAuthService().signInWithApple().then((value) async {
      final Map<String, dynamic> request = {
        ApiRequestKeys.email: value.email,
        ApiRequestKeys.password: value.email,
        ApiRequestKeys.firstName: value.firstName,
        ApiRequestKeys.lastName: value.lastName,
        ApiRequestKeys.mobile: value.mobile,
        ApiRequestKeys.fileUrl: value.profileImage,
        ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
        ApiRequestKeys.deviceNameKey: currentDevice.value.deviceName,
        ApiRequestKeys.platformKey: currentDevice.value.platform,
        ApiRequestKeys.loginType: LoginTypeConst.loginTypeApple,
      };
      log('signInWithGoogle REQUEST: $request');

      /// Social Login Api
      await loginAPICall(request: request, isSocialLogin: true);
    }).catchError((e) {
      setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void handleLoginResponse({String? password, bool isSocialLogin = false, bool isNormalLogin = false}) {
    try {
      setBoolToLocal(SharedPreferenceConst.IS_REMEMBER_ME, isRememberMe.value);

      if (isRememberMe.value && isNormalLogin) {
        setStringToLocal(SharedPreferenceConst.USER_PASSWORD, passwordCont.text);
        final loginRequest = {
          ApiRequestKeys.email: emailCont.text.trim(),
          ApiRequestKeys.password: passwordCont.text.trim(),
        };
        setJsonToLocal(SharedPreferenceConst.LOGIN_REQUEST, loginRequest);
      } else if (!isRememberMe.value) {
        removeValue(SharedPreferenceConst.USER_PASSWORD);
        removeValue(SharedPreferenceConst.LOGIN_REQUEST);
      }

      Get.off(() => WatchingProfileScreen(), arguments: Get.arguments);
      NotificationService().subscribeTopic();

      setLoading(false);
    } catch (e) {
      log("Error  ==> $e");
    }
  }

  Future<void> deviceLogOut({required String device, required int userId}) async {
    setLoading(true);
    await AuthServiceApis.deviceLogoutApiWithoutAuth(deviceId: device, userId: userId).then((value) {
      successSnackBar(value.message);
      // Close bottom sheet after success
      if (Get.isBottomSheetOpen ?? false) Get.back();
    }).catchError((e) {
      errorSnackBar(error: e);
      // Close bottom sheet after error
      if (Get.isBottomSheetOpen ?? false) Get.back();
    }).whenComplete(() {
      setLoading(false);
    });
  }

  Future<void> logOutAll(int userId) async {
    if (isLoading.value) return;
    setLoading(true);
    await AuthServiceApis.logOutAllAPIWithoutAuth(userId: userId).then((value) async {
      successSnackBar(value.message);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() {
      setLoading(false);
    });
  }

  @override
  void onClose() {
    _appConfigWorker?.dispose();
    phoneCont.dispose();
    countryCodeCont.dispose();
    verifyCont.dispose();
    emailCont.dispose();
    passwordCont.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    if (codeResendTimer.value.isActive) {
      codeResendTimer.value.cancel();
    }
    super.onClose();
  }
}