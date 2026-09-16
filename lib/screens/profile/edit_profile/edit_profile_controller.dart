import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/country_picker/country_code.dart';
import 'package:streamit_laravel/utils/gender.dart';

import '../../../main.dart';

class EditProfileController extends BaseController {
  RxBool isBtnEnable = false.obs;
  final GlobalKey<FormState> editProfileFormKey = GlobalKey();

  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCont = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController mobileNoCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController dateOfBirthCont = TextEditingController();
  Rx<Gender> gender = Gender.male.obs;

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode mobileNoFocus = FocusNode();

  RxString profilePic = "".obs;
  RxString imageFile = "".obs;
  Rx<Country> selectedCountry = defaultCountry.obs;
  RxString countryCode = defaultCountry.phoneCode.obs;

  RxBool isPicLoading = false.obs;

  @override
  onReady() {
    init();
  }

  void init() {
    profilePic(loginUserData.value.profileImage);
    mobileNoCont.text = loginUserData.value.mobile.trim();
    final Country resolvedCountry = resolveCountryByDialCode(loginUserData.value.countryCode);
    selectedCountry(resolvedCountry);
    countryCode(resolvedCountry.phoneCode);
    mobileNoCont.text = mobileNoCont.text.replaceFirst('+', '').replaceFirst(countryCode.value, '');

    firstNameCont.text = loginUserData.value.firstName;
    lastNameCont.text = loginUserData.value.lastName;
    emailCont.text = loginUserData.value.email;
    addressCont.text = loginUserData.value.address;
    dateOfBirthCont.text = loginUserData.value.dateOfBirth;
    gender.value = Gender.fromString(loginUserData.value.gender);

    isBtnEnable(true);
  }

  void onBtnEnable() {
    if (firstNameCont.text == loginUserData.value.firstName &&
        lastNameCont.text == loginUserData.value.lastName &&
        emailCont.text == loginUserData.value.email &&
        mobileNoCont.text == loginUserData.value.mobile &&
        imageFile.value.isEmpty) {
      isBtnEnable(false);
    } else {
      isBtnEnable(true);
    }
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

  Future<void> _handleGalleryClick() async {
    isPicLoading(true);
    Navigator.pop(Get.context!);
    await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800).then(
      (pickedFile) {
        if (pickedFile != null) {
          imageFile(pickedFile.path);
        }
      },
    );

    onBtnEnable();
    isPicLoading(false);
  }

  Future<void> _handleCameraClick() async {
    isPicLoading(true);
    Get.back();
    await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800).then(
      (pickedFile) {
        if (pickedFile != null) {
          imageFile(pickedFile.path);
        }
      },
    );
    onBtnEnable();
    isPicLoading(false);
  }

  void chooseImageSource(BuildContext context) {
    Get.bottomSheet(
      AppDialogWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SettingItemWidget(
              subTitleTextStyle: commonSecondaryTextStyle(),
              splashColor: appScreenBackgroundDark,
              highlightColor: appScreenBackgroundDark,
              hoverColor: appScreenBackgroundDark,
              title: locale.value.gallery,
              leading: IconWidget(imgPath: Assets.iconsImages, color: white),
              titleTextColor: white,
              onTap: () async {
                _handleGalleryClick();
              },
            ),
            SettingItemWidget(
              subTitleTextStyle: commonSecondaryTextStyle(),
              title: locale.value.camera,
              leading: IconWidget(imgPath: Assets.iconsCamera, color: white),
              titleTextColor: white,
              onTap: () {
                _handleCameraClick();
              },
              splashColor: appScreenBackgroundDark,
              highlightColor: appScreenBackgroundDark,
              hoverColor: appScreenBackgroundDark,
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> updateProfile() async {
    if (isLoading.value) return;
    setLoading(true);
    final Map<String, dynamic> profileRequest = {
      ApiRequestKeys.idKey: loginUserData.value.id,
      ApiRequestKeys.firstName: firstNameCont.value.text,
      ApiRequestKeys.lastName: lastNameCont.value.text,
      ApiRequestKeys.mobile: '+${countryCode.value}${mobileNoCont.text.trim()}',
      ApiRequestKeys.countryCode: countryCode.value,
      ApiRequestKeys.email: emailCont.value.text,
      ApiRequestKeys.gender: gender.value.name,
      ApiRequestKeys.address: addressCont.text.trim(),
      ApiRequestKeys.dateOfBirth: dateOfBirthCont.text.trim(),
    };

    await AuthServiceApis.updateProfile(request: profileRequest, imageFile: imageFile.value).then((value) {
      successSnackBar(locale.value.profileUpdatedSuccessfully);
      loginUserData.value.firstName = value.data.firstName;
      loginUserData.value.lastName = value.data.lastName;
      loginUserData.value.fullName = value.data.fullName;
      loginUserData.value.email = value.data.email;
      loginUserData.value.mobile = value.data.mobile;
      loginUserData.value.profileImage = value.data.profileImage;
      loginUserData.value.dateOfBirth = value.data.dateOfBirth;
      loginUserData.value.gender = value.data.gender;
      loginUserData.value.address = value.data.address;
      loginUserData.value.countryCode = value.data.countryCode;
      final Country resolvedCountry = resolveCountryByDialCode(loginUserData.value.countryCode);
      selectedCountry(resolvedCountry);
      setJsonToLocal(SharedPreferenceConst.USER_DATA, loginUserData.value.toJson());
      loginUserData.refresh();
      Navigator.pop(Get.context!, true);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    firstNameCont.clear();
    lastNameCont.clear();
    emailCont.clear();
    mobileNoCont.clear();
    imageFile('');
    super.onClose();
  }
}