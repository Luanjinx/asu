import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../components/shimmer_widget.dart';

class ShimmerAccountSetting extends StatelessWidget {
  const ShimmerAccountSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      listAnimationType: commonListAnimationType,
      runSpacing: 32,
      spacing: 12,
      children: List.generate(
        8,
        (index) {
          return Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: 180,
                radius: 6,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: boxDecorationDefault(color: context.cardColor),
                child: Column(
                  spacing: 16,
                  children: [
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: Get.width,
                      radius: 6,
                    ),
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: Get.width,
                      radius: 6,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: boxDecorationDefault(color: context.cardColor),
                child: Column(
                  spacing: 16,
                  children: [
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: Get.width,
                      radius: 6,
                    ),
                    ShimmerWidget(
                      height: Constants.shimmerTextSize,
                      width: Get.width,
                      radius: 6,
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ).paddingTop(42);
  }
}