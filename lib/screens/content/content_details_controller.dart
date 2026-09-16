import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart' show Assets;
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_content_model.dart';
import 'package:streamit_laravel/services/download_control_service.dart';
import 'package:streamit_laravel/services/download_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/cast/controller/fc_cast_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_controller.dart';

class ContentDetailsController extends BaseController<ContentModel> {
  UniqueKey uniqueTrailerKey = UniqueKey();

  //region Futures

  RxList<PosterDataModel> episodeList = RxList();

  //endregion

  //region RxVariables
  RxInt episodePage = 1.obs;

  Rx<DownloadQualities> selectedDownloadQuality = DownloadQualities().obs;
  RxInt currentEpisodeIndex = (-1).obs;
  RxBool showTrailer = false.obs;
  RxBool showShimmer = false.obs;
  RxBool showEpisodeListShimmer = false.obs;

  Rx<VideoData> currentTrailerData = VideoData().obs;

  RxBool isEditReview = false.obs;

  //region Downloads
  RxDouble downloadProgress = 0.0.obs;
  RxBool isDownloaded = false.obs;
  RxInt currentDownloadingEpisodeId = (-1).obs;
  Rx<DownloadControlState> downloadControlState = DownloadControlState.none.obs;
  RxInt _routeChangeTrigger = 0.obs; // Trigger for route changes

  // Multiple Episode Tracking
  RxMap<int, DownloadControlState> episodeStates =
      <int, DownloadControlState>{}.obs;
  RxMap<int, double> episodeProgress = <int, double>{}.obs;
  RxSet<int> activeDownloads = <int>{}.obs;

  //endregion

  int? _registeredDownloadContentId;
  final Map<int, int?> _registeredEpisodeCallbacks = {};
  final Map<int, String> _downloadUrlCache = {};

  // Review Text Controller
  TextEditingController userReviewCont = TextEditingController();
  RxDouble userRating = 0.0.obs;

  // Track download progress dialog state
  RxSet<int> downloadedEpisodeIds = <int>{}.obs;

  //region RxObjects

  Rx<SeasonData> selectedSeason = SeasonData().obs;

  Rx<PosterDataModel> selectedEpisode =
      PosterDataModel(details: ContentData()).obs;

  //endregion

  //region objects
  PosterDataModel argumentData = PosterDataModel(details: ContentData());

  //endregion

  //endregion
  @override
  void onInit() {
    initScrollListener();
    init();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh download status when screen becomes visible
    refreshDownloadStatus();

    // Use GetX worker to listen for route change triggers
    // This will trigger when navigating back to this screen
    ever(_routeChangeTrigger, (_) {
      if (hasContent) {
        refreshDownloadStatus();
      }
    });
  }

  // Method to trigger route change refresh (call this when navigating back)
  void triggerRouteChangeRefresh() {
    _routeChangeTrigger.value++;
  }

  Future<void> init() async {
    if (Get.arguments is PosterDataModel) {
      argumentData = Get.arguments as PosterDataModel;
      update([argumentData]);
      await getContentData(showLoader: false);
    } else if (Get.arguments is ContentData) {
      argumentData = PosterDataModel(details: (Get.arguments as ContentData));
      update([argumentData]);
      await getContentData(showLoader: false);
    }
  }

  Future<void> getContentData({
    bool showLoader = true,
    int? entertainmentId,
    String? entertainmentType,
    VoidCallback? onContentUpdated,
    bool starTrailer = true,
  }) async {
    if (argumentData.id < 0) return;
    showShimmer(!showLoader);
    await getContent(
      showLoader: showLoader,
      contentApiCall: () => CoreServiceApis.getContentDetails(
        contentId: entertainmentId ?? argumentData.entertainmentId,
        type: entertainmentType ?? argumentData.entertainmentType,
      ),
      onSuccess: (data) async {
        content(data);
        if (content.value!.details.isSeasonAvailable) {
          if (argumentData.isSeason &&
              data.details.seasonList
                  .any((element) => element.id == argumentData.id)) {
            setSeasonData(data.details.seasonList
                .firstWhere((element) => element.id == argumentData.id));
          } else {
            setSeasonData(data.details.seasonList.first);
          }
        }
        if (starTrailer &&
            content.value!.isTrailerAvailable &&
            !content.value!.isVideo) {
          await updateTrailerData(content.value!.trailerData.first);
        }
        updateDownloadState(content.value!.id);

        // Update Cast Details
        if (Get.isRegistered<FCCast>()) {
          final castController = Get.find<FCCast>();
          if (castController.device != null &&
              castController.isInitialized.value) {
            castController.setChromeCast(
              videoURL:
                  content.value!.isTrailerAvailable && !content.value!.isVideo
                      ? ""
                      : content.value!.defaultQuality.url,
              // Handle trailer logic properly if needed, usually we cast movie/episode
              contentType: "video/mp4",
              title: content.value!.details.name,
              thumbnailImage: content.value!.details.thumbnailImage,
              releaseDate: content.value!.details.releaseDate,
              device: castController.device!,
            );
          }
        }

        onContentUpdated?.call();
      },
    ).whenComplete(() => showShimmer(false));
  }

  //endregion

  void playNextEpisode(PosterDataModel episode,
      {VoidCallback? onEpisodeDataUpdated}) {
    doIfLogin(
      onLoggedIn: () async {
        final episodeIndex =
            episodeList.indexWhere((element) => element.id == episode.id);
        if (currentEpisodeIndex.value == episodeIndex) return;
        selectedEpisode(episode);

        if (episodeIndex >= 0) {
          currentEpisodeIndex(episodeIndex);
        } else if (episodeList.isNotEmpty) {
          currentEpisodeIndex(0);
        } else {
          currentEpisodeIndex(0);
        }
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        await getEpisodeContentData(
            episodeData: episode, onEpisodeDataUpdated: onEpisodeDataUpdated);
      },
    );
  }

  Future<void> getEpisodeContentData(
      {bool showLoader = true,
      required PosterDataModel episodeData,
      VoidCallback? onEpisodeDataUpdated}) async {
    if (argumentData.details.entertainmentId < 0) return;
    if (isLoading.value) return;
    setLoading(showLoader);

    await getContentData(
      entertainmentId: episodeData.id,
      entertainmentType: episodeData.details.type,
      onContentUpdated: onEpisodeDataUpdated,
    );
  }

  GlobalKey viewShowLessKey = GlobalKey();

  void onPreviousEpisode() {
    if (episodePage.value > 1) {
      episodePage.value--;
    } else {
      episodePage.value = 1;
    }

    // Keep only the first 5 episodes
    if (episodeList.length > Constants.episodePerPage) {
      episodeList.value = episodeList.sublist(
          0,
          episodePage.value > 1
              ? episodePage.value * Constants.episodePerPage
              : Constants.episodePerPage);
    }
    isLastPage(false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewShowLessKey.currentContext != null) {
        Scrollable.ensureVisible(
          viewShowLessKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: 1.0,
        );
      }
    });
  }

  void handleNextEpisode() async {
    if (!isLastPage.value) {
      episodePage.value++;
      await getTvShowEpisodes();
    }
  }

  Future<void> getTvShowEpisodes({bool showInitialLoader = true}) async {
    showEpisodeListShimmer(showInitialLoader || episodePage.value > 1);

    CoreServiceApis.getEpisodesList(
      page: episodePage.value,
      showId: selectedSeason.value.id,
      seasonId: selectedSeason.value.seasonId,
      episodeList: episodeList,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    ).then(
      (value) {
        if (episodeList.isNotEmpty) {
          try {
            for (var episode in episodeList) {
              final existing = hiveService.contentBox.get(episode.id);
              if (existing != null && existing.isDownloaded) {
                downloadedEpisodeIds.add(episode.id);
              }
              // Check for active downloads and restore state
              _syncEpisodeDownloadState(episode.id);
            }
          } catch (e) {
            debugPrint('Error checking download status: $e');
          }

          if (content.value!.isEpisode) {
            currentEpisodeIndex(episodeList
                .indexWhere((element) => element.id == content.value!.id));
          }
        }
      },
    ).catchError((e) {
      throw e;
    }).whenComplete(() {
      showEpisodeListShimmer(false);
      setLoading(false);
    });
  }

  void setSeasonData(SeasonData newSeason) {
    episodePage(1);
    selectedSeason(newSeason);
    episodeList.clear();
    episodeList.refresh();
    if (selectedSeason.value.totalEpisode > 0) {
      getTvShowEpisodes(showInitialLoader: true);
    } else {
      showEpisodeListShimmer(false);
    }
  }

  Future<void> updateTrailerData(VideoData newVideoData) async {
    setLoading(true);

    /// ---- 1️⃣ Toggle visibility to force widget disposal ----
    showTrailer(false);

    // Slight delay to allow UI to rebuild and dispose the old widget/controller
    await Future.delayed(const Duration(milliseconds: 100));

    /// ---- 2️⃣ Generate new Key & Assign Data ----
    uniqueTrailerKey = UniqueKey();
    currentTrailerData.value = newVideoData;

    /// ---- 3️⃣ Show new trailer ----
    showTrailer(true);
    setLoading(false);
  }

  void removeTrailerControllerIfAlreadyExist(int id) {
    if (id != 0) {
      final String tag = '$id';
      if (Get.isRegistered<TrailerController>(tag: tag)) {
        Get.delete<TrailerController>(tag: tag);
      }
    }
    showTrailer(false);
    currentTrailerData(VideoData());
  }

  bool get isDefaultTrailerPlaying {
    if (content.value == null ||
        !content.value!.isTrailerAvailable ||
        currentTrailerData.value.id == 0) {
      return false;
    }
    final trailerData = content.value!.trailerData;
    return trailerData.isNotEmpty &&
        trailerData.first.id == currentTrailerData.value.id;
  }

  //region Content Details Update

  //region LikeContent
  bool isLikeLoading = false;

  Future<void> likeContent(BuildContext context, int id) async {
    if (isLikeLoading) return;
    isLikeLoading = true;
    content.value?.details.isLiked =
        content.value!.details.isLiked.getBoolInt() ? 0 : 1;
    content.refresh();
    successSnackBar(
      content.value!.details.isLiked.getBoolInt()
          ? locale.value.likedSuccessfully
          : locale.value.unlikedSuccessfully,
      icon: content.value!.details.isLiked.getBoolInt()
          ? Container(
              padding: const EdgeInsets.all(5),
              decoration: boxDecorationDefault(
                color: appColorPrimary,
                borderRadius: radius(50),
              ),
              child: IconWidget(
                imgPath: Assets.iconsCheck,
                size: 12,
              ),
            )
          : null,
    );
    await CoreServiceApis.likeContent(
      request: {
        ApiRequestKeys.entertainmentIdKey: id,
        ApiRequestKeys.isLikeKey: content.value!.details.isLiked,
        ApiRequestKeys.typeKey: content.value?.details.type,
        if (selectedAccountProfile.value.id != 0)
          ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
      },
    ).then((value) async {}).catchError((e) {
      content.value?.details.isLiked =
          content.value!.details.isLiked.getBoolInt() ? 0 : 1;
      content.refresh();
    }).whenComplete(() {
      isLikeLoading = false;
    });
  }

  //endregion

  //region WatchListContent

  bool isWatchListLoading = false;

  Future<void> watchListContent(BuildContext context, int id) async {
    if (isWatchListLoading) return;
    isWatchListLoading = true;

    if (!content.value!.details.isInWatchList.getBoolInt()) {
      content.value!.details.isInWatchList = 1;
      content.refresh();
      successSnackBar(
        locale.value.addedToWatchList,
        icon: Container(
          padding: const EdgeInsets.all(5),
          decoration: boxDecorationDefault(
            color: appColorPrimary,
            borderRadius: radius(50),
          ),
          child: IconWidget(
            imgPath: Assets.iconsCheck,
            size: 12,
          ),
        ),
      );
      await CoreServiceApis.saveWatchList(
        request: {
          ApiRequestKeys.entertainmentIdKey: id,
          if (selectedAccountProfile.value.id != 0)
            ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
          if (selectedAccountProfile.value.id != 0)
            ApiRequestKeys.userIdKey: loginUserData.value.id,
          ApiRequestKeys.typeKey: content.value?.details.type,
        },
      ).then((value) async {}).catchError((e) {
        content.value!.details.isInWatchList = 0;
        content.refresh();
      }).whenComplete(() {
        isWatchListLoading = false;
      });
    } else {
      content.value!.details.isInWatchList = 0;
      content.refresh();
      successSnackBar(locale.value.removedFromWatchList);
      await CoreServiceApis.deleteFromWatchlist(
        request: {
          ApiRequestKeys.isAjaxKey: 1,
          ApiRequestKeys.idKey: id,
          if (selectedAccountProfile.value.id != 0)
            ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
          if (selectedAccountProfile.value.id != 0)
            ApiRequestKeys.userIdKey: loginUserData.value.id,
          ApiRequestKeys.typeKey: content.value?.details.type,
        },
      ).then((value) async {}).catchError((e) {
        content.value!.details.isInWatchList = 1;
        content.refresh();
      }).whenComplete(() {
        isWatchListLoading = false;
      });
    }
  }

  //endregion

  //region Review Logic

  Future<void> saveReview() async {
    if (content.value == null) return;
    if (userRating.value <= 0) {
      toast(locale.value.pleaseSelectRating);
      return;
    }

    // Prepare locally
    int reviewId = content.value!.reviews?.myReview?.id ?? -1;
    bool isNew = reviewId <= 0;

    // Optimistic UI Update or Wait for API? User said "manage local object" and "no need to call getContent".
    // I will call API then update local object.

    setLoading(true);

    Map<String, dynamic> req = {
      ApiRequestKeys.entertainmentIdKey: content.value!.id,
      ApiRequestKeys.ratingKey: userRating.value,
      ApiRequestKeys.reviewKey: userReviewCont.text.trim(),
      if (!isNew) ApiRequestKeys.idKey: reviewId,
    };

    await CoreServiceApis.addRating(request: req).then((value) {
      // Success
      successSnackBar(value.message);
      getContentData(showLoader: true, starTrailer: false);
      isEditReview(false);
      if (Get.isBottomSheetOpen == true) Get.back(); // Close dialog
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => setLoading(false));
  }

  Future<void> deleteReview() async {
    if (content.value?.reviews?.myReview == null) return;
    int reviewId = content.value!.reviews!.myReview!.id;
    if (reviewId <= 0) return;

    setLoading(true);

    await CoreServiceApis.deleteRating(
        request: {ApiRequestKeys.idKey: reviewId}).then((value) {
      successSnackBar(value.message);

      content.update((val) {
        if (val != null) {
          val.reviews?.totalReviews = (val.reviews?.totalReviews ?? 0) - 1;
          val.reviews?.myReview = null;
        }
      });
      // Clear inputs
      userReviewCont.clear();
      userRating(0.0);
    }).catchError((e) {
      errorSnackBar(error: e);
    }).whenComplete(() => setLoading(false));
  }

  void openReviewDialog() {
    if (content.value?.reviews?.myReview != null) {
      userReviewCont.text = content.value!.reviews!.myReview!.review;
      userRating(content.value!.reviews!.myReview!.rating.toDouble());
    } else {
      userReviewCont.clear();
      userRating(0.0);
    }
  }

  //endregion

  //region Download helpers

  Future<void> downloadContent(
      int id, ContentModel? contentModel, int? episodeId) async {
    try {
      // Respect Wi-Fi only downloads setting
      if (appDownloadOnWifi.value) {
        final List<ConnectivityResult> connectivity =
            await Connectivity().checkConnectivity();
        final bool isOnWifi = connectivity.contains(ConnectivityResult.wifi);
        if (!isOnWifi) {
          toast(locale.value.downloadsAllowedOnWifiOnly);
          return;
        }
      }

      final contentModelToUse = contentModel ?? content.value;
      if (contentModelToUse == null) return;

      if (selectedDownloadQuality.value.url.isEmpty) {
        toast(locale.value.thisContentIsNotDownloadable);
        return;
      }

      downloadControlState(DownloadControlState.inProgress);
      _downloadUrlCache[id] = selectedDownloadQuality.value.url;
      downloadProgress(0.0);

      // Track which episode/content is downloading for UI percentage
      if (episodeId != null) {
        currentDownloadingEpisodeId(episodeId);
        activeDownloads.add(episodeId);
        episodeStates[episodeId] = DownloadControlState.inProgress;
        episodeProgress[episodeId] = 0.0;
        _registerEpisodeDownloadCallback(episodeId);
      } else {
        currentDownloadingEpisodeId(-1);
        _registerDownloadCallback(id);
      }

      // Wrap content in data key to match parser expectations in download-controller
      final HiveContentModel hiveItem =
          _buildHiveItem(id: id, model: contentModelToUse);
      final service = DownloadService.instance;

      await service.startDownload(
        item: hiveItem,
        url: selectedDownloadQuality.value.url,
        // onProgress is handled by _registerDownloadCallback / _registerEpisodeDownloadCallback
        onProgress: null,
      );

      // No need to wait for completion here as startDownload is now non-blocking for the full download
      // and success/progress is handled by the registered callbacks.
    } catch (e) {
      // Check if this was a pause (cancellation)
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Don't reset state, don't show toast
        return;
      }

      // For real errors, only reset if not already paused or cancelled
      if (downloadControlState.value == DownloadControlState.inProgress) {
        downloadControlState(DownloadControlState.none);
        toast(locale.value.failedToStartDownload);
      }
    }
  }

  HiveContentModel _buildHiveItem(
      {required int id, required ContentModel model}) {
    return HiveContentModel(
      id: id,
      thumbnailImage: model.details.thumbnailImage,
      contentData: jsonEncode(model.toContentJson()),
      profileId: selectedAccountProfile.value.id,
    );
  }

  Future<void> pauseActiveDownload() async {
    final contentId = content.value?.id;
    if (contentId == null) return;

    final url = _downloadUrlCache[contentId];
    if (url == null || url.isEmpty) return;

    // Set state BEFORE pausing to prevent race condition
    downloadControlState(DownloadControlState.paused);

    await DownloadControlService.instance.pauseContent(
      contentId: contentId,
      url: url,
      currentProgress: downloadProgress.value,
    );
  }

  Future<void> resumePausedDownload() async {
    final contentId = content.value?.id;
    final model = content.value;
    if (contentId == null || model == null) return;

    final url = _downloadUrlCache[contentId];
    if (url == null || url.isEmpty) return;

    downloadControlState(DownloadControlState.inProgress);
    final hiveItem = _buildHiveItem(id: contentId, model: model);

    try {
      await DownloadControlService.instance.resumeContent(
        item: hiveItem,
        url: url,
        onProgress: null,
      );
    } catch (e) {
      // If paused again during resume
      if (e is DioException && e.type == DioExceptionType.cancel) {
        debugPrint('Resume was paused/cancelled by user');
        return; // Don't show any toast
      }

      // Fallback: if resume fails (e.g., server does not support range), restart download fresh
      final resumed =
          await restartDownloadFromScratch(hiveItem: hiveItem, url: url);
      if (!resumed) {
        downloadControlState(DownloadControlState.paused);
        toast(locale.value.failedToResumeDownload);
      }
    }
  }

  Future<bool> restartDownloadFromScratch({
    required HiveContentModel hiveItem,
    required String url,
  }) async {
    try {
      downloadControlState(DownloadControlState.inProgress);
      downloadProgress(0.0);

      await DownloadService.instance.startDownload(
        item: hiveItem,
        url: url,
        onProgress: null,
      );

      return true;
    } catch (e) {
      // If cancelled during restart
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return false;
      }
      return false;
    }
  }

  Future<void> cancelActiveDownload() async {
    final contentId = content.value?.id;
    if (contentId == null) return;

    // Unregister callbacks FIRST to prevent them from firing
    _unregisterDownloadCallback();

    // Unregister any episode callbacks
    for (final episodeId in _registeredEpisodeCallbacks.keys.toList()) {
      _unregisterEpisodeDownloadCallback(episodeId);
    }

    // Set state and reset flags BEFORE cancelling
    downloadControlState(DownloadControlState.none);
    isDownloaded(false);
    downloadProgress(0.0);
    currentDownloadingEpisodeId(-1);
    String url = _downloadUrlCache[contentId] ?? '';
    String ext = '.mp4';
    try {
      ext = extension(url);
      if (ext.isEmpty) {
        ext = '.mp4';
      }
    } catch (e) {}

    // Remove from cache
    _downloadUrlCache.remove(contentId);

    // Now cancel the download
    await DownloadControlService.instance
        .cancelContent(contentId: contentId, ext: ext);

    // Small delay to ensure everything is cleaned up
    await Future.delayed(const Duration(milliseconds: 100));

    // Show single success message
    successSnackBar(locale.value.downloadCancelled);
  }

  Future<void> pauseEpisodeDownload(int episodeId) async {
    final url = _downloadUrlCache[episodeId];
    if (url == null || url.isEmpty) return;

    downloadControlState(DownloadControlState.paused);
    currentDownloadingEpisodeId(episodeId);

    // Update individual state
    activeDownloads.add(episodeId);
    episodeStates[episodeId] = DownloadControlState.paused;

    await DownloadControlService.instance.pauseContent(
      contentId: episodeId,
      url: url,
      currentProgress: episodeProgress[episodeId] ?? downloadProgress.value,
    );
  }

  Future<void> resumePausedEpisodeDownload(int episodeId) async {
    final url = _downloadUrlCache[episodeId];
    if (url == null || url.isEmpty) return;

    downloadControlState(DownloadControlState.inProgress);
    currentDownloadingEpisodeId(episodeId);

    // Update individual state
    activeDownloads.add(episodeId);
    episodeStates[episodeId] = DownloadControlState.inProgress;

    HiveContentModel? hiveItem;
    try {
      hiveItem = hiveService.contentBox.get(episodeId);
    } catch (_) {
      hiveItem = null;
    }

    if (hiveItem == null) {
      PosterDataModel? episodeData;
      try {
        episodeData =
            episodeList.firstWhere((element) => element.id == episodeId);
      } catch (_) {
        episodeData = null;
      }

      if (episodeData != null) {
        final downloadData = episodeData.downloadData;
        if (downloadData == null) return;

        final contentModel = ContentModel(
          id: episodeData.id,
          details: episodeData.details,
          downloadData: downloadData,
          trailerData: episodeData.trailerData,
        );
        hiveItem = _buildHiveItem(id: episodeId, model: contentModel);
      }
    }

    if (hiveItem == null) return;

    try {
      await DownloadControlService.instance.resumeContent(
        item: hiveItem,
        url: url,
        onProgress: null,
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return;
      }

      final resumed =
          await restartDownloadFromScratch(hiveItem: hiveItem, url: url);
      if (!resumed) {
        downloadControlState(DownloadControlState.paused);
        toast(locale.value.failedToResumeDownload);
      }
    }
  }

  Future<void> cancelEpisodeDownload(int episodeId) async {
    bool pendingCancel = false;
    _unregisterEpisodeDownloadCallback(episodeId);
    String url = _downloadUrlCache[episodeId] ?? '';
    String ext = '.mp4';
    try {
      ext = extension(url);
      if (ext.isEmpty) {
        ext = '.mp4';
      }
    } catch (e) {}

    _downloadUrlCache.remove(episodeId);
    downloadedEpisodeIds.remove(episodeId);

    if (currentDownloadingEpisodeId.value == episodeId) {
      currentDownloadingEpisodeId(-1);
      downloadProgress(0.0);
    }

    pendingCancel = true;
    activeDownloads.remove(episodeId);
    episodeStates[episodeId] = DownloadControlState.none;
    episodeProgress.remove(episodeId);

    downloadControlState(DownloadControlState.none);

    await DownloadControlService.instance
        .cancelContent(contentId: episodeId, ext: ext);

    await Future.delayed(const Duration(milliseconds: 100));

    if (pendingCancel) {
      // Double check removal
      activeDownloads.remove(episodeId);
    }

    successSnackBar(locale.value.downloadCancelled);
    episodeList.refresh();
  }

  void _checkIfDownloaded(int id) {
    try {
      final existing = hiveService.contentBox.get(id);
      final isActuallyDownloaded = existing != null && existing.isDownloaded;
      isDownloaded(isActuallyDownloaded);
      // If content was deleted, make sure state is cleared
      if (!isActuallyDownloaded && isDownloaded.value) {
        isDownloaded(false);
      }
    } catch (_) {
      isDownloaded(false);
    }
  }

  void updateDownloadState(int contentId) {
    final service = DownloadService.instance;
    final control = DownloadControlService.instance;
    final bool downloading = service.isDownloading(contentId);

    if (downloading) {
      downloadControlState(DownloadControlState.inProgress);
      final existingProgress = service.getDownloadProgress(contentId);
      if (existingProgress != null) {
        downloadProgress(existingProgress);
        isDownloaded(existingProgress >= 100);
      } else {
        // Assume in-progress if no progress yet
        downloadProgress(1);
        isDownloaded(false);
      }
      _registerDownloadCallback(contentId);
    } else if (control.isPaused(contentId)) {
      downloadControlState(DownloadControlState.paused);
    } else {
      downloadProgress(0.0);
      _checkIfDownloaded(contentId);
      downloadControlState(DownloadControlState.none);
    }
  }

  void _registerDownloadCallback(int contentId) {
    _registeredDownloadContentId = contentId;
    DownloadService.instance.registerProgressCallback(contentId, (progress) {
      // Ignore callbacks if state is none (cancelled)
      if (downloadControlState.value == DownloadControlState.none) {
        debugPrint('Ignoring progress callback, download was cancelled');
        return;
      }

      downloadControlState(DownloadControlState.inProgress);
      downloadProgress(progress);

      if (progress >= 100) {
        // Check if paused or cancelled before marking as complete
        if (downloadControlState.value == DownloadControlState.paused) {
          debugPrint(
              'Download reached 100% but is paused, skipping completion');
          return;
        }

        if (downloadControlState.value == DownloadControlState.none) {
          debugPrint(
              'Download reached 100% but was cancelled, skipping completion');
          return;
        }

        isDownloaded(true);
        downloadControlState(DownloadControlState.none);
        successSnackBar(locale.value.downloadCompleted);
      }
    });
  }

  void _unregisterDownloadCallback() {
    if (_registeredDownloadContentId != null) {
      DownloadService.instance
          .unregisterProgressCallback(_registeredDownloadContentId!);
      _registeredDownloadContentId = null;
    }
  }

  void _syncEpisodeDownloadState(int episodeId) {
    final service = DownloadService.instance;
    final bool downloading = service.isDownloading(episodeId);

    if (downloading) {
      final existingProgress = service.getDownloadProgress(episodeId);
      if (existingProgress != null) {
        // If this is the currently downloading episode, update progress
        if (currentDownloadingEpisodeId.value == episodeId) {
          downloadProgress(existingProgress);
        }

        // Register callback to receive updates
        _registerEpisodeDownloadCallback(episodeId);

        // Set as currently downloading if not already set
        if (currentDownloadingEpisodeId.value == -1) {
          currentDownloadingEpisodeId(episodeId);
        }

        // Update new map tracking
        activeDownloads.add(episodeId);
        episodeStates[episodeId] = DownloadControlState.inProgress;
        episodeProgress[episodeId] = existingProgress;
      } else {
        // Assume in-progress if no progress yet
        double initialProgress = 1;
        if (currentDownloadingEpisodeId.value == episodeId) {
          downloadProgress(initialProgress);
        }
        _registerEpisodeDownloadCallback(episodeId);
        if (currentDownloadingEpisodeId.value == -1) {
          currentDownloadingEpisodeId(episodeId);
        }

        activeDownloads.add(episodeId);
        episodeStates[episodeId] = DownloadControlState.inProgress;
        episodeProgress[episodeId] = initialProgress;
      }
    } else if (DownloadControlService.instance.isPaused(episodeId)) {
      activeDownloads.add(episodeId);
      episodeStates[episodeId] = DownloadControlState.paused;
      final snapshot =
          DownloadControlService.instance.getPauseSnapshot(episodeId);
      if (snapshot != null &&
          snapshot.totalBytes != null &&
          snapshot.totalBytes! > 0) {
        episodeProgress[episodeId] =
            (snapshot.downloadedBytes / snapshot.totalBytes!) * 100;
      }
    } else {
      // Check if downloaded - verify it actually exists
      try {
        final existing = hiveService.contentBox.get(episodeId);
        final isActuallyDownloaded = existing != null && existing.isDownloaded;
        if (isActuallyDownloaded) {
          downloadedEpisodeIds.add(episodeId);
        } else {
          // If content was deleted, remove from downloaded list
          downloadedEpisodeIds.remove(episodeId);
        }
      } catch (_) {
        // If error checking, assume not downloaded
        downloadedEpisodeIds.remove(episodeId);
      }
    }
  }

  void _registerEpisodeDownloadCallback(int episodeId) {
    if (_registeredEpisodeCallbacks.containsKey(episodeId))
      return; // Already registered

    _registeredEpisodeCallbacks[episodeId] = episodeId;
    DownloadService.instance.registerProgressCallback(episodeId, (progress) {
      // Ignore callbacks if state is none (cancelled)
      if (downloadControlState.value == DownloadControlState.none) {
        // Don't return here IF we want to support background downloads even if main state is none?
        // But main state 'none' usually implies screen close or something?
        // Actually, if we are tracking multiple, 'downloadControlState' (global) might be irrelevant for this episode
        // EXCEPT if the user cancelled everything.
        // Let's assume we proceed.
      }

      // Update individual progress
      episodeProgress[episodeId] = progress;
      activeDownloads.add(episodeId);
      episodeStates[episodeId] = DownloadControlState.inProgress;

      // Only update if this is the currently tracked episode for the global loader
      if (currentDownloadingEpisodeId.value == episodeId) {
        downloadProgress(progress);
      }

      if (progress >= 100) {
        // Check if paused or cancelled before marking as complete
        // Global state check might be misleading for individual episodes.
        // We should check the individual state if we had it fine-grained.
        // But for now, let's assume if we got 100% and it wasn't paused, we are good.

        if (episodeStates[episodeId] == DownloadControlState.paused) {
          return;
        }

        downloadedEpisodeIds.add(episodeId);

        // Loop cleanup
        activeDownloads.remove(episodeId);
        episodeStates[episodeId] = DownloadControlState.none;
        episodeProgress.remove(episodeId);
        _unregisterEpisodeDownloadCallback(episodeId);

        // Reset global if matched
        if (currentDownloadingEpisodeId.value == episodeId) {
          currentDownloadingEpisodeId(-1);
          successSnackBar(locale.value.downloadCompleted);
        }

        episodeList.refresh();
      }
    });
  }

  void _unregisterEpisodeDownloadCallback(int episodeId) {
    if (_registeredEpisodeCallbacks.containsKey(episodeId)) {
      DownloadService.instance.unregisterProgressCallback(episodeId);
      _registeredEpisodeCallbacks.remove(episodeId);
    }
  }

  @override
  Future<void> onSwipeRefresh() async {
    await super.onSwipeRefresh();
    // Also refresh download status when swiping to refresh
    refreshDownloadStatus();
  }

  void refreshDownloadStatus() {
    if (content.value != null) {
      // Refresh main content download status
      updateDownloadState(content.value!.id);

      // Refresh all episode download statuses
      if (episodeList.isNotEmpty) {
        for (var episode in episodeList) {
          _syncEpisodeDownloadState(episode.id);
        }
        episodeList.refresh();
      }
    }
  }

//endregion

  @override
  Future<void> onClose() async {
    if (Get.isRegistered<FCCast>()) {
      Get.find<FCCast>().stopCasting();
    }
    _unregisterDownloadCallback();
    // Unregister all episode callbacks
    for (final episodeId in _registeredEpisodeCallbacks.keys.toList()) {
      _unregisterEpisodeDownloadCallback(episodeId);
    }

    removeTrailerControllerIfAlreadyExist(currentTrailerData.value.id);
    super.onClose();
  }
}
