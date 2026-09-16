import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class UserProfileComponent extends StatelessWidget {
  final RxBool isLoading;

  final RxBool isEditEnabled = false.obs;

  UserProfileComponent({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.value.profile, style: commonSecondaryTextStyle()),
            Obx(
              () => selectedAccountProfile.value.isChildProfile.getBoolInt()
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        isEditEnabled(!isEditEnabled.value);
                      },
                      child: Obx(
                        () => TextIcon(
                          text: isEditEnabled.value ? locale.value.close : locale.value.edit,
                          textStyle: boldTextStyle(size: 14, color: secondaryTextColor),
                          prefix: IconWidget(
                            imgPath: isEditEnabled.value ? Assets.iconsX : Assets.iconsPencilSimpleLine,
                            color: iconColor,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
        Obx(
          () {
            if (isLoading.value) {
              return HorizontalList(
                runSpacing: 12,
                spacing: 12,
                padding: EdgeInsets.zero,
                wrapAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ShimmerWidget(
                    radius: 8,
                    height: dynamicSpacing.$1,
                    width: dynamicSpacing.$1,
                  );
                },
              );
            } else {
              return Obx(
                () => HorizontalList(
                  runSpacing: 12,
                  spacing: 12,
                  padding: EdgeInsets.zero,
                  itemCount: accountProfiles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Obx(
                        () => selectedAccountProfile.value.isChildProfile.getBoolInt()
                            ? const SizedBox.shrink()
                            : AddProfileComponent(
                                size: dynamicSpacing.$1,
                                onEditSelectionUpdate: (isEditOn) {
                                  isEditEnabled(isEditOn);
                                },
                              ),
                      );
                    }
                    WatchingProfileModel profile = accountProfiles[index - 1];
                    return Obx(
                      () {
                        return ProfileComponent(
                          profile: profile,
                          imageSize: dynamicSpacing.$1,
                          showDelete: accountProfiles.where((element) => element.isChildProfile == 0).length > 1,
                          isEdit: isEditEnabled.value,
                          onSelectedProfile: () {
                            final DashboardController dashboardController = Get.find<DashboardController>();
                            dashboardController.addDataOnBottomNav();
                            dashboardController.currentIndex(0);

                            final HomeController homeController = Get.find<HomeController>();
                            homeController.init(showLoader: true);
                            Get.offAll(() => DashboardScreen());
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }
          },
        )
      ],
    );
  }
}