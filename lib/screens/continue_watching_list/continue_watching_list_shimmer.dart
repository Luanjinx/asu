import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';

class ShimmerContinueWatchingListScreen extends StatelessWidget {
  const ShimmerContinueWatchingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicCardsDimensions = getDynamicSpacing(crossAxisChildrenCount: 2);
    return Wrap(
      runSpacing: dynamicCardsDimensions.$2,
      spacing: dynamicCardsDimensions.$2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(
        20,
        (index) {
          return Container(
            width: dynamicCardsDimensions.$1,
            padding: EdgeInsets.only(bottom: 16),
            decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(4)),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  height: Get.height * 0.10,
                  width: dynamicCardsDimensions.$1,
                  topRightRadius: 4,
                  topLeftRadius: 4,
                ),
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: dynamicCardsDimensions.$1,
                  radius: 4,
                ),
                ShimmerWidget(
                  height: Constants.shimmerTextSize,
                  width: 90,
                  radius: 4,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}