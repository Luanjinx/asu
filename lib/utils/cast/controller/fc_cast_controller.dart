import 'dart:async';
import 'dart:io';

import 'package:flutter_chrome_cast/lib.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/models/ad_config.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/main.dart';

class FCCast extends GetxController {
  RxBool isSearchingForDevice = false.obs;
  RxBool isCastingVideo = false.obs;
  RxBool isInitialized = false.obs;

  RxBool isLoading = false.obs;

  RxnString errorMessage = RxnString();
  String? videoURL;
  String? contentType;
  String? title;
  String? subtitle;
  String? thumbnailImage;
  String? releaseDate;
  GoogleCastDevice? device;

  // Ads
  List<AdConfig> preRollAds = [];
  List<AdConfig> midRollAds = [];
  List<AdConfig> postRollAds = [];

  Duration? duration;
  Duration? startPosition;

  Rx<Duration> currentCastPosition = Duration.zero.obs;
  StreamSubscription? _mediaStatusSubscription;

  @override
  void onInit() {
    super.onInit();
    initPlatformState();

    // Listen to connection state changes
    connectionStream();
    _listenToMediaStatus();
  }

  void _listenToMediaStatus() {
    _mediaStatusSubscription = GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((event) {
      if (event != null) {
        // Dynamic access to avoid property errors if the field name is different in this plugin version
        final pos = (event as dynamic).streamPosition;
        if (pos != null) {
          currentCastPosition.value = Duration(milliseconds: (pos! * 1000).toInt());
        }
      }
    });
  }

  @override
  void onClose() {
    _mediaStatusSubscription?.cancel();
    super.onClose();
  }

  void setChromeCast({
    required String videoURL,
    String? contentType,
    String? title,
    String? subtitle,
    String? studio,
    String? thumbnailImage,
    String? releaseDate,
    required GoogleCastDevice device,
    Duration? duration,
    Duration? startPosition,
    List<AdConfig>? preRollAds,
    List<AdConfig>? midRollAds,
    List<AdConfig>? postRollAds,
  }) {
    this.videoURL = videoURL;
    this.contentType = contentType ?? 'video/mp4'; // Default to mp4 if not provided
    this.title = title.validate();
    this.subtitle = subtitle.validate();
    this.thumbnailImage = thumbnailImage.validate();
    this.device = device;
    this.releaseDate = releaseDate;
    this.releaseDate = releaseDate;
    this.duration = duration;
    this.startPosition = startPosition;

    this.preRollAds = preRollAds ?? [];
    this.midRollAds = midRollAds ?? [];
    this.postRollAds = postRollAds ?? [];

    log("🎬 Chrome Cast configured:");
    log("   Video URL: $videoURL");
    log("   Content Type: $contentType");
    log("   Title: $title");
    log("   Device: ${device.friendlyName}");
    log("   Ads: Pre=${this.preRollAds.length}, Mid=${this.midRollAds.length}, Post=${this.postRollAds.length}");
  }

  Future<void> initPlatformState() async {
    try {
      const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
      GoogleCastOptions? options;

      if (Platform.isIOS) {
        options = IOSGoogleCastOptions(GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId));
      } else if (Platform.isAndroid) {
        options = GoogleCastOptionsAndroid(appId: appId);
      }

      if (options != null) {
        await GoogleCastContext.instance.setSharedInstanceWithOptions(options);
        isInitialized(true);
        log("✅ Chrome Cast initialized successfully");
      } else {
        log("❌ Failed to create Chrome Cast options for platform");
      }
      // Check initial discovery state for iOS
      if (Platform.isIOS) {
        try {
          await GoogleCastDiscoveryManager.instance.isDiscoveryActiveForDeviceCategory(appId);
        } catch (e) {
          log('❌Error checking discovery state: $e');
        }
      }
    } catch (e) {
      log("❌ Error initializing Chrome Cast: $e");
      isInitialized(false);
    }
  }

  void connectionStream() {
    GoogleCastSessionManager.instance.currentSessionStream.listen(
      (event) {
        if (event?.connectionState == GoogleCastConnectState.connecting || event?.connectionState == GoogleCastConnectState.disconnecting) {
          isLoading.value = true;
        } else if (event?.connectionState == GoogleCastConnectState.connected) {
          isLoading.value = false;
          if (event?.device != null) {
            device = event!.device;
          }
        } else if (event?.connectionState == GoogleCastConnectState.disconnected) {
          isCastingVideo(false);
          isLoading.value = false;
        }
      },
    );
  }

  Future<void> stopDiscovery() async {
    try {
      await GoogleCastDiscoveryManager.instance.stopDiscovery();
      isSearchingForDevice(false);
      log("============== Stop discovery ===================");
    } catch (e) {
      log("❌ Error stopping discovery: $e");
    }
  }

  Future<void> startDiscovery() async {
    if (!isInitialized.value) {
      log("⚠️ Chrome Cast not initialized. Initializing now...");
      await initPlatformState();
    }

    try {
      await GoogleCastDiscoveryManager.instance.startDiscovery();
      isSearchingForDevice(true);
      Future.delayed(const Duration(seconds: 10), () => isSearchingForDevice(false));
    } catch (e) {
      log("❌ Error starting discovery: $e");
      isSearchingForDevice(false);
    }
  }

  Future<void> loadMedia() async {
    if (device == null) {
      log("❌ No device selected for casting");
      toast(locale.value.pleaseSelectACastingDeviceFirst);
      return;
    }

    if (videoURL == null || videoURL!.isEmpty) {
      log("❌ No video URL provided for casting");
      toast(locale.value.noVideoUrlAvailableForCasting);
      return;
    }

    if (contentType == null || contentType!.isEmpty) {
      log("❌ No content type provided for casting");
      toast(locale.value.contentTypeNotAvailableForCasting);
      return;
    }

    // Validate video URL format
    try {
      Uri.parse(videoURL!);
    } catch (e) {
      log("❌ Invalid video URL format: $videoURL");
      toast(locale.value.invalidVideoUrlFormat);
      return;
    }

    try {
      // Debug casting information
      debugCastingInfo();

      DateTime? parsedReleaseDate;
      if (releaseDate.validate().isNotEmpty) {
        try {
          parsedReleaseDate = DateTime.tryParse(releaseDate!);
          if (parsedReleaseDate == null) {
            log("⚠️ Failed to parse releaseDate: $releaseDate, using current date");
            parsedReleaseDate = DateTime.now();
          }
        } catch (e) {
          log("⚠️ Exception while parsing releaseDate: $e, using current date");
          parsedReleaseDate = DateTime.now();
        }
      } else {
        parsedReleaseDate = DateTime.now();
      }

      // Create metadata with proper null handling
      GoogleCastMovieMediaMetadata? metadata;
      try {
        metadata = GoogleCastMovieMediaMetadata(
          title: title?.isNotEmpty == true ? title : "Unknown Title",
          studio: APP_NAME,
          subtitle: subtitle?.isNotEmpty == true ? subtitle : "",
          releaseDate: parsedReleaseDate,
          images: thumbnailImage?.isNotEmpty == true ? [GoogleCastImage(url: Uri.parse(thumbnailImage!))] : [],
        );
        log("✅ Metadata created successfully");
      } catch (e) {
        log("⚠️ Error creating metadata: $e, using minimal metadata");
        metadata = GoogleCastMovieMediaMetadata(
          title: "Video",
          studio: "Unknown",
          subtitle: "",
          releaseDate: DateTime.now(),
          images: [],
        );
      }

      // Build Ads as Custom Data (since typed AdBreak classes are not available)
      Map<String, dynamic> customData = {};
      List<Map<String, dynamic>> breaks = [];

      void processAds(List<AdConfig> ads, {bool isPreRoll = false, bool isPostRoll = false}) {
        for (var i = 0; i < ads.length; i++) {
          var ad = ads[i];
          String clipId = "clip_${ad.hashCode}_${DateTime.now().millisecondsSinceEpoch}";
          String breakId = "break_${ad.hashCode}_${DateTime.now().millisecondsSinceEpoch}";

          var clip = {
            "id": clipId,
            "title": ad.adTitle ?? "Ad",
            "contentUrl": ad.url,
            "mimeType": "video/mp4",
            "duration": ad.durationSeconds,
            "clickThroughUrl": ad.primaryClickUrl,
          };

          int position = 0;
          if (isPreRoll) {
            position = 0;
          } else if (isPostRoll) {
            position = (duration != null) ? duration!.inSeconds : -1;
          } else {
            if (ad.startAtSeconds != null) {
              position = ad.startAtSeconds!;
            } else {
              continue;
            }
          }

          breaks.add({
            "id": breakId,
            "position": position,
            "clips": [clip],
          });
        }
      }

      processAds(preRollAds, isPreRoll: true);
      processAds(midRollAds);
      // Post-rolls support if duration is set
      if (duration != null || postRollAds.isNotEmpty) {
        processAds(postRollAds, isPostRoll: true);
      }

      if (breaks.isNotEmpty) {
        customData['adBreaks'] = breaks;
        log("✅ Added ${breaks.length} ad breaks to customData");
      }

      // Try to create media with metadata first, fallback to basic if needed
      GoogleCastMediaInformation media;
      try {
        media = GoogleCastMediaInformation(
          contentId: videoURL!,
          contentUrl: Uri.parse(videoURL!),
          streamType: CastMediaStreamType.buffered,
          contentType: _getMimeType(),
          metadata: metadata,
          duration: duration ?? Duration.zero,
          customData: customData, // Try passing ads via customData
        );
        log("✅ Media information created with metadata & ads");
      } catch (e) {
        log("⚠️ Error creating media with metadata: $e, using basic media info");
        media = createBasicMediaInfo();
      }

      log('🎬 Casting media with metadata: ${metadata.title}');

      try {
        log("🎬 Attempting to load media...");
        await GoogleCastRemoteMediaClient.instance.loadMedia(
          media,
        );

        // Seek to start position if needed
        if (startPosition != null && startPosition!.inSeconds > 0) {
          // Give a short delay for media to initialize
          await Future.delayed(const Duration(milliseconds: 500));
          try {
            await GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: Duration(seconds: startPosition!.inSeconds)));
            log("✅ Seeked to ${startPosition!.inSeconds}s");
          } catch (e) {
            log("⚠️ Seek error: $e");
          }
        }

        log("✅ Media loaded successfully");
      } catch (e) {
        log("❌ Error loading media: $e, trying with minimal parameters");
      }

      isCastingVideo(true);
      log("✅ Casting started successfully");
    } catch (e) {
      log("❌ Error during casting: $e");
      isCastingVideo(false);
      rethrow;
    }
  }

  Future<void> endSession() async {
    try {
      await GoogleCastSessionManager.instance.endSession();
      isCastingVideo(false);
      log("✅ Cast session ended");
    } catch (e) {
      log("❌ Error ending session: $e");
    }
  }

  Future<void> stopCasting() async {
    try {
      await GoogleCastRemoteMediaClient.instance.stop();
      isCastingVideo(false);
      log("✅ Cast media stopped");
    } catch (e) {
      log("❌ Error stopping media: $e");
    }
  }

  void debugCastingInfo() {
    log("🔍 === Casting Debug Info ===");
    log("Video URL: $videoURL");
    log("Content Type: $contentType");
    log("Title: $title");
    log("Subtitle: $subtitle");
    log("Thumbnail: $thumbnailImage");
    log("Release Date: $releaseDate");
    log("Device: ${device?.friendlyName ?? 'None'}");
    log("Connection State: ${GoogleCastSessionManager.instance.connectionState}");
    log("=============================");
  }

  GoogleCastMediaInformation createBasicMediaInfo() {
    return GoogleCastMediaInformation(
      contentId: videoURL!,
      contentUrl: Uri.parse(videoURL!),
      streamType: CastMediaStreamType.buffered,
      contentType: _getMimeType(),
    );
  }

  String _getMimeType() {
    if (contentType == 'hls' || videoURL?.contains('.m3u8') == true) {
      return 'application/x-mpegurl';
    }
    if (contentType == 'video/mp4' || videoURL?.endsWith('.mp4') == true) {
      return 'video/mp4';
    }
    if (contentType != null && contentType!.contains('/')) {
      return contentType!;
    }
    return 'video/mp4';
  }

  Future<void> handleConnect(bool isConnected) async {
    if (isLoading.value) return;
    isLoading(true);
    errorMessage.value = null;
    try {
      if (isConnected) {
        await GoogleCastSessionManager.instance.endSessionAndStopCasting();
        isLoading.value = false;
      } else {
        if (device == null) {
          return;
        }
        // Configure cast with video information if available
        if (videoURL != null && videoURL!.isNotEmpty) {
          setChromeCast(
            videoURL: videoURL.validate(),
            contentType: contentType,
            title: title,
            subtitle: subtitle,
            thumbnailImage: thumbnailImage,
            releaseDate: releaseDate,
            device: device!,
            preRollAds: preRollAds,
            midRollAds: midRollAds,
            postRollAds: postRollAds,
            startPosition: startPosition,
          );
        }
        await GoogleCastSessionManager.instance.startSessionWithDevice(device!);
        isLoading.value = false;
      }
    } catch (e) {
      log('Connecting Issue $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handlePlay() async {
    if (isLoading.value) return;
    isLoading(true);
    errorMessage.value = null;
    try {
      await loadMedia();
    } catch (e) {
      log("Failed to play media: $e");
    } finally {
      isLoading.value = false;
    }
  }
}