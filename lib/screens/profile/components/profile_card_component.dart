import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/screens/profile/edit_profile/edit_profile_screen.dart';
import 'package:streamit_laravel/screens/profile/model/profile_detail_resp.dart';
import 'package:streamit_laravel/screens/profile/profile_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../generated/assets.dart';

class ProfileCardComponent extends StatelessWidget {
  final ProfileModel profileInfo;

  const ProfileCardComponent({super.key, required this.profileInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(14),
      decoration: boxDecorationDefault(
        color: cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            url: profileInfo.profileImage.isEmptyOrNull ? Assets.iconsUserCircle : profileInfo.profileImage,
            height: 52,
            width: 52,
            circle: true,
            fit: BoxFit.cover,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Marquee(
                child: Text(
                  profileInfo.fullName,
                  style: boldTextStyle(),
                ),
              ),
              6.height,
              if (profileInfo.email.isEmptyOrNull)
                const Offstage()
              else
                Row(
                  children: [
                    const CachedImageWidget(
                      url: Assets.iconsEnvelopeSimple,
                      height: 10,
                      width: 10,
                      color: darkGrayTextColor,
                    ).paddingTop(2),
                    6.width,
                    Text(
                      profileInfo.email,
                      style: commonSecondaryTextStyle(size: 12),
                    ),
                  ],
                ),
              2.height,
              if (profileInfo.mobile.isEmptyOrNull)
                const Offstage()
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CachedImageWidget(
                      url: Assets.iconsPhone,
                      height: 10,
                      width: 10,
                      color: darkGrayTextColor,
                    ).paddingTop(2),
                    6.width,
                    Text(
                      profileInfo.mobile,
                      style: commonSecondaryTextStyle(
                        size: 12,
                        color: darkGrayTextColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Get.to(() => EditProfileScreen(), arguments: profileInfo)?.then((value) {
                final ProfileController controller = Get.find<ProfileController>();
                controller.getProfileDetail(showLoader: false);
              });
            },
            icon: const Icon(
              Icons.edit,
              size: 16,
              color: appColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}