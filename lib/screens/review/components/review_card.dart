import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/review/model/review_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel reviewDetail;
  final bool isLoggedInUser;
  final VoidCallback? editCallback;
  final VoidCallback? deleteCallback;

  const ReviewCard({
    super.key,
    required this.reviewDetail,
    this.isLoggedInUser = false,
    this.editCallback,
    this.deleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    if (reviewDetail.review.isEmpty || reviewDetail.rating > -1) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(8),
          color: cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedImageWidget(
                  url: isLoggedInUser
                      ? loginUserData.value.profileImage.isNotEmpty
                          ? loginUserData.value.profileImage
                          : Assets.iconsUserCircle
                      : reviewDetail.profileImage.isNotEmpty
                          ? reviewDetail.profileImage
                          : Assets.iconsUserCircle,
                  height: 40,
                  width: 40,
                  circle: true,
                  fit: BoxFit.cover,
                ),
                12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    2.height,
                    Marquee(
                      child: Text(
                        isLoggedInUser ? loginUserData.value.fullName : reviewDetail.username,
                        style: boldTextStyle(size: 14, color: white),
                      ),
                    ),
                    4.height,
                    if (reviewDetail.rating > -1)
                      Row(
                        children: [
                          const CachedImageWidget(
                            url: Assets.iconsStarFill,
                            height: 10,
                            width: 10,
                            color: yellowColor,
                          ),
                          6.width,
                          Text(
                            "${reviewDetail.rating.toString()} ${locale.value.rating}",
                            style: commonSecondaryTextStyle(size: 12),
                          ),
                        ],
                      ),
                  ],
                ).expand(),
                if (reviewDetail.updatedAt.isNotEmpty)
                  Text(
                    reviewDetail.updatedAt.timeAgo(),
                    style: commonSecondaryTextStyle(color: darkGrayTextColor),
                  ),
              ],
            ),
            if (reviewDetail.review.isNotEmpty) 18.height,
            Row(
              mainAxisAlignment: reviewDetail.review.isNotEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              crossAxisAlignment: reviewDetail.review.isNotEmpty ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (reviewDetail.review.isNotEmpty)
                  readMoreTextWidget(
                    reviewDetail.review,
                    trimLines: 3,
                  ).expand(),
                if (isLoggedInUser)
                  Row(
                    children: [
                      InkWell(
                        splashColor: appColorPrimary.withValues(alpha: 0.4),
                        onTap: () {
                          editCallback?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: boxDecorationDefault(
                            borderRadius: BorderRadius.circular(4),
                            color: cardColor,
                          ),
                          child: IconWidget(
                            imgPath: Assets.iconsPencilSimpleLine,
                            size: 16,
                            color: darkGrayTextColor,
                          ),
                        ),
                      ),
                      12.width,
                      InkWell(
                        splashColor: appColorPrimary.withValues(alpha: 0.4),
                        onTap: () {
                          Get.bottomSheet(
                            AppDialogWidget(
                              imageColor: appColorPrimary,
                              image: Assets.iconsTrash,
                              title: locale.value.doYouWantToDeleteYourReview,
                              onAccept: () {
                                deleteCallback?.call();
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          decoration: boxDecorationDefault(
                            borderRadius: BorderRadius.circular(4),
                            color: cardColor,
                          ),
                          child: IconWidget(
                            imgPath: Assets.iconsTrash,
                            size: 16,
                            color: darkGrayTextColor,
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            )
          ],
        ),
      );
    } else {
      return const Offstage();
    }
  }
}