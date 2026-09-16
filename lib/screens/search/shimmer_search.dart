import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../components/shimmer_widget.dart';

class ShimmerSearch extends StatelessWidget {
  const ShimmerSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedWrap(
      listAnimationType: commonListAnimationType,
      children: List.generate(
        4,
        (index) {
          return HorizontalList(
            itemCount: 4,
            crossAxisAlignment: WrapCrossAlignment.start,
            wrapAlignment: WrapAlignment.start,
            spacing: 18,
            runSpacing: 18,
            itemBuilder: (context, index) {
              return ShimmerWidget(
                height: 180,
                width: Get.width / 3 - 16,
                radius: 6,
              );
            },
          ).paddingBottom(18);
        },
      ),
    );
  }
}