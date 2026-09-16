import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../../utils/common_functions.dart';

class ComingSoonController extends BaseListController<ComingSoonModel> {
  RxInt currentMoviePage = 1.obs;
  RxInt currentVideoPage = 1.obs;
  RxInt currentTvShowPage = 1.obs;

  RxMap<int, bool> loadingRemindItems = <int, bool>{}.obs;
  RxMap<int, bool> loadingWatchlistItems = <int, bool>{}.obs;

  RxList<String> availableFilter = <String>[].obs;

  RxInt currentFilterIndex = 0.obs;
  late Worker _configWorker;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _updateFilterTabs();
    _configWorker = ever(appConfigs, (_) => _updateFilterTabs());
  }

  @override
  void onReady() {
    getListData(showLoader: true);
  }

//Save Reminder
  Future<void> saveRemind({required bool isRemind, required ComingSoonModel comingSoonData}) async {
    loadingRemindItems[comingSoonData.id] = true;

    final previousValue = comingSoonData.isRemind;
    comingSoonData.isRemind = isRemind ? 0 : 1;
    listContent.refresh();

    await CoreServiceApis.saveReminder(
      request: {
        ApiRequestKeys.entertainmentIdKey: comingSoonData.id,
        ApiRequestKeys.isRemindKey: isRemind ? 0 : 1,
        ApiRequestKeys.releaseDateKey: comingSoonData.releaseDate,
        if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
      },
    ).then((value) async {
      await getListData(showLoader: false);
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
      listContent.refresh();
      loadingRemindItems[comingSoonData.id] = false;
      errorSnackBar(error: e);
    });
  }

  Future<void> deleteRemind({required ComingSoonModel comingSoonData}) async {
    loadingRemindItems[comingSoonData.id] = true;

    final previousValue = comingSoonData.isRemind;
    comingSoonData.isRemind = 0;
    listContent.refresh();

    await CoreServiceApis.deleteReminder(
      request: {
        ApiRequestKeys.idKey: comingSoonData.id,
      },
    ).then((value) async {
      await getListData(showLoader: false);
      loadingRemindItems[comingSoonData.id] = false;
      successSnackBar(value.message);
    }).catchError((e) {
      comingSoonData.isRemind = previousValue;
      listContent.refresh();
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
    listContent.refresh();

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
        await getListData(showLoader: false);
        loadingWatchlistItems[comingSoonData.id] = false;
      }).catchError((e) {
        comingSoonData.isInWatchList = previousValue;
        listContent.refresh();
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
        await getListData(showLoader: false);
        loadingWatchlistItems[comingSoonData.id] = false;
      }).catchError((e) {
        comingSoonData.isInWatchList = previousValue;
        listContent.refresh();
        loadingWatchlistItems[comingSoonData.id] = false;
      });
    }
  }

  ComingSoonModel? getUpdatedItem(int id) {
    try {
      return listContent.firstWhereOrNull((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  int getCurrentPage() {
    final String filterType = currentFilterType;
    if (filterType == "all") {
      return currentPage.value;
    } else if (filterType == VideoType.movie) {
      return currentMoviePage.value;
    } else if (filterType == VideoType.tvshow) {
      return currentTvShowPage.value;
    } else if (filterType == VideoType.video) {
      return currentVideoPage.value;
    }
    return currentPage.value;
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getComingSoonList(
        page: getCurrentPage(),
        type: currentFilterType,
        getComingSoonList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => isLoading(false));
  }

  String get currentFilterType {
    if (availableFilter.isEmpty || currentFilterIndex.value >= availableFilter.length) return ApiRequestKeys.allKey;
    final String filterType = availableFilter[currentFilterIndex.value];
    return filterType;
  }

  void _updateFilterTabs() {
    final List<String> tabs = <String>[ApiRequestKeys.allKey];
    if (appConfigs.value.enableMovie) tabs.add(VideoType.movie);
    if (appConfigs.value.enableTvShow) tabs.add(VideoType.tvshow);
    if (appConfigs.value.enableVideo) tabs.add(VideoType.video);

    if (tabs.length == 2) tabs.removeWhere((element) => element == ApiRequestKeys.allKey);
    if (tabs.length > 1) availableFilter.assignAll(tabs);
  }

  //region LikeContent
  Map<int, bool> loadingLikesItems = {};

  Future<void> likeContent(BuildContext context, ComingSoonModel contentDetail) async {
    if (loadingLikesItems.containsKey(contentDetail.id)) return;
    loadingLikesItems[contentDetail.id] = true;
    contentDetail.isLiked = contentDetail.isLiked.getBoolInt() ? 0 : 1;
    listContent.refresh();
    successSnackBar(
      contentDetail.isLiked.getBoolInt() ? locale.value.likedSuccessfully : locale.value.unlikedSuccessfully,
      icon: contentDetail.isLiked.getBoolInt()
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
        ApiRequestKeys.entertainmentIdKey: contentDetail.id,
        ApiRequestKeys.isLikeKey: contentDetail.isLiked,
        ApiRequestKeys.typeKey: contentDetail.type,
        if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
      },
    ).then((value) async {}).catchError((e) {
      contentDetail.isLiked = contentDetail.isLiked.getBoolInt() ? 0 : 1;
      listContent.refresh();
    }).whenComplete(() {
      loadingLikesItems.remove(contentDetail.id);
    });
  }

  @override
  void onClose() {
    _configWorker.dispose();
    super.onClose();
  }
}