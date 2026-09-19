import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/review/model/review_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

class RatingSummaryCard extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final List<ReviewModel> reviews;
  final bool isLoggedIn;
  final VoidCallback onRateAction;
  final bool showRateAction;
  final bool isCard;

  const RatingSummaryCard({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.reviews,
    required this.isLoggedIn,
    required this.onRateAction,
    this.showRateAction = true,
    this.isCard = true,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate rating distribution
    int count5 = 0, count4 = 0, count3 = 0, count2 = 0, count1 = 0;
    int calculableReviews = reviews.length;

    for (var review in reviews) {
      if (review.rating == 5) count5++;
      else if (review.rating == 4) count4++;
      else if (review.rating == 3) count3++;
      else if (review.rating == 2) count2++;
      else if (review.rating == 1) count1++;
    }

    // If no reviews loaded, default to 0 for percentages to avoid division by zero
    double pct5 = calculableReviews > 0 ? (count5 / calculableReviews) : 0;
    double pct4 = calculableReviews > 0 ? (count4 / calculableReviews) : 0;
    double pct3 = calculableReviews > 0 ? (count3 / calculableReviews) : 0;
    double pct2 = calculableReviews > 0 ? (count2 / calculableReviews) : 0;
    double pct1 = calculableReviews > 0 ? (count1 / calculableReviews) : 0;

    return Container(
      padding: isCard ? const EdgeInsets.all(16) : EdgeInsets.zero,
      decoration: isCard ? boxDecorationDefault(
        color: context.cardColor,
        borderRadius: radius(12),
      ) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Average Rating
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                averageRating.toStringAsFixed(1).replaceAll('.0', ''),
                style: boldTextStyle(size: 48, color: isCard ? appColorPrimary : Colors.white),
              ),
              RatingBarWidget(
                onRatingChanged: (v) {},
                rating: averageRating,
                size: 12,
                activeColor: appColorPrimary,
                inActiveColor: textSecondaryColorGlobal.withOpacity(0.5),
                disable: true,
              ),
              6.height,
              Text(
                '$totalReviews ${locale.value.reviews}',
                style: secondaryTextStyle(size: 10),
              ),
            ],
          ),
          
          16.width,
          if (showRateAction) ...[
            Container(
              height: 80,
              width: 1,
              color: textSecondaryColorGlobal.withOpacity(0.2),
            ),
            16.width,
          ],

          // Middle side: Distribution Bars
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRatingBarRow(5, pct5),
                _buildRatingBarRow(4, pct4),
                _buildRatingBarRow(3, pct3),
                _buildRatingBarRow(2, pct2),
                _buildRatingBarRow(1, pct1),
              ],
            ),
          ),

          if (showRateAction) ...[
            16.width,
            Container(
              height: 80,
              width: 1,
              color: textSecondaryColorGlobal.withOpacity(0.2),
            ),
            16.width,

            // Right side: Rate action
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Rate this', style: secondaryTextStyle(size: 12)),
                4.height,
                RatingBarWidget(
                  onRatingChanged: (v) {},
                  rating: 0,
                  size: 14,
                  activeColor: appColorPrimary,
                  inActiveColor: textSecondaryColorGlobal.withOpacity(0.5),
                  disable: true,
                ),
                8.height,
                InkWell(
                  onTap: onRateAction,
                  borderRadius: radius(24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: appColorPrimary),
                      borderRadius: radius(24),
                    ),
                    child: Text(
                      'Rate Now',
                      style: boldTextStyle(size: 12, color: appColorPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRatingBarRow(int star, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$star', style: secondaryTextStyle(size: 12)),
          8.width,
          Expanded(
            child: ClipRRect(
              borderRadius: radius(4),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 4,
                backgroundColor: textSecondaryColorGlobal.withOpacity(0.2),
                color: appColorPrimary,
              ),
            ),
          ),
          8.width,
          SizedBox(
            width: 32,
            child: Text(
              '${(percentage * 100).toInt()}%',
              style: secondaryTextStyle(size: 10),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
