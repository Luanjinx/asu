import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';

import '../../../network/core_api.dart';

class LiveContentDetailsController extends BaseController<ContentModel> {
  RxBool showShimmer = false.obs;
  PosterDataModel argumentData = PosterDataModel(details: ContentData());

  @override
  void onInit() {
    initScrollListener();
    if (Get.arguments is PosterDataModel) {
      argumentData = Get.arguments as PosterDataModel;
      update([argumentData]);
      getLiveShowDetail(showLoader: false);
    }

    super.onInit();
  }

  ///Get Live SHow List
  Future<void> getLiveShowDetail({bool showLoader = true}) async {
    if (argumentData.id < 0) return;
    showShimmer(!showLoader);
    setLoading(showLoader);

    await getContent(
      showLoader: showLoader,
      contentApiCall: () => CoreServiceApis.getLiveContentDetails(contentId: argumentData.id),
      onSuccess: (data) {
        content(data);
      },
    ).whenComplete(() => showShimmer(false));
  }
}