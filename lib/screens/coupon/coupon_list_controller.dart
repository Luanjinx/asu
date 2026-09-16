import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';

import '../../network/core_api.dart';
import '../subscription/model/subscription_plan_model.dart';
import 'model/coupon_list_model.dart';

class CouponListController extends BaseListController<CouponDataModel> {
  RxBool isTyping = false.obs;
  RxBool isCouponApplied = false.obs;

  Rx<SubscriptionPlanModel> selectPlan = SubscriptionPlanModel().obs;

  Rx<CouponDataModel> appliedCouponData = CouponDataModel().obs;

  @override
  void onInit() {
    if (Get.arguments is SubscriptionPlanModel) {
      selectPlan(Get.arguments);
    }
    getListData(showLoader: false);
    super.onInit();
  }

  /// Get Coupon List API
  @override
  Future<void> getListData({bool showLoader = true, String couponCode = "", int? perPageItem, String? selectedPlanId}) async {
    isLoading(showLoader);
    await CoreServiceApis.getCouponListApi(
      planId: selectedPlanId ?? selectPlan.value.planId.toString(),
      couponCode: couponCode,
      page: currentPage.value,
      couponList: listContent,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    ).catchError((e) {
      setLoading(false);
      throw e;
    }).whenComplete(() => isLoading(false));
  }
}