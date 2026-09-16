import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/connectivity_controller.dart';
import 'package:streamit_laravel/screens/account_setting/account_setting_controller.dart';
import 'package:streamit_laravel/screens/channel_list/channel_list_controller.dart';
import 'package:streamit_laravel/screens/content/components/auto_slider_component.dart';
import 'package:streamit_laravel/screens/content/content_details_controller.dart';
import 'package:streamit_laravel/screens/content/content_list_controller.dart';
import 'package:streamit_laravel/screens/content/filtered_content_list_controller.dart';
import 'package:streamit_laravel/screens/dashboard/floting_action_bar/floating_action_controller.dart';
import 'package:streamit_laravel/screens/downloads/download_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_update_watching_profile_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_pin_controller.dart';
import 'package:streamit_laravel/screens/rented_content/rented_content_list_controller.dart';
import 'package:streamit_laravel/screens/review/review_list_controller.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/screens/setting/faq/faq_list_controller.dart';
import 'package:streamit_laravel/screens/setting/setting_controller.dart';
import 'package:streamit_laravel/utils/cast/controller/fc_cast_controller.dart';
import 'package:streamit_laravel/video_players/component/common/rent_detail_bottomsheet_controller.dart';

import '../screens/auth/change_password/change_password_controller.dart';
import '../screens/auth/forgot_password/forgot_pass_controller.dart';
import '../screens/auth/other/notification_controller.dart';
// Auth
import '../screens/auth/sign_in/sign_in_controller.dart';
import '../screens/auth/sign_up/sign_up_controller.dart';
// Utilities & misc
import '../screens/coming_soon/coming_soon_controller.dart';
import '../screens/continue_watching_list/continue_watching_list_controller.dart';
import '../screens/coupon/coupon_list_controller.dart';
// Dashboard
import '../screens/dashboard/dashboard_controller.dart';
// Download & player
import '../screens/genres/genres_controller.dart';
import '../screens/genres/genres_details/genres_details_controller.dart';
// Home & related
import '../screens/home/home_controller.dart';
import '../screens/live_tv/live_tv_controller.dart';
import '../screens/live_tv/live_tv_details/live_tv_details_controller.dart';
// Details screens
import '../screens/payment/payment_controller.dart';
import '../screens/person/person_controller.dart';
import '../screens/person/person_list/person_list_controller.dart';
import '../screens/profile/edit_profile/edit_profile_controller.dart';
// Profile
import '../screens/profile/profile_controller.dart';
import '../screens/profile/watching_profile/watching_profile_controller.dart';
import '../screens/qr_scanner/qr_scanner_controller.dart';
import '../screens/rented_content/rental_list_controller.dart';
import '../screens/setting/help_and_support/help_and_support_controller.dart';
import '../screens/slider/slider_controller.dart';
import '../screens/splash_controller.dart';
// Subscription & payment
import '../screens/subscription/subscription_controller.dart';
import '../screens/subscription/subscription_history/rental_history_controller.dart';
import '../screens/subscription/subscription_history/subscription_history_controller.dart';
import '../screens/walk_through/walk_through_cotroller.dart';
import '../screens/watch_list/watch_list_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core - Initialize connectivity and download progress monitoring
    Get.put(ConnectivityController(), permanent: true);

    Get.lazyPut<SplashScreenController>(() => SplashScreenController(), fenix: true);
    Get.lazyPut<FloatingController>(() => FloatingController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);

    Get.lazyPut(() => SearchScreenController(), fenix: true);
    Get.lazyPut(() => AutoSliderController(0, true));
    // Home & related
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<WatchListController>(() => WatchListController(), fenix: true);
    Get.lazyPut<AddUpdateWatchingProfileController>(() => AddUpdateWatchingProfileController(), fenix: true);
    Get.lazyPut<ProfilePinController>(() => ProfilePinController(), fenix: true);
    Get.lazyPut<ContinueWatchingListController>(() => ContinueWatchingListController(), fenix: true);
    Get.lazyPut<SliderController>(() => SliderController(), fenix: true);

    // Auth
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(), fenix: true);
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController(), fenix: true);
    Get.lazyPut<NotificationScreenController>(() => NotificationScreenController(), fenix: true);
    Get.lazyPut(() => FCCast());

    // Profile
    Get.lazyPut<AccountSettingController>(() => AccountSettingController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<EditProfileController>(() => EditProfileController(), fenix: true);
    Get.lazyPut<WatchingProfileController>(() => WatchingProfileController(), fenix: true);

    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    // Lists & details
    Get.lazyPut<ContentListController>(() => ContentListController(), fenix: true);
    Get.lazyPut<FilteredContentListController>(() => FilteredContentListController(), fenix: true);
    Get.lazyPut<ContentDetailsController>(() => ContentDetailsController(), fenix: true);
    Get.lazyPut<ChannelListController>(() => ChannelListController(), fenix: true);
    Get.lazyPut<GenresController>(() => GenresController(), fenix: true);
    Get.lazyPut<GenresDetailsController>(() => GenresDetailsController(), fenix: true);
    Get.lazyPut<PersonController>(() => PersonController(), fenix: true);
    Get.lazyPut<PersonListController>(() => PersonListController(), fenix: true);
    Get.lazyPut<ReviewListController>(() => ReviewListController(), fenix: true);
    Get.lazyPut<RentalListController>(() => RentalListController(), fenix: true);
    Get.lazyPut<RentedContentListController>(() => RentedContentListController(), fenix: true);
    Get.lazyPut<DownloadController>(() => DownloadController(), fenix: true);
    Get.lazyPut<FAQListController>(() => FAQListController(), fenix: true);

    // Details
    Get.lazyPut<LiveTVController>(() => LiveTVController(), fenix: true);
    Get.lazyPut<LiveContentDetailsController>(() => LiveContentDetailsController(), fenix: true);

    // Subscription & payment
    Get.lazyPut<SubscriptionController>(() => SubscriptionController(), fenix: true);
    Get.lazyPut<SubscriptionHistoryController>(() => SubscriptionHistoryController(), fenix: true);
    Get.lazyPut<RentalHistoryController>(() => RentalHistoryController(), fenix: true);
    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    Get.lazyPut<CouponListController>(() => CouponListController(), fenix: true);

    // Download & player

    Get.lazyPut<RentDetailsController>(() => RentDetailsController(), fenix: true);

    // Utilities & misc
    Get.lazyPut<ComingSoonController>(() => ComingSoonController(), fenix: true);
    Get.lazyPut<QRScannerController>(() => QRScannerController(), fenix: true);
    Get.lazyPut<HelpAndSupportController>(() => HelpAndSupportController(), fenix: true);
    Get.lazyPut<WalkThroughController>(() => WalkThroughController(), fenix: true);
  }
}