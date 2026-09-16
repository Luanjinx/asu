// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:streamit_laravel/generated/assets.dart';

const APP_NAME = 'Streamit';
const APP_MINI_LOGO_URL = Assets.assetsAppMiniLogo;
const APP_LOGO_URL = Assets.assetsAppLoader;
const APP_FONT_FAMILY = 'Roboto';
const DEFAULT_LANGUAGE = 'en';
const AUTO_SLIDER_SECOND = 6000;
const CUSTOM_AD_AUTO_SLIDER_SECOND_VIDEO = 30000;
const CUSTOM_AD_AUTO_SLIDER_SECOND_IMAGE = 30000;
const LIVE_AUTO_SLIDER_SECOND = 5;

const API_VERSION = 3;

///DO NOT ADD SLASH HERE
String DOMAIN_URL = "YOUR_DOMAIN_URL";

bool isInReview = false;

String get baseUrlKeyName => Platform.isAndroid ? 'developingBaseUrl' : 'developingBaseUrl';

String get BASE_URL => '$DOMAIN_URL/api/';

const APP_APPSTORE_URL = '';
const APP_PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=com.iqonic.streamitlaravel';

///LOCAL VIDEO TYPE URL
String get LOCAL_VIDEO_DOMAIN_URL => '$DOMAIN_URL/storage/streamit-laravel/';

//Note: For FIREBASE_CLIENT_ID ---> Go to android/app/google-services.json
// - Find press ctrl+F and look for "client_type": 3
// "client_id" in same object has be pasted here

String get FIREBASE_CLIENT_ID => Platform.isAndroid ? 'YOUR_ANDROID_FIREBASE_CLIENT_ID' : 'YOUR_IOS_FIREBASE_CLIENT_ID';

//region STRIPE
const STRIPE_URL = 'https://api.stripe.com/v1/payment_intents';
const STRIPE_merchantIdentifier = "merchant.flutter.stripe.test";
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';
//endregion

//region RazorPay
const String commonSupportedCurrency = 'INR';
//endregion

//region  PAYSTACK
const String payStackCurrency = "NGN";
//endregion

// PAYPAl
const String payPalSupportedCurrency = 'USD';
//endregion

//ADs
//Live keys
// //Android
const INTERSTITIAL_AD_ID = "YOUR_ANDROID_INTERSTITIAL_AD_ID";
const BANNER_AD_ID = "YOUR_ANDROID_BANNER_AD_ID";

// //IOS
const IOS_INTERSTITIAL_AD_ID = "YOUR_IOS_INTERSTITIAL_AD_ID";
const IOS_BANNER_AD_ID = "YOUR_IOS_BANNER_AD_ID";


//region defaultCountry
Country get defaultCountry => Country(
      phoneCode: '91',
      countryCode: 'IN',
      e164Sc: 91,
      geographic: true,
      level: 1,
      name: 'India',
      example: '23456789',
      displayName: 'India (IN) [+91]',
      displayNameNoCountryCode: 'India (IN)',
      e164Key: '91-IN-0',
      fullExampleWithPlusSign: '+919123456789',
    );
//endregion
