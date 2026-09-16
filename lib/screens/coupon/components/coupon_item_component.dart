import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/price_widget.dart';
import 'package:streamit_laravel/utils/shimmer/shimmer.dart';

import '../../../components/cached_image_widget.dart';
import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../model/coupon_list_model.dart';

class CouponItemComponent extends StatelessWidget {
  final CouponDataModel couponData;
  final VoidCallback onApplyCoupon;
  final VoidCallback? onRemoveCoupon;

  const CouponItemComponent({
    super.key,
    required this.couponData,
    required this.onApplyCoupon,
    this.onRemoveCoupon,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorderWidget(
      color: borderColor,
      radius: 6,
      dotsWidth: 8,
      gap: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: boxDecorationDefault(
          borderRadius: BorderRadius.circular(6),
          color: cardColor,
          border: Border.all(style: BorderStyle.none),
        ),
        child: Row(
          children: [
            const CachedImageWidget(
              url: Assets.iconsSealPercent,
              height: 24,
              width: 24,
              color: appColorPrimary,
            ),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: locale.value.codeWithColon,
                          style: commonSecondaryTextStyle(),
                          children: [
                            const TextSpan(text: " "),
                            TextSpan(text: couponData.code, style: boldTextStyle()),
                          ],
                        ),
                      ),
                    ),
                    5.width,
                    Shimmer.fromColors(
                      baseColor: appColorPrimary.withValues(alpha: 1),
                      highlightColor: goldAnimatedColor,
                      enabled: false,
                      direction: ShimmerDirection.ltr,
                      period: const Duration(seconds: 2),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: boxDecorationDefault(
                          color: appColorPrimary.withValues(alpha: 0.00),
                          border: Border.all(color: appColorPrimary),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${couponData.discountType == Tax.percentage ? '${couponData.discount}%' : '${leftCurrencyFormat()}${couponData.discount.toInt()}${rightCurrencyFormat()}'} Off',
                          style: appButtonTextStyleWhite.copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                4.height,
                RichText(
                  text: TextSpan(
                    text: couponData.description,
                    style: commonSecondaryTextStyle(),
                  ),
                ),
              ],
            ).expand(),
            12.width,
            TextButton(
              onPressed: couponData.isCouponApplied ? onRemoveCoupon : onApplyCoupon,
              style: ButtonStyle(visualDensity: VisualDensity.compact),
              child: Text(
                couponData.isCouponApplied ? locale.value.remove : locale.value.apply,
                style: commonPrimaryTextStyle(color: appColorPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}