import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_screen.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class AddUpdateWatchingProfileController extends BaseController {
  RxBool isEdit = false.obs;
  RxBool isChildrenProfileEnabled = false.obs;
  RxBool isBtnEnable = false.obs;
  RxInt currentIndex = 2.obs; // To track the middle index dynamically
  RxString centerImagePath = ''.obs;

  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  Rx<WatchingProfileModel> selectedProfile = WatchingProfileModel().obs;

  PageController pageController = PageController(
    initialPage: 2,
    viewportFraction: 0.30,
  );

  void init(WatchingProfileModel profile) {
    isEdit(true);
    selectedProfile(profile);
    nameController.text = profile.name;
    centerImagePath(profile.avatar);
    if (profile.avatar.isNotEmpty) {
      defaultWatchingProfileImage.insert(2, profile.avatar);
    }
    isChildrenProfileEnabled(profile.isChildProfile.getBoolInt());
  }

  void getBtnEnable() {
    if (nameController.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }

  void updateCenterImage(String imagePath) {
    centerImagePath.value = imagePath;
  }

  /// Pick custom profile image from gallery only (camera restricted)
  Future<void> pickProfileImageFromGallery() async {
    await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800).then((pickedFile) {
      if (pickedFile != null) {
        centerImagePath.value = pickedFile.path;

        final index = currentIndex.value;
        if (index >= 0 && index < defaultWatchingProfileImage.length) {
          defaultWatchingProfileImage[index] = pickedFile.path;
        }
      }
    });
  }

  Future<void> addProfile() async {
    Map<String, dynamic> request = {
      "name": nameController.text,
      "is_child_profile": isChildrenProfileEnabled.value ? 1 : 0,
      ApiRequestKeys.userIdKey: loginUserData.value.id,
    };

    if (selectedProfile.value.id > 0) request.putIfAbsent(ApiRequestKeys.idKey, () => selectedProfile.value.id);

    try {
      await CoreServiceApis.updateWatchProfile(request: request, imageFile: centerImagePath.value).then((value) async {
        successSnackBar(selectedProfile.value.id > 0 ? locale.value.profileUpdatedSuccessfully : locale.value.newProfileAddedSuccessfully);
        clearData();
        accountProfiles.value = value.data;
        accountProfiles.refresh();
      });
    } catch (e) {
      if (e is Map<String, dynamic>) {
        errorSnackBar(error: e);
        if (e['status_code'] == 406) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false);
            },
          );
        }
      } else {
        errorSnackBar(error: e);
      }
      rethrow;
    }
  }

  Future<void> deleteUserProfile() async {
    if (isLoading.value || selectedProfile.value.id < 0) return;
    Map<String, dynamic> request = {ApiRequestKeys.profileIdKey: selectedProfile.value.id};
    await CoreServiceApis.deleteWatchingProfile(request: request).then((value) async {
      accountProfiles.removeWhere((element) => element.id == selectedProfile.value.id);
      await Future.delayed(Duration(milliseconds: 500));
      successSnackBar(locale.value.profileDeletedSuccessfully);
      accountProfiles.refresh();
      if (selectedAccountProfile.value.id == selectedProfile.value.id) {
        Get.offAll(() => WatchingProfileScreen());
      }

      clearData();
    }).catchError((e) {
      errorSnackBar(error: e);
    });
  }

  void clearData() {
    isEdit(false);
    selectedProfile(WatchingProfileModel());
    nameController.clear();
    isChildrenProfileEnabled(false);
    centerImagePath.value = '';

    // Reset watching profile avatar options back to defaults
    defaultWatchingProfileImage
      ..clear()
      ..addAll(defaultWatchingProfileBaseImages);
  }
}