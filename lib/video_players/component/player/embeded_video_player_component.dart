import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:streamit_laravel/video_players/helper/player_manager.dart';

class EmbeddedVideoPlayer extends StatelessWidget {
  final PlayerManager? playerManager;

  const EmbeddedVideoPlayer({
    super.key,
    this.playerManager,
  });

  @override
  Widget build(BuildContext context) {
    if (playerManager != null) {
      return InAppWebView(
        keepAlive: InAppWebViewKeepAlive(),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllowFullscreen: true,
          isInspectable: kDebugMode,
          transparentBackground: true,
          useHybridComposition: false,
          shouldPrintBackgrounds: false,
          horizontalScrollBarEnabled: false,
          verticalScrollBarEnabled: false,
          supportZoom: false,
        ),
        onExitFullscreen: (controller) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        },
        onEnterFullscreen: (controller) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ],
          );
        },
        onWebViewCreated: (controller) {
          playerManager!.onWebViewCreated(controller);
        },
        onConsoleMessage: (controller, consoleMessage) {
          log("WebView Console: ${consoleMessage.message}");
        },
      );
    }

    return const SizedBox.shrink();
  }
}