import 'package:flutter/material.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';

/// Delegate interface that the Short Drama add-on implements.
abstract class ShortDramaDelegate {
  void restoreSessionToken(String? token);
  void initHomeFeature(HomeController controller);
  void disposeHomeFeature(HomeController controller);
  Widget? buildToggle(HomeController controller);
  Widget buildContent(HomeController controller, Widget homeContent);
  bool shouldShowBanner(HomeController controller, bool defaultShowBanner);
  double getExpandedHeight(HomeController controller, double defaultHeight, double toolbarHeight);
  bool isShortDramaActive(HomeController controller);
  bool isShortDramaSelected(HomeController controller);
  Future<void> refreshHome(HomeController controller);

  /// Handle an incoming deep link. Returns true when the add-on claimed it.
  Future<bool> handleDeepLink(String deepLink);

  /// Re-open a link that arrived before a profile was selected.
  Future<bool> resumePendingDeepLink();

  /// True when a deep link already drove navigation this launch, so the
  /// splash timer must not redirect over it.
  bool get deepLinkHandledThisLaunch;
}

/// A bridge class that safely routes calls to the Short Drama module if it is installed.
/// If the add-on is not installed (delegate is null), it returns safe defaults/stubs.
class ShortDramaBridge {
  static ShortDramaDelegate? _delegate;

  static void register(ShortDramaDelegate delegate) {
    _delegate = delegate;
  }

  static void restoreSessionToken(String? token) {
    _delegate?.restoreSessionToken(token);
  }

  static void initHomeFeature(HomeController controller) {
    _delegate?.initHomeFeature(controller);
  }

  static void disposeHomeFeature(HomeController controller) {
    _delegate?.disposeHomeFeature(controller);
  }

  static Widget? buildToggle(HomeController controller) {
    return _delegate?.buildToggle(controller);
  }

  static Widget buildContent(HomeController controller, Widget homeContent) {
    return _delegate?.buildContent(controller, homeContent) ?? homeContent;
  }

  static bool shouldShowBanner(HomeController controller, bool defaultShowBanner) {
    return _delegate?.shouldShowBanner(controller, defaultShowBanner) ?? defaultShowBanner;
  }

  static double getExpandedHeight(HomeController controller, double defaultHeight, double toolbarHeight) {
    return _delegate?.getExpandedHeight(controller, defaultHeight, toolbarHeight) ?? defaultHeight;
  }

  static bool isShortDramaActive(HomeController controller) {
    return _delegate?.isShortDramaActive(controller) ?? false;
  }

  static bool isShortDramaSelected(HomeController controller) {
    return _delegate?.isShortDramaSelected(controller) ?? false;
  }

  static Future<void> refreshHome(HomeController controller) async {
    if (_delegate != null) {
      await _delegate!.refreshHome(controller);
    }
  }

  /// Every deep-link entry point returns false when the add-on is absent, so
  /// the host simply falls through to its own routing.
  static Future<bool> handleDeepLink(String deepLink) async {
    return await _delegate?.handleDeepLink(deepLink) ?? false;
  }

  static Future<bool> resumePendingDeepLink() async {
    return await _delegate?.resumePendingDeepLink() ?? false;
  }

  static bool get deepLinkHandledThisLaunch {
    return _delegate?.deepLinkHandledThisLaunch ?? false;
  }
}
