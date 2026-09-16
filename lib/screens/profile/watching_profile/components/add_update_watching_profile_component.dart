import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_toggle_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_update_watching_profile_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

class AddUpdateProfileComponent extends StatelessWidget {
  final VoidCallback? onRefreshCallback;

  AddUpdateProfileComponent({
    super.key,
    required this.addUpdateProfileController,
    this.onRefreshCallback,
  });

  final AddUpdateWatchingProfileController addUpdateProfileController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: addUpdateProfileController.editFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 100,
            child: Center(
              child: PageView.builder(
                controller: addUpdateProfileController.pageController,
                onPageChanged: (page) {
                  addUpdateProfileController.currentIndex(page); // Update the current page index
                  addUpdateProfileController.updateCenterImage(defaultWatchingProfileImage[page]); // Update the center image based on the current page
                },
                itemCount: defaultWatchingProfileImage.length,
                itemBuilder: (context, index) {
                  return Obx(() {
                    int middleIndex = addUpdateProfileController.currentIndex.value;
                    bool isCenter = index == middleIndex;

                    return GestureDetector(
                      onTap: () {
                        if (!isCenter) {
                          addUpdateProfileController.pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: !isCenter ? Get.width * 0.04 : Get.width * 0.04),
                        decoration: boxDecorationDefault(
                          color: cardColor,
                          borderRadius: radius(6),
                        ),
                        child: Opacity(
                          opacity: isCenter ? 1 : 0.4,
                          child: Transform.scale(
                            scale: isCenter ? 1.2 : 1.0,
                            child: CachedImageWidget(
                              url: isCenter && addUpdateProfileController.centerImagePath.value.isNotEmpty ? addUpdateProfileController.centerImagePath.value : defaultWatchingProfileImage[index],
                              fit: BoxFit.cover,
                              radius: 8,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ),
          16.height,
          InkWell(
            borderRadius: radius(8),
            onTap: () {
              addUpdateProfileController.pickProfileImageFromGallery();
            },
            child: Container(
              height: 72,
              width: Get.width,
              decoration: boxDecorationDefault(
                color: cardColor,
                borderRadius: radius(8),
                border: Border.all(color: borderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: btnColor,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: IconWidget(
                      imgPath: Assets.iconsImages,
                      size: 18,
                      color: white,
                    ),
                  ),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        locale.value.gallery,
                        style: commonPrimaryTextStyle(),
                      ),
                      2.height,
                      Text(
                        locale.value.uploadCustomProfileImage,
                        style: commonSecondaryTextStyle(),
                      ),
                    ],
                  ).expand(),
                ],
              ),
            ),
          ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.NAME,
            controller: addUpdateProfileController.nameController,
            isValidationRequired: true,
            textStyle: secondaryTextStyle(color: primaryTextColor),
            maxLength: 12,
            decoration: inputDecoration(
              context,
              hintText: locale.value.enterName,
              contentPadding: const EdgeInsets.only(top: 14),
              prefixIcon: IconWidget(
                imgPath: Assets.iconsUserCircle,
                color: primaryTextColor,
                size: 12,
              ).paddingAll(16),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return locale.value.nameCannotBeEmpty;
              }
              return null;
            },
            onChanged: (p0) {
              addUpdateProfileController.nameController.text = p0;
              addUpdateProfileController.getBtnEnable();
            },
            onFieldSubmitted: (p0) {
              addUpdateProfileController.nameController.text = p0;
              addUpdateProfileController.getBtnEnable();
              hideKeyboard(context);
            },
          ),
          16.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.value.childrenSProfile,
                    style: boldTextStyle(),
                  ),
                  4.height,
                  Text(
                    locale.value.madeForKidsUnder12,
                    style: commonSecondaryTextStyle(),
                  ),
                ],
              ),
              Obx(
                () => ToggleWidget(
                  isSwitched: addUpdateProfileController.isChildrenProfileEnabled.value,
                  onSwitch: (value) {
                    addUpdateProfileController.isChildrenProfileEnabled.value = value;
                  },
                ),
              ),
            ],
          ),
          16.height,
          Obx(
            () => AppButton(
              color: addUpdateProfileController.isBtnEnable.value ? appColorPrimary : lightBtnColor,
              disabledColor: btnColor,
              onTap: () async {
                if (addUpdateProfileController.editFormKey.currentState!.validate()) {
                  addUpdateProfileController.getBtnEnable();
                  Get.back();
                  Get.dialog(
                    const LoaderWidget(isBlurBackground: true),
                    barrierDismissible: false,
                  );

                  await addUpdateProfileController.addProfile().whenComplete(() {
                    if (Get.isDialogOpen == true) {
                      Get.back();
                    }
                    onRefreshCallback?.call();
                  });
                }
              },
              child: Text(
                addUpdateProfileController.isEdit.value ? locale.value.update : locale.value.save,
                style: appButtonTextStyleWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}