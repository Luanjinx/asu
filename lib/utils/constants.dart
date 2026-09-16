// ignore_for_file: constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:streamit_laravel/generated/assets.dart';

class Constants {
  static const DEFAULT_EMAIL = 'john@gmail.com';
  static const DEFAULT_PASS = '12345678';

  static const episodePerPage = 10;
  static const int mobilePerPage = 15;
  static const int tabletPerPage = 22;
  static const int desktopPerPage = 30;
  static const appLogoSize = 120.0;
  static const DECIMAL_POINT = 2;
  static const double shimmerTextSize = 12;
  static const double labelTextSize = 18;
  static const String defaultNumber = '1234567890';
  static const String defaultVerificationOTP = '123456';
  static const double commonDialogBoxRadius = 32;

  static List<String> rtlLanguage = [
    'ar', // Arabic
    'he', // Hebrew
    'fa', // Persian (Farsi)
    'ur', // Urdu
    'yi', // Yiddish
    'dv', // Divehi (Maldivian)
    'ps', // Pashto
    'syr', // Syriac
  ];
}
//endregion

//region DateFormats
class DateFormatConst {
  static const DD_MM_YY = "dd-MM-yy";
  static const MMMM_D_yyyy = "MMMM d, y";
  static const D_MMMM_yyyy = "d MMMM, y";
  static const MMMM_D_yyyy_At_HH_mm_a = "MMMM d, y @ hh:mm a";
  static const EEEE_D_MMMM_At_HH_mm_a = "EEEE d MMMM @ hh:mm a";
  static const dd_MMM_yyyy_HH_mm_a = "dd MMM y, hh:mm a";
  static const yyyy_MM_dd_HH_mm = 'yyyy-MM-dd HH:mm';
  static const yyyy_MM_dd = 'yyyy-MM-dd';
  static const HH_mm12Hour = 'hh:mm a';
  static const HH_mm24Hour = 'HH:mm';
}
//endregion

//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion

// region Constant keys
const VIDEO_PLAYER_REFRESH_EVENT = 'video_player_refresh';
const WEB_VIDEO_VIEW_CHANNEL = 'PlayerEvents';
const DOWNLOAD_BUTTON_KEY = 'download_button';
const DOWNLOAD_MENU_PAUSE_KEY = 'download_menu_pause';
const DOWNLOAD_MENU_RESUME_KEY = 'download_menu_resume';
const DOWNLOAD_MENU_CANCEL_KEY = 'download_menu_cancel';
const DOWNLOAD_STATUS_PAUSED_KEY = 'download_status_paused';
//endregion

//region LOGIN TYPE
class LoginTypeConst {
  static const loginTypeGoogle = 'google';
  static const loginTypeApple = 'apple';
  static const loginTypeOTP = 'otp';

  static const loginTypeEmail = 'email';
}
//endregion

//region SharedPreference Keys
class SharedPreferenceConst {
  static const IS_LOGGED_IN = 'IS_LOGGED_IN';
  static const USER_DATA = 'USER_LOGIN_DATA';

  static const USER_PASSWORD = 'USER_PASSWORD';
  static const LOGIN_REQUEST = 'LOGIN_REQUEST';
  static const IS_SOCIAL_LOGIN_IN = 'IS_SOCIAL_LOGIN_IN';
  static const IS_REMEMBER_ME = 'IS_REMEMBER_ME';
  static const IS_FIRST_TIME = 'IS_FIRST_TIME';

  static const IS_APP_CONFIGURATION_SYNCED_ONCE = 'IS_APP_CONFIGURATION_SYNCED_ONCE';
  static const LAST_APP_CONFIGURATION_CALL_TIME = 'APP_CONFIGURATION_CALL_TIME';

  static const IS_DEMO_USER = 'IS_DEMO_USER';

  static const DASHBOARD_DETAIL_LAST_CALL_TIME = 'DASHBOARD_DETAIL_CALL_TIME';
  static const PAGE_LAST_CALL_TIME = 'PAGE_LAST_CALL_TIME';
  static const FAQ_LAST_CALL_TIME = 'FAQ_LAST_CALL_TIME';
  static const NEW_UPDATE_LAST_CALL_TIME = 'NEW_UPDATE_LAST_CALL_TIME';

  static const IS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE = 'IS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE';
  static const IS_IN_APP_USER_LOGIN_DONE_AT_LEASE_ONCE = 'IS_IN_APP_USER_LOGIN_DONE_AT_LEASE_ONCE';
  static const IS_PURCHASE_STORED = 'IS_PURCHASE_STORED';
  static const PURCHASE_REQUEST = 'PURCHASE_REQUEST';
  static const IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED = 'IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED';
  static const IS_SUPPORTED_DEVICE = 'IS_SUPPORTED_DEVICE';

  // locale
  static const POPULAR_MOVIE = 'POPULAR_MOVIE';

  static const CACHE_CONFIGURATION_RESPONSE = 'CACHE_CONFIGURATION_RESPONSE';
  static const CACHE_DASHBOARD_RESPONSE = 'CACHE_DASHBOARD_RESPONSE';
  static const CACHE_COMING_SOON_RESPONSE = 'CACHE_COMING_SOON_RESPONSE';
  static const CACHE_LIVE_TV_DASHBOARD_RESPONSE = 'CACHE_LIVE_TV_DASHBOARD_RESPONSE';
  static const CACHE_PROFILE_DETAIL = 'CACHE_PROFILE_DETAIL';
  static const CACHE_MOVIE_LIST = 'CACHE_MOVIE_LIST';
  static const CACHE_TV_SHOW_LIST = 'CACHE_TV_SHOW_LIST';
  static const CACHE_VIDEO_LIST = 'CACHE_VIDEO_LIST';
  static const CACHE_GENRE_LIST = 'CACHE_GENRE_LIST';
  static const CACHE_ACTOR_LIST = 'CACHE_ACTOR_LIST';
  static const CACHE_CHANNEL_LIST = 'CACHE_CHANNEL_LIST';
  static const CACHE_USER_SUBSCRIPTION_DATA = 'CACHE_USER_SUBSCRIPTION_DATA';
  static const CACHE_UNREAD_NOTIFICATION_COUNT = 'CACHE_UNREAD_NOTIFICATION_COUNT';
}
//endregion

//region SettingsLocalConst
class SettingsLocalConst {
  static const THEME_MODE = 'THEME_MODE';
  static const APP_UPDATE = 'APP_UPDATE';
  static const OPTIONAL_UPDATE_NOTIFY = 'OPTIONAL_UPDATE_NOTIFY';
  static const PARENTAL_CONTROL = 'PARENTAL_CONTROL';
  static const IS_NOTIFY_UPDATE_ENABLED = 'CACHE_NOTIFY_UPDATE_ENABLED';
  static const APP_STREAMING_QUALITY = 'APP_STREAMING_QUALITY ';

  static const APP_DOWNLOAD_QUALITY = 'APP_DOWNLOAD_QUALITY ';
  static const IS_DOWNLOAD_WIFI_ENABLED = 'CACHE_DOWNLOAD_WIFI_ENABLED';

  static const IS_SMART_DELETE_DOWNLOAD_ENABLED = 'IS_SMART_DELETE_DOWNLOAD_ENABLED';
}
//endregion

//region Currency position
class CurrencyPosition {
  static const CURRENCY_POSITION_LEFT = 'left';
  static const CURRENCY_POSITION_RIGHT = 'right';
  static const CURRENCY_POSITION_LEFT_WITH_SPACE = 'left_with_space';
  static const CURRENCY_POSITION_RIGHT_WITH_SPACE = 'right_with_space';
}
//endregion

//region Gender TYPE
class GenderTypeConst {
  static const MALE = 'male';
  static const FEMALE = 'female';

  static const OTHER = 'other';
}
//endregion

//region PaymentStatus
class PaymentStatus {
  static const PAID = 'paid';
  static const pending = 'pending';
  static const failed = 'failed';
}
//endregion

//region Firebase Topic keys
class FirebaseMsgConst {
  //Other Consts
  static const topicSubscribed = 'topic-----subscribed---->';
  static const topicUnSubscribed = 'topic-----UnSubscribed---->';
  static const userWithUnderscoreKey = 'user_';

  static const additionalDataKey = 'additional_data';
  static const contentIdKey = 'content_id';

  static const contentTypeKey = 'content_type';
  static const notificationDataKey = 'Notification Data';
  static const fcmNotificationTokenKey = 'FCM Notification Token';
  static const apnsNotificationTokenKey = 'APNS Notification Token';
  static const notificationErrorKey = 'Notification Error';
  static const notificationTitleKey = 'Notification Title';

  static const notificationKey = 'Notification';

  static const onClickListener = "Error On Notification Click Listener";
  static const onMessageListen = "Error On Message Listen";
  static const onMessageOpened = "Error On Message Opened App";
  static const onGetInitialMessage = 'Error On Get Initial Message';
  static const messageDataCollapseKey = 'MessageData Collapse Key';
  static const messageDataMessageIdKey = 'MessageData Message Id';

  static const notificationBodyKey = 'Notification Body';

  static const notificationChannelIdKey = 'notification';
  static const notificationChannelNameKey = 'Notification';
}
//endregion

//region Payment Methods
class PaymentMethods {
  static const PAYMENT_METHOD_CASH = 'cash';
  static const PAYMENT_METHOD_STRIPE = 'stripe';
  static const PAYMENT_METHOD_RAZORPAY = 'razorpay';
  static const PAYMENT_METHOD_PAYPAL = 'paypal';
  static const PAYMENT_METHOD_PAYSTACK = 'paystack';
  static const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
  static const PAYMENT_METHOD_AIRTEL = 'airtel';
  static const PAYMENT_METHOD_PHONEPE = 'phonepe';
  static const PAYMENT_METHOD_MIDTRANS = 'midtrans';
  static const PAYMENT_METHOD_IN_APP_PURCHASE = 'IN_APP_PURCHASE';
}
//endregion

//region Page slug
class AppPages {
  static const termsAndCondition = 'terms-conditions';
  static const privacyPolicy = 'privacy-policy';
  static const helpAndSupport = 'help-and-support';
  static const refundAndCancellation = 'refund-and-cancellation-policy';
  static const dataDeletion = 'data-deletation-request';
  static const faq = 'faq';
  static const aboutUs = 'about-us';
}
//endregion

//region Theme Constants

class ThemeConstants {
  //region FontWeight
  static const FontWeight genreFontWeight = FontWeight.w600;

  static const FontWeight titleFontWeight = FontWeight.w500;

//endregion
}
//endregion

class SubscriptionTitle {
  static const videoCast = 'video-cast';
  static const ads = 'ads';
  static const deviceLimit = 'device-limit';
  static const downloadStatus = 'download-status';
  static const supportedDeviceType = 'supported-device-type';
  static const profileLimit = 'profile-limit';
}

class VideoType {
  static const movie = 'movie';
  static const tvshow = 'tvshow';
  static const episode = 'episode';

  static const season = 'season';
  static const liveTv = 'livetv';
  static const video = 'video';
}

class SubscriptionStatus {
  static const active = 'active';
  static const cancel = 'cancel';
  static const inActive = 'inactive';

  static const deActive = 'deactivated';
}

class MovieAccess {
  static const paidAccess = 'paid';
  static const freeAccess = 'free';
  static const payPerView = 'pay-per-view';
  static const rental = 'rental';
  static const oneTimePurchase = 'onetime';
}

class URLTypes {
  static const vimeo = 'vimeo';
  static const url = 'url';
  static const hls = 'hls';
  static const file = 'file';
  static const local = 'local';
  static const youtube = 'youtube';
  static const embedded = 'embedded';
  static const String x265 = 'x265';
}

class Tax {
  static const String percentage = 'percentage';
  static const String fixed = 'fixed';
}

class BannerType {
  static const String tvShow = 'tv_show';
  static const String movie = 'movie';
  static const String video = 'video';
  static const String home = 'home';
  static const String promotional = 'promotional';
}

class PurchaseType {
  static const rental = 'rental';
  static const oneTimePurchased = 'onetime';
}

Map<String, String> languageMap = {
  "Afrikaans": "af",
  "Albanian": "sq",
  "Amharic": "am",
  "Arabic": "ar",
  "Armenian": "hy",
  "Azerbaijani": "az",
  "Basque": "eu",
  "Belarusian": "be",
  "Bengali": "bn",
  "Bosnian": "bs",
  "Bulgarian": "bg",
  "Catalan": "ca",
  "Cebuano": "ceb",
  "Chinese": "zh",
  "Corsican": "co",
  "Croatian": "hr",
  "Czech": "cs",
  "Danish": "da",
  "Dutch": "nl",
  "English": "en",
  "Esperanto": "eo",
  "Estonian": "et",
  "Finnish": "fi",
  "French": "fr",
  "Frisian": "fy",
  "Galician": "gl",
  "Georgian": "ka",
  "German": "de",
  "Greek": "el",
  "Gujarati": "gu",
  "Haitian Creole": "ht",
  "Hausa": "ha",
  "Hawaiian": "haw",
  "Hebrew": "he",
  "Hindi": "hi",
  "Hmong": "hmn",
  "Hungarian": "hu",
  "Icelandic": "is",
  "Igbo": "ig",
  "Indonesian": "id",
  "Irish": "ga",
  "Italian": "it",
  "Japanese": "ja",
  "Javanese": "jv",
  "Kannada": "kn",
  "Kazakh": "kk",
  "Khmer": "km",
  "Kinyarwanda": "rw",
  "Korean": "ko",
  "Kurdish": "ku",
  "Kyrgyz": "ky",
  "Lao": "lo",
  "Latin": "la",
  "Latvian": "lv",
  "Lithuanian": "lt",
  "Luxembourgish": "lb",
  "Macedonian": "mk",
  "Malagasy": "mg",
  "Malay": "ms",
  "Malayalam": "ml",
  "Maltese": "mt",
  "Maori": "mi",
  "Marathi": "mr",
  "Mongolian": "mn",
  "Myanmar (Burmese)": "my",
  "Nepali": "ne",
  "Norwegian": "no",
  "Nyanja (Chichewa)": "ny",
  "Odia (Oriya)": "or",
  "Pashto": "ps",
  "Persian": "fa",
  "Polish": "pl",
  "Portuguese": "pt",
  "Punjabi": "pa",
  "Romanian": "ro",
  "Russian": "ru",
  "Samoan": "sm",
  "Scots Gaelic": "gd",
  "Serbian": "sr",
  "Sesotho": "st",
  "Shona": "sn",
  "Sindhi": "sd",
  "Sinhala (Sinhalese)": "si",
  "Slovak": "sk",
  "Slovenian": "sl",
  "Somali": "so",
  "Spanish": "es",
  "Sundanese": "su",
  "Swahili": "sw",
  "Swedish": "sv",
  "Tagalog (Filipino)": "tl",
  "Tajik": "tg",
  "Tamil": "ta",
  "Tatar": "tt",
  "Telugu": "te",
  "Thai": "th",
  "Turkish": "tr",
  "Turkmen": "tk",
  "Ukrainian": "uk",
  "Urdu": "ur",
  "Uyghur": "ug",
  "Uzbek": "uz",
  "Vietnamese": "vi",
  "Welsh": "cy",
  "Xhosa": "xh",
  "Yiddish": "yi",
  "Yoruba": "yo",
  "Zulu": "zu",
};

List<String> getQualityList() {
  return [
    QualityConstants.low,
    QualityConstants.medium,
    QualityConstants.high,
    QualityConstants.veryHigh,
    QualityConstants.ultra2K,
    QualityConstants.ultra4K,
    QualityConstants.ultra8K,
  ];
}

class QualityConstants {
  static const String defaultQualityKey = 'default_quality';
  static const String defaultQuality = 'default';
  static const String low = '480p';
  static const String medium = '720p';
  static const String high = '1080p';
  static const String veryHigh = '1440p';
  static const String ultra2K = '2K';
  static const String ultra4K = '4K';
  static const String ultra8K = '8K';
}

class NotificationType {
  static const String movie_added = 'movie_add';
  static const String season_added = 'season_add';
  static const String tvshow_added = 'tv_show_add';
  static const String video_added = 'video_add';
  static const String episode_added = 'episode_add';
  static const String upcoming = 'upcoming';
  static const String continueWatch = 'continue_watch';
  static const String subscription = 'new_subscription';
  static const String cancelSubscription = 'cancle_subscription';
  static const String subscriptionExpireReminder = 'subscription_expiry_reminder';
  static const String expiryPlan = 'expiry_plan';
  static const String purchaseExpireReminder = 'purchase_expiry_reminder';
  static const String rentExpireReminder = 'rent_expiry_reminder';
  static const String rentVideo = 'rent_video';
  static const String purchaseVideo = 'purchase_video';
}

const List<String> defaultWatchingProfileBaseImages = [
  Assets.watchingProfileDefaultProfile1,
  Assets.watchingProfileDefaultProfile2,
  Assets.watchingProfileDefaultProfile3,
  Assets.watchingProfileDefaultProfile4,
  Assets.watchingProfileDefaultProfile5,
];

List<String> defaultWatchingProfileImage = [...defaultWatchingProfileBaseImages];

const String accountSettings = 'account_settings';
const String purchaseSettings = 'purchase_settings';
const String deviceSettings = 'device_settings';