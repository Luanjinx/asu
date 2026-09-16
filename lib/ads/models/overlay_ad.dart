enum OverlayAdType {
  image,
  html,
  video,
}

class OverlayAd {
  final String imageUrl;
  final String htmlContent;
  final String clickThroughUrl;
  final int startTime;
  final int duration;
  final OverlayAdType type;
  final String? redirectUrl;
  final String? trackingUrl;
  final String? videoUrl;
  final int skipDuration;

  bool get isHtml => type == OverlayAdType.html;

  bool get isVideo => type == OverlayAdType.video;

  bool get isImage => type == OverlayAdType.image;

  /// Returns the primary URL to open when the overlay is clicked.
  String? get primaryClickUrl {
    if (clickThroughUrl.trim().isNotEmpty) return clickThroughUrl;

    if (redirectUrl != null && redirectUrl!.trim().isNotEmpty) {
      return redirectUrl;
    }

    // Some ad systems incorrectly put click URLs in tracking tags.
    if (trackingUrl != null && trackingUrl!.trim().isNotEmpty) {
      return trackingUrl;
    }

    return null;
  }

  OverlayAd({
    this.imageUrl = '',
    this.htmlContent = '',
    this.clickThroughUrl = '',
    this.startTime = 0,
    this.duration = 10,
    OverlayAdType? type,
    this.redirectUrl,
    this.trackingUrl,
    this.videoUrl,
    this.skipDuration = 5,
  }) : type = type ?? _determineType(imageUrl, htmlContent, videoUrl);

  /// Determines the proper ad type.
  /// This is **critical** for preventing blank overlays.
  static OverlayAdType _determineType(
    String image,
    String html,
    String? video,
  ) {
    // 1️⃣ Video gets priority
    if (video != null && video.trim().isNotEmpty) {
      return OverlayAdType.video;
    }

    // 2️⃣ HTML — including iframe strings — must be detected before image.
    if (html.trim().isNotEmpty) {
      return OverlayAdType.html;
    }

    // 3️⃣ Image if non-empty
    if (image.trim().isNotEmpty) {
      return OverlayAdType.image;
    }

    // ❗ Fallback: treat empty overlays as image (placeholder)
    return OverlayAdType.image;
  }

  @override
  String toString() {
    return 'OverlayAd(type: $type, start: $startTime, duration: $duration, '
        'video: $videoUrl, html: ${htmlContent.isNotEmpty}, image: $imageUrl)';
  }
}