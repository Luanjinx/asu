import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../utils/constants.dart';

class ShimmerRentalHistoryList extends StatelessWidget {
  const ShimmerRentalHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 1);
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      listAnimationType: commonListAnimationType,
      children: List.generate(
        10,
        (index) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(
              borderRadius: radius(8),
              color: context.cardColor,
              border: Border.all(color: context.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: Get.width * 0.4,
                      radius: 6,
                    ).expand(),
                    16.width,
                    ShimmerWidget(
                      height: 22,
                      width: 60,
                      radius: 6,
                    ),
                  ],
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerWidget(
                      height: 16,
                      width: 16,
                      radius: 4,
                    ),
                    8.width,
                    ShimmerWidget(
                      height: 12,
                      width: Get.width * 0.5,
                      radius: 6,
                    ),
                  ],
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
          );
        },
      ),
    );
  }
}
