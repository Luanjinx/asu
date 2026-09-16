import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../configs.dart';
import '../utils/constants.dart';

class AppMinLogoWidget extends StatelessWidget {
  final Size? size;

  const AppMinLogoWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return appConfigs.value.appMiniLogo.isNotEmpty && appConfigs.value.appMiniLogo.validateURL()
        ? Image.network(
            appConfigs.value.appMiniLogo,
            height: size?.height ?? Constants.appLogoSize,
            width: size?.width ?? Constants.appLogoSize,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                APP_MINI_LOGO_URL,
                height: size?.height ?? Constants.appLogoSize,
                width: size?.width ?? Constants.appLogoSize,
              );
            },
          )
        : Image.asset(
            APP_MINI_LOGO_URL,
            height: size?.height ?? Constants.appLogoSize,
            width: size?.width ?? Constants.appLogoSize,
          );
  }
}

class AppLogoWidget extends StatelessWidget {
  final Size? size;
  final String? assetLogo;

  const AppLogoWidget({super.key, this.size, this.assetLogo});

  @override
  Widget build(BuildContext context) {
    return appConfigs.value.appLogo.isNotEmpty && appConfigs.value.appLogo.validateURL()
        ? Image.network(
            appConfigs.value.appLogo,
            height: size?.height ?? Constants.appLogoSize,
            width: size?.width ?? Constants.appLogoSize,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                assetLogo ?? APP_LOGO_URL,
                height: size?.height ?? Constants.appLogoSize,
                width: size?.width ?? Constants.appLogoSize,
              );
            },
          )
        : Image.asset(
            assetLogo ?? APP_LOGO_URL,
            height: size?.height ?? Constants.appLogoSize,
            width: size?.width ?? Constants.appLogoSize,
          );
  }
}

class AppLoaderWidget extends StatelessWidget {
  final Size? size;

  const AppLoaderWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return appConfigs.value.appLoader.isNotEmpty && appConfigs.value.appLoader.validateURL()
        ? Image.network(
            appConfigs.value.appLoader,
            height: size?.height ?? Constants.appLogoSize,
            width: size?.width ?? Constants.appLogoSize,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                APP_LOGO_URL,
                height: size?.height ?? Constants.appLogoSize,
                width: size?.width ?? Constants.appLogoSize,
              );
            },
          )
        : Image.asset(
            APP_LOGO_URL,
            height: size?.height ?? Constants.appLogoSize,
            width: size?.width ?? Constants.appLogoSize,
          );
  }
}