import 'dart:async';

import 'package:streamit_laravel/controllers/base_controller.dart';

import '../../network/core_api.dart';
import 'model/genres_model.dart';

class GenresController extends BaseListController<GenreModel> {
  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getGenresList(
        page: currentPage.value,
        genresList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).then((value) {}).catchError((e) {
      throw e;
    }).whenComplete(() => isLoading(false));
  }
}