import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/screens/auth/model/login_response.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';
import 'package:streamit_laravel/screens/profile/model/profile_detail_resp.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../network/core_api.dart';
import '../../utils/constants.dart';

class ProfileController extends BaseController<ProfileDetailResponse> {
  RxBool showShimmer = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    if (isLoggedIn.value) {
      getProfileDetail(showLoader: false);
    }
  }

  Future<void> cancelSubscription() async {
    if (isLoading.value) return;
    setLoading(true);

    await CoreServiceApis.cancelSubscription(
      request: {
        ApiRequestKeys.idKey: currentSubscription.value.id,
        ApiRequestKeys.userIdKey: loginUserData.value.id,
      },
    ).then((value) async {
      successSnackBar(value.message);
      Map<String, dynamic>? cachedLoginUserDataKey = await getJsonFromLocal(SharedPreferenceConst.USER_DATA) ?? null;
      if (cachedLoginUserDataKey != null) {
        final userData = cachedLoginUserDataKey;
        userData['plan_details'] = SubscriptionPlanModel().toJson();
        loginUserData.value = UserData.fromJson(userData);
      }
      currentSubscription(SubscriptionPlanModel());
      if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty) {
        isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
      }

      currentSubscription.value.activePlanInAppPurchaseIdentifier = '';
      removeValue(SharedPreferenceConst.CACHE_USER_SUBSCRIPTION_DATA);
      await setJsonToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
      setLoading(true);
      handleLogoutFromAllOtherDevices(
        loaderOnOff: (isLoading) {
          setLoading(isLoading);
        },
        isLoading: isLoading,
      );
    }).catchError((e) {
      setLoading(false);
      errorSnackBar(error: e);
    }).whenComplete(() {
      setLoading(false);
    });
  }

  ///Get Profile List
  Future<void> getProfileDetail({bool showLoader = true}) async {
    if (isLoggedIn.value) {
      showShimmer(true);
      await getContent(
        showLoader: showLoader,
        contentApiCall: () => CoreServiceApis.getProfileDet(),
        onSuccess: (data) {
          content(data);
          content.refresh();
          accountProfiles.value = data.data.profileList;
          currentSubscription(data.data.planDetails);
          loginUserData.value.firstName = data.data.firstName;
          loginUserData.value.lastName = data.data.lastName;
          loginUserData.value.fullName = data.data.fullName;
          loginUserData.value.email = data.data.email;
          loginUserData.value.mobile = data.data.mobile;
          loginUserData.value.countryCode = data.data.countryCode;
          loginUserData.value.address = data.data.address;
          loginUserData.value.gender = data.data.gender;
          loginUserData.value.dateOfBirth = data.data.dateOfBirth;
          loginUserData.value.profileImage = data.data.profileImage;
          loginUserData.value.planDetails = data.data.planDetails;
          loginUserData.refresh();

          if (currentSubscription.value.level > -1 &&
              currentSubscription.value.planType.isNotEmpty &&
              currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
            isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
          } else {
            isCastingSupported(false);
          }
          currentSubscription.value.activePlanInAppPurchaseIdentifier = isIOS ? currentSubscription.value.appleInAppPurchaseIdentifier : currentSubscription.value.googleInAppPurchaseIdentifier;
          setJsonToLocal(SharedPreferenceConst.CACHE_USER_SUBSCRIPTION_DATA, data.data.planDetails.toJson());
        },
      ).whenComplete(() {
        setLoading(false);
        showShimmer(false);
      });
    }
  }

  ///Get Person Wise Movie List

  Future<void> logoutCurrentUser() async {
    setLoading(true);
    Get.back();

    await AuthServiceApis.deviceLogoutApi(deviceId: currentDevice.value.deviceId).then((value) async {
      isLoggedIn(false);

      await clearAppData();
      final HomeController homeController = Get.find<HomeController>();
      homeController.init(showLoader: true);
      successSnackBar(locale.value.youHaveBeenLoggedOutSuccessfully);
    }).catchError((e) async {
      isLoggedIn(false);
      await clearAppData();
    }).whenComplete(() => setLoading(false));
  }
}