import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../main.dart';
import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../../utils/common_functions.dart';
import '../../utils/constants.dart';
import '../home/home_controller.dart';
import '../profile/profile_controller.dart';

class WatchListController extends BaseListController<PosterDataModel> {
  RxBool isDelete = false.obs;
  RxList<PosterDataModel> selectedPosters = RxList();
  RxInt currentFilterIndex = 0.obs;
  RxInt currentMoviePage = 1.obs;
  RxInt currentVideoPage = 1.obs;
  RxInt currentTvShowPage = 1.obs;
  RxBool isRefreshing = false.obs;

  RxList<String> availableFilter = <String>[].obs;
  late Worker _configWorker;

  @override
  void onInit() {
    super.onInit();
    _updateFilterTabs();
    _configWorker = ever(appConfigs, (_) => _updateFilterTabs());
    getListData(showLoader: false);
    initScrollListener(onNextPage: () {
      onScroll();
    });
  }

  int getCurrentPage() {
    final String filterType = currentFilterType;
    if (filterType.isEmpty || filterType == ApiRequestKeys.allKey) {
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

  @override
  Future<void> onRefresh() async {
    isRefreshing(true);
    // Complete refresh Future immediately so RefreshIndicator disappears
    // Then handle loading separately in next microtask
    Future.microtask(() async {
      final String filterType = currentFilterType;
      if (filterType.isEmpty || filterType == ApiRequestKeys.allKey) {
        currentPage(1);
      } else if (filterType == VideoType.movie) {
        currentMoviePage(1);
      } else if (filterType == VideoType.tvshow) {
        currentTvShowPage(1);
      } else if (filterType == VideoType.video) {
        currentVideoPage(1);
      } else {
        currentPage(1);
      }
      isLastPage(false);
      await getListData();
      isRefreshing(false);
    });
  }

  @override
  Future<void> onScroll() async {
    if (isLoading.value) return;
    if (!isLastPage.value) {
      final String filterType = currentFilterType;
      if (filterType.isEmpty || filterType == ApiRequestKeys.allKey) {
        currentPage++;
      } else if (filterType == VideoType.movie) {
        currentMoviePage++;
      } else if (filterType == VideoType.tvshow) {
        currentTvShowPage++;
      } else if (filterType == VideoType.video) {
        currentVideoPage++;
      } else {
        currentPage++;
      }
      await getListData(showLoader: false);
    }
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getWatchList(
        page: getCurrentPage(),
        type: ApiRequestKeys.allKey == currentFilterType ? '' : currentFilterType,
        watchList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => isLoading(false));
  }

  Future<void> handleRemoveFromWatchClick(BuildContext context) async {
    if (isLoading.value) return;
    Get.bottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      enableDrag: false,
      AppDialogWidget(
        image: Assets.iconsTrash,
        imageColor: appColorPrimary,
        title: locale.value.removeSelectedFromWatchList,
        onAccept: () async {
          setLoading(true);
          await CoreServiceApis.deleteFromWatchlist(request: {
            ApiRequestKeys.isAjaxKey: 1,
            ApiRequestKeys.idKey: selectedPosters.validate().map((e) => e.id).toList().join(','),
            if (selectedAccountProfile.value.id != 0) ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
            if (selectedAccountProfile.value.id != 0) ApiRequestKeys.userIdKey: loginUserData.value.id,
            ApiRequestKeys.typeKey: selectedPosters.firstOrNull?.details.type,
          }).then((value) {
            selectedPosters.validate().forEach(
              (element) {
                listContent.removeWhere((e) => e.id == element.id);
              },
            );
            isDelete.value = !isDelete.value;
            selectedPosters.clear();
            successSnackBar(value.message);
            getListData();
            updateWatchList(selectedPosters.validate().map((e) => e.id).toList());
          }).catchError((e) {
            setLoading(false);
            errorSnackBar(error: e);
          }).whenComplete(() => isLoading(false));
        },
      ),
    );
  }

  Future<void> updateWatchList(List<int> idList) async {
    ProfileController profileCont = Get.find<ProfileController>();
    HomeController homeController = Get.find<HomeController>();
    profileCont.getProfileDetail();
    homeController.getDashboardDetail();
  }

  void removeItemFromWatchList(int contentId) {
    listContent.removeWhere((item) => item.id == contentId || item.details.id == contentId || item.entertainmentId == contentId);
    selectedPosters.removeWhere((item) => item.id == contentId || item.details.id == contentId || item.entertainmentId == contentId);
  }

  @override
  void onClose() {
    _configWorker.dispose();
    super.onClose();
  }
}