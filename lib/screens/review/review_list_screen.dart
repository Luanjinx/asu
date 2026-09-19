import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/review/components/review_card.dart';
import 'package:streamit_laravel/screens/review/review_list_controller.dart';
import 'package:streamit_laravel/screens/review/shimmer_review_list/shimmer_review_list.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import 'model/review_model.dart';

import 'package:streamit_laravel/screens/content/components/rating_summary_card.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_screen.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';

class ReviewListScreen extends StatelessWidget {
  final String movieName;
  final String contentType;
  final String? posterImage;
  final double averageRating;
  final int totalReviews;

  ReviewListScreen({
    super.key,
    required this.movieName,
    required this.contentType,
    this.posterImage,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  final ReviewListController reviewCont = Get.find<ReviewListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewAppScaffold(
        scrollController: reviewCont.scrollController,
        currentPage: reviewCont.currentPage,
        isLoading: (reviewCont.isLoading.value).obs,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        onRefresh: reviewCont.onRefresh,
        appBarTitleText: 'Rating & Review',
        fabWidget: FloatingActionButton(
          onPressed: () {
            if (isLoggedIn.value) {
              reviewCont.onReviewCheck();
              reviewCont.isEdit(false);
              Get.bottomSheet(
                AppDialogWidget(
                  child: editReviewDialog(context),
                ),
                isScrollControlled: true,
              );
            } else {
              Get.to(() => SignInScreen());
            }
          },
          backgroundColor: appColorPrimary,
          child: const Icon(Icons.add, color: white),
        ),
        body: Obx(
          () => SnapHelperWidget(
            future: reviewCont.listContentFuture.value,
            loadingWidget: ShimmerReviewList(),
            errorBuilder: (error) {
              return AppNoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: reviewCont.onRetry,
              );
            },
            onSuccess: (res) {
              return Obx(
                () {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              if (posterImage != null && posterImage!.isNotEmpty)
                                ClipRRect(
                                  borderRadius: radius(8),
                                  child: CachedImageWidget(
                                    url: posterImage!,
                                    height: 80,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              12.width,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(movieName, style: boldTextStyle(size: 18)),
                                    4.height,
                                    Text('Ratings & Reviews', style: secondaryTextStyle(size: 14)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Rating Summary Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: RatingSummaryCard(
                            averageRating: averageRating,
                            totalReviews: totalReviews,
                            reviews: reviewCont.listContent,
                            isLoggedIn: isLoggedIn.value,
                            onRateAction: () {
                              if (isLoggedIn.value) {
                                reviewCont.onReviewCheck();
                                reviewCont.isEdit(false);
                                Get.bottomSheet(
                                  AppDialogWidget(
                                    child: editReviewDialog(context),
                                  ),
                                  isScrollControlled: true,
                                );
                              } else {
                                Get.to(() => SignInScreen());
                              }
                            },
                          ),
                        ),
                        24.height,
                        // Reviews List
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reviews (${reviewCont.listContent.length})', style: boldTextStyle(size: 16)),
                              Text('Most Recent', style: secondaryTextStyle(size: 12)),
                            ],
                          ),
                        ),
                        16.height,
                        if (reviewCont.listContent.isEmpty)
                          Column(
                            children: [
                              32.height,
                              Icon(Icons.star_border, size: 64, color: textSecondaryColorGlobal.withOpacity(0.5)),
                              16.height,
                              Text('No reviews yet', style: boldTextStyle(size: 18)),
                              8.height,
                              Text('Be the first to rate this movie', style: secondaryTextStyle(size: 14)),
                              32.height,
                            ],
                          ).center().visible(!reviewCont.isLoading.value)
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AnimatedWrap(
                              runSpacing: 12,
                              spacing: 12,
                              itemCount: reviewCont.listContent.length,
                              listAnimationType: commonListAnimationType,
                              itemBuilder: (ctx, index) {
                              ReviewModel reviewDetail = reviewCont.listContent[index];
                              return ReviewCard(
                                reviewDetail: reviewDetail,
                                isLoggedInUser: reviewDetail.userId == loginUserData.value.id,
                                editCallback: () async {
                                  reviewCont.onReviewCheck();
                                  reviewCont.isEdit(true);
                                  Get.bottomSheet(
                                    AppDialogWidget(
                                      child: editReviewDialog(context),
                                    ),
                                    isScrollControlled: true,
                                  );
                                },
                                deleteCallback: () {
                                  reviewCont.deleteReview(reviewDetail.id);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget editReviewDialog(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              locale.value.yourReview,
              style: boldTextStyle(),
            ).expand(),
            Obx(
              () => InkWell(
                onTap: () {
                  Get.back();
                  reviewCont.isBtnEnable(false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: boxDecorationDefault(
                    borderRadius: BorderRadius.circular(4),
                    color: cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(reviewCont.isEdit.value ? Icons.close : Icons.mode_edit_outlined, size: 12, color: white),
                      4.width,
                      Text(reviewCont.isEdit.value ? locale.value.close : locale.value.edit.toUpperCase(), style: boldTextStyle(size: 12)),
                    ],
                  ),
                ),
              ).visible(reviewCont.isEdit.value),
            ),
          ],
        ),
        Obx(
          () => RatingBarWidget(
            size: 16,
            allowHalfRating: true,
            activeColor: goldColor,
            inActiveColor: darkGrayTextColor,
            rating: reviewCont.ratingVal.value,
            spacing: 8,
            onRatingChanged: (rating) {
              reviewCont.ratingVal(rating);
              reviewCont.getBtnEnable();
            },
          ),
        ),
        AppTextField(
          textStyle: commonPrimaryTextStyle(size: 14),
          focus: reviewCont.focus,
          controller: reviewCont.reviewCont,
          textFieldType: TextFieldType.MULTILINE,
          decoration: inputDecoration(
            context,
            hintText: locale.value.shareYourThoughtsOnContent(movieName, contentType.getContentTypeTitleSingular()),
            contentPadding: const EdgeInsetsDirectional.all(12),
          ),
          onChanged: (value) {
            reviewCont.getBtnEnable();
          },
        ),
        Obx(
          () => IgnorePointer(
            ignoring: !reviewCont.isBtnEnable.value,
            child: AppButton(
              width: double.infinity,
              text: locale.value.submit,
              disabledColor: btnColor,
              color: reviewCont.isBtnEnable.value ? appColorPrimary : lightBtnColor,
              textStyle: appButtonTextStyleWhite.copyWith(
                color: reviewCont.isBtnEnable.value ? white : darkGrayTextColor,
              ),
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
              onTap: () {
                if (reviewCont.isLoading.value) return;
                if (reviewCont.isBtnEnable.value) {
                  hideKeyboard(context);
                  Get.back();
                  reviewCont.editReview();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
