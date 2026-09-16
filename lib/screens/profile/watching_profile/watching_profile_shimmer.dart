import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

class WatchingProfileShimmer extends StatelessWidget {
  const WatchingProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.44,
      decoration: boxDecorationDefault(
        color: cardColor,
        borderRadius: radius(22),
        gradient: LinearGradient(
          colors: [
            appColorSecondary.withValues(alpha: 0.2),
            black.withValues(alpha: 0.4),
            black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          /// Title section
          SliverToBoxAdapter(
            child: Column(
              children: [
                28.height,
                const ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: 120,
                  radius: 6,
                ),
                28.height,
              ],
            ),
          ),

          /// Animated Grid
          SliverAnimatedGrid(
            initialItemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index, animation) {
              return ScaleTransition(
                scale: animation,
                child: ShimmerWidget(
                  height: Get.width / 3 - 42,
                  radius: defaultRadius,
                ).paddingAll(16),
              );
            },
          ),
        ],
      ),
    );
  }
}