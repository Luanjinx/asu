import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_controller.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/video_players/trailer/trailer_controller.dart';

import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../../utils/common_functions.dart';

class ComingSoonDetailsController extends BaseController {
  Rx<ContentModel?> contentDetail = Rx<ContentModel?>(null);

  // Trailer state management
  RxBool showTrailer = false.obs;
  Rx<VideoData> currentTrailerData = VideoData().obs;
  UniqueKey uniqueTrailerKey = UniqueKey();

  RxMap<int, bool> loadingRemindItems = <int, bool>{}.obs;
  RxMap<int, bool> loadingWatchlistItems = <int, bool>{}.obs;

  RxBool isReminderMe = false.obs; // Moved local state if needed

  ScrollController scrollController = ScrollController();

  // We need the initial data
  late ComingSoonModel incomingData;

  Future<void> onRefresh() async {
    return getContentDetail(comingSoonData: incomingData);
  }

  bool get isDefaultTrailerPlaying {
    if (contentDetail.value == null || !contentDetail.value!.isTrailerAvailable || currentTrailerData.value.id == 0) {
      return false;
    }
    final trailerData = contentDetail.value!.trailerData;
    return trailerData.isNotEmpty && trailerData.first.id == currentTrailerData.value.id;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ComingSoonModel) {
      getContentDetail(comingSoonData: Get.arguments as ComingSoonModel);
    }
  }

  Future<void> getContentDetail({required ComingSoonModel comingSoonData}) async {
    isLoading(true);
    await CoreServiceApis.getContentDetails(
      contentId: comingSoonData.id,
      type: comingSoonData.type,
      requiresReleasedDataOnly: false,
    ).then(
      (contentModel) async {
        contentDetail.value = contentModel;
        bool hasContent = contentDetail.value != null;

        if (hasContent && contentDetail.value!.isTrailerAvailable && !contentDetail.value!.isVideo) {
          showTrailer(true);
          await updateTrailerData(contentDetail.value!.trailerData.first);
        }
      },
    ).catchError((e) {
      throw e;
    }).whenComplete(() {
      isLoading(false);
    });
  }

  Future<void> updateTrailerData(VideoData newVideoData) async {
    // If same trailer, ignore
    if (currentTrailerData.value.id == newVideoData.id) return;

    /// ---- 1️⃣ Toggle visibility to force widget disposal ----
    showTrailer(false);

    // Slight delay to allow UI to rebuild and dispose the old widget/controller
    await Future.delayed(const Duration(milliseconds: 100));

    /// ---- 2️⃣ Generate new Key & Assign Data ----
    uniqueTrailerKey = UniqueKey();
    currentTrailerData.value = newVideoData;

    /// ---- 3️⃣ Show new trailer ----
    showTrailer(true);
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

  //Save Reminder
  Future<void> saveRemind({required bool isRemind, required ComingSoonModel comingSoonData}) async {
    loadingRemindItems[comingSoonData.id] = true;

    final previousValue = comingSoonData.isRemind;
    comingSoonData.isRemind = isRemind ? 0 : 1;

    // Update List Controller if exists
    updateListController(comingSoonData);

    await CoreServiceApis.saveReminder(
      request: {
        ApiRequestKeys.entertainmentIdKey: comingSoonData.id,
        ApiRequestKeys.isRemindKey: isRemind ? 0 : 1,
        ApiRequestKeys.releaseDateKey: comingSoonData.releaseDate,
        if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
      },
    ).then((value) async {
      loadingRemindItems[comingSoonData.id] = false;
      successSnackBar(
        value.message,
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
    }).catchError((e) {
      comingSoonData.isRemind = previousValue;
      updateListController(comingSoonData);
      loadingRemindItems[comingSoonData.id] = false;
      errorSnackBar(error: e);
    });
  }

  Future<void> deleteRemind({required ComingSoonModel comingSoonData}) async {
    loadingRemindItems[comingSoonData.id] = true;

    final previousValue = comingSoonData.isRemind;
    comingSoonData.isRemind = 0;

    updateListController(comingSoonData);

    await CoreServiceApis.deleteReminder(
      request: {
        ApiRequestKeys.idKey: comingSoonData.id,
      },
    ).then((value) async {
      loadingRemindItems[comingSoonData.id] = false;
      successSnackBar(value.message);
    }).catchError((e) {
      comingSoonData.isRemind = previousValue;
      updateListController(comingSoonData);
      loadingRemindItems[comingSoonData.id] = false;
      errorSnackBar(error: e);
    });
  }

  Future<void> saveWatchList({required ComingSoonModel comingSoonData}) async {
    if (isLoading.isTrue) return;

    loadingWatchlistItems[comingSoonData.id] = true;

    final previousValue = comingSoonData.isInWatchList;
    final isCurrentlyInWatchList = comingSoonData.isInWatchList.getBoolInt();

    if (isCurrentlyInWatchList) {
      comingSoonData.isInWatchList = 0;
    } else {
      comingSoonData.isInWatchList = 1;
    }

    updateListController(comingSoonData);

    if (isCurrentlyInWatchList) {
      successSnackBar(locale.value.removedFromWatchList);
      await CoreServiceApis.deleteFromWatchlist(
        request: {
          ApiRequestKeys.isAjaxKey: 1,
          ApiRequestKeys.idKey: comingSoonData.id,
          if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
          if (selectedAccountProfile.value.id != 0) ApiRequestKeys.userIdKey: loginUserData.value.id,
          ApiRequestKeys.typeKey: comingSoonData.type,
        },
      ).then((value) async {
        loadingWatchlistItems[comingSoonData.id] = false;
      }).catchError((e) {
        comingSoonData.isInWatchList = previousValue;
        updateListController(comingSoonData);
        loadingWatchlistItems[comingSoonData.id] = false;
      });
    } else {
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
          ApiRequestKeys.entertainmentIdKey: comingSoonData.id,
          if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
          ApiRequestKeys.typeKey: comingSoonData.type,
        },
      ).then((value) async {
        loadingWatchlistItems[comingSoonData.id] = false;
      }).catchError((e) {
        comingSoonData.isInWatchList = previousValue;
        updateListController(comingSoonData);
        loadingWatchlistItems[comingSoonData.id] = false;
      });
    }
  }

  //region LikeContent
  bool isLikeLoading = false;

  Future<void> likeContent(BuildContext context, int id) async {
    if (isLikeLoading) return;
    isLikeLoading = true;
    contentDetail.value?.details.isLiked = contentDetail.value!.details.isLiked.getBoolInt() ? 0 : 1;
    contentDetail.refresh();
    successSnackBar(
      contentDetail.value!.details.isLiked.getBoolInt() ? locale.value.likedSuccessfully : locale.value.unlikedSuccessfully,
      icon: contentDetail.value!.details.isLiked.getBoolInt()
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
        ApiRequestKeys.isLikeKey: contentDetail.value!.details.isLiked,
        ApiRequestKeys.typeKey: contentDetail.value?.details.type,
        if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
      },
    ).then((value) async {}).catchError((e) {
      contentDetail.value?.details.isLiked = contentDetail.value!.details.isLiked.getBoolInt() ? 0 : 1;
      contentDetail.refresh();
    }).whenComplete(() {
      isLikeLoading = false;
    });
  }

  void updateListController(ComingSoonModel data) {
    if (Get.isRegistered<ComingSoonController>()) {
      Get.find<ComingSoonController>().listContent.refresh();
      // Or more granular update if possible, but listContent.refresh() is what was used.
    }
  }

  ComingSoonModel? getUpdatedItem(int id) {
    if (Get.isRegistered<ComingSoonController>()) {
      return Get.find<ComingSoonController>().getUpdatedItem(id);
    }
    return null;
  }
}