// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/country_picker/country_list.dart';
import 'package:streamit_laravel/utils/country_picker/country_utils.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';
import 'package:streamit_laravel/utils/gender.dart';

import '../../../../main.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_base.dart';
import '../../../../utils/common_functions.dart';
import '../edit_profile_controller.dart';

class EditFormFieldComponent extends StatelessWidget {
  EditFormFieldComponent({super.key});

  final EditProfileController profileCont = Get.isRegistered<EditProfileController>() ? Get.find<EditProfileController>() : Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: profileCont.editProfileFormKey,
      child: AnimatedWrap(
        runSpacing: 16,
        listAnimationType: commonListAnimationType,
        children: [
          24.height,
          Obx(
            () => Row(
              children: [
                IgnorePointer(
                  ignoring: loginUserData.value.loginType == LoginTypeConst.loginTypeOTP,
                  child: GestureDetector(
                    onTap: () {
                      profileCont.changeCountry(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                      decoration: boxDecorationDefault(
                        borderRadius: BorderRadiusDirectional.circular(4),
                        border: Border.all(color: borderColor, width: 0.5),
                        color: cardColor,
                      ),
                      child: Row(
                        spacing: 6,
                        children: [
                          Text(profileCont.selectedCountry.value.flagEmoji, style: commonPrimaryTextStyle(size: 20)),
                          Text(profileCont.countryCode.value.prefixText(value: '+'), style: commonPrimaryTextStyle()),
                          IconWidget(imgPath: Assets.iconsCaretDown, color: iconColor),
                        ],
                      ),
                    ),
                  ),
                ),
                16.width,
                AppTextField(
                  textStyle: commonPrimaryTextStyle(),
                  controller: profileCont.mobileNoCont,
                  textFieldType: TextFieldType.PHONE,
                  cursorColor: white,
                  nextFocus: profileCont.firstNameFocus,
                  maxLength: getValidPhoneNumberLength(CountryModel.fromJson(profileCont.selectedCountry.value.toJson())),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  readOnly: loginUserData.value.loginType == LoginTypeConst.loginTypeOTP,
                  validator: (mobileCont) {
                    if (mobileCont == null || mobileCont.isEmpty) {
                      return locale.value.mobileNumberIsRequired;
                    }
                    return null;
                  },
                  decoration: inputDecoration(
                    context,
                    contentPadding: const EdgeInsets.only(top: 14),
                    hintText: locale.value.mobileNumber,
                    prefixIcon: IconWidget(
                      imgPath: Assets.iconsPhone,
                      color: iconColor,
                      size: 12,
                    ).paddingAll(14),
                  ),
                  onChanged: (value) {
                    profileCont.onBtnEnable();
                  },
                ).expand(flex: 3),
              ],
            ),
          ),
          AppTextField(
            textStyle: commonPrimaryTextStyle(),
            controller: profileCont.firstNameCont,
            focus: profileCont.firstNameFocus,
            nextFocus: profileCont.lastNameFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: white,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return locale.value.firstNameIsRequiredField;
              }
              return null;
            },
            decoration: inputDecoration(
              context,
              contentPadding: const EdgeInsets.only(top: 14),
              hintText: locale.value.firstName,
              prefixIcon: IconWidget(
                imgPath: Assets.iconsUserCircle,
                color: iconColor,
                size: 12,
              ).paddingAll(16),
            ),
            onChanged: (value) {
              profileCont.onBtnEnable();
            },
          ),
          AppTextField(
            textStyle: commonPrimaryTextStyle(),
            controller: profileCont.lastNameCont,
            focus: profileCont.lastNameFocus,
            nextFocus: profileCont.emailFocus,
            textFieldType: TextFieldType.NAME,
            cursorColor: white,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return locale.value.lastNameIsRequiredField;
              }
              return null;
            },
            decoration: inputDecoration(
              context,
              contentPadding: const EdgeInsets.only(top: 14),
              hintText: locale.value.lastName,
              prefixIcon: IconWidget(
                imgPath: Assets.iconsUserCircle,
                color: iconColor,
                size: 12,
              ).paddingAll(16),
            ),
            onChanged: (value) {
              profileCont.onBtnEnable();
            },
          ),
          AppTextField(
            textStyle: commonPrimaryTextStyle(),
            controller: profileCont.emailCont,
            focus: profileCont.emailFocus,
            nextFocus: profileCont.mobileNoFocus,
            textFieldType: TextFieldType.EMAIL_ENHANCED,
            readOnly: loginUserData.value.loginType == LoginTypeConst.loginTypeApple || loginUserData.value.loginType == LoginTypeConst.loginTypeGoogle,
            cursorColor: white,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return locale.value.pleaseEnterValidEmailAddress;
              } else if (!value.isValidEmail()) {
                return locale.value.pleaseEnterValidEmailAddress;
              }
              return null;
            },
            decoration: inputDecoration(
              context,
              contentPadding: const EdgeInsets.only(top: 14),
              hintText: locale.value.email,
              prefixIcon: IconWidget(
                imgPath: Assets.iconsEnvelopeSimple,
                color: iconColor,
                size: 12,
              ).paddingAll(15),
            ),
            onChanged: (value) {
              profileCont.onBtnEnable();
            },
          ),
          AppTextField(
            textStyle: commonPrimaryTextStyle(),
            controller: profileCont.addressCont,
            textFieldType: TextFieldType.MULTILINE,
            cursorColor: white,
            minLines: 4,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '${locale.value.address} ${locale.value.firstNameIsRequiredField.replaceAll("First name", "").trim()}';
              }
              return null;
            },
            decoration: inputDecoration(
              context,
              contentPadding: const EdgeInsets.only(top: 14),
              hintText: locale.value.address,
              prefixIcon: IconWidget(
                imgPath: Assets.iconsMapPin,
                color: iconColor,
                size: 12,
              ).paddingAll(15),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor),
              color: cardColor,
            ),
            child: Row(
              children: [
                IconWidget(
                  imgPath: Assets.iconsGender,
                  color: iconColor,
                  size: 20,
                ),
                10.width,
                _genderTile(Gender.male, locale.value.male, Icons.male),
                10.width,
                _genderTile(Gender.female, locale.value.female, Icons.female),
                10.width,
                _genderTile(Gender.other, locale.value.other, Icons.transgender),
              ],
            ),
          ),
          AppTextField(
            textStyle: commonPrimaryTextStyle(),
            controller: profileCont.dateOfBirthCont,
            readOnly: true,
            textFieldType: TextFieldType.OTHER,
            onTap: () => onDateOfBirthTap(context),
            cursorColor: white,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return locale.value.dateOfBirthRequired;
              }
              return null;
            },
            decoration: inputDecoration(
              context,
              contentPadding: const EdgeInsets.only(top: 14),
              hintText: locale.value.dateOfBirth,
              prefixIcon: IconWidget(
                imgPath: Assets.iconsCalendar,
                color: iconColor,
                size: 12,
              ).paddingAll(15),
            ),
          ),
          40.height,
          Obx(
            () => AppButton(
              width: double.infinity,
              text: locale.value.update,
              color: profileCont.isBtnEnable.isTrue ? appColorPrimary : cardColor,
              textStyle: appButtonTextStyleWhite,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                if (profileCont.editProfileFormKey.currentState!.validate()) {
                  profileCont.updateProfile();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void update(Gender value) {
    profileCont.gender.value = value;
  }

  Widget _genderTile(Gender value, String label, IconData icon) {
    return Obx(() {
      final bool isSelected = profileCont.gender.value == value;
      return InkWell(
        onTap: () => update(value),
        child: Row(
          children: [
            Radio<Gender>(
              value: value,
              groupValue: profileCont.gender.value,
              onChanged: (v) => update(v!),
              activeColor: appColorPrimary,
              fillColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return appColorPrimary;
                }
                return borderColor;
              }),
              visualDensity: VisualDensity.compact,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    });
  }

  dynamic onDateOfBirthTap(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFB00020),
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      profileCont.dateOfBirthCont.text = DateFormat('yyyy-MM-dd').format(date);
    }
  }
}