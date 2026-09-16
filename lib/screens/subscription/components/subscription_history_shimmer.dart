import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../utils/constants.dart';

class SubscriptionHistoryShimmer extends StatelessWidget {
  const SubscriptionHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 1);
    return AnimatedWrap(
      spacing: dynamicSpacing.$2,
      runSpacing: dynamicSpacing.$2,
      listAnimationType: commonListAnimationType,
      children: List.generate(
        10,
        (index) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(
              borderRadius: radius(8),
              color: context.cardColor,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: dynamicSpacing.$1 * 0.5,
                      radius: 6,
                    ).expand(),
                    8.width,
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: dynamicSpacing.$1 * 0.3,
                      radius: 6,
                    ),
                  ],
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 16,
                  children: [
                    ShimmerWidget(
                      height: 16,
                      width: dynamicSpacing.$1 * 0.5,
                      radius: 6,
                    ).expand(),
                    ShimmerWidget(
                      height: 24,
                      width: dynamicSpacing.$1 * 0.2,
                      radius: 18,
                    ),
                  ],
                ),
                12.height,
                ...List.generate(
                  6,
                  (index) => Row(
                    spacing: 16,
                    children: [
                      ShimmerWidget(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(2)),
                        ),
                      ),
                      ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: Get.width,
                        radius: 6,
                      ).expand()
                    ],
                  ).paddingDirectional(top: 4, bottom: 4),
                ),
                12.height,
                ShimmerWidget(
                  height: 1,
                  width: dynamicSpacing.$1,
                  radius: 6,
                ),
                12.height,
                ShimmerWidget(
                  height: 40,
                  width: dynamicSpacing.$1,
                  radius: 6,
                ),
              ],
            ),
          ).paddingOnly(bottom: 8, top: 8);
        },
      ),
    );
  }
}
