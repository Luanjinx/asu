class AdConfig {
  final String url;
  final bool isSkippable;
  final int skipAfterSeconds;
  final String? clickThroughUrl;
  final String type;
  final Map<String, List<String>> trackingEvents;
  final List<String> clickTrackingUrls;
  final String? adTitle;
  final String? adSystem;
  final List<String> errorUrls;
  final List<String> impressionUrls;
  final int? startAtSeconds;
  final int? durationSeconds;
  final String? redirectUrl;
  final String? trackingUrl;

  AdConfig({
    required this.url,
    this.isSkippable = false,
    this.skipAfterSeconds = 5,
    this.clickThroughUrl,
    required this.type,
    this.trackingEvents = const {},
    this.clickTrackingUrls = const [],
    this.adTitle,
    this.adSystem,
    this.errorUrls = const [],
    this.impressionUrls = const [],
    this.startAtSeconds,
    this.durationSeconds,
    this.redirectUrl,
    this.trackingUrl,
  });

  String? get primaryClickUrl {
    if (clickThroughUrl != null && clickThroughUrl!.trim().isNotEmpty) {
      return clickThroughUrl;
    }
    if (redirectUrl != null && redirectUrl!.trim().isNotEmpty) {
      return redirectUrl;
    }
    if (trackingUrl != null && trackingUrl!.trim().isNotEmpty) {
      return trackingUrl;
    }
    if (clickTrackingUrls.isNotEmpty) {
      return clickTrackingUrls.first;
    }
    return null;
  }
}