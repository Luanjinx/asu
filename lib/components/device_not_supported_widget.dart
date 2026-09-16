import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/screens/subscription/components/subscribe_card.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../generated/assets.dart';
import '../main.dart';
import '../utils/colors.dart';

class DeviceNotSupportedComponent extends StatelessWidget {
  final double? height;
  final double? width;
  final String title;

  const DeviceNotSupportedComponent({super.key, this.height, this.width, required this.title});

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    return Stack(
      children: [
        SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              42.height,
              CachedImageWidget(
                url: Assets.iconsWarning,
                height: 100,
                width: 100,
                color: yellowColor,
              ),
              8.height,
              Text(locale.value.yourDeviceIsNot, style: boldTextStyle()),
              2.height,
              Text(locale.value.pleaseUpgradeToContinue, style: secondaryTextStyle()),
              8.height,
              SubscribeCard(showUpgrade: true)
            ],
          ),
        ),
        if (isLandscape)
          PositionedDirectional(
            top: ResponsiveSize.getTop(10),
            start: ResponsiveSize.getStart(12),
            end: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                backButton(context: context),
                16.width,
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: commonPrimaryTextStyle(size: 18),
                ).expand(),
              ],
            ),
          )
      ],
    );
  }
}