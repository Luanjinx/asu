import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/auth/model/app_configuration_res.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/coupon/model/coupon_list_model.dart';
import 'package:streamit_laravel/screens/payment/model/payment_model.dart';
import 'package:streamit_laravel/screens/payment/model/subscription_model.dart';
import 'package:streamit_laravel/screens/payment/payment_gateways/pay_pal_service.dart';
import 'package:streamit_laravel/screens/subscription/subscription_controller.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../coupon/coupon_list_controller.dart';
import '../subscription/model/subscription_plan_model.dart';
import 'payment_gateways/flutter_wave_service.dart';
import 'payment_gateways/pay_stack_service.dart';
import 'payment_gateways/razor_pay_service.dart';
import 'payment_gateways/stripe_services.dart';

class PaymentController extends BaseController {
  RxBool showCoupon = false.obs;
  RxBool isPaymentLoading = false.obs;
  RxString paymentOption = PaymentMethods.PAYMENT_METHOD_STRIPE.obs;
  RxList<PaymentSetting> originalPaymentList = RxList();
  Rx<SubscriptionPlanModel> selectPlan = SubscriptionPlanModel().obs;
  RxDouble price = 0.0.obs;
  RxDouble discount = 0.0.obs;
  RxDouble rentPrice = 0.0.obs;
  RxBool isRent = false.obs;
  Rx<PaymentSetting> selectPayment = PaymentSetting().obs;
  ContentData contentData = ContentData();
  ContentModel contentModel = ContentModel(details: ContentData(), downloadData: DownloadDataModel());
  RentalData rentalData = RentalData();

  // Payment Class
  RazorPayService razorPayService = RazorPayService();
  PayStackService paystackServices = PayStackService();

  PayPalService payPalService = PayPalService();
  FlutterWaveService flutterWaveServices = FlutterWaveService();
  Rx<Future<RxBool>> paymentListFuture = Future(() => false.obs).obs;

  // Coupon
  CouponListController couponController = CouponListController();

  PaymentMethod availablePaymentMethods = PaymentMethod(
    razorPay: RazorPay(),
    stripePay: StripePay(),
    payStackPay: PayStackPay(),
    paypalPay: PaypalPay(),
    flutterWavePay: FlutterwavePay(),
    inAppPurchase: InAppPurchase(),
  );

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is List && args.isNotEmpty) {
      if (args[0] is ContentModel) {
        contentModel = (args[0] as ContentModel);
        contentData = (args[0] as ContentModel).details;
        contentData.id = (args[0] as ContentModel).id;
        update([contentData]);
      }
      if (args[1] is SubscriptionPlanModel) {
        selectPlan.value = args[1] as SubscriptionPlanModel;
        price.value = args[2];
        discount.value = args[3];
      } else if (args[1] is RentalData) {
        rentalData = (args[1] as RentalData);
        update([rentalData]);
        rentPrice.value = rentalData.discountedPrice.validate().toDouble();
        discount.value = rentalData.discount.toDouble();
        isRent.value = true;
      }
    }
    allApisCalls();
    super.onInit();
  }

  Future<void> allApisCalls() async {
    /// Fetch Coupon List
    fetchCouponList();
    await getAppConfigurations();
  }

  Future<void> fetchCouponList() async {
    if (isRent.value) return;
    setLoading(true);
    await couponController.getListData(selectedPlanId: selectPlan.value.planId.toString()).then((value) {
      couponController.listContent.removeWhere((coupon) => coupon.discountType == Tax.fixed && coupon.discount.validate().toDouble() >= selectPlan.value.totalPrice.toDouble());
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      log('Coupon List Error: ${error.toString()}');
    });
  }

  Future<void> getAppConfigurations() async {
    isPaymentLoading(true);
    setLoading(true);
    await CoreServiceApis.getAvailablePaymentMethods().then((value) async {
      availablePaymentMethods = value.data;
      showCoupon.value = true;
      update([availablePaymentMethods]);

      paymentListFuture(Future(() async => getPayment())).whenComplete(() => setLoading(false));
    }).onError((error, stackTrace) {
      toast(error.toString());
    }).whenComplete(() {
      setLoading(false);
      isPaymentLoading(false);
    });
  }

  ///Get Payment List
  Future<RxBool> getPayment({bool showLoader = true}) async {
    isLoading(showLoader);
    originalPaymentList.clear();
    if (availablePaymentMethods.stripePay.stripePublicKey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 0,
          title: locale.value.stripePay,
          type: PaymentMethods.PAYMENT_METHOD_STRIPE,
          liveValue: LiveValue(stripePublickey: availablePaymentMethods.stripePay.stripePublicKey, stripeKey: availablePaymentMethods.stripePay.stripeSecretKey),
        ),
      );
    }
    if (availablePaymentMethods.razorPay.razorpayPublicKey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 1,
          title: locale.value.razorPay,
          type: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
          liveValue: LiveValue(razorKey: availablePaymentMethods.razorPay.razorpayPublicKey, razorSecret: availablePaymentMethods.razorPay.razorpaySecretKey),
        ),
      );
    }
    if (availablePaymentMethods.payStackPay.payStackPublicKey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 2,
          title: locale.value.payStackPay,
          type: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
          liveValue: LiveValue(paystackPublicKey: availablePaymentMethods.payStackPay.payStackPublicKey, paystackSecrateKey: availablePaymentMethods.payStackPay.payStackPublicKey),
        ),
      );
    }
    if (availablePaymentMethods.paypalPay.paypalClientId.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 3,
          title: locale.value.paypalPay,
          type: PaymentMethods.PAYMENT_METHOD_PAYPAL,
          liveValue: LiveValue(
            payPalClientId: availablePaymentMethods.paypalPay.paypalClientId,
            payPalSecretKey: availablePaymentMethods.paypalPay.paypalSecretKey,
          ),
        ),
      );
    }
    if (availablePaymentMethods.flutterWavePay.flutterwavePublickey.isNotEmpty) {
      originalPaymentList.add(
        PaymentSetting(
          id: 4,
          title: locale.value.flutterWavePay,
          type: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
          liveValue: LiveValue(
            flutterwavePublic: availablePaymentMethods.flutterWavePay.flutterwavePublickey,
            flutterwaveSecret: availablePaymentMethods.flutterWavePay.flutterwaveSecretkey,
          ),
        ),
      );
    }
    if (!isRent.value &&
        availablePaymentMethods.inAppPurchase.entitlementId.isNotEmpty &&
        (isIOS ? availablePaymentMethods.inAppPurchase.appleApiKey.isNotEmpty : availablePaymentMethods.inAppPurchase.googleApiKey.isNotEmpty)) {
      originalPaymentList.add(
        PaymentSetting(
          id: 5,
          title: locale.value.inAppPurchase,
          type: PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE,
        ),
      );
    }
    setLoading(false);

    return true.obs;
  }

  void handlePaymentSelection(PaymentSetting data) {
    selectPayment.value = data;
    paymentOption.value = data.type.validate();
    showCoupon(paymentOption.value != PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE && !isRent.value);
    update([selectPayment, paymentOption]);
  }

  /// handle Payment Click

  void handlePayNowClick(BuildContext context, VoidCallback onSuccess) {
    Get.bottomSheet(
      AppDialogWidget(
        title: "${isRent.value ? locale.value.doYouConfirmThis(contentData.name) : locale.value.doYouConfirmThisPlanWithPlanName(selectPlan.value.name)}",
        onAccept: () {
          if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
            payWithStripe(context, onSuccess);
          } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
            payWithRazorPay(context, onSuccess);
          } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
            payWithPayStack(context, onSuccess);
          } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
            payWithFlutterWave(context, onSuccess);
          } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYPAL) {
            payWithPaypal(context, onSuccess);
          } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE) {
            payWithInAppPurchase(onSuccess);
          }
        },
        image: isRent.value ? Assets.imagesRental : Assets.iconsCrown,
        imageColor: appColorPrimary,
        positiveText: locale.value.confirm,
        negativeText: locale.value.cancel,
      ),
    );
  }

  Future<void> payWithStripe(BuildContext context, VoidCallback onSuccess) async {
    await StripeServices.stripePaymentMethod(
      publicKey: availablePaymentMethods.stripePay.stripePublicKey,
      secretKey: availablePaymentMethods.stripePay.stripeSecretKey,
      loaderOnOff: (p0) {
        isLoading(p0);
      },
      amount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE,
            onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE,
            onSuccess: onSuccess,
          );
        }
      },
    ).catchError(onError);
  }

  Future<void> payWithRazorPay(BuildContext context, VoidCallback onSuccess) async {
    setLoading(true);
    final isOrderCreated = await razorPayService
        .init(
      razorPublicKey: availablePaymentMethods.razorPay.razorpayPublicKey,
      razorSecretKey: availablePaymentMethods.razorPay.razorpaySecretKey,
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      selectedPlanId: selectPlan.value.id,
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
            onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(transactionId: res["transaction_id"].toString(), paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY, onSuccess: onSuccess);
        }
      },
    )
        .catchError((e) {
      setLoading(false);
      toast(e.toString());
      return false;
    });

    if (isOrderCreated) {
      setLoading(false);
      await Future.delayed(const Duration(seconds: 1));
      razorPayService.razorPayCheckout();
    } else {
      setLoading(false);
      toast(locale.value.failedInitiateRazorpayPayment);
    }
  }

  Future<void> payWithPayStack(BuildContext context, VoidCallback onSuccess) async {
    setLoading(true);
    await paystackServices.init(
      publicKey: availablePaymentMethods.payStackPay.payStackPublicKey,
      loaderOnOff: (p0) {
        isLoading(p0);
      },
      ctx: context,
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
            onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
            onSuccess: onSuccess,
          );
        }
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
    if (Get.context != null) {
      paystackServices.checkout();
    } else {
      toast(locale.value.contextNotFound);
    }
  }

  void payWithPaypal(BuildContext context, VoidCallback onSuccess) {
    setLoading(true);
    payPalService.paypalCheckOut(
      secretKey: availablePaymentMethods.paypalPay.paypalSecretKey,
      clientId: availablePaymentMethods.paypalPay.paypalClientId,
      context: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL,
            onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL,
            onSuccess: onSuccess,
          );
        }
        // toast("==============Completed=================", print: true);
        //saveSubscriptionPlan(paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL, txnId: res["transaction_id"], paymentStatus: PaymentStatus.PAID);
      },
    );
  }

  Future<void> payWithFlutterWave(BuildContext context, VoidCallback onSuccess) async {
    setLoading(true);
    flutterWaveServices.checkout(
      secretKey: availablePaymentMethods.flutterWavePay.flutterwaveSecretkey,
      publicKey: availablePaymentMethods.flutterWavePay.flutterwavePublickey,
      ctx: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isRent.value ? rentPrice.value.validate() : price.value.validate(),
      isTestMode: availablePaymentMethods.flutterWavePay.flutterwavePublickey.toLowerCase().contains("test"),
      onComplete: (res) {
        if (isRent.value) {
          saveRentDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
            onSuccess: onSuccess,
          );
        } else {
          saveSubscriptionDetails(
            transactionId: res["transaction_id"].toString(),
            paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
            onSuccess: onSuccess,
          );
        }
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    setLoading(false);
  }

  void payWithInAppPurchase(VoidCallback onSuccess) {
    final InAppPurchase inAppPurchase = availablePaymentMethods.inAppPurchase;
    setLoading(true);
    inAppPurchaseService.init(apiKey: isIOS ? inAppPurchase.appleApiKey : inAppPurchase.googleApiKey).then(
      (value) {
        setLoading(false);
        final selectedRevenueCatPackage = inAppPurchaseService.getSelectedPlanFromRevenueCat(selectPlan.value);
        if (selectedRevenueCatPackage != null) {
          inAppPurchaseService.startPurchase(
            selectedRevenueCatPackage: selectedRevenueCatPackage,
            onComplete: (transactionId) {
              saveSubscriptionDetails(
                transactionId: transactionId,
                paymentType: PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE,
                onSuccess: onSuccess,
              );
            },
          );
        } else {
          toast(locale.value.cantFindPlanOnStore(selectPlan.value.name, isIOS ? 'Appstore' : "PlayStore"));
        }
      },
    );
  }

//saveSubscriptionDetails

  Future<void> saveSubscriptionDetails({required String transactionId, required String paymentType, required VoidCallback onSuccess}) async {
    if (isLoading.value) return;
    setLoading(true);
    Map<String, dynamic> request = {
      ApiRequestKeys.planIdKey: selectPlan.value.planId,
      ApiRequestKeys.userIdKey: loginUserData.value.id,
      ApiRequestKeys.identifierKey: selectPlan.value.name.validate(),
      ApiRequestKeys.paymentStatusKey: PaymentStatus.PAID,
      ApiRequestKeys.paymentTypeKey: paymentType,
      ApiRequestKeys.transactionIdKey: transactionId.validate(),
      ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
      ApiRequestKeys.paymentDate: DateTime.now().toString(),
    };

    if (couponController.appliedCouponData.value.code.isNotEmpty) {
      request.putIfAbsent(ApiRequestKeys.couponIdKey, () => couponController.appliedCouponData.value.id);
    }

    if (paymentType == PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE) {
      request.putIfAbsent(
        ApiRequestKeys.activeInAppPurchaseIdentifierKey,
        () => isIOS ? selectPlan.value.appleInAppPurchaseIdentifier : selectPlan.value.googleInAppPurchaseIdentifier,
      );
    }
    await CoreServiceApis.saveSubscriptionDetails(request: request).then((value) async {
      Get.back();
      Get.back();
      onSuccess.call();
      updateSubscriptionDetails(value);
    }).catchError((e) {
      setLoading(false);
      errorSnackBar(error: e);
    }).whenComplete(() {
      setLoading(false);
    });
  }

  void updateSubscriptionDetails(SubscriptionResponseModel value) {
    currentSubscription(value.data);
    if (currentSubscription.value.level > -1 && currentSubscription.value.planType.isNotEmpty && currentSubscription.value.planType.any((element) => element.slug == SubscriptionTitle.videoCast)) {
      isCastingSupported(currentSubscription.value.planType.firstWhere((element) => element.slug == SubscriptionTitle.videoCast).limitationValue.getBoolInt());
    } else {
      isCastingSupported(false);
    }
    currentSubscription.value.activePlanInAppPurchaseIdentifier = isIOS ? currentSubscription.value.appleInAppPurchaseIdentifier : currentSubscription.value.googleInAppPurchaseIdentifier;
    setJsonToLocal(SharedPreferenceConst.CACHE_USER_SUBSCRIPTION_DATA, value.data.toJson());
    setJsonToLocal(SharedPreferenceConst.USER_DATA, loginUserData.toJson());
  }

  Future<void> saveRentDetails({required String transactionId, required String paymentType, required VoidCallback onSuccess}) async {
    if (isLoading.value) return;
    setLoading(true);
    String typeValue = contentData.type.validate();
    final Map<String, dynamic> request = {
      ApiRequestKeys.userIdKey: loginUserData.value.id,
      "price": rentalData.discountedPrice.validate(),
      "discount": rentalData.discount.validate(),
      "payment_status": PaymentStatus.PAID,
      "payment_type": paymentType,
      "transaction_id": transactionId.validate(),
      "purchase_type": 'rental',
      "access_duration": rentalData.accessDuration.validate(),
      "available_for": rentalData.availabilityDays.validate(),
      "movie_id": contentModel.id.validate(),
      ApiRequestKeys.typeKey: typeValue,
    };

    await CoreServiceApis.saveRentDetails(request: request).then((value) async {
      Get.back();
      onSuccess.call();
    }).catchError((e) {
      if (e is Map && e.containsKey('message')) {
        errorSnackBar(error: e['message']);
        return;
      }
      errorSnackBar(error: e);
    }).whenComplete(() async {
      setLoading(false);
    });
  }

  void removeAppliedCoupon({bool isDataFetch = true}) {
    if (isRent.value) return;
    couponController.appliedCouponData.value.isCouponApplied = false;
    couponController.appliedCouponData.value = CouponDataModel();
    SubscriptionController subscriptionController = Get.find<SubscriptionController>();
    subscriptionController.calculateTotalPrice();

    /// Fetch Coupon List
    if (isDataFetch) fetchCouponList();
  }

  @override
  void onClose() {
    removeAppliedCoupon();
    super.onClose();
  }
}