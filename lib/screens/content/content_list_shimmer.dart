import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class ContentListShimmer extends StatelessWidget {
  final double? height;
  final double? width;
  final double spacing;
  final int length;

  const ContentListShimmer({super.key, this.height, required this.width, this.spacing = 12, this.length = 15});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      runSpacing: spacing,
      spacing: spacing,
      listAnimationType: commonListAnimationType,
      children: List.generate(
        length,
        (index) {
          return ShimmerWidget(
            height: height ?? Get.height * 0.20,
            width: width,
            radius: 6,
          );
        },
      ),
    );
  }
}