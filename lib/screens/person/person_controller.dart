import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class PersonController extends BaseListController<PosterDataModel> {
  ArgumentModel argumentData = ArgumentModel();
  Rx<Cast> castDetails = Cast().obs;

  RxList<String> availableFilter = <String>[].obs;

  RxInt currentFilterIndex = 0.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    if (Get.arguments is ArgumentModel) {
      updateFilterTabs();
      argumentData = Get.arguments as ArgumentModel;
      update([argumentData]);

      await Future.wait(
        [
          getCastData(),
          getListData(showLoader: false),
        ],
      );
    }
  }

  String get currentFilterParam {
    final String filterType = availableFilter.isNotEmpty ? availableFilter[currentFilterIndex.value] : ApiRequestKeys.allKey;
    if (filterType == ApiRequestKeys.allKey) {
      return '${VideoType.movie},${VideoType.tvshow}';
    }
    return filterType;
  }

  void updateFilterTabs() {
    final List<String> tabs = <String>[ApiRequestKeys.allKey];
    if (appConfigs.value.enableMovie) tabs.add(VideoType.movie);
    if (appConfigs.value.enableTvShow) tabs.add(VideoType.tvshow);

    if (tabs.length == 2) tabs.removeWhere((element) => element == ApiRequestKeys.allKey);
    if (tabs.length > 1) availableFilter.assignAll(tabs);
  }

  Future<void> getCastData() async {
    await CoreServiceApis.getCastDetails(param: argumentData.stringArgument).then(
      (value) {
        castDetails(value);
      },
    );
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    String newParams = argumentData.stringArgument;
    if (argumentData.stringArgument.isNotEmpty) {
      if (newParams.contains('&${ApiRequestKeys.typeKey}=${ApiRequestKeys.actorKey}')) {
        newParams = newParams.replaceAll('&${ApiRequestKeys.typeKey}=${ApiRequestKeys.actorKey}', '').replaceAll(ApiRequestKeys.idKey, ApiRequestKeys.actorId);
      } else if (newParams.contains('&${ApiRequestKeys.typeKey}=${ApiRequestKeys.directorKey}')) {
        newParams = newParams.replaceAll('&${ApiRequestKeys.typeKey}=${ApiRequestKeys.directorKey}', '').replaceAll(ApiRequestKeys.idKey, ApiRequestKeys.directorId);
      }
    }

    final queryParams = '$newParams&${ApiRequestKeys.isReleasedKey}=1&${ApiRequestKeys.searchTypeKey}=${currentFilterParam}';

    setLoading(showLoader);

    await listContentFuture(CoreServiceApis.searchContent(queryParams: queryParams)).then(
      (value) {
        isLastPage(true);
        listContent(value);
        listContent.shuffle();
      },
    ).whenComplete(
      () => setLoading(false),
    );
  }
}