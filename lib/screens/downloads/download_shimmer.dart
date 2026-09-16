import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';

class DownloadShimmer extends StatelessWidget {
  const DownloadShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      itemCount: 4,
      runSpacing: 16,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // Section title shimmer
            _sectionShimmer(),

            // Download items shimmer
            ...List.generate(3, (index) => _downloadItemShimmer()),
          ],
        );
      },
    );
  }

  Widget _sectionShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        ShimmerWidget(
          height: 20,
          width: 120,
          radius: 4,
        ),
        const Divider(color: dividerDarkColor),
      ],
    );
  }

  Widget _downloadItemShimmer() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        spacing: 16,
        children: [
          // Thumbnail shimmer - matches the actual thumbnail size
          ShimmerWidget(
            height: Get.height * 0.08,
            width: Get.width * 0.32,
            topLeftRadius: 6,
            bottomLeftRadius: 6,
          ),

          // Content details shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                // Title shimmer
                ShimmerWidget(
                  height: 16,
                  width: Get.width * 0.4,
                  radius: 4,
                ),

                // Description shimmer - 2 lines
                ShimmerWidget(
                  height: 12,
                  width: Get.width * 0.35,
                  radius: 4,
                ),
                ShimmerWidget(
                  height: 12,
                  width: Get.width * 0.25,
                  radius: 4,
                ),
              ],
            ),
          ),

          // Delete button shimmer
          ShimmerWidget(
            height: 24,
            width: 24,
            radius: 12,
          ).paddingDirectional(end: 16),
        ],
      ),
    );
  }
}