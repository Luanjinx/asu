import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../components/shimmer_widget.dart';
import '../../../utils/constants.dart';

class LiveTvDetailsShimmerScreen extends StatelessWidget {
  const LiveTvDetailsShimmerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 2);

    double itemHeight = Get.height * 0.12;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Row(
          children: [
            const ShimmerWidget(
              height: Constants.shimmerTextSize,
              width: 70,
              radius: 6,
            ),
            const Spacer(),
            const ShimmerWidget(
              height: 40,
              width: 40,
              radius: 50,
            ),
          ],
        ),
        16.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: double.infinity,
          radius: 6,
        ),
        8.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: double.infinity,
          radius: 6,
        ),
        8.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 250,
          radius: 6,
        ),
        24.height,
        const ShimmerWidget(
          height: Constants.shimmerTextSize,
          width: 50,
          radius: 6,
        ),
        8.height,
        Wrap(
          spacing: dynamicSpacing.$2,
          runSpacing: dynamicSpacing.$2,
          children: List.generate(12, (index) {
            return ShimmerWidget(
              height: itemHeight,
              width: dynamicSpacing.$1,
              radius: 6,
            );
          }),
        ),
        40.height,
      ],
    );
  }
}