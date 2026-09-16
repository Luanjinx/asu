import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:share_plus/share_plus.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/network/network_utils.dart';
import 'package:streamit_laravel/routes/app_routes.dart';
import 'package:streamit_laravel/screens/auth/services/social_logins.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/screens/device/model/device_model.dart';
import 'package:streamit_laravel/screens/rented_content/component/rent_details_component.dart';
import 'package:streamit_laravel/addon_bridge/short_drama/short_drama_bridge.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/screens/profile/model/profile_detail_resp.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/services/notification_service.dart';
import 'package:streamit_laravel/utils/price_widget.dart';

import '../components/cached_image_widget.dart';
import '../configs.dart';
import '../main.dart';
import '../screens/auth/model/about_page_res.dart';
import '../screens/auth/model/app_configuration_res.dart';
import '../screens/auth/model/login_response.dart';
import '../screens/subscription/model/subscription_plan_model.dart';
import '../screens/subscription/subscription_screen.dart';
import 'colors.dart';
import 'common_base.dart';
import 'constants.dart';

///DO NOT CHANGE THE APP PACKAGE NAME
String appPackageName = 'com.iqonic.streamitlaravel';

Future<bool> get isIqonicProduct async => await getPackageName() == appPackageName;

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
RxBool is18Plus = false.obs;
Rx<UserData> loginUserData = UserData(planDetails: SubscriptionPlanModel()).obs;
RxList<AboutDataModel> appPageList = <AboutDataModel>[].obs;
RxBool isDarkMode = false.obs;
RxString tempOTP = "".obs;
RxBool adsLoader = false.obs;
Rx<WatchingProfileModel> selectedAccountProfile = WatchingProfileModel().obs;
RxList<WatchingProfileModel> accountProfiles = <WatchingProfileModel>[].obs;
RxBool isSupportedDevice = true.obs;
Rx<SubscriptionPlanModel> currentSubscription = SubscriptionPlanModel().obs;
RxBool isCastingSupported = false.obs;
RxBool isCastingAvailable = false.obs;
RxBool isInternetAvailable = true.obs;
RxBool isRTL = false.obs;
Rx<DeviceData> currentDevice = DeviceData().obs;
RxBool isPipModeOn = false.obs;
RxInt appUnReadNotificationCount = 0.obs;
RxBool appUpdateNotify = false.obs;
RxBool appDownloadOnWifi = false.obs;
RxBool appSmartDownloadDeleteOn = false.obs;
RxBool appParentalLockEnabled = false.obs;
RxBool appScreenCastConnected = false.obs;
ListAnimationType commonListAnimationType = ListAnimationType.None;

Rx<Currency> appCurrency = Currency().obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  applicationURL: ApplicationURL(mobileAppUrl: MobileAppUrl()),
  currency: Currency(),
  bannerAds: BannerAds(),
).obs;

bool get isAdsAllowed =>
    currentSubscription.value.id < 0 || (currentSubscription.value.planType.isNotEmpty &&
    currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.ads) &&
    currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.ads).limitationValue == 1);

// Currency position common
bool get isCurrencyPositionLeft => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

String get appNameTopic => APP_NAME.toLowerCase().replaceAll(' ', '_');

String convertDate(String dateString) {
  if (dateString != "") {
    DateTime date = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }
  return "";
}

bool containsHtml(String text) {
  return RegExp(r'<[^>]+>').hasMatch(text);
}

String parseHtmlIfNeeded(String? text) {
  if (text == null) return '';
  return containsHtml(text) ? parseHtmlString(text) : text;
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String getEndPoint({required String endPoint, int? perPages, int? page, List<String>? params}) {
  String perPage = "?per_page=$perPages";
  String pages = "&page=$page";

  if (page != null && params.validate().isEmpty) {
    return "$endPoint$perPage$pages";
  } else if (page != null && params.validate().isNotEmpty) {
    return "$endPoint$perPage$pages&${params.validate().join('&')}";
  } else if (page == null && params != null && params.isNotEmpty) {
    return "$endPoint?${params.join('&')}";
  }
  return endPoint;
}

void doIfLogin({required VoidCallback onLoggedIn, bool shouldNavigateBack = true}) async {
  if (isLoggedIn.value) {
    onLoggedIn.call();
  } else {
    await Get.to(() => SignInScreen(), preventDuplicates: false, arguments: ArgumentModel(boolArgument: shouldNavigateBack));
  }
}

void checkCastSupported({required VoidCallback onCastSupported}) {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  if (isCastingSupported.value) {
    onCastSupported.call();
  } else {
    if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
      toast(locale.value.kidsProfileCannotAccessSubscription);
      return;
    }

    toast('${locale.value.castingNotSupported} ${locale.value.pleaseUpgradeToContinue}');
    Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false)?.then((v) {
      if (isCastingSupported.value) {
        onCastSupported.call();
      }
    });
  }
}

Widget watchNowButton({
  EdgeInsets? margin,
  required ContentModel contentData,
  required VoidCallback callBack,
  required VoidCallback onPaymentReturnCallBack,
  VoidCallback? pauseCurrentVideo,
}) {
  return AppButton(
    color: contentData.details.access == MovieAccess.payPerView
        ? contentData.details.hasContentAccess.getBoolInt()
            ? appColorPrimary
            : rentedColor
        : appColorPrimary,
    width: Get.width * 0.40,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconWidget(imgPath: Assets.iconsPlayFill),
        12.width,
        Marquee(
          child: Text(
            contentData.details.access == MovieAccess.oneTimePurchase && contentData.rentalData != null && !contentData.details.hasContentAccess.getBoolInt()
                ? locale.value.oneTime
                : contentData.buttonTitle,
            style: boldTextStyle(size: textSecondarySizeGlobal.toInt()),
          ),
        ).flexible(),
      ],
    ),
    onTap: () async {
      onSubscriptionLoginCheck(
        callBack: callBack,
        content: contentData.details,
        onPaymentDone: onPaymentReturnCallBack,
        onRentalNoRented: () {
          if (contentData.isRentDetailsAvailable) {
            Get.bottomSheet(
              AppDialogWidget(
                child: RentalDetailsComponent(
                  contentData: contentData,
                  onWatchNow: callBack,
                  rentalData: contentData.rentalData!,
                  onPaymentReturnCallBack: onPaymentReturnCallBack,
                  onPauseCurrentVideo: onPaymentReturnCallBack,
                ),
              ),
              isScrollControlled: true,
            );
          }
        },
      );
    },
  );
}

Widget rentAndPaidButton({
  EdgeInsets? margin,
  required VoidCallback callBack,
  required RentalData rentData,
}) {
  return AppButton(
    width: double.infinity,
    color: rentedColor,
    hoverColor: appColorPrimary,
    focusColor: appColorPrimary,
    textStyle: appButtonTextStyleWhite,
    disabledColor: btnColor,
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 10),
    shapeBorder: RoundedRectangleBorder(borderRadius: radius(4)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CachedImageWidget(
          url: Assets.iconsFilmReel,
          height: 14,
          width: 14,
          color: Colors.white,
        ),
        12.width,
        Text(
          rentData.access == MovieAccess.oneTimePurchase ? locale.value.oneTimeFor : locale.value.rentFor,
          style: boldTextStyle(),
        ),
        8.width,
        PriceWidget(
          price: rentData.price,
          discountedPrice: rentData.discountedPrice,
          discount: rentData.discount,
          isDiscountedPrice: rentData.discount > 0.0,
          color: primaryIconColor,
        ),
      ],
    ),
    onTap: () async {
      if (isLoggedIn.value) {
        callBack.call();
      } else {
        doIfLogin(onLoggedIn: callBack);
      }
    },
  );
}

void onSubscriptionLoginCheck({
  required VoidCallback callBack,
  required VoidCallback onPaymentDone,
  required ContentData content,
  required VoidCallback onRentalNoRented,
  VoidCallback? pauseCurrentVideo,
}) {
  final ContentData contentData = content;

  if (isLoggedIn.value) {
    // Check device support first - if not supported, navigate to video screen to show DeviceNotSupportedComponent
    if (!isSupportedDevice.value) {
      callBack.call();
      return;
    }

    if (contentData.access == MovieAccess.freeAccess) {
      callBack.call();
    } else {
      if ((contentData.access == MovieAccess.paidAccess || contentData.requiredPlanLevel > 0) && currentSubscription.value.level < contentData.requiredPlanLevel) {
        if (selectedAccountProfile.value.isChildProfile.validate() == 1) {
          toast(locale.value.kidsProfileCannotAccessSubscription);
          return;
        }
        pauseCurrentVideo?.call();
        Get.to(() => SubscriptionScreen(launchDashboard: false), preventDuplicates: false, arguments: contentData.requiredPlanLevel)?.then((v) {
          if (currentSubscription.value.level >= contentData.requiredPlanLevel) {
            onPaymentDone.call();
          }
        });
      } else if ((contentData.access == MovieAccess.payPerView || contentData.access == MovieAccess.oneTimePurchase) && !contentData.hasContentAccess.getBoolInt()) {
        onRentalNoRented.call();
      } else {
        callBack.call();
      }
    }
  } else {
    doIfLogin(onLoggedIn: callBack);
  }
}

Future<void> handlePip({required dynamic controller, required BuildContext context}) async {
  if (isIOS) {
    if (controller.currentVideoUrl.contains("youtube.com") || controller.currentVideoUrl.contains("youtu.be")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            body: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri('https://www.youtube.com/embed/smTK_AeAPHs?si=fmjqoFkRZb9eYbEm&controls=0&rel=0&modestbranding=1&showinfo=0'),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                transparentBackground: true,
                allowsInlineMediaPlayback: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              onWebViewCreated: (c) {
                controller.webController = c;
              },
              onLoadStop: (c, url) async {
                await c.evaluateJavascript(source: '''
                        var style = document.createElement('style');
                        style.type = 'text/css';
                        style.innerHTML = `
                          .ytp-chrome-top,
                          .ytp-show-cards-title,
                          .ytp-title-link,
                          .ytp-chrome-top-buttons {
                            display: none !important;
                          }
                          .ytp-button.ytp-watch-later-button {
                            display: none !important;
                          }
                          .ytp-button.ytp-share-button {
                            display: none !important;
                          }
                          .ytp-watermark {
                            display: none !important;
                          }
                         `;
                        document.head.appendChild(style);
                        document.addEventListener('webkitpresentationmodechanged', function(event) {
                          if (event.target.webkitPresentationMode == 'picture-in-picture') {
                            console.log('Entered Picture-in-Picture');
                          } else {
                            console.log('Exited Picture-in-Picture');
                          }
                        });


                        var video = document.querySelector('video');
                        if (video) {
                          var requestPiP = document.createElement('button');
                          requestPiP.innerText = 'Enter Picture-in-Picture';
                          requestPiP.style.position = 'fixed';
                          requestPiP.style.bottom = '10px';
                          requestPiP.style.left = '10px';
                          requestPiP.style.zIndex = '1000';
                          requestPiP.onclick = function() {
                            if (document.pictureInPictureElement) {
                              document.exitPictureInPicture();
                            } else {
                              video.requestPictureInPicture();
                            }
                          };
                          document.body.appendChild(requestPiP);
                        } else {
                           console.error('No video element found');
                        }
                        ''');
              },
              shouldOverrideUrlLoading: (c, navigationAction) async {
                if (navigationAction.request.url.toString().startsWith('https://youtu.be/smTK_AeAPHs?si=UQAlhFHgP-j1YSjG')) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
            ),
          ),
        ),
      );
    } else {
      try {
        await const MethodChannel("videoPlatform").invokeMethod('play', {
          "data": controller.currentVideoUrl
          // "data": "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8"
          // "data": "https://storage.googleapis.com/exoplayer-test-media-0/BigBuckBunny_320x180.mp4"
        });
      } on PlatformException catch (e) {
        debugPrint("Fail: ${e.message}");
      }
    }
  } else {
    /// Android Picture In Picture Mode
    try {
      // Set up platform channel listener for PiP mode changes
      platform.setMethodCallHandler((call) async {
        if (call.method == 'onPipModeChanged') {
          bool newPipMode = call.arguments as bool;

          // Only update if the PiP state has actually changed to prevent unnecessary rebuilds
          if (isPipModeOn.value != newPipMode) {
            isPipModeOn.value = newPipMode;

            // If exiting PiP mode, trigger a rebuild of the video player
            if (!newPipMode) {
              // Add delay to ensure UI is ready
              await Future.delayed(const Duration(milliseconds: 300));
              // Emit event to refresh video player
              LiveStream().emit(VIDEO_PLAYER_REFRESH_EVENT);
            }
          }
        }
      });

      // Enter PiP mode through platform channel
      final bool isPipEnabled = await platform.invokeMethod('showNativeView');
      isPipModeOn.value = isPipEnabled;
    } catch (e) {
      debugPrint("PiP Error: $e");
    }
  }
}

List<(String, IconData, Color)> getSupportedDeviceText({bool isMobileSupported = false, bool isDesktopSupported = false, bool isTabletSupported = false, bool isTvSupported = false}) {
  List<(String, IconData, Color)> supportedDeviceText = [];

  supportedDeviceText.add(
    (
      '${locale.value.mobile}${isMobileSupported ? locale.value.supported : locale.value.notSupported}',
      isMobileSupported ? Icons.check_circle_outline_rounded : Icons.clear,
      isMobileSupported ? discountColor : redColor,
    ),
  );
  supportedDeviceText.add((
    '${locale.value.laptop}${isDesktopSupported ? locale.value.supported : locale.value.notSupported}',
    isDesktopSupported ? Icons.check_circle_outline_rounded : Icons.clear,
    isDesktopSupported ? discountColor : redColor,
  ));
  supportedDeviceText.add(
    (
      '${locale.value.tablet.suffixText(value: ' ')}${isTabletSupported ? locale.value.supported : locale.value.notSupported}',
      isTabletSupported ? Icons.check_circle_outline_rounded : Icons.clear,
      isTabletSupported ? discountColor : redColor,
    ),
  );
  supportedDeviceText.add(
    (
      '${locale.value.tv.suffixText(value: ' ')}${isTvSupported ? locale.value.supported : locale.value.notSupported}',
      isTvSupported ? Icons.check_circle_outline_rounded : Icons.clear,
      isTvSupported ? discountColor : redColor,
    ),
  );

  return supportedDeviceText;
}

(String, String) getDownloadQuality(PlanLimit? planLimit) {
  String notSupportedText = '';
  String supportedText = '';
  if (planLimit != null) {
    if (planLimit.four80Pixel.getBoolInt()) {
      supportedText += '480P';
    } else {
      notSupportedText += '480P';
    }
    if (planLimit.seven20p.getBoolInt()) {
      supportedText += '720P';
    } else {
      notSupportedText += '720P';
    }
    if (planLimit.one080p.getBoolInt()) {
      supportedText += '1080P';
    } else {
      notSupportedText += '1080P';
    }
    if (planLimit.oneFourFour0Pixel.getBoolInt()) {
      supportedText += '1440P';
    } else {
      notSupportedText += '1440P';
    }
    if (planLimit.twoKPixel.getBoolInt()) {
      supportedText += '2K';
    } else {
      notSupportedText += '2K';
    }
    if (planLimit.fourKPixel.getBoolInt()) {
      supportedText += '4K';
    } else {
      notSupportedText += '4K';
    }
    if (planLimit.eightKPixel.getBoolInt()) {
      supportedText += '8K';
    } else {
      notSupportedText += '8K';
    }
  }

  RegExp regex = RegExp(r"(?<=P|K)");
  List<String> notSupportedParts = [];
  List<String> supportedParts = [];
  if (notSupportedText.isNotEmpty) {
    notSupportedParts = notSupportedText.split(regex);
  }
  if (supportedText.isNotEmpty) supportedParts = supportedText.split(regex);

  return (supportedParts.join('/'), notSupportedParts.join('/'));
}

/// Check if a specific download quality is supported by the user's plan
/// Returns true if quality is supported, false otherwise
bool checkDownloadQualitySupported(String quality, bool hasContentAccess) {
  // Check if user has active subscription

  if (quality == QualityConstants.defaultQualityKey && hasContentAccess) return true;
  if (currentSubscription.value.planType.isEmpty) return false;

  // Find download status in plan types
  final downloadPlan = currentSubscription.value.planType.firstWhereOrNull((plan) => plan.slug == SubscriptionTitle.downloadStatus);

  if (downloadPlan == null || !downloadPlan.limitationValue.getBoolInt()) {
    return false;
  }

  final limit = downloadPlan.limit;

  switch (quality) {
    case QualityConstants.low:
      return limit.four80Pixel.getBoolInt();
    case QualityConstants.medium:
      return limit.seven20p.getBoolInt();
    case QualityConstants.high:
      return limit.one080p.getBoolInt();
    case QualityConstants.veryHigh:
      return limit.oneFourFour0Pixel.getBoolInt();
    case QualityConstants.ultra2K:
      return limit.twoKPixel.getBoolInt();
    case QualityConstants.ultra4K:
      return limit.fourKPixel.getBoolInt();
    case QualityConstants.ultra8K:
      return limit.eightKPixel.getBoolInt();
    default:
      return false;
  }
}

String getPageIcon(String slug) {
  switch (slug) {
    case AppPages.privacyPolicy:
      {
        return Assets.iconsShieldCheck;
      }
    case AppPages.termsAndCondition:
      {
        return Assets.iconsFileText;
      }
    case AppPages.helpAndSupport:
      {
        return Assets.iconsQuestion;
      }
    case AppPages.refundAndCancellation:
      {
        return Assets.iconsReceipt;
      }
    case AppPages.dataDeletion:
      {
        return Assets.iconsTrash;
      }
    case AppPages.aboutUs:
      {
        return Assets.iconsInfo;
      }
    default:
      return Assets.iconsReceipt;
  }
}

String getQualityIcon(String quality) {
  switch (quality) {
    case QualityConstants.defaultQualityKey:
    case QualityConstants.defaultQuality:
      return Assets.qualityStandardDefinition;
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
      return Assets.quality8k;
    case QualityConstants.ultra8K:
      return Assets.quality8k;
    default:
      return Assets.qualityStandardDefinition;
  }
}

Future<void> launchUrlCustomURL(String? url) async {
  if (url.validate().isNotEmpty) {
    await custom_tabs.launchUrl(
      Uri.parse(url.validate()),
      customTabsOptions: custom_tabs.CustomTabsOptions(
        colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(toolbarColor: appColorPrimary),
        animations: custom_tabs.CustomTabsSystemAnimations.slideIn(),
        urlBarHidingEnabled: true,
        shareState: custom_tabs.CustomTabsShareState.on,
        browser: const custom_tabs.CustomTabsBrowserConfiguration(
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
          headers: {'key': 'value'},
        ),
      ),
      safariVCOptions: const custom_tabs.SafariViewControllerOptions(
        barCollapsingEnabled: true,
        dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
        entersReaderIfAvailable: false,
        preferredControlTintColor: appScreenBackgroundDark,
        preferredBarTintColor: appColorPrimary,
      ),
    );
  }
}

Future<void> checkApiCallIsWithinTimeSpan({bool forceSync = false, required VoidCallback callback, required String sharePreferencesKey, Duration? duration}) async {
  DateTime currentTimeStamp = DateTime.timestamp();
  DateTime lastSyncedTimeStamp = DateTime.fromMillisecondsSinceEpoch(await getIntFromLocal(sharePreferencesKey, defaultValue: 0));
  DateTime fiveMinutesLater = lastSyncedTimeStamp.add(duration ?? const Duration(minutes: 5));

  if (forceSync || currentTimeStamp.isAfter(fiveMinutesLater)) {
    callback.call();
  } else {
    log('$sharePreferencesKey was synced recently');
  }
}

bool isComingSoon(String releaseDate) {
  final now = DateTime.now();
  final parsedDate = _parseFlexibleDate(releaseDate);
  if (parsedDate == null) return false; // couldn't parse = treat as not future
  return parsedDate.isAfter(now);
}

DateTime? _parseFlexibleDate(String input) {
  // Clean text like "23rd April 2010 at 3" → "23 April 2010"
  String clean = input.replaceAll(RegExp(r'(\d+)(st|nd|rd|th)', caseSensitive: false), r'\1').replaceAll(RegExp(r'at.*', caseSensitive: false), '').trim();

  // Try multiple date formats
  final formats = [
    'yyyy-MM-dd',
    'dd-MM-yyyy',
    'MM-dd-yyyy',
    'dd MMM yyyy',
    'MMM dd, yyyy',
    'dd MMMM yyyy',
    'MMMM dd, yyyy',
  ];

  for (final format in formats) {
    try {
      return DateFormat(format).parse(clean);
    } catch (_) {}
  }

  // Try ISO or other parsable formats (e.g., 2025-10-08T14:30:00)
  try {
    return DateTime.parse(clean);
  } catch (_) {
    return null;
  }
}

Future<void> secureScreen() async {
  // Screenshot block
  await ScreenProtector.preventScreenshotOn();

  // Screen recording / data leakage block
  await ScreenProtector.protectDataLeakageOn();
}

Future<void> removeSecureScreen() async {
  await ScreenProtector.preventScreenshotOff();

  await ScreenProtector.protectDataLeakageOff();
}

Future<void> downloadAndOpenFile({
  required String url,
  required Function(bool) loaderOnOffCallback,
  BuildContext? context,
}) async {
  try {
    loaderOnOffCallback(true);

    final response = await getRemoteDataFromUrl(endPoint: url, isDownload: true);

    if (response.statusCode == 200) {
      String fileName = url.split('/').last;
      Directory dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$fileName");

      await file.writeAsBytes(response.data);

      if (fileName.endsWith('.pdf')) {
        await OpenFile.open(file.path);
      } else {
        await safeShare(
          ShareParams(
            files: [XFile(file.path)],
            text: fileName,
            sharePositionOrigin: getSharePositionOrigin(context),
          ),
        );
      }
    } else {
      toast(locale.value.unableToDownloadFilePleaseTryAgainLater);
    }
  } catch (e) {
    toast(locale.value.unableToDownloadFilePleaseTryAgainLater);
  } finally {
    loaderOnOffCallback(false);
  }
}

String getTypeForContinueWatch({required String type}) {
  final dynamic videoTypeMap = {
    "movie": VideoType.movie,
    "video": VideoType.video,
    'episode': VideoType.tvshow,
  };
  return videoTypeMap[type] ?? '';
}

Future<void> logOutFromAllDevice({
  required Function(bool isLoading) loaderOnOff,
  required bool showLoader,
  bool showSuccess = false,
  VoidCallback? onSuccess,
}) async {
  loaderOnOff.call(showLoader);
  await AuthServiceApis.logOutAllAPIWithoutAuth(userId: loginUserData.value.id).then((value) async {
    if (showSuccess) successSnackBar(value.message);
    await clearAppData();
    if (onSuccess != null)
      onSuccess.call();
    else {
      final DashboardController dashboardController = Get.find<DashboardController>();
      dashboardController.addDataOnBottomNav();
      dashboardController.currentIndex(0);
      Get.offAll(() => DashboardScreen());
    }
  }).catchError((e) {
    errorSnackBar(error: e);
    clearAppData();
    final DashboardController dashboardController = Get.find<DashboardController>();
    dashboardController.addDataOnBottomNav();
    dashboardController.currentIndex(0);
    Get.offAll(() => DashboardScreen());
  }).whenComplete(() {
    loaderOnOff.call(false);
  });
}

Future<void> handleLogoutAndNavigateToLogin({
  required VoidCallback? onFormReset,
  required VoidCallback? onFormClear,
  required Function(bool) onLoadingStateChange,
}) async {
  onFormReset?.call();
  onFormClear?.call();

  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }

  onLoadingStateChange(true);
  try {
    await AuthServiceApis.logOutAllAPIWithoutAuth(userId: loginUserData.value.id);
    await clearAppData();
    Get.offAll(() => SignInScreen(title: locale.value.changePasswordMessage), routeName: AppRoutes.signIn);
  } catch (e) {
    errorSnackBar(error: e);
    await clearAppData();
    Get.offAll(() => SignInScreen(title: locale.value.changePasswordMessage), routeName: AppRoutes.signIn);
  } finally {
    onLoadingStateChange(false);
  }
}

Future<void> clearAppData({bool isFromDeleteAcc = false}) async {
  NotificationService().unSubscribeTopic();
  isLoggedIn(false);
  selectedAccountProfile(WatchingProfileModel());
  loginUserData(UserData(planDetails: SubscriptionPlanModel()));
  currentSubscription(SubscriptionPlanModel());

  // Clear short drama DRM tokens
  try {
    ShortDramaBridge.restoreSessionToken(null);
    log('Short drama tokens cleared');
  } catch (e) {
    // Short drama feature not available, ignore
    log('Short drama tokens clear skipped: $e');
  }

  if (isFromDeleteAcc) {
    GoogleSignInAuthService().googleSignIn.disconnect();
    removeValue(SharedPreferenceConst.IS_REMEMBER_ME);
    removeValue((SharedPreferenceConst.LOGIN_REQUEST));
  } else {
    final tempPASSWORD = await getStringFromLocal(SharedPreferenceConst.USER_PASSWORD);
    final tempIsRememberMe = await getBoolFromLocal(SharedPreferenceConst.IS_REMEMBER_ME);

    if (tempPASSWORD is String) {
      await setStringToLocal(SharedPreferenceConst.USER_PASSWORD, tempPASSWORD);
    }
    await setBoolToLocal(SharedPreferenceConst.IS_REMEMBER_ME, await tempIsRememberMe);
  }
  removeValuesFromLocalStorage();
  final DashboardController dashboardController = Get.find();
  dashboardController.currentIndex(0);
  dashboardController.addDataOnBottomNav();
  Get.offAll(() => DashboardScreen());
}

void removeValuesFromLocalStorage() {
  removeValue(SharedPreferenceConst.IS_LOGGED_IN);
  removeValue(SharedPreferenceConst.IS_SUPPORTED_DEVICE);
  removeValue(SharedPreferenceConst.IS_SOCIAL_LOGIN_IN);
  removeValue(SharedPreferenceConst.IS_DEMO_USER);
  removeValue(SharedPreferenceConst.IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED);
  removeValue(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE);

  removeValue(SharedPreferenceConst.USER_DATA);
  removeValue(SharedPreferenceConst.CACHE_USER_SUBSCRIPTION_DATA);
  removeValue(SharedPreferenceConst.CACHE_UNREAD_NOTIFICATION_COUNT);
  removeValue(SharedPreferenceConst.LAST_APP_CONFIGURATION_CALL_TIME);
  removeValue(SharedPreferenceConst.DASHBOARD_DETAIL_LAST_CALL_TIME);
  removeProfileSpecificData();
}

void removeProfileSpecificData() {
  removeValue(SharedPreferenceConst.CACHE_DASHBOARD_RESPONSE);
  removeValue(SharedPreferenceConst.CACHE_PROFILE_DETAIL);
  removeValue(SharedPreferenceConst.CACHE_LIVE_TV_DASHBOARD_RESPONSE);
  cachedDashboardDetailResponse = null;
  cachedLiveTvDashboard = null;
  cachedProfileDetails = null;

  cachedComingSoonList = RxList<ComingSoonModel>();
  cachedContinueWatchList = RxList<PosterDataModel>();
  cachedWatchList = RxList<PosterDataModel>();
  cachedRentedContentList = RxList<PosterDataModel>();
  cachedPersonList = RxList();
  cachedSliderList = RxList();
}

//Get Device Information

Future<void> getDeviceInfo() async {
    if (kIsWeb) {
    currentDevice(
      DeviceData(
        deviceId: 'web',
        deviceName: 'Browser',
        platform: 'Web',
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      ),
    );
    return;
  }

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;

    currentDevice(
      DeviceData(
        deviceId: androidInfo.id.validate(),
        deviceName: '${androidInfo.brand}(${androidInfo.model.validate()})',
        platform: locale.value.android,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      ),
    );
  }

  if (Platform.isIOS) {
    final iosInfo = await DeviceInfoPlugin().iosInfo;
    currentDevice(
      DeviceData(
        deviceId: iosInfo.identifierForVendor.validate(),
        deviceName: iosInfo.name,
        platform: locale.value.ios,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        updatedAt: DateTime.now().toUtc().toIso8601String(),
      ),
    );
  }
}

///Get ChooseService List
Future<void> getAppConfigurations({Function(bool)? loaderOnOff}) async {
  await CoreServiceApis.getAppConfigurations(
    loaderOnOff: loaderOnOff,
    forceSync: true,
    onError: () {
      setBoolToLocal(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, false);
    },
  ).then((value) async {
    setBoolToLocal(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, true);
  }).catchError((e) {
    setBoolToLocal(SharedPreferenceConst.IS_APP_CONFIGURATION_SYNCED_ONCE, false);
    throw e;
  });

  await CoreServiceApis.getPageList().then((value) {
    appPageList.value = value; // data in the observable list
    setIntToLocal(SharedPreferenceConst.PAGE_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
  });
}


Future<void> getCacheData() async {
  Map<String, dynamic>? cachedConfigKey = await getJsonFromLocal(SharedPreferenceConst.CACHE_CONFIGURATION_RESPONSE) ?? null;
  if (cachedConfigKey != null) {
    appConfigs(ConfigurationResponse.fromJson(cachedConfigKey));
  }

  Map<String, dynamic>? cachedUserSubscriptionKey = await getJsonFromLocal(SharedPreferenceConst.CACHE_USER_SUBSCRIPTION_DATA) ?? null;
  if (cachedUserSubscriptionKey != null) {
    currentSubscription(SubscriptionPlanModel.fromJson(cachedUserSubscriptionKey));
  }
  Map<String, dynamic>? cachedDashboardKey = await getJsonFromLocal(SharedPreferenceConst.CACHE_DASHBOARD_RESPONSE) ?? null;
  if (cachedDashboardKey != null) {
    cachedDashboardDetailResponse = DashboardDetailResponse.fromJson(cachedDashboardKey);
  }

  Map<String, dynamic>? cachedLiveTvDashboardKey = await getJsonFromLocal(SharedPreferenceConst.CACHE_LIVE_TV_DASHBOARD_RESPONSE) ?? null;
  if (cachedLiveTvDashboardKey != null) {
    cachedLiveTvDashboard = LiveChannelDashboardResponse.fromJson(cachedLiveTvDashboardKey);
  }
  Map<String, dynamic>? cachedProfileDetailsKey = await getJsonFromLocal(SharedPreferenceConst.CACHE_PROFILE_DETAIL) ?? null;
  if (cachedProfileDetailsKey != null) {
    cachedProfileDetails = ProfileDetailResponse.fromJson(cachedProfileDetailsKey);
  }

  appUnReadNotificationCount(await getIntFromLocal(SharedPreferenceConst.CACHE_UNREAD_NOTIFICATION_COUNT, defaultValue: 0));
  appUpdateNotify(await getBoolFromLocal(SettingsLocalConst.IS_NOTIFY_UPDATE_ENABLED, defaultValue: false));
  appDownloadOnWifi(await getBoolFromLocal(SettingsLocalConst.IS_DOWNLOAD_WIFI_ENABLED, defaultValue: false));
  appSmartDownloadDeleteOn(await getBoolFromLocal(SettingsLocalConst.IS_SMART_DELETE_DOWNLOAD_ENABLED));
  appParentalLockEnabled(await getBoolFromLocal(SettingsLocalConst.PARENTAL_CONTROL, defaultValue: false));
}
