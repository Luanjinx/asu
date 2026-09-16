import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/payment/payment_controller.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_base.dart';
import '../../utils/common_functions.dart';
import 'components/coupon_item_component.dart';
import 'model/coupon_list_model.dart';

class CouponListScreen extends StatefulWidget {
  const CouponListScreen({super.key});

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  final PaymentController paymentController = Get.find<PaymentController>();

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
    return NewAppScaffold(
      isLoading: false.obs,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.coupons,
      isPinnedAppbar: true,
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              textStyle: commonPrimaryTextStyle(size: 14),
              onTapOutside: (event) => hideKeyboard(context),
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
            10.height,
            Text(
              locale.value.allCoupons,
              style: boldTextStyle(),
            ),
            16.height,
            if (coupons.isEmpty)
              AppNoDataWidget(
                title: locale.value.oopsWeCouldnTFind,
                retryText: "",
                imageWidget: const EmptyStateWidget(),
              ).paddingSymmetric(horizontal: 16)
            else
              AnimatedListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: coupons.length,
                listAnimationType: commonListAnimationType,
                itemBuilder: (context, index) {
                  final CouponDataModel couponData = coupons[index];

                  return CouponItemComponent(
                    couponData: couponData,
                    onApplyCoupon: () {
                      hideKeyboard(context);
                      couponData.isCouponApplied = true;
                      Get.back(result: couponData);
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
      }),
    );
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