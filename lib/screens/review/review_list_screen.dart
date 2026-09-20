import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/components/rating_summary_card.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/review/components/review_card.dart';
import 'package:streamit_laravel/screens/review/model/review_model.dart';
import 'package:streamit_laravel/screens/review/review_list_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class ReviewComponent extends StatelessWidget {
  final ContentDetailsController controller;

  const ReviewComponent({super.key, required this.controller});

  void _navigateToReviewList() {
    if (controller.showTrailer.value) {
      controller.removeTrailerControllerIfAlreadyExist(controller.currentTrailerData.value.id);
    }
    final details = controller.content.value!.details;
    Get.to(
      () => ReviewListScreen(
        movieName: details.name,
        contentType: details.type,
        posterImage: details.thumbnailImage,
        averageRating: double.tryParse(details.imdbRating) ?? 0.0,
        totalReviews: controller.content.value!.reviews?.totalReviews ?? 0,
      ),
      arguments: ArgumentModel(intArgument: controller.content.value!.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.content.value == null ||
            (controller.content.value != null &&
                (controller.content.value!.details.type == VideoType.video ||
                    controller.content.value!.details.type == VideoType.episode))) {
          return const Offstage();
        }
        final hasReviews = controller.content.value!.isReviewAvailable;
        final details = controller.content.value!.reviews;
        final myReview = details?.myReview;
        final otherReviews = details?.otherReviewList;

        List<ReviewModel> allReviews = [];
        if (myReview != null) allReviews.add(myReview);
        if (otherReviews != null) allReviews.addAll(otherReviews);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: boxDecorationDefault(
            color: context.cardColor,
            borderRadius: radius(12),
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Ratings & Reviews', style: boldTextStyle(size: 18)),
                  if (hasReviews)
                    InkWell(
                      onTap: _navigateToReviewList,
                      borderRadius: radius(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: appColorPrimary),
                          borderRadius: radius(24),
                        ),
                        child: Text('Write a Review', style: boldTextStyle(size: 12, color: appColorPrimary)),
                      ),
                    ),
                ],
              ),
              if (hasReviews)
                RatingSummaryCard(
                  averageRating: double.tryParse(controller.content.value!.details.imdbRating) ?? 0.0,
                  totalReviews: details?.totalReviews ?? 0,
                  reviews: allReviews,
                  isLoggedIn: isLoggedIn.value,
                  onRateAction: _navigateToReviewList,
                ),
              if (hasReviews && allReviews.isNotEmpty) ...[
                Divider(color: textSecondaryColorGlobal.withOpacity(0.2)),
                ReviewCard(
                  reviewDetail: allReviews.first,
                  isLoggedInUser: allReviews.first.userId == loginUserData.value.id,
                  editCallback: _navigateToReviewList,
                  deleteCallback: () {
                    controller.deleteReview();
                  },
                ),
                Divider(color: textSecondaryColorGlobal.withOpacity(0.2)),
                InkWell(
                  onTap: _navigateToReviewList,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Text('See All Reviews >', style: boldTextStyle(color: textSecondaryColorGlobal, size: 14)),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget reviewForm(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            controller.isEditReview(false);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.content.value!.details.type == VideoType.tvshow
                    ? locale.value.rateThisTvShow
                    : locale.value.rateThisMovie,
                style: boldTextStyle(),
              ),
              if (controller.isEditReview.value)
                IconWidget(
                  imgPath: Assets.iconsX,
                  size: 16,
                ),
            ],
          ),
        ),
        Obx(
          () => RatingBarWidget(
            size: 18,
            allowHalfRating: true,
            activeColor: goldColor,
            inActiveColor: darkGrayTextColor,
            rating: controller.userRating.value,
            spacing: 8,
            onRatingChanged: (rating) {
              controller.userRating(rating);
            },
          ),
        ),
        AppTextField(
          controller: controller.userReviewCont,
          textFieldType: TextFieldType.MULTILINE,
          minLines: 3,
          maxLines: 5,
          decoration: inputDecoration(
            context,
            hintText: locale.value.shareYourThoughtsOnContent(
              controller.content.value!.details.name,
              controller.content.value!.details.type.getContentTypeTitleSingular(),
            ),
            contentPadding: const EdgeInsetsDirectional.all(12),
          ),
        ),
        4.height,
        AppButton(
          text: locale.value.submit,
          disabledColor: btnColor,
          enabled: controller.userRating.value > 0 || controller.userReviewCont.text.isNotEmpty,
          width: double.infinity,
          color: appColorPrimary,
          onTap: () {
            if (controller.isLoading.value) return;
            if (controller.showTrailer.value) {
              controller.removeTrailerControllerIfAlreadyExist(controller.currentTrailerData.value.id);
            }
            doIfLogin(
              onLoggedIn: () {
                if (isLoggedIn.value) {
                  hideKeyboard(context);
                  controller.saveReview();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
