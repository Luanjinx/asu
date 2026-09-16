import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../utils/common_functions.dart';

class GenresDetailsController extends BaseListController<PosterDataModel> {
  ArgumentModel argumentData = ArgumentModel();
  RxList<String> availableFilter = <String>[].obs;

  RxInt currentFilterIndex = 0.obs;

  @override
  void onInit() {
    if (Get.arguments is ArgumentModel) {
      argumentData = Get.arguments as ArgumentModel;
      argumentData.stringArgument += '&${ApiRequestKeys.isReleasedKey}=1';
      update([argumentData]);
    }
    updateFilterTabs();
    ever(appConfigs, (_) => updateFilterTabs());
    init();
    super.onInit();
  }

  void updateFilterTabs() {
    final List<String> tabs = <String>[ApiRequestKeys.allKey];
    if (appConfigs.value.enableMovie) tabs.add(VideoType.movie);
    if (appConfigs.value.enableTvShow) tabs.add(VideoType.tvshow);

    if (tabs.length == 2) tabs.removeWhere((element) => element == ApiRequestKeys.allKey);
    if (tabs.length > 1) availableFilter.assignAll(tabs);
  }

  String get currentFilterParam {
    final String filterType = availableFilter.isNotEmpty ? availableFilter[currentFilterIndex.value] : ApiRequestKeys.allKey;
    if (filterType == ApiRequestKeys.allKey) {
      return '${VideoType.movie},${VideoType.tvshow}';
    }
    return filterType;
  }

  Future<void> init() async {
    if(isLoading.value) return;
    currentPage(1);
    isLastPage(false);
    listContent([]);
    if (Get.arguments is ArgumentModel) {
      getListData(showLoader: true);
    }
  }

  @override
  Future<void> getListData({bool showLoader = true, String params = ''}) async {
    String newParams = argumentData.stringArgument;

    final queryParams = '$newParams&${ApiRequestKeys.searchTypeKey}=${currentFilterParam}&${ApiRequestKeys.pageKey}=${currentPage.value}&${ApiRequestKeys.perPageKey}=30';

    setLoading(showLoader);

    await listContentFuture(CoreServiceApis.searchContent(queryParams: queryParams)).then((value) {
      if(value.length < 30) isLastPage(true);
      listContent.addAll(value);
    }).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }
}