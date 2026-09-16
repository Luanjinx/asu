import 'package:flutter/foundation.dart';
import 'package:streamit_laravel/ads/vast/vast_parser.dart';
import 'package:streamit_laravel/ads/models/vast_media.dart';

/// Serialize a [VastMedia] instance into a simple map that can travel across isolates.
Map<String, dynamic> serializeVastMedia(VastMedia media) {
  return <String, dynamic>{
    'mediaUrls': media.mediaUrls,
    'clickThroughUrls': media.clickThroughUrls,
    'clickTrackingUrls': media.clickTrackingUrls,
    'skipDuration': media.skipDuration,
    'trackingEvents': media.trackingEvents,
    'adTitle': media.adTitle,
    'adSystem': media.adSystem,
    'errorUrls': media.errorUrls,
    'impressionUrls': media.impressionUrls,
    'linearDurationSeconds': media.linearDurationSeconds,
    'companionImageUrl': media.companionImageUrl,
    'companionClickThroughUrl': media.companionClickThroughUrl,
    'companionDurationSeconds': media.companionDurationSeconds,
    'nonLinearImageUrl': media.nonLinearImageUrl,
    'nonLinearClickThroughUrl': media.nonLinearClickThroughUrl,
    'nonLinearHtmlResource': media.nonLinearHtmlResource,
    'nonLinearDurationSeconds': media.nonLinearDurationSeconds,
  };
}

/// Fetch and parse a VAST document in a background isolate, returning a serializable map.
Future<Map<String, dynamic>?> fetchVastPayloadInBackground(String url) {
  return compute(_fetchVastPayload, url);
}

@pragma('vm:entry-point')
Future<Map<String, dynamic>?> _fetchVastPayload(String url) async {
  final parser = VastParser();
  final media = await parser.fetchVastMedia(url);
  if (media == null) return null;
  return serializeVastMedia(media);
}
