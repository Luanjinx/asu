import 'dart:async';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

import '../../network/core_api.dart';
import '../../utils/common_functions.dart';
import '../../utils/constants.dart';
import '../coupon/model/coupon_list_model.dart';

class SubscriptionController extends BaseListController<SubscriptionPlanModel> {
  Rx<SubscriptionPlanModel> selectPlan = SubscriptionPlanModel().obs;
  RxDouble price = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxBool isExpanded = false.obs;

  RxDouble totalAmount = 0.0.obs;
  RxDouble tempTotalAmount = 0.0.obs;

  RxDouble totalTaxAmount = 0.0.obs;
  RxDouble priceWithCouponDiscount = 0.0.obs;

  int requiredLevel = 0;

  @override
  void onInit() {
    if (Get.arguments is int) {
      requiredLevel = Get.arguments;
      update([requiredLevel]);
    }
    getListData(showLoader: false);

    super.onInit();
  }

  ///Get Subscription List
  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);

    await listContentFuture(
      CoreServiceApis.getPlanList(
        subscriptionPlanList: listContent,
        page: currentPage.value,
        lastPageCallBack: (bool) {
          isLastPage(bool);
        },
      ),
    ).then((value) {
      if (listContent.isNotEmpty) {
        if (requiredLevel > 0 && listContent.any((element) => element.level == requiredLevel)) {
          selectPlan(listContent.firstWhere((element) => element.level == requiredLevel));
          calculateTotalPrice();
        }
      }
    }).catchError((e) {
      log("getPlan List Err : $e");
    }).whenComplete(() => isLoading(false));
  }

  void calculateTotalPrice({CouponDataModel? appliedCouponData}) {
    if (appliedCouponData != null && appliedCouponData.discount.toDouble() > 0) {
      if (appliedCouponData.discountType == Tax.percentage) {
        final double tempAmount = selectPlan.value.discount.getBoolInt() ? selectPlan.value.totalPrice.toDouble() : selectPlan.value.price.toDouble();
        priceWithCouponDiscount.value = tempAmount * (appliedCouponData.discount.toDouble() / 100);
      } else if (appliedCouponData.discountType == Tax.fixed) {
        priceWithCouponDiscount.value = appliedCouponData.discount.toDouble();
      }
    } else {
      priceWithCouponDiscount.value = 0.0;
    }
    price.value =
        selectPlan.value.discount.getBoolInt() ? (selectPlan.value.totalPrice.toDouble() - priceWithCouponDiscount.value) : (selectPlan.value.price.toDouble() - priceWithCouponDiscount.value);

    double totalTax = 0.0;
    double totalTaxWithoutDiscount = 0.0;
    for (var tax in appConfigs.value.taxPercentage) {
      if (tax.type.toLowerCase() == Tax.percentage) {
        totalTax += price.value * tax.value / 100;
        totalTaxWithoutDiscount += (selectPlan.value.totalPrice.toDouble() - priceWithCouponDiscount.toDouble()) * (tax.value / 100);
      } else if (tax.type.toLowerCase() == Tax.fixed) {
        totalTax += tax.value;
        totalTaxWithoutDiscount += tax.value;
      } else {
        totalTax += tax.value;
        totalTaxWithoutDiscount += tax.value;
      }
    }

    totalTaxAmount(totalTax);

    tempTotalAmount((selectPlan.value.totalPrice - priceWithCouponDiscount.toDouble()) + totalTaxWithoutDiscount);
    totalAmount(price.value + totalTax);
  }
}