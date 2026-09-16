import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_functions.dart' show appConfigs;
import 'package:streamit_laravel/utils/constants.dart' show VideoType;

import '../../network/core_api.dart';

class RentalListController extends BaseListController<PosterDataModel> {
  RxList<String> availableFilter = <String>[].obs;

  RxInt currentFilterIndex = 0.obs;

  late Worker _configWorker;

  @override
  void onInit() {
    _updateFilterTabs();
    _configWorker = ever(appConfigs, (_) => _updateFilterTabs());
    getListData(showLoader: false);
    super.onInit();
  }

  String get currentFilterType {
    if (availableFilter.isEmpty ||
        currentFilterIndex.value >= availableFilter.length)
      return ApiRequestKeys.allKey;
    final String filterType = availableFilter[currentFilterIndex.value];
    return filterType;
  }

  void _updateFilterTabs() {
    final List<String> tabs = <String>[ApiRequestKeys.allKey];
    if (appConfigs.value.enableMovie) tabs.add(VideoType.movie);
    if (appConfigs.value.enableTvShow) tabs.add(VideoType.episode);
    if (appConfigs.value.enableVideo) tabs.add(VideoType.video);

    if (tabs.length == 2)
      tabs.removeWhere((element) => element == ApiRequestKeys.allKey);
    if (tabs.length > 1) availableFilter.assignAll(tabs);
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    if (showLoader) setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getPayPerViewList(
        page: currentPage.value,
        rentalList: listContent,
        type: currentFilterType == VideoType.episode ? VideoType.tvshow : currentFilterType,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => isLoading(false));
  }

  @override
  void onClose() {
    _configWorker.dispose();
    super.onClose();
  }
}
