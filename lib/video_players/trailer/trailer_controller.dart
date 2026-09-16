import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/video_players/helper/player_manager.dart';

class TrailerController extends GetxController with WidgetsBindingObserver {
  bool isFullScreenEnable;
  final VideoData videoData;
  final VoidCallback? onTrailerCompleted;

  // Getters for UI
  PlayerManager get playerManager => _playerManager;

  // Player State
  RxBool isInitialized = false.obs;
  RxBool isPlaying = false.obs;
  RxBool isBuffering = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  // Player Managers
  final PlayerManager _playerManager = PlayerManager();

  TrailerController({
    required this.videoData,
    this.onTrailerCompleted,
    this.isFullScreenEnable = true,
  });

  @override
  void onInit() {
    super.onInit();
    initializeTrailer();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> initializeTrailer() async {
    try {
      log('TrailerController: initializeTrailer for ${videoData.id}');
      hasError(false);
      isBuffering(true);

      final (String type, String url) = _getVideoLinkAndType();

      // Initialize Player
      _playerManager.isMuted(true);
      await _playerManager.initialize(
        url: url,
        type: type.toLowerCase(),
        thumbnail: videoData.posterImage,
      );
      log('TrailerController: Initialized successfully');
      _setupListeners();
      isInitialized(true);
      isBuffering(false);
    } catch (e) {
      hasError(true);
      errorMessage(e.toString());
      isBuffering(false);
      log("Trailer initialization error: $e");
    }
  }

  (String, String) _getVideoLinkAndType() {
    return (videoData.urlType.toLowerCase(), videoData.url);
  }

  void _setupListeners() {
    // Listen for completion
    _playerManager.onEvent = (event) {
      if (event == 'ended') {
        onTrailerCompleted?.call();
      } else if (event == 'error') {
        hasError(true);
        errorMessage('An error occurred during playback.');
      } else if (event == 'buffering') {
        isBuffering(true);
      } else if (event == 'playing') {
        isBuffering(false);
        isPlaying(true);
      }
    };
  }

  Future<void> play() async {
    await _playerManager.play();
    playerManager.handleUserInteraction();
  }

  Future<void> pause() async {
    await _playerManager.pause();
    playerManager.handleUserInteraction();
  }

  DecorationImage? getThumbnailImage() {
    final url = videoData.posterImage;
    if (url.isNotEmpty && !url.contains("/data/user")) {
      return DecorationImage(
        image: NetworkImage(url),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(appScreenBackgroundDark.withValues(alpha: 0.4), BlendMode.darken),
      );
    } else if (url.contains("/data/user") && File(url).existsSync()) {
      return DecorationImage(
        image: FileImage(File(url)),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(appScreenBackgroundDark.withValues(alpha: 0.4), BlendMode.darken),
      );
    }
    return null;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  @override
  void onClose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    isPipModeOn(false);
    WidgetsBinding.instance.removeObserver(this);
    _playerManager.dispose();
    super.onClose();
  }
}