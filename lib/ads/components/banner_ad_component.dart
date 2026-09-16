import 'package:flutter/material.dart';
import 'package:streamit_laravel/ads/custom_ads/custom_ads.dart';
import 'package:streamit_laravel/ads/video_player_ads/custom_ad_widget.dart';

class BannerAdComponent extends StatelessWidget {
  final double bannerHeight;
  final String adType;
  final String adUrl;
  final String redirectUrl;
  final VoidCallback? onSkip;

  const BannerAdComponent({
    super.key,
    required this.bannerHeight,
    this.adType = '',
    this.adUrl = '',
    this.redirectUrl = '',
    this.onSkip,
    this.onVideoCompleted,
    this.onVideoStarted,
  });

  final VoidCallback? onVideoCompleted;
  final VoidCallback? onVideoStarted;

  @override
  Widget build(BuildContext context) {
    return CustomAdWidget(
      ad: CustomAds(
        type: adType,
        url: adUrl,
        redirectUrl: redirectUrl,
        size: bannerHeight,
      ),
      onVideoCompleted: onVideoCompleted,
      onVideoStarted: onVideoStarted,
    );
  }
}