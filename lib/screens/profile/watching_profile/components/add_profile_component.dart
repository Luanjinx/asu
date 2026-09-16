import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_update_watching_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_update_watching_profile_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

class AddProfileComponent extends StatelessWidget {
  final double size;
  final bool isEdit;
  final Function(bool isEditOn)? onEditSelectionUpdate;
  final Future<void> Function()? onRefreshCallback;

  AddProfileComponent({
    super.key,
    required this.size,
    this.isEdit = false,
    this.onEditSelectionUpdate,
    this.onRefreshCallback,
  });

  final RxBool isEditEnabled = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isEdit) {
          AddUpdateWatchingProfileController addUpdateWatchingProfileController = Get.find<AddUpdateWatchingProfileController>();
          Get.bottomSheet(
            AppDialogWidget(
              child: AddUpdateProfileComponent(
                addUpdateProfileController: addUpdateWatchingProfileController,
                onRefreshCallback: () async {
                  isEditEnabled(false);
                  if (onEditSelectionUpdate != null) onEditSelectionUpdate!(false);
                  if (onRefreshCallback != null) {
                    await onRefreshCallback!();
                  }
                },
              ),
            ),
            isScrollControlled: true,
          );
        } else {
          isEditEnabled(!isEditEnabled.value);
          if (onEditSelectionUpdate != null) onEditSelectionUpdate!(isEditEnabled.value);
        }
      },
      child: Container(
        height: size,
        width: size,
        decoration: boxDecorationDefault(
          borderRadius: radius(defaultRadius),
          color: cardColor,
          border: Border.all(color: borderColor),
        ),
        child: Column(
          spacing: 6,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: btnColor,
              ),
              padding: const EdgeInsets.all(6),
              child: const CachedImageWidget(
                url: Assets.iconsPlus,
                height: 16,
                width: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}