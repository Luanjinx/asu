import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/constants.dart';

class ContentDetailsShimmer extends StatelessWidget {
  const ContentDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        16.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 90,
          radius: 6,
        ),
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 90,
          radius: 6,
        ),
        ShimmerWidget(
          height: 40,
          width: Get.width,
          radius: 6,
        ),
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 90,
          radius: 6,
        ),
        ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: Get.width,
          radius: 6,
        ),
        ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: Get.width,
          radius: 6,
        ),
        Row(
          spacing: 16,
          children: List.generate(
            3,
            (index) {
              return const ShimmerWidget(
                height: 40,
                width: 40,
                radius: 50,
              );
            },
          ),
        ),
        ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 90,
          radius: 6,
        ),
        Row(
          spacing: 16,
          children: List.generate(
            3,
            (index) {
              return ShimmerWidget(
                height: Get.height * 0.08,
                width: Get.width / 3 - 24,
                radius: 6,
              );
            },
          ),
        ),
        ...List.generate(
          3,
          (index) {
            return Container(
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerWidget(
                    height: Get.height * 0.08,
                    width: Get.width / 3 - 24,
                    radius: 6,
                  ),
                  Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: double.infinity,
                        radius: 6,
                      ),
                      const ShimmerWidget(
                        height: Constants.shimmerTextSize,
                        width: double.infinity,
                        radius: 6,
                      ),
                    ],
                  ).expand(),
                  8.width,
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}