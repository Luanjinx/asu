import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../../../components/cached_image_widget.dart';
import '../../../../main.dart';

class RateComponent extends StatelessWidget {
  final CategoryListModel rateDetails;
  final bool isLoading;

  const RateComponent({super.key, required this.rateDetails, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (appConfigs.value.applicationURL.applicationURL.isEmpty) return SizedBox.shrink();
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecorationDefault(
        borderRadius: BorderRadius.circular(6),
        color: cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(locale.value.shareYourThoughtsWithUs, style: boldTextStyle(color: white)),
              5.height,
              Text(locale.value.weValueYourOpinion, style: commonSecondaryTextStyle(size: 12)),
              12.height,
              AppButton(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                text: locale.value.rateNow,
                disabledColor: btnColor,
                color: appColorPrimary,
                textStyle: appButtonTextStyleWhite.copyWith(fontSize: 12),
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                onTap: () async {
                  handleRate();
                },
              ),
            ],
          ).expand(),
          20.width,
          const Align(
            alignment: Alignment.center,
            child: CachedImageWidget(
              url: Assets.imagesIcRating,
              width: 120,
            ),
          ),
        ],
      ),
    );
  }
}