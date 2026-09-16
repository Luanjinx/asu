import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();
    final spacing = dynamicSpacing.$2;

    return AnimatedWrap(
      listAnimationType: commonListAnimationType,
      spacing: spacing,
      runSpacing: spacing,
      itemCount: 20,
      itemBuilder: (ctx, index) {
        return Container(
          decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(defaultRadius)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: spacing,
            children: [
              // Thumbnail shimmer
              ShimmerWidget(
                height: Get.height * 0.08,
                width: Get.width * 0.28,
                radius: 6,
              ),

              // Content shimmer
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: spacing / 4,
                children: [
                  ShimmerWidget(
                    height: Constants.shimmerTextSize,
                    width: Get.width * 0.5,
                    radius: 4,
                  ),
                  ShimmerWidget(
                    height: Constants.shimmerTextSize,
                    width: Get.width * 0.4,
                    radius: 4,
                  ),
                ],
              ).paddingSymmetric(horizontal: 8, vertical: 8).expand(),
              // Time shimmer
              ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: 50,
                radius: 4,
              ).paddingSymmetric(horizontal: 8, vertical: 8),
            ],
          ),
        );
      },
    );
  }
}