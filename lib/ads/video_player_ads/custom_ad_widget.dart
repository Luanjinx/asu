import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/custom_ads/ad_player.dart';
import 'package:streamit_laravel/ads/custom_ads/custom_ads.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

/// Widget that displays a custom video ad.
class CustomAdWidget extends StatelessWidget {
  final CustomAds ad;

  const CustomAdWidget({
    super.key,
    required this.ad,
    this.onVideoCompleted,
    this.onVideoStarted,
    this.onVideoError,
  });

  final VoidCallback? onVideoCompleted;
  final VoidCallback? onVideoStarted;
  final VoidCallback? onVideoError;

  @override
  Widget build(BuildContext context) {
    if (ad.type == 'image' || ad.url.isImage) {
      return InkWell(
        onTap: () {
          if (ad.redirectUrl.isNotEmpty) {
            launchUrlCustomURL(ad.redirectUrl);
          }
        },
        child: CachedImageWidget(
          url: ad.url,
          height: ad.size,
          width: Get.width,
          fit: BoxFit.cover,
        ).cornerRadiusWithClipRRect(defaultRadius),
      );
    }

    Widget videoAd = AdPlayer(
      height: ad.size,
      redirectUrl: ad.redirectUrl,
      adType: ad.type,
      videoUrl: ad.url.validate(),
      isFromPlayerAd: true,
      onVideoCompleted: onVideoCompleted,
      onVideoStarted: onVideoStarted,
      onVideoError: onVideoError,
      startSkipTimer: (value) {
        if (value.value) {
          onVideoStarted?.call();
        }
      },
    );

    return videoAd;
  }
}