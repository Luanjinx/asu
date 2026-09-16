import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../utils/constants.dart';

class ShimmerReviewList extends StatelessWidget {
  const ShimmerReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      spacing: 12,
      runSpacing: 12,
      listAnimationType: commonListAnimationType,
      children: List.generate(
        6,
        (index) {
          return Container(
            padding: EdgeInsets.all(12),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerWidget(
                      height: 40,
                      width: 40,
                      radius: 50,
                    ),
                    Column(
                      children: [
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 90,
                          radius: 6,
                        ),
                        const ShimmerWidget(
                          height: Constants.shimmerTextSize,
                          width: 90,
                          radius: 6,
                        ).paddingOnly(top: 12),
                      ],
                    ).paddingDirectional(start: 16),
                    const Spacer(),
                    const ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: 90,
                      radius: 6,
                    ).paddingDirectional(start: 16)
                  ],
                ),
                16.height,
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: Get.width,
                  radius: 6,
                ).paddingDirectional(start: 16),
                10.height,
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: Get.width,
                  radius: 6,
                ).paddingDirectional(start: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}