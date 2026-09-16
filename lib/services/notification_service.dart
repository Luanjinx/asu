import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' show get;
import 'package:nb_utils/nb_utils.dart' show IntExtensions;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:streamit_laravel/screens/auth/other/notification_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_detail_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/rental_history_screen.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/subscription_history_screen.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

/// Handle background notification when app is not running
///
/// This will be called when the app is not running and receives a notification
/// via FCM. The function is an entry point for the VM, so it must not be a
/// closure or tear-off.
@pragma('vm:entry-point')
Future<void> handleBackground(RemoteMessage message) async {
  debugPrint('Title:- ${message.notification?.title}');
  debugPrint('Body:- ${message.notification?.body}');
  debugPrint('Data:- ${message.data}');
}

class NotificationService {
  NotificationService._();

  static final _instance = NotificationService._();

  factory NotificationService() {
    return _instance;
  }

  final _firebaseMessaging = FirebaseMessaging.instance;

  final _flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'notification',
    'Notification',
    description:
        'Get alerts for transactions, offers, and important updates from Streamit.',
    importance: Importance.high,
  );

  final icon = '@drawable/ic_stat_ic_notification';

  /// Initialize the notification service.
  ///
  /// This function initialize the notification service. It request for the
  /// notification permission, get the FCM token, initialize the push notification
  /// and initialize the local notification.
  ///
  /// Any error that occur during the initialization process will be logged in
  /// the debug console.
  Future<void> init() async {
    try {
      await _firebaseMessaging.requestPermission();
      await getFcmToken();
      await initPushNotification();
      await initLocalNotification();
    } catch (e) {
      debugPrint('Notification Service Init Error: $e');
    } finally {
      await FirebaseMessaging.instance.subscribeToTopic(appNameTopic);
      debugPrint('Subscribed to topic: $appNameTopic');
    }
  }

  /// Get the FCM token.
  ///
  /// This function get the FCM token from the Firebase Messaging Service. If the
  /// token is not available, it will return an empty string.
  ///
  /// The token is used to send a notification to a specific device.
  ///
  /// The token is logged in the debug console for debugging purpose.
  ///
  Future<String> getFcmToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM TOKEN:- $fcmToken');
      return fcmToken ?? '';
    } catch (e) {
      debugPrint('Get FCM Token Error: $e');
      return '';
    }
  }

  /// Initialize push notification
  ///
  /// This function initialize the push notification service. It set the
  /// foreground notification presentation options to show alert, badge and sound.
  /// It also enable the auto initialization of the Firebase Messaging Service.
  ///
  /// It listen to the following events:
  ///
  /// - `onMessageOpenedApp`: When the app is opened from a notification tap.
  /// - `onBackgroundMessage`: When the app is in background and receive a
  ///   notification.
  /// - `onMessage`: When the app receive a notification.
  ///
  /// When the app receive a notification, it will show a notification using the
  /// `showNotification` function.
  Future<void> initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessaging.setAutoInitEnabled(true);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackground);
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Title:- ${message.notification?.title}');
      debugPrint('Body:- ${message.notification?.body}');
      debugPrint('Data:- ${message.data}');
      if (Platform.isIOS) return;
      final notification = message.notification;
      if (notification == null) return;
      showNotification(
        title: notification.title!,
        body: notification.body!,
        payload: message.data,
        imageUrl: notification.android?.imageUrl,
      );
    });
  }

  /// Initialize local notification plugin.
  ///
  /// This will initialize the flutter local notification plugin.
  /// On android, it will create a notification channel.
  /// On iOS, it will request permissions for notification.
  Future<void> initLocalNotification() async {
    const iosInitializationSettings = DarwinInitializationSettings();
    final androidInitializationSettings = AndroidInitializationSettings(icon);

    final settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
    );

    final androidPlatformImplementation =
        _flutterLocalNotificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    androidPlatformImplementation?.createNotificationChannel(_androidChannel);
    final iosPlatformImplementation =
        _flutterLocalNotificationPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    await iosPlatformImplementation?.requestPermissions(
      alert: true,
      sound: true,
      badge: true,
    );
  }

  /// Displays a notification with the specified [title] and [body].
  ///
  /// The [payload] is a map of additional data that will be included with the
  /// notification, serialized as a JSON string.
  ///
  /// Optionally, an [imageUrl] can be provided to display an image in the
  /// notification. The image is processed to create a [NotificationDetails]
  /// object using [getNotificationDetails].
  ///
  /// A random [id] is generated for the notification to differentiate it from
  /// other notifications.
  void showNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
    String? imageUrl,
  }) async {
    final id = Random().nextInt(1000);
    final notificationDetails =
        await getNotificationDetails(image: imageUrl, fileName: 'fcm_$id.png');

    _flutterLocalNotificationPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(payload),
    );
  }

  /// Returns a [NotificationDetails] object with [BigPictureStyleInformation]
  /// set if [image] is not null or empty.
  ///
  /// The [BigPictureStyleInformation] is used to show the image in the
  /// notification shade.
  ///
  /// The image is downloaded and saved to the cache directory, and then the
  /// path to the image is used to create the [FilePathAndroidBitmap].
  ///
  /// If the image cannot be downloaded or saved, then [BigPictureStyleInformation]
  /// is null, and the notification will be shown without an image.
  Future<NotificationDetails> getNotificationDetails(
      {String? image, String? fileName}) async {
    BigPictureStyleInformation? bigPictureStyle;
    if (image != null && image.isNotEmpty) {
      final filePath = await _downloadAndSaveImage(
        url: image,
        fileName: fileName ?? 'notification.jpg',
      );

      if (filePath != null) {
        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(filePath),
        );
      }
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        icon: icon,
        importance: _androidChannel.importance,
        priority: Priority.high,
        styleInformation: bigPictureStyle,
        colorized: true,
        color: appColorPrimary,
      ),
    );
  }

  /// Downloads the image from the given [url] and saves it to the cache directory
  /// with the given [fileName].
  ///
  /// Returns the path to the saved file if the download and save is successful.
  /// Otherwise, returns null.
  ///
  /// The method logs an error if the download or save fails.
  Future<String?> _downloadAndSaveImage({
    required String url,
    required String fileName,
  }) async {
    try {
      final response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      debugPrint('Notification Image download failed: $e');
    }
    return null;
  }

  void handleMessage(RemoteMessage message) async {
    final data = parseAdditionalData(message.data);
    onNotificationTap(data);
  }

  Future<bool> checkNotificationPermission() async {
    final notificationSetting =
        await _firebaseMessaging.getNotificationSettings();
    if (notificationSetting.authorizationStatus ==
            AuthorizationStatus.authorized ||
        notificationSetting.authorizationStatus ==
            AuthorizationStatus.provisional) {
      return true;
    }
    return false;
  }

  Future<void> subscribeTopic() async {
    if (loginUserData.value.id < 0) return;
    final topic =
        '${FirebaseMsgConst.userWithUnderscoreKey}${loginUserData.value.id}';
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint('Subscribed to topic: $topic');
  }

  Future<void> unSubscribeTopic() async {
    if (loginUserData.value.id < 0) return;
    final topic =
        '${FirebaseMsgConst.userWithUnderscoreKey}${loginUserData.value.id}';
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    debugPrint('Unsubscribed from topic: $topic');
  }
}

void onDidReceiveNotificationResponse(NotificationResponse details) {
  final data = parseAdditionalData(jsonDecode(details.payload ?? '{}'));
  onNotificationTap(data);
}

Map<String, dynamic> parseAdditionalData(Map<String, dynamic> data) {
  try {
    final raw = data[FirebaseMsgConst.additionalDataKey];
    if (raw == null) return {};
    if (raw is String) {
      return Map<String, dynamic>.from(jsonDecode(raw));
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
  } catch (e) {
    debugPrint('Additional Data parse error: $e');
  }
  return {};
}

void onNotificationTap(Map<String, dynamic> data) {
  debugPrint('Notification data: $data');
  if (data.isEmpty) {
    openNotificationScreen();
    return;
  }

  String notificationType = data['notification_type'] ?? '';
  int id = int.tryParse(data['id']?.toString() ?? '') ?? int.tryParse(data['content_id']?.toString() ?? '') ?? -1;
  String contentType = data['content_type'] ?? '';

  if (id > 0 && notificationType.isNotEmpty) {
    if (notificationType == NotificationType.movie_added) {
      openContent(id, VideoType.movie);
      return;
    }
    if (notificationType == NotificationType.tvshow_added ||
        notificationType == NotificationType.episode_added ||
        notificationType == NotificationType.season_added) {
      openContent(id, VideoType.tvshow);
      return;
    }
    if (notificationType == NotificationType.video_added) {
      openContent(id, VideoType.video);
      return;
    }
    if (notificationType == NotificationType.upcoming) {
      if (contentType.isNotEmpty) {
        Get.to(
          () => ComingSoonDetailScreen(
              comingSoonData: ComingSoonModel(id: id, type: contentType)),
          arguments: ComingSoonModel(id: id, type: contentType),
        );
        return;
      }
    }
    if (notificationType == NotificationType.continueWatch) {
      if (contentType.isNotEmpty) {
        openContent(id, contentType);
        return;
      }
    }
    if (notificationType == NotificationType.rentVideo ||
        notificationType == NotificationType.purchaseVideo) {
      if (contentType.isNotEmpty) {
        openContent(id, contentType);
        return;
      }
    }
  }

  if (notificationType == NotificationType.subscription ||
      notificationType == NotificationType.cancelSubscription) {
    if (isLoggedIn.value &&
        selectedAccountProfile.value.isChildProfile.validate() == 0) {
      Get.to(() => SubscriptionHistoryScreen());
    }
    return;
  }

  if (notificationType == NotificationType.subscriptionExpireReminder || notificationType == NotificationType.expiryPlan) {
    if (isLoggedIn.value &&
        selectedAccountProfile.value.isChildProfile.validate() == 0) {
      Get.to(() => SubscriptionScreen(launchDashboard: false));
    }
    return;
  }

  if (notificationType == NotificationType.purchaseExpireReminder ||
      notificationType == NotificationType.rentExpireReminder) {
    if (isLoggedIn.value &&
        selectedAccountProfile.value.isChildProfile.validate() == 0) {
      Get.to(() => RentalHistoryScreen());
    }
    return;
  }

  openNotificationScreen();
}

void openNotificationScreen() {
  if (isLoggedIn.value &&
      selectedAccountProfile.value.isChildProfile.validate() == 0) {
    Get.to(() => NotificationScreen());
  }
}

void openContent(int id, String type) {
  Get.to(
    () => ContentDetailsScreen(),
    arguments: PosterDataModel(
      id: id,
      details: ContentData(type: type),
    ),
  );
}
