import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import 'model/profile_watching_model.dart';

class WatchingProfileController extends BaseListController<WatchingProfileModel> {
  RxBool isEdit = false.obs;

  RxBool showShimmer = false.obs;
  SliderController sliderController = SliderController();

  @override
  Future<void> onInit() async {
    init();
    super.onInit();
  }

  Future<void> init() async {
    await Future.wait(
      [
        sliderController.getBanner(type: BannerType.promotional, showLoader: true),
        getListData(showLoader: false),
      ],
    );
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    showShimmer(!showLoader);
    errorMessage('');
    await CoreServiceApis.getWatchingProfileList(
      page: currentPage.value,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    ).then(
      (value) {
        appParentalLockEnabled(accountProfiles.any((element) => element.isProfileProtected));
        setBoolToLocal(SettingsLocalConst.PARENTAL_CONTROL, accountProfiles.any((element) => element.isProfileProtected));
      },
    ).whenComplete(() {
      showShimmer(false);
      setLoading(false);
    }).catchError((e) {
      errorMessage(e);
      throw e;
    });
  }
}