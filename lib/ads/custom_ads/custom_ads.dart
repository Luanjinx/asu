/// Model representing a custom ad configuration.
///
/// * [type] – the ad type, e.g. 'image' or 'video'.
/// * [url] – the media URL.
/// * [redirectUrl] – optional URL to open when the ad is tapped.
/// * [size] – optional size identifier for banner ads (e.g. 'banner', 'largeBanner').
class CustomAds {
  final String type;
  final String url;
  final String redirectUrl;
  final double? size;

  const CustomAds({
    required this.type,
    required this.url,
    this.redirectUrl = '',
    this.size,
  });
}