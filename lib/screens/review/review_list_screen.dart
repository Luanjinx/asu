import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
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
        bottomNavigationBar: !isLoggedIn.value
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: AppButton(
                  width: double.infinity,
                  text: 'Login to Review',
                  textStyle: boldTextStyle(color: Colors.black),
                  color: Colors.white,
                  onTap: () {
                    Get.to(() => SignInScreen());
                  },
                ),
              )
            : null,
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
                            showRateAction: false,
                            isCard: false,
                            onRateAction: () {},
                          ),
                        ),
                        if (isLoggedIn.value) ...[
                          24.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: editReviewDialog(context),
                          ),
                          24.height,
                        ] else ...[
                          16.height,
                          Divider(color: context.dividerColor, height: 1),
                          16.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RatingBarWidget(
                                      rating: 0,
                                      size: 28,
                                      activeColor: Colors.white,
                                      inActiveColor: textSecondaryColorGlobal.withOpacity(0.5),
                                      disable: true,
                                      onRatingChanged: (v){},
                                    ),
                                    16.width,
                                    Text('Login to rate this ${contentType.getContentTypeTitleSingular().toLowerCase()}', style: secondaryTextStyle(size: 12)),
                                  ]
                                ),
                                16.height,
                                AppButton(
                                  text: 'Login',
                                  textStyle: boldTextStyle(color: appColorPrimary, size: 14),
                                  color: Colors.transparent,
                                  shapeBorder: RoundedRectangleBorder(
                                    borderRadius: radius(8),
                                    side: BorderSide(color: appColorPrimary),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                                  onTap: () {
                                    Get.to(() => SignInScreen());
                                  },
                                ),
                              ]
                            )
                          ),
                          16.height,
                          Divider(color: context.dividerColor, height: 1),
                          24.height,
                        ],
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
                                  reviewCont.scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rate this ${contentType.getContentTypeTitleSingular().toLowerCase()}',
          style: boldTextStyle(size: 16),
        ),
        8.height,
        Obx(
          () => RatingBarWidget(
            size: 28,
            allowHalfRating: true,
            activeColor: Colors.white,
            inActiveColor: textSecondaryColorGlobal.withOpacity(0.5),
            rating: reviewCont.ratingVal.value,
            spacing: 8,
            onRatingChanged: (rating) {
              reviewCont.ratingVal(rating);
              reviewCont.getBtnEnable();
            },
          ),
        ),
        8.height,
        Text('Tap a star to rate', style: secondaryTextStyle(size: 12)),
        16.height,
        AppTextField(
          textStyle: commonPrimaryTextStyle(size: 14),
          focus: reviewCont.focus,
          controller: reviewCont.reviewCont,
          textFieldType: TextFieldType.MULTILINE,
          decoration: inputDecoration(
            context,
            hintText: 'Write your review (optional)',
            fillColor: context.cardColor,
            filled: true,
          ).copyWith(
            border: OutlineInputBorder(borderRadius: radius(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: radius(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: radius(12), borderSide: BorderSide.none),
          ),
          onChanged: (value) {
            reviewCont.getBtnEnable();
          },
        ),
        16.height,
        Obx(
          () => IgnorePointer(
            ignoring: !reviewCont.isBtnEnable.value,
            child: AppButton(
              width: double.infinity,
              text: 'Submit Review',
              disabledColor: context.cardColor.withOpacity(0.5),
              color: reviewCont.isBtnEnable.value ? context.cardColor : context.cardColor.withOpacity(0.5),
              textStyle: boldTextStyle(
                color: reviewCont.isBtnEnable.value ? Colors.white : textSecondaryColorGlobal,
              ),
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(12)),
              onTap: () {
                if (reviewCont.isLoading.value) return;
                if (reviewCont.isBtnEnable.value) {
                  hideKeyboard(context);
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
