import 'package:get/get.dart';

import '../bindings/app_bindings.dart';
import '../screens/auth/sign_in/sign_in_screen.dart';
import '../screens/auth/sign_up/signup_screen.dart';
import '../screens/coming_soon/coming_soon_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/live_tv/live_tv_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/setting/help_and_support/help_and_support_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/subscription/subscription_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String dashboard = '/dashboard';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String comingSoon = '/coming-soon';
  static const String liveTv = '/live-tv';
  static const String subscription = '/subscription';
  static const String payment = '/payment';
  static const String settings = '/settings';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String banner = '/banner';
  static const String watchingProfile = '/watching-profile';
  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: dashboard,
      page: () => DashboardScreen(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: comingSoon,
      page: () => ComingSoonScreen(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: liveTv,
      page: () => LiveTvScreen(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: subscription,
      page: () => SubscriptionScreen(launchDashboard: true),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: payment,
      page: () => PaymentScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: settings,
      page: () => HelpAndSupportScreen(),
      binding: AppBindings(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signIn,
      page: () => SignInScreen(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signUp,
      page: () => SignUpScreen(),
      binding: AppBindings(),
      transition: Transition.fadeIn,
    ),
  ];
}