import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String firstName;
  final String lastName;
  final Color? color;

  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final bool circle;
  final double? radius;
  final int bottomLeftRadius;
  final int bottomRightRadius;
  final int topLeftRadius;
  final int topRightRadius;

  const CachedImageWidget({
    super.key,
    required this.url,
    this.height,
    this.width,
    this.fit,
    this.firstName = "",
    this.lastName = "",
    this.color,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
    this.circle = false,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
  });

  Widget _buildPlaceholder() {
    return ShimmerWidget(
      height: height,
      width: width,
      radius: radius ?? 0,
    );
  }

/*  int? _getMemCacheWidth() {
    if (width != null && width != double.infinity) {
      return (width! * Get.pixelRatio).toInt();
    }
    return null;
  }

  int? _getMemCacheHeight() {
    if (height != null && height != double.infinity) {
      return (height! * Get.pixelRatio).toInt();
    }
    return null;
  }*/

  Widget _buildImageWidget() {
    if (url.validate().isEmpty) {
      return _buildPlaceholder();
    } else if (url.startsWith('http')) {
      if (url.endsWith('svg')) {
        return SvgPicture.network(
          url,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          colorFilter: color != null ? ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn) : null,
          alignment: alignment as Alignment? ?? Alignment.center,
          errorBuilder: (_, __, ___) {
            return Image.network(
              url,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            );
          },
          placeholderBuilder: (BuildContext context) {
            return _buildPlaceholder();
          },
        );
      }
      return CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        alignment: alignment as Alignment? ?? Alignment.center,
        placeholder: (_, __) => _buildPlaceholder(),
        errorWidget: (_, __, ___) {
          return Image.network(
            url,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          );
        },
      );
    } else if (url.startsWith("assets")) {
      if (url.endsWith('svg')) {
        return SvgPicture.asset(
          url,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          colorFilter: color != null ? ColorFilter.mode(color ?? Colors.transparent, BlendMode.srcIn) : null,
          alignment: alignment as Alignment? ?? Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder();
          },
          placeholderBuilder: (BuildContext context) {
            return _buildPlaceholder();
          },
        );
      }
      return Image.asset(
        url,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    } else {
      return Image.file(
        File(url),
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget();

    // Handle circle or radius-based clipping
    if (circle) {
      return ClipOval(child: imageWidget);
    } else if (radius != null && radius! > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius!),
        child: imageWidget,
      );
    } else if (topLeftRadius > 0 || topRightRadius > 0 || bottomLeftRadius > 0 || bottomRightRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(topLeftRadius.toDouble()),
          topEnd: Radius.circular(topRightRadius.toDouble()),
          bottomStart: Radius.circular(bottomLeftRadius.toDouble()),
          bottomEnd: Radius.circular(bottomRightRadius.toDouble()),
        ),
        child: imageWidget,
      );
    } else {
      return imageWidget; // no clipping
    }
  }
}