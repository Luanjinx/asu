import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/extension/date_time_extension.dart' show DateExtension;

import '../constants.dart';

extension StrExt on String {
  //region DateTime
  DateTime get dateInyyyyMMddHHmmFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this);
    } catch (e) {
      try {
        return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(DateTime.parse(this).toString());
      } catch (e) {
        log('dateInyyyyMMddHHmmFormat Error in $this: $e');
        return DateTime.now();
      }
    }
  }

  String get dateInddMMMyyyyHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.dd_MMM_yyyy_HH_mm_a).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      try {
        return "$dateInyyyyMMddHHmmFormat";
      } catch (e) {
        return this;
      }
    }
  }

  //endregion

  //region common

  String get getYouTubeId {
    String url = validate();
    if (!url.contains('http') && (url.length == 11)) return url;
    url = url.trim();

    for (var exp in [
      RegExp(r"^https://(?:www\.|m\.)?youtube\.com/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https://(?:www\.|m\.)?youtube(?:-nocookie)?\.com/embed/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https://youtu\.be/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https://(?:www\.)?youtube\.com/live/([_\-a-zA-Z0-9]{11})(?:\?.*)?$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    return '';
  }

  bool get isDirectVideoLink {
    final videoExtensions = [
      '.mp4',
      '.mkv',
      '.webm',
      '.mov',
      '.avi',
      '.wmv',
      '.flv',
      '.m4v',
      '.3gp',
      '.3g2',
      '.ts',
      '.mts',
      '.m2ts',
      '.vob',
      '.ogv',
    ];

    final lowerCaseUrl = toLowerCase();
    return videoExtensions.any((ext) => lowerCaseUrl.endsWith(ext));
  }

  String get getURLFromIFrame {
    if (!this.startsWith("<iframe")) return this;

    final match = RegExp("src=['\"]([^'\"]+)['\"]").firstMatch(this);
    return match?.group(1) ?? this;
  }

  bool get isYoutubeLink {
    if (isEmpty) return false;

    final patterns = <RegExp>[
      // Normal watch URL
      RegExp(r"^(https?:\/\/)?(www\.)?youtube\.com\/watch\?v=[\w\-]{11}"),

      // Short youtu.be URL
      RegExp(r"^(https?:\/\/)?(www\.)?youtu\.be\/[\w\-]{11}"),

      // Embed player
      RegExp(r"^(https?:\/\/)?(www\.)?youtube(?:-nocookie)?\.com\/embed\/[\w\-]{11}"),

      // Live links
      RegExp(r"^(https?:\/\/)?(www\.)?youtube\.com\/live\/[\w\-]{11}"),

      // Shorts
      RegExp(r"^(https?:\/\/)?(www\.)?youtube\.com\/shorts\/[\w\-]{11}"),

      // Legacy /v/ style
      RegExp(r"^(https?:\/\/)?(www\.)?youtube\.com\/v\/[\w\-]{11}")
    ];

    return patterns.any((exp) => exp.hasMatch(this));
  }

  String get getVimeoVideoId {
    final RegExp regExp = RegExp(
      r'vimeo\.com/(?:channels/(?:\w+/)?|groups/[^/]+/videos/|album/\d+/video/|video/|)(\d+)(?:$|/|\?)',
    );
    final match = regExp.firstMatch(this);
    return (match != null && match.group(1) != null) ? match.group(1)! : '';
  }

  bool get isVimeoLink {
    final value = trim();
    if (value.isEmpty) return false;

    final patterns = <RegExp>[
      // Normal Vimeo video
      RegExp(r'^(https?:\/\/)?(www\.)?vimeo\.com\/\d+'),

      // Vimeo player embed URL
      RegExp(r'^(https?:\/\/)?player\.vimeo\.com\/video\/\d+'),

      // Vimeo iframe embed (note: NOT a raw string)
      RegExp(
        "<iframe[^>]*src=['\"]https?:\\/\\/player\\.vimeo\\.com\\/video\\/\\d+[^'\\\"]*['\"]",
      ),
    ];

    return patterns.any((exp) => exp.hasMatch(value));
  }

  bool isValidEmail() {
    return RegExp(r'^[a-z0-9]+([\._]?[a-z0-9]+)*@[a-z0-9]+\.[a-z]{2,}$').hasMatch(this);
  }

  String timeAgo() {
    final dateTime = DateTime.parse(this).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0) {
      if (diff.inHours > 0) {
        return '${diff.inHours} ${locale.value.hr} ${locale.value.ago}';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes} ${locale.value.min} ${locale.value.ago}';
      } else {
        return locale.value.justNow;
      }
    } else if (diff.inDays == 1) {
      return locale.value.yesterday;
    } else if (diff.inDays <= 2) {
      return '${diff.inDays} ${locale.value.daysAgo}';
    } else if (diff.inDays <= 30) {
      return '${(diff.inDays / 7).floor()} weeks ${locale.value.ago}';
    } else if (diff.inDays <= 365) {
      return '${(diff.inDays / 30).floor()} months ${locale.value.ago}';
    } else {
      return '${(diff.inDays / 365).floor()} years ${locale.value.ago}';
    }
  }

  String getFilterType() {
    if (this == locale.value.all) {
      return 'all';
    } else if (this == locale.value.movies) {
      return VideoType.movie;
    } else if (this == locale.value.tVShows) {
      return VideoType.tvshow;
    } else if (this == locale.value.videos) {
      return VideoType.video;
    } else {
      return '';
    }
  }

  String getContentTypeTitle() {
    if (this == VideoType.movie) {
      return locale.value.movies; 
    } else if (this == VideoType.tvshow) {
      return locale.value.tVShows;
    } else if (this == VideoType.episode) {
      return locale.value.episodes;
    } else if (this == VideoType.video) {
      return locale.value.videos;
    } else if (this == ApiRequestKeys.allKey) {
      return locale.value.all;
    } else {
      return '';
    }
  }

  String getContentTypeLabelSingular() {
    if (this == VideoType.movie) {
      return locale.value.movie;
    } else if (this == VideoType.tvshow) {
      return locale.value.tvShow;
    } else if (this == VideoType.video) {
      return locale.value.video;
    } else {
      return '';
    }
  }

  /// Returns singular content type title (e.g., Movie, TV Show, Video).
  String getContentTypeTitleSingular() {
    if (this == VideoType.movie) {
      return locale.value.movie;
    } else if (this == VideoType.tvshow) {
      return locale.value.tvShow;
    } else if (this == VideoType.video) {
      return locale.value.video;
    } else {
      return '';
    }
  }

  String getContentTypeIcon() {
    if (this == locale.value.all) {
      return '';
    } else if (this == locale.value.movies) {
      return Assets.iconsFilmReel;
    } else if (this == locale.value.tVShows) {
      return Assets.iconsTelevision;
    } else if (this == locale.value.videos) {
      return Assets.iconsVideo;
    } else {
      return '';
    }
  }

  String getPaymentLogo() {
    if (this == PaymentMethods.PAYMENT_METHOD_STRIPE) {
      return Assets.paymentLogoStripe;
    } else if (this == PaymentMethods.PAYMENT_METHOD_PAYPAL) {
      return Assets.paymentLogoPaypal;
    } else if (this == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
      return Assets.paymentLogoRazorpay;
    } else if (this == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
      return Assets.paymentLogoPaystack;
    } else if (this == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
      return Assets.paymentLogoFlutterwave;
    } else if (this == PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE) {
      return isIOS ? Assets.logosAppstoreConnect : Assets.logosGooglePlayConsole;
    }
    return '';
  }

  String getQualityIcon() {
    switch (this) {
      case QualityConstants.low:
        return Assets.quality480;
      case QualityConstants.medium:
        return Assets.quality720;
      case QualityConstants.high:
        return Assets.quality1080;
      case QualityConstants.veryHigh:
        return Assets.quality1440;
      case QualityConstants.ultra2K:
        return Assets.quality2k;
      case QualityConstants.ultra4K:
        return Assets.quality4k;
      case QualityConstants.ultra8K:
        return Assets.quality8k;
      default:
        return Assets.qualityStandardDefinition;
    }
  }

  /// Returns the appropriate icon for a page based on its slug
  String getPageIcon() {
    switch (this) {
      case AppPages.termsAndCondition:
        return Assets.iconsFileText;
      case AppPages.privacyPolicy:
        return Assets.iconsShieldCheck;
      case AppPages.helpAndSupport:
        return Assets.iconsQuestion;
      case AppPages.refundAndCancellation:
        return Assets.iconsReceipt;
      case AppPages.dataDeletion:
        return Assets.iconsTrash;
      case AppPages.faq:
        return Assets.iconsQuestion;
      case AppPages.aboutUs:
        return Assets.iconsInfo;
      default:
        return Assets.iconsFileText;
    }
  }

  String _phpToDartPattern() {
    const map = {
      'Y': 'yyyy',
      'y': 'yy',
      'm': 'MM',
      'n': 'M',
      'M': 'MMM',
      'F': 'MMMM',
      'd': 'dd',
      'j': 'd',
      'D': 'EEE',
      'l': 'EEEE',
      'H': 'HH',
      'G': 'H',
      'h': 'hh',
      'g': 'h',
      'i': 'mm',
      's': 'ss',
      'a': 'a',
      'A': 'a',
      'O': 'Z',
      'P': 'XXX',
    };

    final buffer = StringBuffer();

    for (var i = 0; i < length; i++) {
      final char = this[i];

      if (char == 'S') {
        buffer.write("'S'");
        continue;
      }

      buffer.write(map[char] ?? char);
    }

    return buffer.toString();
  }

  String _applyOrdinal(DateTime date, String formatted) {
    final day = date.day;

    String suffix;
    if (day >= 11 && day <= 13) {
      suffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
        default:
          suffix = 'th';
      }
    }

    return formatted.replaceAll('S', suffix);
  }

  String formatWithPhp(DateTime date) {
    try {
      final dartPattern = _phpToDartPattern();
      final formatted = DateFormat(dartPattern).format(date);
      return _applyOrdinal(date, formatted);
    } catch (e) {
      return date.formatDateYYYYmmdd();
    }
  }

  String getDeviceIconByPlatform({String deviceName = ''}) {
    if (this == 'mobile') {
      return Assets.iconsDeviceMobile;
    }

    return Assets.iconsDesktop;
  }

  String get singularSubscriptionDuration {
    switch (toLowerCase()) {
      case 'day':
        return locale.value.day;
      case 'week':
        return locale.value.week;
      case 'month':
        return locale.value.month;
      case 'year':
        return locale.value.year;
      default:
        return this;
    }
  }

  String get pluralSubscriptionDuration {
    switch (toLowerCase()) {
      case 'day':
        return locale.value.days;
      case 'week':
        return locale.value.weeks;
      case 'month':
        return locale.value.months;
      case 'year':
        return locale.value.years;
      default:
        return this;
    }
  }

  String getEmptyComingSoonListMessage() {
    final String filterType = this;
    if (filterType == ApiRequestKeys.allKey) {
      return locale.value.noComingSoonContentAvailable;
    } else if (filterType == VideoType.movie) {
      return locale.value.noComingSoonMovieAvailable;
    } else if (filterType == VideoType.tvshow) {
      return locale.value.noComingSoonTvShowAvailable;
    } else if (filterType == VideoType.video) {
      return locale.value.noComingSoonVideoAvailable;
    }
    return locale.value.noComingSoonContentAvailable;
  }
}