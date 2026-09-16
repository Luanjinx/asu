class VastMedia {
  final List<String> mediaUrls;
  final List<String> clickThroughUrls;
  final List<String> clickTrackingUrls;
  final int? skipDuration;
  final Map<String, List<String>> trackingEvents;
  final String? adTitle;
  final String? adSystem;
  final List<String> errorUrls;
  final List<String> impressionUrls;
  final int? linearDurationSeconds;
  final String? companionImageUrl;
  final String? companionClickThroughUrl;
  final int? companionDurationSeconds;
  final String? nonLinearImageUrl;
  final String? nonLinearClickThroughUrl;
  final String? nonLinearHtmlResource;
  final int? nonLinearDurationSeconds;
  final String? nonLinearVideoUrl; // Add field

  VastMedia({
    required this.mediaUrls,
    required this.clickThroughUrls,
    required this.clickTrackingUrls,
    this.skipDuration,
    this.trackingEvents = const {},
    this.adTitle,
    this.adSystem,
    this.errorUrls = const [],
    this.impressionUrls = const [],
    this.linearDurationSeconds,
    this.companionImageUrl,
    this.companionClickThroughUrl,
    this.companionDurationSeconds,
    this.nonLinearImageUrl,
    this.nonLinearClickThroughUrl,
    this.nonLinearHtmlResource,
    this.nonLinearDurationSeconds,
    this.nonLinearVideoUrl, // Add field
  });
}