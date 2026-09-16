import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/page_transition_builder.dart';

import '../utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackgroundDark,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      surfaceTintColor: appScreenBackgroundDark,
      backgroundColor: appScreenBackgroundDark,
      iconTheme: const IconThemeData(color: primaryIconColor),
      titleTextStyle: boldTextStyle(
        color: primaryTextColor,
        fontFamily: APP_FONT_FAMILY,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,

      ),
    ),
    primaryColor: appColorPrimary,
    dividerColor: cardColor,
    iconTheme: const IconThemeData(color: Colors.white),
    primaryColorDark: appColorPrimary,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white, selectionHandleColor: appColorPrimary),
    hoverColor: appScreenBackgroundDark,
    fontFamily: APP_FONT_FAMILY,
    drawerTheme: const DrawerThemeData(backgroundColor: cardColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: borderColor),
    primaryTextTheme: TextTheme(
      titleLarge: commonPrimaryTextStyle(color: primaryTextColor),
      labelSmall: commonPrimaryTextStyle(color: primaryTextColor),
    ),
    cardTheme: const CardThemeData(color: cardColor),
    cardColor: cardColor,
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: APP_FONT_FAMILY),
      displayMedium: TextStyle(fontFamily: APP_FONT_FAMILY),
      displaySmall: TextStyle(fontFamily: APP_FONT_FAMILY),
      headlineLarge: TextStyle(fontFamily: APP_FONT_FAMILY),
      headlineMedium: TextStyle(fontFamily: APP_FONT_FAMILY),
      headlineSmall: TextStyle(fontFamily: APP_FONT_FAMILY),
      titleLarge: TextStyle(fontFamily: APP_FONT_FAMILY),
      titleMedium: TextStyle(fontFamily: APP_FONT_FAMILY),
      titleSmall: TextStyle(fontFamily: APP_FONT_FAMILY),
      bodyLarge: TextStyle(fontFamily: APP_FONT_FAMILY),
      bodyMedium: TextStyle(fontFamily: APP_FONT_FAMILY),
      bodySmall: TextStyle(fontFamily: APP_FONT_FAMILY),
      labelLarge: TextStyle(fontFamily: APP_FONT_FAMILY),
      labelMedium: TextStyle(fontFamily: APP_FONT_FAMILY),
      labelSmall: TextStyle(fontFamily: APP_FONT_FAMILY),
    ),
    tabBarTheme: const TabBarThemeData(indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.white))),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: AppPageTransitionsBuilder(),
        TargetPlatform.iOS: AppPageTransitionsBuilder(),
        TargetPlatform.linux: AppPageTransitionsBuilder(),
        TargetPlatform.macOS: AppPageTransitionsBuilder(),
        TargetPlatform.windows: AppPageTransitionsBuilder(),
      },
    ),
    colorScheme: const ColorScheme.dark(
      primary: cardColor,
      onPrimary: cardColor,
      secondary: whiteColor,
      error: Color(0xFFCF6676),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: appScreenBackgroundDark,
      titleTextStyle: boldTextStyle(
        color: primaryTextColor,
        size: ResponsiveSize.getFontSize(20),
      ),
      contentTextStyle: commonPrimaryTextStyle(),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: appColorPrimary,
      textTheme: ButtonTextTheme.primary,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: appScreenBackgroundDark,
      tilePadding: EdgeInsets.zero,
      collapsedBackgroundColor: appScreenBackgroundDark,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(boldTextStyle(color: appColorPrimary, size: 14, weight: FontWeight.w600)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        visualDensity: VisualDensity.compact,
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
      ),
    ),
  );
}