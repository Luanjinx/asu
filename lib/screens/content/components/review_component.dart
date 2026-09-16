import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/review/components/review_card.dart';
import 'package:streamit_laravel/screens/review/review_list_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class ReviewComponent extends StatelessWidget {
  final ContentDetailsController controller;

  const ReviewComponent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.content.value == null ||
            (controller.content.value != null && (controller.content.value!.details.type == VideoType.video || controller.content.value!.details.type == VideoType.episode))) return const Offstage();
        final hasReviews = controller.content.value!.isReviewAvailable;
        final details = controller.content.value!.reviews;
        final myReview = details?.myReview;
        final otherReviews = details?.otherReviewList;

        return Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasReviews) ...[
              if (controller.isEditReview.value || myReview == null)
                reviewForm(context)
              else ...[
                viewAllWidget(
                  label: locale.value.yourReview,
                  showViewAll: false,
                  labelSize: 16,
                  isSymmetricPaddingEnable: false,
                ),
                if (!controller.isEditReview.value)
                  ReviewCard(
                    reviewDetail: myReview,
                    isLoggedInUser: true,
                    editCallback: () {
                      controller.openReviewDialog();
                      controller.isEditReview(true);
                    },
                    deleteCallback: () {
                      controller.deleteReview();
                    },
                  ),
              ]
            ],
            4.height,
            if (hasReviews && otherReviews.validate().isNotEmpty) ...[
              viewAllWidget(
                label: locale.value.reviews,
                showViewAll: details!.totalReviews > 3,
                labelSize: 16,
                isSymmetricPaddingEnable: false,
                onButtonPressed: () {
                  if (controller.showTrailer.value) {
                    controller.removeTrailerControllerIfAlreadyExist(controller.currentTrailerData.value.id);
                  }
                  Get.to(
                    () => ReviewListScreen(
                      movieName: controller.content.value!.details.name,
                      contentType: controller.content.value!.details.type,
                    ),
                    arguments: ArgumentModel(intArgument: controller.content.value!.id),
                  );
                },
              ),
              AnimatedWrap(
                runSpacing: 12,
                spacing: 12,
                listAnimationType: commonListAnimationType,
                itemCount: otherReviews.validate().length,
                // Show max 3
                itemBuilder: (context, index) {
                  return ReviewCard(reviewDetail: otherReviews.validate()[index]);
                },
              ),
            ],
          ],
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
              Text(controller.content.value!.details.type == VideoType.tvshow ? locale.value.rateThisTvShow : locale.value.rateThisMovie, style: boldTextStyle()),
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
            hintText: locale.value.shareYourThoughtsOnContent(controller.content.value!.details.name, controller.content.value!.details.type.getContentTypeTitleSingular()),
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
            if (controller.showTrailer.value) controller.removeTrailerControllerIfAlreadyExist(controller.currentTrailerData.value.id);
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