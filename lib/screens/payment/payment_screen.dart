import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/successfull_dialogbox.dart';
import 'package:streamit_laravel/screens/auth/sign_in/sign_in_screen.dart';
import 'package:streamit_laravel/screens/coupon/coupan_list_component.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_controller.dart';
import 'package:streamit_laravel/screens/home/home_controller.dart';
import 'package:streamit_laravel/screens/payment/components/payment_card_component.dart';
import 'package:streamit_laravel/screens/payment/payment_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart' show BannerType, SubscriptionTitle;

import '../../components/app_scaffold.dart';
import '../../components/loader_widget.dart';
import '../../main.dart';
import '../../utils/common_base.dart';
import '../../utils/empty_error_state_widget.dart';
import '../coupon/coupon_list_screen.dart';
import '../coupon/model/coupon_list_model.dart';
import '../subscription/components/subscription_price_component.dart';
import '../subscription/subscription_controller.dart';
import 'components/selected_plan_component.dart';

class PaymentScreen extends StatelessWidget {
  final PaymentController paymentCont = Get.find<PaymentController>();
  final SubscriptionController subscriptionCont = Get.find<SubscriptionController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: paymentCont.scrollController,
      isLoading: paymentCont.isLoading,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: paymentCont.isRent.value ? locale.value.rent : locale.value.subscription,
      onRefresh: () async {
        await paymentCont.getPayment(showLoader: true); // Retry fetching payment methods
      },
      leadingWidget: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          subscriptionCont.isExpanded(false);
          paymentCont.removeAppliedCoupon();
          Get.back();
        },
        icon: backButton(onBackPressed: () => Navigator.pop(context)),
      ),
      body: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectedPlanComponent(
              planDetails: paymentCont.selectPlan.value,
              price: paymentCont.isRent.value ? paymentCont.rentPrice.value : paymentCont.selectPlan.value.totalPrice.toDouble(),
              contentName: paymentCont.contentData.name.validate(),
              isRent: paymentCont.isRent.value,
              rentalData: paymentCont.rentalData,
            ),
            24.height,
            Text(
              locale.value.choosePaymentMethod,
              style: boldTextStyle(),
            ),
            16.height,
            Obx(() {
              return SnapHelperWidget(
                future: paymentCont.paymentListFuture.value,
                errorBuilder: (error) {
                  return Obx(
                    () => AppNoDataWidget(
                      title: error,
                      retryText: locale.value.reload,
                      imageWidget: const ErrorStateWidget(),
                      onRetry: () async {
                        await paymentCont.getPayment(showLoader: true); // Retry fetching payment methods
                      },
                    ).center().visible(!paymentCont.isLoading.value),
                  );
                },
                loadingWidget: SizedBox(
                  width: Get.width,
                  height: Get.height * 0.20,
                  child: const LoaderWidget(),
                ).center(),
                onSuccess: (data) {
                  if (paymentCont.originalPaymentList.isEmpty && !paymentCont.isPaymentLoading.value) {
                    return AppNoDataWidget(
                      title: locale.value.noPaymentMethodsFound,
                      retryText: locale.value.reload,
                      imageWidget: const EmptyStateWidget(),
                      onRetry: () async {
                        await paymentCont.getPayment(showLoader: true); // Retry fetching payment methods
                      },
                    ).center();
                  } else {
                    return AnimatedWrap(
                      runSpacing: 12,
                      spacing: 12,
                      listAnimationType: commonListAnimationType,
                      itemCount: paymentCont.originalPaymentList.length,
                      // Number of payment methods
                      itemBuilder: (context, index) {
                        return PaymentCardComponent(
                          paymentDetails: paymentCont.originalPaymentList[index], // Payment method details
                        ); // Add padding between items
                      },
                    );
                  }
                },
              );
            }),
            if (paymentCont.showCoupon.value && paymentCont.couponController.listContent.isNotEmpty) ...[
              24.height,
              Obx(() {
                return viewAllWidget(
                  label: locale.value.coupons,
                  showViewAll: true,
                  isSymmetricPaddingEnable: false,
                  iconButton: paymentCont.couponController.listContent.length <= 2
                      ? SizedBox.shrink()
                      : InkWell(
                          splashColor: appColorPrimary.withValues(alpha: 0.4),
                          highlightColor: Colors.transparent,
                          onTap: () {
                            hideKeyboard(context);
                            Get.to(
                              () => CouponListScreen(),
                              arguments: paymentCont.selectPlan.value,
                            )?.then((value) async {
                              if (value != null) {
                                if (value is CouponDataModel) {
                                  paymentCont.couponController.appliedCouponData(value);
                                  subscriptionCont.calculateTotalPrice(appliedCouponData: paymentCont.couponController.appliedCouponData.value);
                                  successSnackBar(locale.value.coupanApplied);
                                }
                              }
                            });
                          },
                          child: Text(locale.value.viewAll, style: boldTextStyle(size: 14, color: appColorPrimary)),
                        ),
                );
              }),
              16.height,
              CouponListComponent(),
            ],
          ],
        );
      }),
      widgetsStackedOverBody: [
        PositionedDirectional(
          bottom: 10,
          start: ResponsiveSize.getStart(16),
          end: ResponsiveSize.getEnd(16),
          child: Obx(
            () {
              return PriceComponent(
                subscriptionCont: subscriptionCont,
                appliedCouponData: paymentCont.couponController.appliedCouponData.value,
                buttonText: locale.value.proceedPayment,
                isProceedPayment: true,
                isRent: paymentCont.isRent.value,
                rentData: paymentCont.rentalData,
                contentDetails: paymentCont.contentData,
                buttonColor: paymentCont.selectPayment.value.type.isNotEmpty ? rentedColor : null,
                onCallBack: () {
                  if (isLoggedIn.value) {
                    if (paymentCont.selectPayment.value.id > -1) {
                      if (paymentCont.isLoading.isFalse) {
                        if (paymentCont.isRent.value) {
                          paymentCont.price(paymentCont.rentPrice.value);
                        } else {
                          paymentCont.price(subscriptionCont.totalAmount.value);
                        }
                        int previousLimit = currentSubscription.value.id > 0 ? (int.tryParse(currentSubscription.value.planType.firstWhereOrNull((element) => element.slug == SubscriptionTitle.deviceLimit)?.limit.value ?? '1') ?? 1) : 1;
                        paymentCont.handlePayNowClick(
                          context,
                          () {
                            if (paymentCont.isRent.value) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return SuccessDialogueComponent(
                                    title: locale.value.successfullyRented,
                                    subtitle: locale.value.enjoyUntilDays(paymentCont.rentalData.availabilityDays),
                                    buttonText: locale.value.beginWatching,
                                    onButtonClick: () {
                                      Get.back();
                                      Get.find<HomeController>().sliderController.getBanner(type: BannerType.home, showLoader: false);
                                    },
                                  );
                                },
                              );
                            } else {
                              loginUserData.value.planDetails = currentSubscription.value;
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return SuccessDialogueComponent(
                                    title: locale.value.paymentSuccessful + ' 🎉',
                                    subtitle: locale.value.yourPaymentWasCompleted,
                                    buttonText: paymentCont.contentData.id > 0 ? locale.value.beginWatching : locale.value.explore,
                                    onButtonClick: () {
                                      Get.back();
                                      int currentLimit = currentSubscription.value.id > 0 ? (int.tryParse(currentSubscription.value.planType.firstWhereOrNull((element) => element.slug == SubscriptionTitle.deviceLimit)?.limit.value ?? '1') ?? 1) : 0;
                                      if (previousLimit > currentLimit) {
                                        logOutFromAllDevice(
                                          loaderOnOff: (setLoading) {
                                            paymentCont.setLoading(setLoading);
                                          },
                                          showLoader: true,
                                          onSuccess: () {
                                            final DashboardController dashboardController = Get.find<DashboardController>();
                                            dashboardController.addDataOnBottomNav();
                                            dashboardController.currentIndex(0);
                                            Get.to(() => SignInScreen(title: locale.value.logoutAllConfirmationMessage));
                                          },
                                        );
                                      }
                                      Get.find<HomeController>().sliderController.getBanner(type: BannerType.home, showLoader: false);
                                    },
                                  );
                                },
                              );
                            }
                          },
                        );
                      } else {
                        return;
                      }
                    } else {
                      return toast(locale.value.pleaseSelectPaymentMethod);
                    }
                  }
                },
              );
            },
          ),
        )
      ],
    );
  }
}