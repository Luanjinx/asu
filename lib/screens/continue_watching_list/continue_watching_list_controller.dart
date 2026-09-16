import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../main.dart';
import '../../network/core_api.dart';

class ContinueWatchingListController extends BaseListController<PosterDataModel> {
  @override
  void onInit() {
    getListData(showLoader: false);
    super.onInit();
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(
      CoreServiceApis.getContinueWatchingList(
        page: currentPage.value,
        continueWatchList: listContent,
        lastPageCallBack: (p0) {
          isLastPage(p0);
        },
      ),
    ).catchError((e) {
      throw e;
    }).whenComplete(() => setLoading(false));
  }

  Future<void> removeFromContinueWatching(int id) async {
    if (isLoading.value) return;

    // Optimistically remove from local lists to keep UI in sync with action.
    final int localIndex = listContent.indexWhere((element) => element.id == id);
    final PosterDataModel? removedLocalItem = localIndex != -1 ? listContent[localIndex] : null;
    if (localIndex != -1) listContent.removeAt(localIndex);
    cachedContinueWatchList.removeWhere((element) => element.id == id);
    listContent.refresh();

    final HomeController homeScreenCont = Get.find();
    final int dashboardIndex = homeScreenCont.dashboardOtherDetailsSectionList.indexWhere(
      (element) => element.sectionType == DashboardCategoryType.continueWatching,
    );
    int removedDashboardIndex = -1;
    PosterDataModel? removedDashboardItem;

    if (dashboardIndex != -1) {
      final List<PosterDataModel> dashboardList = List<PosterDataModel>.from(
        homeScreenCont.dashboardOtherDetailsSectionList[dashboardIndex].data.cast<PosterDataModel>(),
      );
      removedDashboardIndex = dashboardList.indexWhere((element) => element.id == id);
      removedDashboardItem = removedDashboardIndex != -1 ? dashboardList[removedDashboardIndex] : null;
    }

    homeScreenCont.removeFromContinueWatching(id);

    isLoading(true);
    await CoreServiceApis.removeContinueWatching(continueWatchingId: id).then((value) {
      if (value.message.isNotEmpty) {
        successSnackBar(value.message);
      } else {
        successSnackBar(locale.value.removedFromContinueWatch);
      }
    }).catchError((e) {
      // Revert optimistic changes on failure.
      if (removedLocalItem != null && localIndex != -1) {
        listContent.insert(localIndex, removedLocalItem);
      }
      if (removedDashboardItem != null && removedDashboardIndex != -1) {
        homeScreenCont.addContinueWatchingItem(removedDashboardItem, index: removedDashboardIndex);
      }
      if (removedLocalItem != null) {
        cachedContinueWatchList.add(removedLocalItem);
      }
      listContent.refresh();
      errorSnackBar(error: e);
    }).whenComplete(() => isLoading(false));
  }
}