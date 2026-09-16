import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/payment/payment_screen.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/shimmer/shimmer.dart';

import '../../../components/cached_image_widget.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/price_widget.dart';
import '../../coupon/model/coupon_list_model.dart';
import '../subscription_controller.dart';

class PriceComponent extends StatelessWidget {
  final SubscriptionController subscriptionCont;
  final String? buttonText;
  final bool isProceedPayment;
  final VoidCallback? onCallBack;
  final Color? buttonColor;
  final CouponDataModel? appliedCouponData;
  final bool isRent;
  final RentalData? rentData;

  final ContentData? contentDetails;

  const PriceComponent({
    super.key,
    required this.subscriptionCont,
    this.buttonText,
    this.isProceedPayment = false,
    this.onCallBack,
    this.buttonColor,
    this.appliedCouponData,
    this.isRent = false,
    this.rentData,
    this.contentDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: boxDecorationDefault(
          color: cardColor.withValues(alpha: 0.9),
          borderRadius: radius(subscriptionCont.isExpanded.value ? defaultRadius : 32),
          border: Border.all(color: subscriptionCont.isExpanded.value ? btnColor : borderColorDark.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedCrossFade(
              firstCurve: Curves.easeIn,
              firstChild: Column(
                spacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isRent ? locale.value.rent : subscriptionCont.selectPlan.value.name,
                        style: commonW600PrimaryTextStyle(),
                      ).expand(),
                      PriceWidget(
                        discount: isRent ? rentData!.discount.validate() : subscriptionCont.selectPlan.value.discountPercentage,
                        isDiscountedPrice: isRent ? rentData!.discount > 0 : subscriptionCont.selectPlan.value.discountPercentage > 0,
                        discountedPrice: isRent ? rentData!.discountedPrice.validate() : subscriptionCont.selectPlan.value.totalPrice,
                        size: 20,
                        price: isRent ? rentData!.price.validate() : subscriptionCont.selectPlan.value.price,
                        isLineThroughEnabled: isRent ? rentData!.discountedPrice > 0 : subscriptionCont.selectPlan.value.discountPercentage > 0,
                      ),
                    ],
                  ),
                  if (appliedCouponData != null && appliedCouponData!.code.isNotEmpty)
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(locale.value.couponDiscount, style: commonSecondaryTextStyle()),
                            Text(
                              '(${appliedCouponData!.code})',
                              style: boldTextStyle(color: primaryTextColor, size: ResponsiveSize.getFontSize(14)),
                            ).expand(),
                          ],
                        ).expand(),
                        PriceWidget(
                          price: subscriptionCont.priceWithCouponDiscount.value,
                          isPercentage: false,
                          size: 16,
                          color: discountColor,
                        )
                      ],
                    ),
                  if (appConfigs.value.taxPercentage.isNotEmpty)
                    if (appConfigs.value.taxPercentage.isNotEmpty && !isRent) ...[
                      Row(
                        children: [
                          Text(locale.value.tax, style: commonPrimaryTextStyle()).expand(),
                          Wrap(
                            spacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              PriceWidget(
                                price: subscriptionCont.totalTaxAmount.value,
                                isPercentage: false,
                                size: 16,
                                color: discountColor,
                              ),
                            ],
                          )
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: const Offstage(),
                        secondChild: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          decoration: boxDecorationDefault(
                            color: cardColor,
                            borderRadius: radius(4),
                          ),
                          child: AnimatedWrap(
                            listAnimationType: commonListAnimationType,
                            itemCount: appConfigs.value.taxPercentage.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${appConfigs.value.taxPercentage[index].title} (${appConfigs.value.taxPercentage[index].value}%)',
                                    style: commonSecondaryTextStyle(),
                                  ).expand(),
                                  PriceWidget(
                                    price: ((subscriptionCont.selectPlan.value.totalPrice - subscriptionCont.priceWithCouponDiscount.value) * appConfigs.value.taxPercentage[index].value) / 100,
                                    size: 14,
                                    color: lightGoldenRodYellow,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        crossFadeState: CrossFadeState.showSecond,
                        duration: Duration(milliseconds: 800),
                      ),
                    ],
                  Divider(color: lightDividerColor)
                ],
              ),
              secondChild: const Offstage(),
              crossFadeState: subscriptionCont.isExpanded.value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 600),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    subscriptionCont.isExpanded.value = !subscriptionCont.isExpanded.value;
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.value.pay,
                        style: commonSecondaryTextStyle(),
                      ),
                      2.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            final value = subscriptionCont.tempTotalAmount.value;
                            return PriceWidget(
                              price: isRent ? rentData!.discountedPrice : value,
                              color: primaryTextColor,
                              size: 18,
                            );
                          }),
                          if (subscriptionCont.discount.value != 0.0) 2.width,
                          6.width,
                          RotatedBox(
                            quarterTurns: subscriptionCont.isExpanded.isTrue ? 3 : 1,
                            child: const CachedImageWidget(
                              url: Assets.iconsCaretLeft,
                              height: 18,
                              width: 18,
                              color: darkGrayTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).expand(),
                Shimmer.fromColors(
                  baseColor: (buttonColor ?? descriptionTextColor).withValues(alpha: 1),
                  highlightColor: goldAnimatedColor,
                  enabled: false,
                  direction: ShimmerDirection.ltr,
                  period: const Duration(seconds: 2),
                  child: GestureDetector(
                    onTap: () async {
                      if (isProceedPayment) {
                        onCallBack?.call();
                      } else {
                        if (subscriptionCont.selectPlan.value.planType.isNotEmpty && subscriptionCont.selectPlan.value.planType.any((element) => element.slug == SubscriptionTitle.profileLimit)) {
                          final profileLimitType = subscriptionCont.selectPlan.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.profileLimit);
                          if (accountProfiles.length > profileLimitType.limit.value.toInt() && profileLimitType.limitationValue == 1) {
                            final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 3, screenPadding: 32);
                            Get.bottomSheet(
                              AppDialogWidget(
                                child: Column(
                                  spacing: 12,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconWidget(
                                      imgPath: Assets.iconsWarning,
                                      color: yellowColor,
                                      size: 28,
                                    ),
                                    Text(
                                      locale.value.profileLimitIncreaseMessage(planName: subscriptionCont.selectPlan.value.name, limit: profileLimitType.limit.value.toInt()),
                                      style: boldTextStyle(),
                                      textAlign: TextAlign.center,
                                    ),
                                    8.height,
                                    Obx(
                                      () => AnimatedWrap(
                                        spacing: dynamicSpacing.$2,
                                        runSpacing: dynamicSpacing.$2,
                                        itemCount: accountProfiles.length,
                                        itemBuilder: (context, index) {
                                          WatchingProfileModel profile = accountProfiles[index];
                                          return Obx(
                                            () => ProfileComponent(
                                              profile: profile,
                                              imageSize: dynamicSpacing.$1,
                                              isEdit: true,
                                              showEdit: false,
                                              onRefreshCallback: () {
                                                if (Get.isDialogOpen == true) {
                                                  Get.back();
                                                }
                                              },
                                              showDelete: (accountProfiles.where((element) => element.isChildProfile == 0).length > 1 && selectedAccountProfile.value.id != profile.id),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    8.height,
                                    Obx(
                                      () => AppButton(
                                        width: Get.width / 2,
                                        text: buttonText ?? locale.value.next,
                                        color: appColorPrimary,
                                        textStyle: appButtonTextStyleWhite,
                                        disabledColor: btnColor,
                                        enabled: accountProfiles.length <= profileLimitType.limit.value.toInt(),
                                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(6)),
                                        onTap: () {
                                          Get.back();
                                          navigateToScreen();
                                        },
                                      ),
                                    )
                                  ],
                                ).paddingSymmetric(
                                  horizontal: 12,
                                ),
                              ),
                              isScrollControlled: true,
                            );
                          } else {
                            navigateToScreen();
                          }
                        } else {
                          navigateToScreen();
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: boxDecorationDefault(
                        color: (buttonColor ?? descriptionTextColor).withValues(alpha: 0.00),
                        border: Border.all(color: buttonColor ?? descriptionTextColor),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        buttonText ?? locale.value.next,
                        style: appButtonTextStyleWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void navigateToScreen() {
    Get.to(
      () => PaymentScreen(),
      arguments: [
        if (isRent) ...[
          contentDetails,
          rentData,
        ] else ...[
          contentDetails,
          subscriptionCont.selectPlan.value,
          subscriptionCont.totalAmount.value,
          subscriptionCont.discount.value,
        ],
      ],
    );
  }
}