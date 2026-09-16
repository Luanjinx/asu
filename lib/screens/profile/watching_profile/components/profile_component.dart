import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/profile/components/delete_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_update_watching_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_update_watching_profile_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_pin_component.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../model/profile_watching_model.dart';

class ProfileComponent extends StatelessWidget {
  final WatchingProfileModel profile;
  final bool isEdit;
  final bool showDelete;
  final bool showEdit;
  final double? height;
  final double? width;
  final double imageSize;
  final VoidCallback? onRefreshCallback;
  final VoidCallback? onSelectedProfile;

  const ProfileComponent({
    super.key,
    required this.profile,
    this.showDelete = false,
    this.height,
    this.width,
    required this.imageSize,
    this.isEdit = false,
    this.onRefreshCallback,
    this.onSelectedProfile,
    this.showEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (profile.id != selectedAccountProfile.value.id) {
          if (profile.isProfileProtected && (selectedAccountProfile.value.isChildProfile.getBoolInt() || selectedAccountProfile.value.id < 0)) {
            Get.bottomSheet(
              isScrollControlled: true,
              enableDrag: false,
              AppDialogWidget(
                child: ProfilePinComponent(
                  profilePin: profile.profilePin,
                  onVerificationCompleted: () {
                    selectedAccountProfile(profile);
                    onSelectedProfile?.call();
                  },
                  buttonText: locale.value.verifyPin,
                ),
              ),
            );
          } else {
            selectedAccountProfile(profile);
            onSelectedProfile?.call();
          }
          removeProfileSpecificData();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Container(
            height: imageSize,
            width: imageSize,
            decoration: boxDecorationDefault(
              borderRadius: radius(selectedAccountProfile.value.id == profile.id ? 10 : defaultRadius),
              color: cardColor,
              border: Border.all(color: selectedAccountProfile.value.id == profile.id ? yellowColor : borderColor, width: selectedAccountProfile.value.id == profile.id ? 2 : 1),
            ),
            child: Stack(
              children: [
                CachedImageWidget(
                  url: profile.avatar,
                  fit: BoxFit.cover,
                  width: Get.width,
                  height: imageSize,
                  radius: defaultRadius,
                  firstName: profile.name,
                ),
                if (profile.isChildProfile.getBoolInt())
                  PositionedDirectional(
                    top: 4,
                    start: 4,
                    child: CachedImageWidget(
                      url: Assets.iconsKids,
                      fit: BoxFit.cover,
                      width: 24,
                      height: 24,
                      radius: defaultRadius,
                    ),
                  ),
                Row(
                  spacing: 6,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showEdit)
                      InkWell(
                        onTap: () {
                          final AddUpdateWatchingProfileController updateWatchingController = Get.find<AddUpdateWatchingProfileController>();
                          updateWatchingController.init(profile);
                          if (appParentalLockEnabled.value) {
                            Get.bottomSheet(
                              isScrollControlled: true,
                              enableDrag: false,
                              AppDialogWidget(
                                child: ProfilePinComponent(
                                  profilePin: profile.profilePin,
                                  onVerificationCompleted: () {
                                    Get.bottomSheet(
                                      AppDialogWidget(
                                        child: AddUpdateProfileComponent(
                                          addUpdateProfileController: updateWatchingController,
                                          onRefreshCallback: () {
                                            onRefreshCallback?.call();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  buttonText: profile.isChildProfile.getBoolInt() ? null : locale.value.verifyPin,
                                ),
                              ),
                            );
                          } else {
                            Get.bottomSheet(
                              AppDialogWidget(
                                child: AddUpdateProfileComponent(
                                  addUpdateProfileController: updateWatchingController,
                                  onRefreshCallback: () {
                                    onRefreshCallback?.call();
                                  },
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: btnColor,
                          ),
                          child: const CachedImageWidget(
                            url: Assets.iconsPencilSimpleLine,
                            color: Colors.white,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      ),
                    if (showDelete || profile.isChildProfile.getBoolInt())
                      InkWell(
                        onTap: () {
                          final AddUpdateWatchingProfileController updateWatchingController = Get.find<AddUpdateWatchingProfileController>();
                          updateWatchingController.init(profile);
                          Get.bottomSheet(
                            isDismissible: true,
                            isScrollControlled: true,
                            enableDrag: false,
                            AppDialogWidget(
                              child: DeleteProfileComponent(
                                profileName: updateWatchingController.selectedProfile.value.name,
                                onDeleteAccount: () async {
                                  Get.back();
                                  Get.dialog(
                                    const LoaderWidget(isBlurBackground: true),
                                    barrierDismissible: false,
                                  );
                                  await updateWatchingController.deleteUserProfile().whenComplete(() {
                                    if (Get.isDialogOpen == true) {
                                      Get.back();
                                    }
                                    onRefreshCallback?.call();
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: btnColor,
                          ),
                          child: const CachedImageWidget(
                            url: Assets.iconsTrash,
                            color: Colors.white,
                            height: 16,
                            width: 16,
                          ),
                        ),
                      )
                  ],
                ).center().visible(isEdit),
              ],
            ),
          ),
          Marquee(
            child: Text(
              profile.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: commonW500PrimaryTextStyle(size: 14),
            ),
          ),
        ],
      ),
    );
  }
}