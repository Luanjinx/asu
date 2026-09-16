import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../utils/constants.dart';

class ShimmerSubscriptionList extends StatelessWidget {
  const ShimmerSubscriptionList({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 1);
    return AnimatedWrap(
      spacing: dynamicSpacing.$2,
      runSpacing: dynamicSpacing.$2,
      listAnimationType: commonListAnimationType,
      children: List.generate(
        6,
        (index) {
          return Container(
            width: dynamicSpacing.$1,
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: dynamicSpacing.$1,
                  radius: 6,
                ).paddingDirectional(start: 16, top: 16, end: 16),
                8.height,
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: dynamicSpacing.$1,
                  radius: 6,
                ).paddingDirectional(start: 16, end: 16),
                16.height,
                ShimmerWidget(
                  height: 1,
                  width: dynamicSpacing.$1,
                  radius: 6,
                ).paddingDirectional(start: 16, end: 16),
                16.height,
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
                  ).paddingDirectional(start: 16, top: 4, bottom: 4, end: 16),
                )
              ],
            ).paddingOnly(bottom: 16),
          ).paddingOnly(bottom: 8, top: 8);
        },
      ),
    );
  }
}