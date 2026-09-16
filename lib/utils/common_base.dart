import 'dart:async';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:playx_version_update/playx_version_update.dart';
import 'package:share_plus/share_plus.dart';
import 'package:slugify/slugify.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/new_update_dialog.dart';
import 'package:streamit_laravel/components/u_l_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/account_setting/components/logout_account_component.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/extension/get_x_extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../configs.dart';
import '../main.dart';
import 'colors.dart';
import 'common_functions.dart';
import 'constants.dart';
import 'country_picker/country_list.dart';

Widget getAppBarGradient({Color? statusBarColor, String titleText = ''}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: List.generate(
          8,
          (i) => (statusBarColor ?? appColorSecondary).withValues(
            alpha: [0.16, 0.14, 0.12, 0.10, 0.08, 0.04, 0.02, 0.01][i],
          ),
        ),
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: titleText.isNotEmpty
        ? Text(
            titleText,
            style: boldTextStyle(
                size: ResponsiveSize.getFontSize(Constants.labelTextSize)),
          )
        : null,
  );
}

Widget get commonDivider => const Column(
      children: [
        Divider(height: 1, thickness: 0.6, color: borderColor),
      ],
    );

Future<void> handleRate() async {
  if (appConfigs.value.applicationURL.applicationURL.isNotEmpty)
    commonLaunchUrl(appConfigs.value.applicationURL.applicationURL,
        launchMode: LaunchMode.externalApplication);
}

void hideKeyBoardWithoutContext() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(
      id: 1,
      name: locale.value.english,
      languageCode: 'en',
      fullLanguageCode: 'en-US',
      flag: Assets.flagsIcUs,
    ),
    LanguageDataModel(
      id: 2,
      name: 'Greek',
      languageCode: 'el',
      fullLanguageCode: 'el-EL',
      flag: Assets.flagsIcGreece,
    ),
    LanguageDataModel(
      id: 3,
      name: locale.value.arabic,
      languageCode: 'ar',
      fullLanguageCode: 'ar-AR',
      flag: Assets.flagsIcAr,
    ),
    LanguageDataModel(
      id: 4,
      name: locale.value.french,
      languageCode: 'fr',
      fullLanguageCode: 'fr-FR',
      flag: Assets.flagsIcFr,
    ),
    LanguageDataModel(
      id: 4,
      name: locale.value.german,
      languageCode: 'de',
      fullLanguageCode: 'de-DE',
      flag: Assets.flagsIcDe,
    ),
  ];
}

Future<void> commonLaunchUrl(String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode);
}

enum DeviceType { mobile, tablet, desktop, tv }

class ResponsiveSize {
  // Base reference dimensions
  static late double baseWidth;
  static late double baseHeight;
  static late DeviceType deviceType;

  static double getHorizontalPadding(double basePadding) => basePadding;

  /// Device type detection
  static DeviceType getDeviceType() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;

    double screenWidth = view.physicalSize.width / view.devicePixelRatio;
    deviceType = DeviceType.mobile;
    if (screenWidth >= 1920) deviceType = DeviceType.tv;
    if (screenWidth >= 1024) deviceType = DeviceType.desktop;
    if (screenWidth >= 600) deviceType = DeviceType.tablet;

    return deviceType;
  }

  /// Assign baseWidth/baseHeight
  static void initResponsive() {
    getDeviceType();
    switch (deviceType) {
      case DeviceType.mobile:
        baseWidth = Platform.isIOS ? 375.0 : 411.0;
        baseHeight = Platform.isIOS ? 812.0 : 823.0;
        break;
      case DeviceType.tablet:
        baseWidth = Platform.isIOS ? 768.0 : 800.0;
        baseHeight = Platform.isIOS ? 1024.0 : 1280.0;
        break;
      case DeviceType.desktop:
        baseWidth = 1366.0;
        baseHeight = 768.0;
        break;
      case DeviceType.tv:
        baseWidth = 1920.0;
        baseHeight = 1080.0;
        break;
    }
  }

  static double getVerticalPadding(double basePadding) => basePadding;

  // EdgeInsets helpers
  static EdgeInsets getEdgeInsets(double baseValue) =>
      EdgeInsets.all(baseValue);

  static EdgeInsets getSymmetricPadding({
    required double horizontal,
    required double vertical,
  }) =>
      EdgeInsets.symmetric(
        horizontal: getHorizontalPadding(horizontal),
        vertical: getVerticalPadding(vertical),
      );

  static EdgeInsets getHorizontalOnly(double baseValue) =>
      EdgeInsets.symmetric(horizontal: baseValue);

  static EdgeInsets getFromLTRB({
    required double left,
    required double top,
    required double right,
    required double bottom,
  }) =>
      EdgeInsets.fromLTRB(
        getHorizontalPadding(left),
        getVerticalPadding(top),
        getHorizontalPadding(right),
        getVerticalPadding(bottom),
      );

  // Font size

  static int getFontSize(
    double baseSize, {
    double minScale = 0.8,
    double maxScale = 2.5,
  }) =>
      baseSize.toInt();

  // Position helpers
  static double getTop(double baseTop) => getVerticalPadding(baseTop);

  static double getBottom(double baseBottom) => getVerticalPadding(baseBottom);

  static double getStart(double baseStart) => getHorizontalPadding(baseStart);

  static double getEnd(double baseEnd) => getHorizontalPadding(baseEnd);
}

/// Configure base font & UI globals
void setupGlobalFontConfig() {
  ResponsiveSize.initResponsive();
  fontFamilyPrimaryGlobal = APP_FONT_FAMILY;
  textPrimarySizeGlobal = 16;

  fontFamilySecondaryGlobal = APP_FONT_FAMILY;
  textSecondarySizeGlobal = 14.toDouble();

  fontFamilyBoldGlobal = APP_FONT_FAMILY;

  textPrimaryColorGlobal = primaryTextColor;
  textSecondaryColorGlobal = secondaryTextColor;

  defaultBlurRadius = 0;
  defaultRadius = 8;
  defaultSpreadRadius = 0;
}

//region Common TextStyle

TextStyle get appButtonTextStyleGray => boldTextStyle(
    color: appColorSecondary, size: ResponsiveSize.getFontSize(14));

TextStyle get appButtonPrimaryColorText =>
    boldTextStyle(color: appColorPrimary);

TextStyle get appButtonFontColorText =>
    boldTextStyle(color: Colors.grey, size: ResponsiveSize.getFontSize(14));

TextStyle get appButtonTextStyleWhite => boldTextStyle(
    color: primaryTextColor,
    size: ResponsiveSize.getFontSize(14),
    weight: FontWeight.w600);

TextStyle commonSecondaryTextStyle(
    {int? size, Color? color, FontStyle? fontStyle}) {
  return secondaryTextStyle(
    weight: FontWeight.w500,
    color: color ?? secondaryTextColor,
    size: ResponsiveSize.getFontSize((size ?? 14).toDouble()),
    fontStyle: fontStyle,
  );
}

TextStyle commonPrimaryTextStyle(
    {int? size, Color? color, FontStyle? fontStyle}) {
  return commonW500PrimaryTextStyle(
    color: color ?? primaryTextColor,
    size: ResponsiveSize.getFontSize((size ?? 16).toDouble()),
    fontStyle: fontStyle,
  );
}

TextStyle commonW600PrimaryTextStyle(
    {int? size, Color? color, FontStyle? fontStyle}) {
  return primaryTextStyle(
    weight: FontWeight.w600,
    color: color ?? primaryTextColor,
    size: ResponsiveSize.getFontSize((size ?? 16).toDouble()),
    fontStyle: fontStyle,
  );
}

TextStyle commonW500PrimaryTextStyle(
    {int? size, Color? color, FontStyle? fontStyle}) {
  return primaryTextStyle(
    weight: FontWeight.w500,
    color: color ?? primaryTextColor,
    size: ResponsiveSize.getFontSize((size ?? 16).toDouble()),
    fontStyle: fontStyle,
  );
}

//endregion

//region Common Input Decoration
InputDecoration inputDecoration(
  BuildContext context, {
  Widget? prefixIcon,
  EdgeInsetsGeometry? contentPadding,
  BoxConstraints? prefixIconConstraints,
  BoxConstraints? suffixIconConstraints,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  Color? fillColor,
  bool? alignLabelWithHint,
  InputBorder? enabledBorder,
  InputBorder? focusedErrorBorder,
  InputBorder? errorBorder,
  InputBorder? border,
  InputBorder? focusedBorder,
  InputBorder? disabledBorder,
  VisualDensity? visualDensity,
  BoxConstraints? boxConstraints,
}) {
  return InputDecoration(
    contentPadding: contentPadding,
    //labelText: labelText,
    counterText: "",
    hintText: hintText,
    hintStyle: commonSecondaryTextStyle(),
    labelStyle: commonSecondaryTextStyle(),
    alignLabelWithHint: alignLabelWithHint,
    prefixIcon: prefixIcon,
    prefixIconConstraints: prefixIconConstraints,
    suffixIcon: suffixIcon,
    suffixIconConstraints: suffixIconConstraints,
    enabledBorder: enabledBorder ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0),
        ),
    focusedErrorBorder: focusedErrorBorder ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: appColorPrimary, width: 0.0),
        ),
    errorBorder: errorBorder ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: appColorPrimary, width: 1.0),
        ),
    errorMaxLines: 2,
    border: border ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0),
        ),
    disabledBorder: disabledBorder ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 0.0),
        ),
    errorStyle: commonPrimaryTextStyle(color: appColorPrimary, size: 12),
    focusedBorder: focusedBorder ??
        const OutlineInputBorder(
          borderSide: BorderSide(color: appColorPrimary, width: 0.0),
        ),
    filled: filled ?? true,
    fillColor: fillColor,
    visualDensity: visualDensity,
    constraints: boxConstraints,
    hoverColor: Colors.transparent,
  );
}

InputDecoration inputDecorationWithFillBorder(
  BuildContext context, {
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? labelText,
  String? hintText,
  double? borderRadius,
  bool? filled,
  Color? fillColor,
}) {
  return InputDecoration(
    contentPadding:
        ResponsiveSize.getFromLTRB(left: 12, top: 10, right: 10, bottom: 10),
    labelText: labelText,
    hintText: hintText,
    hintStyle: commonSecondaryTextStyle(size: 12),
    labelStyle: commonSecondaryTextStyle(size: 12),
    alignLabelWithHint: true,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: appColorPrimary),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: cardColor),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: appColorPrimary),
    ),
    errorMaxLines: 2,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: cardColor),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: cardColor),
    ),
    errorStyle: commonPrimaryTextStyle(color: appColorPrimary, size: 12),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      borderSide: BorderSide(color: appColorPrimary),
    ),
    filled: filled,
    fillColor: fillColor,
  );
}

//endregion

Widget backButton(
    {Object? result,
    double size = 20,
    EdgeInsets? padding,
    VoidCallback? onBackPressed,
    BuildContext? context}) {
  return IconButton(
    padding: padding ?? EdgeInsets.zero,
    onPressed: onBackPressed ??
        () {
          bool isLandscape =
              MediaQuery.of(context ?? Get.context!).orientation ==
                  Orientation.landscape;
          if (isLandscape) {
            SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          }
          Get.back(result: result);
        },
    icon: IconWidget(
        imgPath: isRTL.value ? Assets.iconsCaretRight : Assets.iconsCaretLeft,
        color: Colors.white,
        size: size),
  );
}

/// Routes name to directly navigate the route by its name

String movieDurationTime(String time) {
  // Parse the input string
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

  // Create a Duration object
  Duration duration =
      Duration(hours: hours, minutes: minutes, seconds: seconds);

  // Extract hours, minutes, and seconds
  int h = duration.inHours;
  int m = duration.inMinutes.remainder(60);
  int s = duration.inSeconds.remainder(60);

  // Format the string
  String formattedTime = h == 0 ? '${m}m' : '${h}h ${m}m';
  if (s != 0) {
    formattedTime += ' ${s}s';
  }

  return formattedTime;
}

/// Format remaining release days to show day/days, week/weeks, month/months
String formatRemainingReleaseDays(int remaningReleaseDays) {
  if (remaningReleaseDays <= 0) return '';

  if (remaningReleaseDays < 7) {
    return 'In $remaningReleaseDays ${remaningReleaseDays == 1 ? 'Day' : 'Days'}';
  } else if (remaningReleaseDays < 30) {
    final weeks = (remaningReleaseDays / 7).floor();
    return 'In $weeks ${weeks == 1 ? 'Week' : 'Weeks'}';
  } else if (remaningReleaseDays < 365) {
    final months = (remaningReleaseDays / 30).floor();
    return 'In $months ${months == 1 ? 'Month' : 'Months'}';
  } else {
    final years = (remaningReleaseDays / 365).floor();
    return 'In $years ${years == 1 ? 'Year' : 'Years'}';
  }
}

String formatDuration(String time) {
  // Parse the input string
  List<String> parts = time.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

  // Create a Duration object
  Duration duration =
      Duration(hours: hours, minutes: minutes, seconds: seconds);

  // Extract hours, minutes, and seconds
  int h = duration.inHours;
  int m = duration.inMinutes.remainder(60);
  int s = duration.inSeconds.remainder(60);

  // Format the string
  String formattedTime = '';
  if (h > 0) formattedTime = '${h}h ';
  if (m > 0) {
    formattedTime += '${m}m ';
  } else if (s > 0) {
    formattedTime += '${s}s'; // Show seconds only if minutes are 0
  }

  return formattedTime;
}

// Pending Movie Percentage
(double pendingPercentage, String timeLeft) calculatePendingPercentage(
    String totalDuration, String watchedDuration) {
  Duration parseTime(String time) {
    if (time.isEmpty) {
      return Duration.zero; // Handle empty input
    }
    List<String> parts = time.split(':');
    int hours = 0, minutes = 0, seconds = 0;

    try {
      if (parts.length > 2) {
        hours = int.parse(parts[0]);
        minutes = int.parse(parts[1]);
        seconds = int.parse(parts[2].split('.').first);
      } else {
        minutes = int.parse(parts[0]);
        seconds = int.parse(parts[1].split('.').first);
      }
    } catch (e) {
      return Duration.zero; // Handle parsing error
    }

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // Parse the time strings into Duration objects
  Duration movieTotalDuration = parseTime(totalDuration);
  Duration watchedTimerDuration = parseTime(watchedDuration);

  // Calculate the total seconds
  int totalSeconds = movieTotalDuration.inSeconds;
  int watchedTimerSeconds = watchedTimerDuration.inSeconds;

  if (totalSeconds <= 0) {
    // Avoid division by zero or invalid total time
    return (0.0, "00:00:00 ");
  }

  // Calculate the percentage
  double pendingPercentage =
      (watchedTimerSeconds / totalSeconds).clamp(0.0, 1.0);

  // Format the remaining time
  String formattedRemainingTime = formatDuration(
    (movieTotalDuration - watchedTimerDuration).toString().split('.').first,
  );
  if (formattedRemainingTime.isEmpty) {
    formattedRemainingTime = '0s ${locale.value.left}';
  } else {
    formattedRemainingTime = '$formattedRemainingTime ${locale.value.left}';
  }

  return (pendingPercentage, formattedRemainingTime);
}

class DashboardCategoryType {
  static const rateApp = 'rate-our-app';
  static const continueWatching = 'continue_watching';
  static const genres = 'genres';

  static const favoriteGenres = 'favorite_genres';
  static const popularTvShow = 'popular_tvshow';
  static const popularMovie = 'popular_movie';
  static const popularVideo = 'popular_video';
  static const popularLanguage = 'popular_language';
  static const personality = 'personality';
  static const favoritePersonality = 'favorite_personality';
  static const otherSections = 'other_section';
  static const channels = 'top_channel';
  static const freeMovie = 'free_movie';
  static const latestMovies = 'latest_movie';
  static const advertisement = 'advertisement';
  static const top10 = 'top_10';
  static const recommendedForYou = 'recommended_for_you';
  static const payPerView = 'pay_per_view';
  static const customAd = 'custom_ad';
  static const basedOnPreviousWatch = 'based_on_previous_watch';
  static const basedOnLikes = 'based_on_likes';
  static const basedOnViews = 'based_on_imdb';
  static const personalised = 'personalised';

  static const trendingInCountry = 'trending_in_country';
}

//Show Mobile NO Format
String formatMobileNumber(String mobileNumber) {
  if (mobileNumber.length != 12) {
    return mobileNumber;
  }

  String countryCode = mobileNumber.substring(0, 2);
  String firstPart = mobileNumber.substring(2, 4);
  String lastPart = mobileNumber.substring(mobileNumber.length - 2);
  String maskedMiddlePart = "******";

  String formattedNumber = "+$countryCode $firstPart$maskedMiddlePart$lastPart";

  return formattedNumber;
}

DateTime calculateExpirationDate(
    DateTime startDate, String duration, int durationTime) {
  int durationTimes = durationTime;

  switch (duration.toLowerCase()) {
    case 'month':
      return DateTime(
          startDate.year, startDate.month + durationTimes, startDate.day);
    case 'year':
      return DateTime(
          startDate.year + durationTimes, startDate.month, startDate.day);
    case 'quarterly':
      return DateTime(
          startDate.year, startDate.month + (durationTimes * 3), startDate.day);
    case 'week':
      return startDate.add(Duration(days: durationTimes * 7));

    // Add more cases if needed
    default:
      return DateTime(startDate.year, startDate.month, startDate.day);
  }
}

/* Future<SnackbarController> errorSnackBar({required dynamic error, SnackPosition? position}) async {
  String message;
  if (!await isNetworkAvailable()) {
    message = locale.value.noInternetAvailable;
  } else if (error is String) {
    message = error;
  } else if (error is Map<String, dynamic>) {
    message = error['error_message'] ?? error['message'] ?? error['error'];
  } else {
    message = locale.value.somethingWentWrong;
  }

  return Get.showSnackBar(
    isDismissible: true,
    padding: ResponsiveSize.getSymmetricPadding(horizontal: 8, vertical: 2),
    message: message,
    snackPosition: position ?? SnackPosition.BOTTOM,
    colorText: cardColor,
    backgroundColor: lightPrimaryColor,
    borderRadius: 4,
    margin: ResponsiveSize.getFromLTRB(left: 16, top: 0, right: 16, bottom: 64),
  );
} */

Future<void> errorSnackBar(
    {required dynamic error, SnackPosition? position}) async {
  String message;
  if (!await isNetworkAvailable()) {
    message = locale.value.noInternetAvailable;
  } else if (error is String) {
    message = error;
  } else if (error is Map<String, dynamic>) {
    message = error['error_message'] ?? error['message'] ?? error['error'];
  } else {
    message = locale.value.somethingWentWrong;
  }
  FToast fToast = FToast();
  try {
    fToast.init(navigatorKey.currentContext!);
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: appColorPrimary.withAlpha(220)),
        child: Text(
          message,
          style: const TextStyle(color: whiteColor),
          textAlign: TextAlign.start,
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          bottom: 50.0,
          left: 16.0,
          right: 16.0,
          child: child,
        );
      },
    );
  } catch (e) {}
}

/* SnackbarController successSnackBar(String message, {SnackPosition? position}) {
  return Get.showSnackBar(
    isDismissible: true,
    message: message,
    snackPosition: position ?? SnackPosition.BOTTOM,
    margin: ResponsiveSize.getFromLTRB(left: 8, top: 0, right: 8, bottom: 60),
    colorText: cardColor,
    borderRadius: 4,
    padding: ResponsiveSize.getSymmetricPadding(horizontal: 8, vertical: 2),
    backgroundColor: successSnackBarBackgroundColor,
  );
} */

void successSnackBar(String message, {Widget? icon, SnackPosition? position}) {
  FToast fToast = FToast();
  try {
    fToast.init(navigatorKey.currentContext!);
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0), color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 8.0),
            ],
            Flexible(
              child: Text(
                message,
                style: const TextStyle(color: whiteColor),
              ),
            ),
          ],
        ),
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 3),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          bottom: 50.0,
          left: 16.0,
          right: 16.0,
          child: child,
        );
      },
    );
  } catch (e) {
    print("Error showing toast: $e");
  }
}

String getNumberInString(int durationTime) {
  switch (durationTime) {
    case 1:
      return "one";
    case 2:
      return "two";
    case 3:
      return "three";
    case 4:
      return "four";
    case 5:
      return "five";
    case 6:
      return "six";
    case 7:
      return "seven";
    case 8:
      return "eight";
    case 9:
      return "nine";
    case 10:
      return "ten";
    case 11:
      return "eleven";
    case 12:
      return "twelve";
    case -1:
      return "one";
    // Add more cases if needed
    default:
      return "one";
  }
}

String formatDateWithDaySuffix(String dateString) {
  if (dateString.isEmpty) return "";

  try {
    final date = DateTime.parse(dateString);
    final day = date.day;
    final suffix = getDaySuffix(day);
    final formatter = DateFormat('MMM yyyy, hh:mm a', 'en');
    return '${day}$suffix ${formatter.format(date)}';
  } catch (e) {
    return dateString;
  }
}

String getDaySuffix(int day) {
  if (day >= 11 && day <= 13) return 'th';

  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

IconData getDeviceIconByPlatform(
    {required String deviceName, required String platform}) {
  final lowerName = deviceName.toLowerCase();
  final lowerPlatform = platform.toLowerCase();

  if (lowerName.contains('browser') ||
      lowerName.contains('chrome') ||
      lowerName.contains('firefox') ||
      lowerName.contains('safari') ||
      lowerName.contains('edge') ||
      lowerName.contains('opera') ||
      lowerPlatform.contains('web') ||
      lowerPlatform.contains('desktop')) {
    return Icons.computer;
  }

  if (lowerName.contains('iphone') ||
      lowerName.contains('ipad') ||
      lowerName.contains('ios') ||
      lowerPlatform.contains('ios')) {
    return Icons.phone_iphone;
  }

  if (lowerName.contains('android') || lowerPlatform.contains('android')) {
    return Icons.phone_android;
  }

  return Icons.phone_android;
}

Widget IconWidget(
    {required String imgPath,
    Color? color,
    double size = 20,
    bool colorRequired = true}) {
  return CachedImageWidget(
    url: imgPath,
    width: size,
    height: size,
    color: colorRequired ? color ?? primaryIconColor : null,
  );
}

String getVideoLink(String iframeString) {
  final regex = RegExp(r'src="(.*?)"');
  final match = regex.firstMatch(iframeString);
  return match?.group(1) ?? '';
}

Rect? getSharePositionOrigin(BuildContext? context) {
  try {
    BuildContext? ctx = context ?? Get.context;
    if (ctx != null) {
      final RenderBox? box = ctx.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;
        if (size.width > 0 && size.height > 0) {
          return position & size;
        }
      }
    }
  } catch (e) {
    // ignore
  }

  // Fallback to screen center/dimensions to avoid crash on iPad
  try {
    final ctx = Get.context;
    if (ctx != null) {
      final size = MediaQuery.of(ctx).size;
      if (size.width > 0 && size.height > 0) {
        return Rect.fromLTWH(size.width / 2 - 50, size.height / 2 - 50, 100, 100);
      }
    }
  } catch (_) {}

  return const Rect.fromLTWH(0, 0, 100, 100);
}

Future<void> safeShare(ShareParams params) async {
  try {
    await SharePlus.instance.share(params);
  } on PlatformException catch (e) {
    if (e.message?.contains("sharePositionOrigin") == true || e.details?.toString().contains("sharePositionOrigin") == true || e.toString().contains("sharePositionOrigin")) {
      try {
        final fallbackParams = ShareParams(
          text: params.text,
          files: params.files,
          uri: params.uri,
          title: params.title,
          subject: params.subject,
          excludedCupertinoActivities: params.excludedCupertinoActivities,
          downloadFallbackEnabled: params.downloadFallbackEnabled,
          mailToFallbackEnabled: params.mailToFallbackEnabled,
          fileNameOverrides: params.fileNameOverrides,
          previewThumbnail: params.previewThumbnail,
          sharePositionOrigin: const Rect.fromLTWH(0, 0, 1, 1),
        );
        await SharePlus.instance.share(fallbackParams);
      } catch (_) {
        // ignore secondary failures
      }
    } else {
      rethrow;
    }
  } catch (_) {
    // ignore other exceptions
  }
}

void shareVideo({required String type, required String name, BuildContext? context}) async {
  String shareURL = "";

  String slug = slugify(name);

  shareURL = '$DOMAIN_URL/$type-details/$slug';
  if (shareURL.isNotEmpty) {
    SharePlus.instance.share(ShareParams(text: shareURL.trim()));
  } else {
    toast(locale.value.sorryCouldntShareThis(type));
  }
}

String getReleaseYear(String date) {
  if (date.isNotEmpty) {
    String year = DateTime.parse(date).year.toString();
    return year;
  } else {
    return "";
  }
}

String getIcons({required String title}) {
  Map<String, dynamic> iconMap = {
    SubscriptionTitle.videoCast: Assets.iconsScreencast,
    SubscriptionTitle.ads: Assets.iconsMegaphone,
    SubscriptionTitle.deviceLimit: Assets.iconsDevices,
    SubscriptionTitle.downloadStatus: Assets.iconsDownload,
    SubscriptionTitle.supportedDeviceType: Assets.iconsDeviceMobile,
    SubscriptionTitle.profileLimit: Assets.iconsUserCircleGear,
  };
  return iconMap[title] ?? Assets.iconsReadCvLogo;
}

int determinePerPage({int? perPage}) {
  if (perPage != null) return perPage;
  // Obtain the screen width in logical pixels
  final screenWidth = ResponsiveSize.baseWidth;
  if (screenWidth < 600) {
    // Mobile devices
    return Constants.mobilePerPage;
  } else if (screenWidth < 1200) {
    // Tablet devices
    return Constants.tabletPerPage;
  } else {
    // Other devices (e.g., desktops)
    return Constants.desktopPerPage;
  }
}

String getSubscriptionPlanStatus(String status) {
  if (status == SubscriptionStatus.active) {
    return locale.value.active;
  } else if (status == SubscriptionStatus.inActive) {
    return locale.value.expired;
  } else if (status == SubscriptionStatus.cancel) {
    return locale.value.cancelled;
  } else if (status == SubscriptionStatus.deActive) {
    return locale.value.deactivated;
  } else {
    return '';
  }
}

String getPlatformMinimumVersion() {
  if (isIOS) {
    return appConfigs.value.mobileApp!.ios.minimumRequiredVersion;
  } else {
    return appConfigs.value.mobileApp!.android.minimumRequiredVersion;
  }
}

bool getIfForceUpdate(String currentVersion) {
  if (isIOS) {
    return appConfigs.value.mobileApp!.ios.minimumRequiredVersion.isNotEmpty &&
        appConfigs.value.mobileApp!.ios.minimumRequiredVersion !=
            currentVersion;
  } else {
    return appConfigs
            .value.mobileApp!.android.minimumRequiredVersion.isNotEmpty &&
        appConfigs.value.mobileApp!.android.minimumRequiredVersion !=
            currentVersion;
  }
}

StreamSubscription? _downloadInfoStreamSubscription;

Future<void> showAppUpdateDialog(BuildContext context) async {
  PackageInfoData packageInfo = await getPackageInfo();

  final result = await PlayxVersionUpdate.checkVersion(
    options: PlayxUpdateOptions(
      androidPackageName: packageInfo.packageName,
      iosBundleId: packageInfo.packageName,
      minVersion: getPlatformMinimumVersion(),
      forceUpdate: getIfForceUpdate(packageInfo.versionName.validate()),
    ),
  );

  result.when(
    success: (info) async {
      if (!info.canUpdate) return;

      bool showNewUpdate = false;
      await checkApiCallIsWithinTimeSpan(
        duration: Duration(days: 1),
        callback: () {
          showNewUpdate = appUpdateNotify.value;
        },
        sharePreferencesKey: SharedPreferenceConst.NEW_UPDATE_LAST_CALL_TIME,
      );
      if (showNewUpdate ||
          getIfForceUpdate(packageInfo.versionName.validate())) {
        setIntToLocal(SharedPreferenceConst.NEW_UPDATE_LAST_CALL_TIME,
            DateTime.timestamp().millisecondsSinceEpoch);
        showDialog(
          context: context,
          builder: (context) => NewUpdateDialog(
            version: info.newVersion,
            updates: [info.releaseNotes.toString()],
            onUpdate: () async {
              Get.back();
              if (getIfForceUpdate(packageInfo.versionName.validate())) {
                await PlayxVersionUpdate.startImmediateUpdate();
              } else {
                final result = await PlayxVersionUpdate.startFlexibleUpdate();

                result.when(
                  success: (isStarted) {
                    if (isStarted) {
                      listenToFlexibleDownloadUpdates(context);
                    } else {}
                  },
                  error: (error) {
                    errorSnackBar(error: error);
                  },
                );
              }
            },
            onCancel: () async {
              if (getIfForceUpdate(packageInfo.versionName.validate())) {
                exit(0);
              } else {
                Get.back();
              }
            },
          ),
        );
      }
    },
    error: (error) {
      debugPrint('Error checking for update: ${error.message}');
    },
  );
}

// IMPORTANT: Always cancel your stream subscription when it's no longer needed
// (e.g., in your widget's dispose method) to prevent memory leaks.
void listenToFlexibleDownloadUpdates(BuildContext context) {
  _downloadInfoStreamSubscription =
      PlayxVersionUpdate.listenToFlexibleDownloadUpdate().listen((info) {
    if (info == null) {
      return;
    }

    switch (info.status) {
      case PlayxDownloadStatus.downloaded:
        // The update is ready! Prompt the user to install it.
        _promptToCompleteFlexibleUpdate(context);
        _downloadInfoStreamSubscription
            ?.cancel(); // Stop listening once it's downloaded.
        break;
      case PlayxDownloadStatus.failed:
        _downloadInfoStreamSubscription?.cancel();
        // Inform the user and maybe offer a retry.
        break;
      case PlayxDownloadStatus.canceled:
        _downloadInfoStreamSubscription?.cancel();
        break;
      case PlayxDownloadStatus
            .installed: // Added this case for completeness with new enum

        _downloadInfoStreamSubscription?.cancel();
        break;
      default: // Handles unknown or any new statuses

        break;
    }
  }, onError: (error) {
    toast(locale.value.errorWhileMonitoringDownloadUpdates(error.toString()));
  });
}

Future<void> _promptToCompleteFlexibleUpdate(BuildContext context) async {
  Get.showSnackBar(
    isDismissible: true,
    message: 'A new update has finished downloading!',
    snackPosition: SnackPosition.BOTTOM,
    margin: ResponsiveSize.getFromLTRB(left: 8, top: 0, right: 8, bottom: 60),
    colorText: cardColor,
    borderRadius: 4,
    padding: ResponsiveSize.getSymmetricPadding(horizontal: 8, vertical: 2),
    backgroundColor: successSnackBarBackgroundColor,
    mainButton: TextButton(
      onPressed: () async {
        final result = await PlayxVersionUpdate.completeFlexibleUpdate();
        result.when(
          success: (isCompleted) {},
          error: (error) {
            errorSnackBar(error: error.message);
          },
        );
      },
      child: Text('Restart App',
          style: boldTextStyle(
              size: ResponsiveSize.getFontSize(14), color: darkGreen)),
    ),
  );
}

ReadMoreText readMoreTextWidget(
  String data, {
  Color? colorClickableText,
  int trimLength = 250,
  int trimLines = 2,
  TrimMode trimMode = TrimMode.Line,
  TextAlign? textAlign,
  TextDirection? textDirection,
  double? textScaleFactor,
  String? semanticsLabel,
  int? textSize,
}) {
  return ReadMoreText(
    parseHtmlString(data),
    trimMode: trimMode,
    style: secondaryTextStyle(
      weight: FontWeight.w500,
      color: descriptionTextColor,
      size: ResponsiveSize.getFontSize((14).toDouble()),
    ),
    textAlign: textAlign,
    trimLength: trimLength,
    colorClickableText: colorClickableText ?? appColorPrimary,
    semanticsLabel: semanticsLabel,
    trimExpandedText: locale.value.readLess.prefixText(value: ' '),
    trimCollapsedText: locale.value.readMore,
    trimLines: trimLines,
    textScaleFactor: textScaleFactor,
  );
}

Widget viewAllWidget({
  required String label,
  Widget? iconButton,
  Color? labelColor,
  int? labelSize,
  void Function()? onButtonPressed,
  Icon? icon,
  IconData? iconData,
  Color? iconColor,
  bool showViewAll = true,
  bool isSymmetricPaddingEnable = true,
}) {
  return Row(
    children: [
      Text(
        label,
        style: commonW600PrimaryTextStyle(
            size: labelSize ?? 18, color: labelColor ?? primaryTextColor),
      ).expand(),
      if (showViewAll)
        iconButton ??
            InkWell(
              onTap: onButtonPressed,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: IconWidget(
                imgPath: isRTL.value
                    ? Assets.iconsCaretLeft
                    : Assets.iconsCaretRight,
                size: 16,
              ),
            ),
    ],
  ).paddingSymmetric(
      horizontal: isSymmetricPaddingEnable
          ? ResponsiveSize.getHorizontalPadding(16)
          : 0,
      vertical:
          isSymmetricPaddingEnable ? ResponsiveSize.getVerticalPadding(16) : 0);
}

void handleLogoutFromAllOtherDevices({
  required Function(bool isLoading) loaderOnOff,
  required RxBool isLoading,
  bool isCancelButtonShow = true,
  VoidCallback? onSuccess,
  String? title,
}) {
  Get.bottomSheet(
    isDismissible: true,
    isScrollControlled: true,
    enableDrag: false,
    AppDialogWidget(
      child: LogoutAccountComponent(
        logOutAll: true,
        title: title,
        isCancelButtonShow: isCancelButtonShow,
        onLogout: (isLogoutAll) {
          logOutFromAllDevice(
            loaderOnOff: loaderOnOff,
            showLoader: isLoading.value,
            showSuccess: true,
          );
        },
        device: '',
        deviceName: '',
      ),
    ),
  ).then((value) {
    if (value == true) return;
    if (!isCancelButtonShow) {
      logOutFromAllDevice(
        loaderOnOff: loaderOnOff,
        showLoader: false,
      );
    }
  });
}

Widget subscriptionBenefitsTile({required PlanType planType}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedImageWidget(
            url: getIcons(title: planType.slug),
            height: 16,
            width: 16,
            color: darkGrayTextColor,
          ),
          8.width,
          Marquee(
            child: Text(
              planType.message,
              style: commonPrimaryTextStyle(
                size: 12,
                color: darkGrayTextColor,
              ),
            ),
          ).expand(),
        ],
      ).visible(planType.slug != SubscriptionTitle.supportedDeviceType &&
          planType.slug != SubscriptionTitle.profileLimit &&
          planType.slug != SubscriptionTitle.downloadStatus &&
          planType.slug != SubscriptionTitle.videoCast &&
          planType.slug != SubscriptionTitle.ads &&
          planType.slug != SubscriptionTitle.deviceLimit),
      if (planType.slug == SubscriptionTitle.deviceLimit)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  locale.value.deviceLimitMessage(
                      !planType.limitationValue.getBoolInt()
                          ? '1'
                          : planType.limit.value),
                  style: primaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets:
              ResponsiveSize.getFromLTRB(left: 16, top: 2, right: 0, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [],
        ),
      if (planType.slug == SubscriptionTitle.videoCast)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  planType.limitationValue == 1
                      ? locale.value.videoCastingEnabled
                      : locale.value.videoCastingDisabled,
                  style: commonPrimaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets:
              ResponsiveSize.getFromLTRB(left: 16, top: 2, right: 0, bottom: 2),
          customSymbol: const SizedBox.shrink(),
          children: const [],
        ),
      if (planType.slug == SubscriptionTitle.ads)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  planType.limitationValue == 1
                      ? locale.value.adsWillBeShown
                      : locale.value.adsWillNotBeShown,
                  style: commonPrimaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets:
              ResponsiveSize.getFromLTRB(left: 16, top: 2, right: 0, bottom: 2),
          customSymbol: const SizedBox.shrink(),
          children: const [],
        ),
      if (planType.slug == SubscriptionTitle.supportedDeviceType)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  locale.value.supportedDeviceType,
                  style: commonPrimaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets:
              ResponsiveSize.getFromLTRB(left: 16, top: 2, right: 0, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: getSupportedDeviceText(
            isDesktopSupported:
                planType.limit.enableLaptop.toInt().getBoolInt(),
            isMobileSupported: !planType.limitationValue.getBoolInt()
                ? true
                : planType.limit.enableMobile.toInt().getBoolInt(),
            isTabletSupported: planType.limit.enableTablet.toInt().getBoolInt(),
            isTvSupported: planType.limit.enableTv.toInt().getBoolInt(),
          )
              .map(
                (e) => Row(
                  children: [
                    Icon(
                      e.$2,
                      size: 12,
                      color: e.$3,
                    ),
                    2.width,
                    Text(e.$1, style: commonSecondaryTextStyle()),
                  ],
                ),
              )
              .toList(),
        ),
      if (planType.slug == SubscriptionTitle.profileLimit)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Text(
                locale.value.profileLimitMessage(
                    !planType.limitationValue.getBoolInt()
                        ? '1'
                        : planType.limit.value),
                style: primaryTextStyle(
                  size: 12,
                  color: darkGrayTextColor,
                ),
              ).expand(),
            ],
          ),
          edgeInsets:
              ResponsiveSize.getFromLTRB(left: 16, top: 2, right: 0, bottom: 2),
          customSymbol: const SizedBox.shrink(),
          children: const [],
        ),
      if (planType.slug == SubscriptionTitle.downloadStatus)
        ULWidget(
          titleWidget: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImageWidget(
                url: getIcons(title: planType.slug),
                height: 16,
                width: 16,
                color: darkGrayTextColor,
              ),
              8.width,
              Marquee(
                child: Text(
                  locale.value.downloadResolution,
                  style: commonPrimaryTextStyle(
                    size: 12,
                    color: darkGrayTextColor,
                  ),
                ),
              ).expand(),
            ],
          ),
          edgeInsets:
              ResponsiveSize.getFromLTRB(left: 16, top: 2, right: 0, bottom: 2),
          customSymbol: SizedBox.shrink(),
          children: [
            if (getDownloadQuality((planType).limit).$1.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 12,
                    color: discountColor,
                  ),
                  2.width,
                  Text(getDownloadQuality(planType.limit).$1,
                      style: commonSecondaryTextStyle()),
                ],
              ),
            if (getDownloadQuality(planType.limit).$2.isNotEmpty)
              Row(
                children: [
                  Icon(
                    Icons.clear,
                    size: 12,
                    color: appColorPrimary,
                  ),
                  2.width,
                  Text(getDownloadQuality(planType.limit).$2,
                      style: commonSecondaryTextStyle()),
                ],
              )
          ],
        ),
    ],
  );
}

/// Compute scroll threshold based on device type
double getDynamicScrollOffset() {
  switch (ResponsiveSize.deviceType) {
    case DeviceType.mobile:
      return 120;
    case DeviceType.tablet:
      return 180;
    case DeviceType.desktop:
      return 240;
    case DeviceType.tv:
      return 320;
  }
}

String? validatePassword(String? password,
    {bool isNewPassword = false, bool isConfirmPassword = false}) {
  final value = password!;

  if (value.isEmpty) {
    if (isNewPassword) {
      return locale.value.newPasswordRequired;
    } else if (isConfirmPassword) {
      return locale.value.confirmPasswordIsRequired;
    } else {
      return locale.value.passwordIsRequired;
    }
  }

  if (value.length < 8 || value.length > 14) {
    return locale.value.passwordLengthRule;
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return locale.value.passwordUppercaseRule;
  }

  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return locale.value.passwordLowercaseRule;
  }

  if (!RegExp(r'[@$!%*?&]').hasMatch(value)) {
    return locale.value.passwordSpecialCharacterRule;
  }

  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return locale.value.passwordDigitRule;
  }

  return null; // password is valid
}

Widget premiumTagWidget() {
  return Container(
    padding: ResponsiveSize.getEdgeInsets(2),
    decoration:
        boxDecorationDefault(shape: BoxShape.circle, color: yellowColor),
    child: IconWidget(imgPath: Assets.iconsCrown, size: 14),
  );
}

Widget rentalTagWidget({required bool hasAccess, double? size}) {
  return Container(
    padding: ResponsiveSize.getSymmetricPadding(horizontal: 6, vertical: 4),
    decoration: boxDecorationDefault(
      borderRadius: BorderRadius.circular(4),
      color: rentedColor,
    ),
    child: Row(
      spacing: 4,
      children: [
        CachedImageWidget(
          url: Assets.iconsFilmReel,
          height: size ?? 8,
          width: size ?? 8,
          color: primaryIconColor,
        ),
        Text(
          hasAccess ? locale.value.rented : locale.value.rent,
          style: commonSecondaryTextStyle(
            color: primaryTextColor,
            size: ResponsiveSize.getFontSize(size ?? 10),
          ),
        ),
      ],
    ),
  );
}

(double, double) getDynamicSpacing({
  int crossAxisChildrenCount = 3,
  double screenPadding = 12,
  double desiredSpacing = 12,
  double desiredRunSpacing = 12,
}) {
  final count = (ResponsiveSize.deviceType == DeviceType.desktop ||
          ResponsiveSize.deviceType == DeviceType.tablet)
      ? (crossAxisChildrenCount * 2)
      : crossAxisChildrenCount;
  double screenWidth = Get.width;
  double availableWidth = screenWidth - (screenPadding * 2);

  // Calculate item width that fits perfectly given your desired spacing
  double itemWidth = (availableWidth - (desiredSpacing * (count - 1))) / count;

  // Adjust spacing slightly if math rounding leaves small gaps
  double totalItemWidth = itemWidth * count;
  double remainingWidth = availableWidth - totalItemWidth;
  double finalSpacing =
      remainingWidth > 0 ? remainingWidth / (count - 1) : desiredSpacing;

  return (
    itemWidth,
    finalSpacing,
  );
}

String normalizeDialCode(String code) =>
    code.replaceAll(RegExp(r'[^\d]'), '').trim();

Country cloneDefaultCountry() => Country.from(json: defaultCountry.toJson());

Country resolveCountryByDialCode(String dialCode) {
  log(dialCode);
  final Country? matchedCountry = countryFromDialCode(dialCode);
  return matchedCountry ?? cloneDefaultCountry();
}

Country? countryFromDialCode(String dialCode) {
  log(dialCode);
  final String sanitized = normalizeDialCode(dialCode);
  if (sanitized.isEmpty) return null;

  for (final Map<String, dynamic> country in countryCodes) {
    if ('${country['e164_cc'] ?? ''}' == sanitized) {
      return Country.from(json: country);
    }
  }
  return null;
}
