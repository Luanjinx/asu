import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/models/vast_media.dart';
import 'package:streamit_laravel/network/network_utils.dart';
import 'package:xml/xml.dart' as xml;

/// Robust VAST parser with CDATA-safe extraction and NonLinear (overlay) support.
class VastParser {
  final Set<String> _loggedTrackingErrors = <String>{};

  /// Fetch and parse VAST media from URL
  Future<VastMedia?> fetchVastMedia(String vastUrl) async {
    try {
      final value = await getRemoteDataFromUrl(endPoint: vastUrl);
      String xmlString;

      if (value is String) {
        xmlString = value;
      } else if (value is Map) {
        return _parseJsonVastResponse(value as Map<String, dynamic>);
      } else {
        log('Unsupported VAST payload: ${value.runtimeType}');
        return null;
      }

      if (!xmlString.trim().startsWith('<')) {
        log('Response is not XML, treating as direct video URL');
        return _parseDirectVideoUrl(xmlString);
      }

      return _parseXmlVastResponse(xmlString);
    } catch (e, st) {
      log('VAST fetch error: $e\n$st');
      return null;
    }
  }

  /// Parse XML VAST response (main parser)
  VastMedia? _parseXmlVastResponse(String xmlString) {
    try {
      // Minor cleanup for some malformed tags seen in the wild
      xmlString = xmlString.replaceAll('<IconClicks>', '<Iconclicks>').replaceAll('</IconClicks>', '</Iconclicks>');

      final document = xml.XmlDocument.parse(xmlString);

      // Basic fields
      final adTitle = document.findAllElements('AdTitle').map((e) => e.innerText.trim()).firstOrNull;
      final adSystem = document.findAllElements('AdSystem').map((e) => e.innerText.trim()).firstOrNull;

      final errorUrls = document.findAllElements('Error').map((e) => e.innerText.trim()).where((s) => s.isNotEmpty).toList();

      final impressionUrls = document.findAllElements('Impression').map((e) => e.innerText.trim()).where((s) => s.isNotEmpty).toList();

      // Media files (Linear)
      final mediaUrls = <String>[];
      for (final mediaFile in document.findAllElements('MediaFile')) {
        final type = mediaFile.getAttribute('type')?.toLowerCase() ?? '';
        final raw = _extractCDataOrText(mediaFile);
        if (raw.isEmpty) continue;

        if (type == 'video/mp4' || type == 'video/webm' || type == 'application/x-mpegurl' || type == 'application/vnd.apple.mpegurl' || raw.endsWith('.mp4') || raw.contains('.m3u8')) {
          mediaUrls.add(raw);
        }
      }

      // ClickThrough & ClickTracking
      final clickThroughUrls = document.findAllElements('ClickThrough').map((e) => e.innerText.trim()).where((s) => s.isNotEmpty).toList();

      final clickTrackingUrls = document.findAllElements('ClickTracking').map((e) => e.innerText.trim()).where((s) => s.isNotEmpty).toList();

      // Tracking events
      final trackingEvents = <String, List<String>>{};
      for (final tracking in document.findAllElements('Tracking')) {
        final event = tracking.getAttribute('event');
        final url = tracking.innerText.trim();
        if (event != null && url.isNotEmpty) {
          trackingEvents.putIfAbsent(event, () => []).add(url);
        }
      }

      // Linear block and durations
      int? vastSkipDuration;
      int? linearDurationSeconds;

      final linearNodes = document.findAllElements('Linear');
      xml.XmlElement? chosenLinear;
      if (linearNodes.isNotEmpty) {
        chosenLinear = linearNodes.firstWhere((n) => n.getAttribute('skipoffset') != null, orElse: () => linearNodes.first);
      }

      final skipOffset = chosenLinear?.getAttribute('skipoffset');
      if (skipOffset != null) vastSkipDuration = _parseVastTimeValue(skipOffset);

      final durationNode = chosenLinear?.findElements('Duration').firstOrNull ?? document.findAllElements('Duration').firstOrNull;
      if (durationNode != null) linearDurationSeconds = _parseVastTimeValue(durationNode.innerText.trim());

      // Companion
      String? companionImageUrl;
      String? companionClickThroughUrl;
      int? companionDurationSeconds;
      final companion = document.findAllElements('Companion').firstOrNull;
      if (companion != null) {
        companionImageUrl =
            companion.findElements('StaticResource').map((e) => _extractCDataOrText(e)).firstOrNull ?? companion.findElements('HTMLResource').map((e) => _extractCDataOrText(e)).firstOrNull;

        companionClickThroughUrl = companion.findElements('CompanionClickThrough').map((e) => e.innerText.trim()).firstOrNull;

        final durationAttr = companion.getAttribute('duration');
        if (durationAttr != null) companionDurationSeconds = _parseVastTimeValue(durationAttr);
      }

      // ---- Robust NonLinear (overlay) parsing ----
      String? nonLinearImageUrl;
      String? nonLinearClickThroughUrl;
      String? nonLinearHtmlResource;
      String? nonLinearVideoUrl;
      int? nonLinearDurationSeconds;

      final nonLinearNodes = document.findAllElements('NonLinear');
      if (nonLinearNodes.isNotEmpty) {
        for (final nn in nonLinearNodes) {
          // duration
          final minDurationAttr = nn.getAttribute('minSuggestedDuration');
          if (minDurationAttr != null) nonLinearDurationSeconds = _parseVastTimeValue(minDurationAttr);

          // clickthrough
          nonLinearClickThroughUrl ??= nn.findElements('NonLinearClickThrough').map((e) => _extractCDataOrText(e)).where((s) => s.isNotEmpty).firstOrNull;

          // 1) IFrameResource
          final iframeNode = nn.findElements('IFrameResource').firstOrNull;
          if (iframeNode != null) {
            final raw = _extractCDataOrText(iframeNode);
            if (raw.isNotEmpty) {
              if (_looksLikeVideoUrl(raw)) {
                nonLinearVideoUrl ??= raw;
              } else if (raw.startsWith('http')) {
                nonLinearHtmlResource ??= '<iframe src="$raw" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen></iframe>';
              }
            }
          }

          // 2) HTMLResource
          final htmlNode = nn.findElements('HTMLResource').firstOrNull;
          if (htmlNode != null && nonLinearHtmlResource == null) {
            final htmlExtracted = _extractCDataOrText(htmlNode);
            if (htmlExtracted.isNotEmpty) {
              // If it's a URL wrap in iframe otherwise use raw HTML snippet
              if (htmlExtracted.startsWith('http')) {
                nonLinearHtmlResource = '<iframe src="$htmlExtracted" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen></iframe>';
              } else {
                nonLinearHtmlResource = htmlExtracted;
              }
            }
          }

          // 3) StaticResource (image or video)
          final staticNode = nn.findElements('StaticResource').firstOrNull;
          if (staticNode != null) {
            final raw = _extractCDataOrText(staticNode);
            final creativeType = staticNode.getAttribute('creativeType')?.toLowerCase() ?? '';

            if (raw.isNotEmpty) {
              if (creativeType.startsWith('video/') || _looksLikeVideoUrl(raw)) {
                nonLinearVideoUrl ??= raw;
              } else if (creativeType.startsWith('image/') || raw.endsWith('.jpg') || raw.endsWith('.jpeg') || raw.endsWith('.png') || raw.endsWith('.gif')) {
                nonLinearImageUrl ??= raw;
              } else if (creativeType.contains('html') || raw.startsWith('http')) {
                nonLinearHtmlResource ??= '<iframe src="$raw" width="100%" height="100%" frameborder="0" scrolling="no" allowfullscreen></iframe>';
              }
            }
          }

          // If we found at least one valid creative, stop (prefer first valid)
          if (nonLinearVideoUrl != null || nonLinearHtmlResource != null || nonLinearImageUrl != null) {
            break;
          }
        }
      }

      // Debug log to help trace what was parsed
      log('VAST parsed: mediaUrls=${mediaUrls.length}, nonLinearImage=$nonLinearImageUrl, nonLinearVideo=$nonLinearVideoUrl, nonLinearHtml=${nonLinearHtmlResource != null}, nonLinearClick=$nonLinearClickThroughUrl, nonLinearDuration=$nonLinearDurationSeconds');

      return VastMedia(
        mediaUrls: mediaUrls,
        clickThroughUrls: clickThroughUrls,
        clickTrackingUrls: clickTrackingUrls,
        skipDuration: vastSkipDuration,
        trackingEvents: trackingEvents,
        adTitle: adTitle,
        adSystem: adSystem,
        errorUrls: errorUrls,
        impressionUrls: impressionUrls,
        linearDurationSeconds: linearDurationSeconds,
        companionImageUrl: companionImageUrl,
        companionClickThroughUrl: companionClickThroughUrl,
        companionDurationSeconds: companionDurationSeconds,
        nonLinearImageUrl: nonLinearImageUrl,
        nonLinearClickThroughUrl: nonLinearClickThroughUrl,
        nonLinearHtmlResource: nonLinearHtmlResource,
        nonLinearDurationSeconds: nonLinearDurationSeconds,
        nonLinearVideoUrl: nonLinearVideoUrl,
      );
    } catch (e, st) {
      log('XML VAST parsing error: $e\n$st');
      return null;
    }
  }

  /// Parse inline XML content without performing a network request.
  VastMedia? parseXmlString(String xmlString) {
    if (xmlString.trim().isEmpty) return null;
    return _parseXmlVastResponse(xmlString);
  }

  /// Parse JSON VAST response (for non-XML responses)
  VastMedia? _parseJsonVastResponse(Map<String, dynamic> jsonData) {
    try {
      final mediaUrls = <String>[];
      final clickThroughUrls = <String>[];
      final clickTrackingUrls = <String>[];
      final trackingEvents = <String, List<String>>{};
      final errorUrls = <String>[];
      final impressionUrls = <String>[];

      // Extract common fields
      if (jsonData['video_url'] != null) mediaUrls.add(jsonData['video_url'].toString());
      if (jsonData['media_url'] != null) mediaUrls.add(jsonData['media_url'].toString());
      if (jsonData['url'] != null) mediaUrls.add(jsonData['url'].toString());

      if (jsonData['click_through_url'] != null) clickThroughUrls.add(jsonData['click_through_url'].toString());
      if (jsonData['click_url'] != null) clickThroughUrls.add(jsonData['click_url'].toString());

      if (jsonData['tracking_events'] is Map) {
        final events = jsonData['tracking_events'] as Map<String, dynamic>;
        events.forEach((event, urls) {
          if (urls is List) {
            trackingEvents[event] = urls.map((u) => u.toString()).toList();
          } else if (urls is String) {
            trackingEvents[event] = [urls];
          }
        });
      }

      int? skipDuration;
      if (jsonData['skip_duration'] != null) skipDuration = int.tryParse(jsonData['skip_duration'].toString());

      return VastMedia(
        mediaUrls: mediaUrls,
        clickThroughUrls: clickThroughUrls,
        clickTrackingUrls: clickTrackingUrls,
        skipDuration: skipDuration,
        trackingEvents: trackingEvents,
        adTitle: jsonData['ad_title']?.toString(),
        adSystem: jsonData['ad_system']?.toString(),
        errorUrls: errorUrls,
        impressionUrls: impressionUrls,
        linearDurationSeconds: int.tryParse(jsonData['duration']?.toString() ?? ''),
        companionImageUrl: jsonData['companion_image']?.toString(),
        companionClickThroughUrl: jsonData['companion_click_url']?.toString(),
        companionDurationSeconds: int.tryParse(jsonData['companion_duration']?.toString() ?? ''),
      );
    } catch (e, st) {
      log('JSON VAST parsing error: $e\n$st');
      return null;
    }
  }

  /// Parse direct video URL (for non-XML responses)
  VastMedia? _parseDirectVideoUrl(String url) {
    try {
      if (url.isNotEmpty && (url.startsWith('http') || url.startsWith('https'))) {
        return VastMedia(
          mediaUrls: [url],
          clickThroughUrls: [],
          clickTrackingUrls: [],
          skipDuration: 5,
          trackingEvents: {},
          adTitle: 'Direct Video Ad',
          adSystem: 'Direct',
          errorUrls: [],
          impressionUrls: [],
        );
      }
      return null;
    } catch (e, st) {
      log('Direct video URL parsing error: $e\n$st');
      return null;
    }
  }

  /// Send VAST tracking events (fire-and-forget)
  Future<void> sendTrackingEvents(List<String> urls) async {
    if (urls.isEmpty) return;

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        validateStatus: (_) => true,
      ),
    );

    for (final url in urls) {
      if (url.isEmpty) continue;
      try {
        final response = await dio.get(url);
        final status = response.statusCode ?? 0;
        if (status >= 400) {
          final key = '$url-$status';
          if (_loggedTrackingErrors.add(key)) {
            log('VAST tracking warning (HTTP $status): $url');
          }
        }
      } on DioException catch (e) {
        final key = '${url}_dio';
        if (_loggedTrackingErrors.add(key)) log('VAST tracking error: ${e.message}');
      } catch (e) {
        final key = '${url}_generic';
        if (_loggedTrackingErrors.add(key)) log('VAST tracking error: $e');
      }
    }
  }

  // Utilities

  static int? _parseVastTimeValue(String value) {
    final trimmed = value.trim();
    if (trimmed.contains(':')) {
      final parts = trimmed.split(':').map((e) => int.tryParse(e) ?? 0).toList();
      if (parts.length == 3) return parts[0] * 3600 + parts[1] * 60 + parts[2];
      if (parts.length == 2) return parts[0] * 60 + parts[1];
    } else {
      return int.tryParse(trimmed);
    }
    return null;
  }

  // Safely extract text or CDATA contents from a node
  static String _extractCDataOrText(xml.XmlElement node) {
    final raw = node.children.map((c) => c.toString()).join('');
    final cleaned = raw.replaceAll('<![CDATA[', '').replaceAll(']]>', '').trim();
    return cleaned;
  }

  // Heuristic to detect video URLs (mp4/webm/m3u8 or common video hosts)
  static bool _looksLikeVideoUrl(String s) {
    final lower = s.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.webm') || lower.contains('.m3u8') || lower.contains('youtube.com') || lower.contains('vimeo.com');
  }
}