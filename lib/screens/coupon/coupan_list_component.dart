import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/payment/payment_controller.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';

import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/common_functions.dart';
import 'components/coupon_item_component.dart';
import 'model/coupon_list_model.dart';

class CouponListComponent extends StatefulWidget {
  const CouponListComponent({super.key});

  @override
  State<CouponListComponent> createState() => _CouponListComponentState();
}

class _CouponListComponentState extends State<CouponListComponent> {
  final PaymentController paymentController = Get.find<PaymentController>();
  final SubscriptionController subscriptionController = Get.find<SubscriptionController>();

  RxList<CouponDataModel> coupons = RxList<CouponDataModel>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    searchController.text = '';
    coupons.assignAll(List.of(paymentController.couponController.listContent).toList());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            textStyle: commonPrimaryTextStyle(size: 14),
            controller: searchController,
            textFieldType: TextFieldType.NAME,
            cursorColor: white,
            decoration: inputDecoration(
              context,
              fillColor: cardColor,
              filled: true,
              hintText: locale.value.enterCouponCode,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchController.text.isNotEmpty) ...[
                    GestureDetector(
                      onTap: () => init(),
                      child: const Icon(
                        Icons.clear,
                        size: 18,
                        color: appColorPrimary,
                      ),
                    ).paddingOnly(right: 8),
                    TextButton(
                      onPressed: () {
                        hideKeyboard(context);
                        onSearch();
                      },
                      child: Text(locale.value.check, style: commonPrimaryTextStyle(color: appColorPrimary)),
                    ),
                    8.width,
                  ]
                ],
              ),
            ),
            onChanged: (value) => onSearch(),
            onFieldSubmitted: (value) => onSearch(),
          ),
          16.height,
          if (coupons.isEmpty)
            Center(
              child: Text(locale.value.oopsWeCouldnTFind, style: boldTextStyle(), textAlign: TextAlign.center).paddingSymmetric(horizontal: 16, vertical: 8),
            )
          else
            AnimatedListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coupons.length > 2 ? 2 : coupons.length,
              listAnimationType: commonListAnimationType,
              itemBuilder: (context, index) {
                final CouponDataModel couponData = coupons[index];

                if (couponData.code == paymentController.couponController.appliedCouponData.value.code) {
                  couponData.isCouponApplied = true;
                } else {
                  couponData.isCouponApplied = false;
                }

                return CouponItemComponent(
                  couponData: couponData,
                  onApplyCoupon: () {
                    hideKeyboard(context);
                    paymentController.couponController.appliedCouponData(couponData);
                    subscriptionController.calculateTotalPrice(appliedCouponData: paymentController.couponController.appliedCouponData.value);
                    successSnackBar(locale.value.coupanApplied);
                    setState(() {});
                  },
                  onRemoveCoupon: () {
                    hideKeyboard(context);
                    Get.bottomSheet(
                      AppDialogWidget(
                        title: locale.value.doYouWantToRemoveCoupon(paymentController.couponController.appliedCouponData.value.code),
                        positiveText: locale.value.remove,
                        negativeText: locale.value.cancel,
                        image: Assets.iconsSealPercent,
                        imageColor: appColorPrimary,
                        onAccept: () {
                          couponData.isCouponApplied = false;
                          paymentController.removeAppliedCoupon(isDataFetch: false);
                          successSnackBar(locale.value.coupanRemoved);
                          setState(() {});
                        },
                      ),
                    );
                  },
                ).paddingOnly(bottom: 20);
              },
            ),
        ],
      );
    });
  }

  void onSearch() {
    if (searchController.text.isNotEmpty) {
      coupons.assignAll(paymentController.couponController.listContent.where((element) => element.code.toLowerCase().contains(searchController.text.toLowerCase())).toList());
      setState(() {});
    } else {
      init();
    }
  }
}