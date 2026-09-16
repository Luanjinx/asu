import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final double? height;
  final double? width;

  final double? imageSize;
  final String noDataImage;

  const EmptyStateWidget({
    super.key,
    this.height,
    this.width,
    this.noDataImage = '',
    this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    if (noDataImage.isNotEmpty) {
      return CachedImageWidget(
        url: noDataImage,
        color: iconColor,
        height: imageSize ?? 120,
      );
    }
    return Lottie.asset(Assets.lottieEmptyLottie, height: imageSize ?? 150, repeat: true);
  }
}

class ErrorStateWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const ErrorStateWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.lottieErrorLottie, height: height ?? 110, repeat: true);
  }
}