import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';

import '../../network/core_api.dart';

class ChannelListController extends BaseListController<PosterDataModel> {
  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    int categoryId = -1;
    if (Get.arguments is ArgumentModel) {
      categoryId = (Get.arguments as ArgumentModel).intArgument;
    }
    setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getChannelList(
        page: currentPage.value,
        getChannelList: listContent,
        category: categoryId,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }
}