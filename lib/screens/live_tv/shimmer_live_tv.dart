import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../components/shimmer_widget.dart';
import '../../utils/constants.dart';

class ShimmerLiveTv extends StatelessWidget {
  const ShimmerLiveTv({super.key});

  @override
  Widget build(BuildContext context) {
    // Get dynamic grid size (width + spacing)
    final dynamicSpacing = getDynamicSpacing(
      crossAxisChildrenCount: 2,
    );

    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      direction: Axis.vertical,
      children: List.generate(
        4,
        (index) => AnimatedWrap(
          runSpacing: dynamicSpacing.$2,
          direction: Axis.vertical,
          children: [
            const ShimmerWidget(
              height: Constants.shimmerTextSize,
              width: 180,
              radius: 6,
            ).paddingSymmetric(vertical: 16),
            AnimatedWrap(
              runSpacing: dynamicSpacing.$2,
              spacing: dynamicSpacing.$2,
              children: List.generate(
                4,
                (index) => ShimmerWidget(
                  height: Get.height * 0.12,
                  width: dynamicSpacing.$1,
                  radius: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    ).paddingSymmetric(horizontal: 12);
  }
}