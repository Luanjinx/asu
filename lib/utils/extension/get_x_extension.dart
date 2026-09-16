import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

extension ExtensionSnackbar on GetInterface {
  SnackbarController showSnackBar({
    required String message,
    Color? colorText,
    Duration? duration = const Duration(seconds: 2),

    /// with instantInit = false you can put snackbar on initState
    bool instantInit = true,
    SnackPosition? snackPosition,
    Widget? titleText,
    Widget? messageText,
    Widget? icon,
    bool? shouldIconPulse,
    double? maxWidth,
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    Color? leftBarIndicatorColor,
    List<BoxShadow>? boxShadows,
    Gradient? backgroundGradient,
    TextButton? mainButton,
    OnTap? onTap,
    bool? isDismissible,
    bool? showProgressIndicator,
    DismissDirection? dismissDirection,
    AnimationController? progressIndicatorController,
    Color? progressIndicatorBackgroundColor,
    Animation<Color>? progressIndicatorValueColor,
    SnackStyle? snackStyle,
    Curve? forwardAnimationCurve,
    Curve? reverseAnimationCurve,
    Duration? animationDuration,
    double? barBlur,
    double? overlayBlur,
    SnackbarStatusCallback? snackbarStatus,
    Color? overlayColor,
    Form? userInputForm,
  }) {
    final showSnackBar = GetSnackBar(
      snackbarStatus: snackbarStatus,
      messageText: messageText ??
          Text(
            message,
            style: commonW600PrimaryTextStyle(
              color: colorText ?? primaryTextColor,
              size: 14,
            ),
          ).paddingSymmetric(vertical: 12),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM,
      borderRadius: borderRadius ?? 15,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      duration: duration,
      barBlur: barBlur ?? 7.0,
      backgroundColor: backgroundColor ?? Colors.grey.withValues(alpha: 0.2),
      icon: icon,
      shouldIconPulse: shouldIconPulse ?? true,
      maxWidth: maxWidth,
      padding: padding ?? const EdgeInsets.all(16),
      borderColor: borderColor,
      borderWidth: borderWidth,
      leftBarIndicatorColor: leftBarIndicatorColor,
      boxShadows: boxShadows,
      backgroundGradient: backgroundGradient,
      mainButton: mainButton,
      onTap: onTap,
      isDismissible: isDismissible ?? true,
      dismissDirection: dismissDirection,
      showProgressIndicator: showProgressIndicator ?? false,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
      progressIndicatorValueColor: progressIndicatorValueColor,
      snackStyle: snackStyle ?? SnackStyle.FLOATING,
      forwardAnimationCurve: forwardAnimationCurve ?? Curves.easeOutCirc,
      reverseAnimationCurve: reverseAnimationCurve ?? Curves.easeOutCirc,
      animationDuration: animationDuration ?? const Duration(seconds: 1),
      overlayBlur: overlayBlur ?? 0.0,
      overlayColor: overlayColor ?? Colors.transparent,
      userInputForm: userInputForm,
    );

    final controller = SnackbarController(showSnackBar);

    void safeShow() {
      try {
        // Check if Get.context is available and has an overlay
        if (Get.context != null && Get.overlayContext != null) {
          controller.show();
        } else {
          // Fallback to toast if no overlay context is available
          log('Snackbar overlay missing, falling back to toast');
          toast(message);
        }
      } catch (e) {
        log('Snackbar error, falling back to toast: $e');
        toast(message);
      }
    }

    if (instantInit) {
      // Use post frame callback to ensure context is ready
      ambiguate(SchedulerBinding.instance)?.addPostFrameCallback((_) {
        safeShow();
      });
    } else {
      ambiguate(SchedulerBinding.instance)?.addPostFrameCallback((_) {
        safeShow();
      });
    }
    return controller;
  }
}