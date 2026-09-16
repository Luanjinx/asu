import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:media_kit/media_kit.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/locale/language_en.dart';
import 'package:streamit_laravel/routes/app_routes.dart';
import 'package:streamit_laravel/screens/splash_controller.dart';
import 'package:streamit_laravel/screens/splash_screen.dart';
import 'package:streamit_laravel/screens/auth/model/app_configuration_res.dart';
import 'package:streamit_laravel/screens/auth/model/login_response.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/addon_bridge/short_drama/short_drama_bridge.dart';
import 'package:streamit_laravel/addon_registration.dart';
import 'package:streamit_laravel/services/encryption_service.dart';
import 'package:streamit_laravel/services/hive_service.dart';
import 'package:streamit_laravel/services/in_app_purhcase_service.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/services/notification_service.dart';
import 'package:streamit_laravel/utils/page_transition_builder.dart';

import 'app_theme.dart';
import 'bindings/app_bindings.dart';
import 'configs.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'screens/content/model/content_model.dart';
import 'screens/profile/model/profile_detail_resp.dart';
import 'utils/colors.dart';
import 'utils/common_base.dart';
import 'utils/common_functions.dart';
import 'utils/constants.dart';

Rx<BaseLanguage> locale = LanguageEn().obs;

InAppPurchaseService inAppPurchaseService = InAppPurchaseService();
HiveService hiveService = HiveService();
DashboardDetailResponse? cachedDashboardDetailResponse;
LiveChannelDashboardResponse? cachedLiveTvDashboard;
ProfileDetailResponse? cachedProfileDetails;

RxList<ComingSoonModel> cachedComingSoonList = RxList<ComingSoonModel>();
RxList<PosterDataModel> cachedContinueWatchList = RxList<PosterDataModel>();
RxList<PosterDataModel> cachedWatchList = RxList<PosterDataModel>();
RxList<PosterDataModel> cachedRentedContentList = RxList<PosterDataModel>();
RxList<Cast> cachedPersonList = RxList();
RxList<PosterDataModel> cachedSliderList = RxList();
bool isNotificationRead = false;
bool isScreenShotAllowed = false;

const platform = MethodChannel('flutter.iqonic.streamitlaravel.com.channel');

Future<void> initConfig() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Duration.zero,
    ));
    await remoteConfig.setDefaults({
      baseUrlKeyName: DOMAIN_URL,
      "isScreenShotAllowed": isScreenShotAllowed,
      "reviewParameter": jsonEncode({
        "iosVersion": "1.0.0",
        "androidVersion": "1.0.0",
        "isIosInReview": false,
        "isAndroidInReview": false,
        "andoidBaseUrl": DOMAIN_URL,
        "iosBaseUrl": DOMAIN_URL
      })
    });
    await remoteConfig.fetchAndActivate();
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      setFirebaseConfigData();
    });
    setFirebaseConfigData();
  } catch (e) {
    print("Init Config Error: $e");
  }
}

Future<void> setFirebaseConfigData() async {
  try {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final value = remoteConfig.getString(baseUrlKeyName);
    try {
      isScreenShotAllowed = remoteConfig.getBool('isScreenShotAllowed');
    } catch (e) {
      isScreenShotAllowed = false;
    }
    if(value.isNotEmpty) DOMAIN_URL = value;
    if(!(await isIqonicProduct)) return; 
    final reviewParameter = remoteConfig.getString('reviewParameter');
    if(reviewParameter.isEmpty) return;
    final reviewParameterMap = jsonDecode(reviewParameter);
    final iosVersion = reviewParameterMap['iosVersion'];
    final androidVersion = reviewParameterMap['androidVersion'];
    final isIosInReview = reviewParameterMap['isIosInReview'];
    final isAndroidInReview = reviewParameterMap['isAndroidInReview'];
    final androidBaseUrl = reviewParameterMap['androidBaseUrl'];
    final iosBaseUrl = reviewParameterMap['iosBaseUrl'];
    final versionName = (await getPackageInfo()).versionName;
    if(versionName == null || versionName.isEmpty) return;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    if(isAndroidInReview && Platform.isAndroid && versionName == androidVersion) {
      isInReview = true;
      DOMAIN_URL = androidBaseUrl;
    }
    if(isIosInReview && Platform.isIOS && versionName == iosVersion) {
      isInReview = true;
      DOMAIN_URL = iosBaseUrl;
    }
  } catch (e) {
    print("Set Firebase Config Data Error: $e");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  setupGlobalFontConfig();

  await Firebase.initializeApp().then((value) {
    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
    NotificationService().init();
  }).catchError(onError);
  await initConfig();
// Initialize encryption service
  await EncryptionService.initialize();

  // Initialize local storage
  await LocalStorage.init();
  hiveService.init();
  ShortDramaAddon.register();

  appButtonBackgroundColorGlobal = appColorPrimary;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  defaultAppButtonTextColorGlobal = primaryTextColor;
  passwordLengthGlobal = 8;

  selectedLanguageCode(await getStringFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);

  await initialize(aLocaleLanguageList: languageList(), defaultLanguage: selectedLanguageCode.value);

  final BaseLanguage temp = await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value = await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  Map<String, dynamic>? cachedConfigKey = await getJsonFromLocal(SharedPreferenceConst.CACHE_CONFIGURATION_RESPONSE);
  if (cachedConfigKey != null) {
    appConfigs(ConfigurationResponse.fromJson(cachedConfigKey));
  }

  isLoggedIn(await getBoolFromLocal(SharedPreferenceConst.IS_LOGGED_IN));
  setBoolToLocal(SharedPreferenceConst.IS_LOGGED_IN, isLoggedIn.value);

  Map<String, dynamic>? cachedLoginUserDataKey = await getJsonFromLocal(SharedPreferenceConst.USER_DATA);
  if (cachedLoginUserDataKey != null) {
    loginUserData(UserData.fromJson(cachedLoginUserDataKey));
    if ((loginUserData.value.shortDramaSessionToken ?? '').isNotEmpty) {
      ShortDramaBridge.restoreSessionToken(loginUserData.value.shortDramaSessionToken);
    }
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark
    ),
  );

  MobileAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    final deepLink = routeInformation.uri.toString();
    if (deepLink.isNotEmpty) {
      Get.find<SplashScreenController>().handleDeepLinking(deepLink: deepLink);
      return true;
    }
    return super.didPushRouteInformation(routeInformation);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash,
      navigatorKey: navigatorKey,
      title: APP_NAME,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.noTransition,
      supportedLocales: LanguageDataModel.languageLocales(),
      getPages: AppRoutes.routes,
      onGenerateInitialRoutes: (String initialRoute) {
        final knownNames = AppRoutes.routes.map((p) => p.name).toList();
        if (initialRoute.isNotEmpty && knownNames.contains(initialRoute)) {
          try {
            final getPage = AppRoutes.routes.firstWhere((p) => p.name == initialRoute);
            getPage.binding?.dependencies();
            return [
              GetPageRoute(
                page: getPage.page,
                routeName: initialRoute,
                binding: getPage.binding,
              ),
            ];
          } catch (e, st) {
            debugPrint('MyApp.onGenerateInitialRoutes: failed to build route for "$initialRoute": $e\n$st');
          }
        }
        return [
          GetPageRoute(
            page: () => SplashScreen(deepLink: initialRoute, link: true),
            routeName: AppRoutes.splash,
            binding: AppBindings(),
          ),
        ];
      },
      unknownRoute: GetPage(
        name: AppRoutes.splash,
        page: () => SplashScreen(deepLink: '', link: false),
        binding: AppBindings(),
      ),
      localizationsDelegates: const [
        AppLocalizations(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) => Locale(selectedLanguageCode.value),
      fallbackLocale: const Locale(DEFAULT_LANGUAGE),
      locale: Locale(selectedLanguageCode.value),
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return FToastBuilder()(
            context,
            Theme(
              data: AppTheme.darkTheme.copyWith(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: AppPageTransitionsBuilder(),
                    TargetPlatform.iOS: AppPageTransitionsBuilder(),
                  },
                ),
              ),
              child: child!,
            ));
      },
      initialBinding: BindingsBuilder(() {
        AppBindings().dependencies();
      }),
    );
  }
}
