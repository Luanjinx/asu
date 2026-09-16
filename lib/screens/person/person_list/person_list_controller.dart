import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';

import '../../../network/core_api.dart';

class PersonListController extends BaseListController<Cast> {
  final RxBool isFetchingList = false.obs;

  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    String type = '';
    if (Get.arguments is ArgumentModel) {
      type = (Get.arguments as ArgumentModel).stringArgument;
    }
    if (!isFetchingList.value) {
      isFetchingList(true);
    }
    setLoading(showLoader);

    await listContentFuture(
      CoreServiceApis.getActorsList(
        page: currentPage.value,
        actorList: listContent,
        param: type,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() {
      setLoading(false);
      isFetchingList(false);
    });
  }
}