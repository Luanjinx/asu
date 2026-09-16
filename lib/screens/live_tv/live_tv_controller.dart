import 'dart:async';

import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';

import '../../network/core_api.dart';

class LiveTVController extends BaseController<LiveChannelDashboardResponse> {
  RxBool showShimmer = false.obs;

  @override
  void onInit() {
    initScrollListener();
    super.onInit();
  }

  @override
  void onReady() {
    getLiveDashboardDetail(startTimer: true);
  }

  ///Get Live Dashboard List
  Future<void> getLiveDashboardDetail({bool showLoader = true, bool startTimer = false}) async {
    showShimmer(showLoader);
    await getContent(
      contentApiCall: () => CoreServiceApis.getLiveDashboard(),
      showLoader: showLoader,
      onSuccess: (data) {},
    ).whenComplete(() => showShimmer(false));
  }
}