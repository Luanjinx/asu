# Streamit - Laravel Flutter Platform

## About The Project
Streamit is a powerful video streaming application built with Flutter, designed to offer a seamless and immersive entertainment experience. It supports movies, TV shows, and videos with a rich set of features including casting, downloading, and multiple payment gateways.

## Features
- **Cross-Platform**: Supports Android and iOS.
- **Localization**: Full multi-language support including English, French, German, Arabic, Greek, and more.
- **Dynamic Content**: Movies, TV Shows, Videos, and Live TV.
- **User Engagement**: Reviews, Ratings, Watchlist, and Continue Watching.
- **Monetization**:
    - Subscription Plans (In-App Purchases, Stripe, Razorpay, Paystack, Flutterwave, Paypal, etc.)
    - Pay-Per-View / Rental
    - Advertisement Support (Google AdMob)
- **Playback**:
    - Casting support (Chromecast)
    - Video Player with quality selection, subtitles, and speed control.
- **Offline Viewing**: Download content for offline access.
- **Authentication**: Social Login (Google, Apple), OTP Verification.
- **Add-on Ready**: Optional feature modules plug in without modifying app code.

## Add-ons

This app ships with an add-on bridge so optional feature modules — sold and
installed separately — can be plugged in without touching app code.

- `lib/addon_bridge/` — delegate interfaces and façades for each supported add-on
- `lib/addon_registration.dart` — the single place where add-ons are registered

Out of the box `addon_registration.dart` is an empty stub, and every bridge call
returns a safe default. The app builds and runs normally with no add-ons
installed.

Installing an add-on is two steps: copy its folder into `lib/`, then fill in
`register()`. Each add-on ships its own `INSTALLATION_GUIDE.md` with the exact
snippet and any extra prerequisites.

Available add-on:

- **Short Drama** — short-form vertical drama, purchased separately.
  Get it here: <https://iqonic.design/product/ott-streaming-short-drama/>
  Bridge: `lib/addon_bridge/short_drama/short_drama_bridge.dart`

> App code must never import an add-on's folder directly. Going through the
> bridge is what keeps the app compiling when the add-on is absent.

## Development Environment

### 🐦 Flutter

- **Version**: 3.47.0 (stable)
- **Supported Platforms**: Android, iOS
- **Version pin**: `.fvmrc` (use [FVM](https://fvm.app/) to match it)

### 📱 Android

- **Android Gradle Plugin**: 9.1.0
- **Gradle**: 9.3.1
- **Kotlin**: 2.4.0
- **Build scripts**: Kotlin DSL (`build.gradle.kts`, `settings.gradle.kts`)
- **Java**: 17
- **NDK**: 29.0.13599879
- **compileSdk / targetSdk / minSdk**: taken from the Flutter SDK

### 💻 IDEs

- **Android Studio**: 2025.1.3
    - Plugins: Flutter, Dart
- **Visual Studio Code**: 1.102.3
    - Extension: Flutter

## Configuration Guide

To customize the application for your environment, please follow these configuration steps:

### 1. Domain & API Configuration
- Open `lib/configs.dart`.
- Update `DOMAIN_URL` with your backend domain (e.g., `https://your-domain.com`).
- `BASE_URL` is automatically derived from `DOMAIN_URL`.

### 2. Payment Gateways
- **Stripe**: In `lib/configs.dart`, update `STRIPE_merchantIdentifier`, `STRIPE_MERCHANT_COUNTRY_CODE`, and `STRIPE_CURRENCY_CODE`.
- **RazorPay, PayStack, PayPal**: Check `lib/configs.dart` for relevant currency and key configurations.

### 3. Google Ads
- **Configuration**: Open `lib/configs.dart` and update the Ad Unit IDs for Android and iOS (Interstitial, Banner).
- **Manifest/Info.plist**:
    - **Android**: Update `com.google.android.gms.ads.APPLICATION_ID` in `android/app/src/main/AndroidManifest.xml`.
    - **iOS**: Update `GADApplicationIdentifier` in `ios/Runner/Info.plist`.

### 4. Firebase Configuration
- **Setup**: Create a new project in the [Firebase Console](https://console.firebase.google.com/).
- **Android**: Download `google-services.json` and place it in `android/app/`.
- **iOS**: Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
- **Dart Config**: Run `flutterfire configure` or manually update `lib/firebase_options.dart` with your new project keys (API Key, App ID, Messaging Sender ID, Project ID).
- **Auth**: Update `FIREBASE_CLIENT_ID` in `lib/configs.dart`.

### 5. Push Notifications
- Ensure Firebase Messaging is set up correctly as per step 4.
- Logic is handled in `lib/services/push_notification_service.dart`.
- **Topic Subscription**: The app subscribes to an app-wide topic `streamit_laravel` and user-specific topics.
- **Notification Icon**: Ensure you have generated a notification icon named `ic_stat_ic_notification` and placed it in the `android/app/src/main/res/drawable` folders. This is required for the status bar icon to display correctly on Android.

### 6. Platform Specifics
- **Android**:
    - Check `android/app/src/main/AndroidManifest.xml` to update `package` name if you refactor.
    - Verify required permissions (Internet, Camera, Storage, etc.).
- **iOS**:
    - Check `ios/Runner/Info.plist` to update `CFBundleIdentifier` (Bundle ID).
    - Verify privacy descriptions (Camera, Photo Library, Microphone usage).

### 7. Deep Linking

Incoming links are routed by `MyApp.didPushRouteInformation` (warm start) and
`onGenerateInitialRoutes` (cold start), then dispatched in
`SplashScreenController.handleDeepLinking`.

- **Android**: configured. Update the `<intent-filter>` host and `pathPrefix`
  entries in `android/app/src/main/AndroidManifest.xml` to match your domain.
  `autoVerify="true"` additionally requires an `assetlinks.json` served from
  `https://your-domain/.well-known/`.
- **iOS**: deep linking will be introduced in a later update.

Add-ons that handle their own links receive them through their bridge, so no
app code changes when one is installed.

## Build Notes

A few settings look unusual and are deliberate. Please read before "tidying"
them:

- **`dio` is pinned to `>=5.9.0 <5.10.0`** in `pubspec.yaml`. dio 5.10 added
  `DioExceptionType.transformTimeout`, and `playx_network` (transitive via
  `playx_version_update`) switches over that enum without a wildcard, which
  fails the release AOT compile. A caret range does **not** work here — `^5.9.0`
  still resolves to 5.11.0.
- **`android/build.gradle.kts` re-applies the Kotlin plugin** to library modules
  that ship `src/main/kotlin` without it. Several plugins skip
  `apply plugin: 'kotlin-android'` when the AGP major version is ≥ 9, assuming
  built-in Kotlin; Flutter requires `android.builtInKotlin=false`, so their
  Kotlin would otherwise never compile.
- **`android/gradle.properties` keeps `newDsl=false` and `builtInKotlin=false`.**
  Both are required by the Flutter Gradle plugin; removing them breaks plugin
  application outright.
- **Proguard suppressions use package wildcards**, not specific inner-class
  names. R8 re-letters obfuscated inner classes on every dependency bump.

Release build:

```bash
flutter build apk --release
flutter build appbundle --release
```

## Postman Collection

A Postman collection is included to help you test and understand the API endpoints used by the application.

- **Location**: The collection files are located in the `postman/` directory at the root of the project.
- **Usage**:
    1. Open [Postman](https://www.postman.com/).
    2. Click on **Import**.
    3. Drag and drop the files from the `postman/` folder into Postman or select the folder.
    4. You will see a new collection named **Streamit** (or similar) with organized folders for different modules (Auth, Dashboard, Content, etc.).
    5. Configure the environment variables (like `base_url`, `api_token`) in Postman to match your local or staging server.
