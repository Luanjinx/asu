import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../network/core_api.dart';

class InAppPurchaseService extends BaseController {
  Rx<Offerings?> revenueCatSubscriptionOfferings = Rx<Offerings?>(null);

  Future<void> init({required String apiKey}) async {
    try {
      await Purchases.setLogLevel(LogLevel.error);

      if (apiKey.isNotEmpty) {
        PurchasesConfiguration configuration = PurchasesConfiguration(apiKey);
        await Purchases.configure(configuration);

        log('In App Purchase Configuration Successful');
        setBoolToLocal(SharedPreferenceConst.IS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE, true);

        if (isLoggedIn.value && !await getBoolFromLocal(SharedPreferenceConst.IS_IN_APP_USER_LOGIN_DONE_AT_LEASE_ONCE)) {
          await loginToRevenueCat();
        }

        initRevenueCat();
      }
    } catch (e) {
      log('In App Purchase Configuration Failed: $e');
    }
    log('In App Purchase Init Complete');
  }

  Future<void> loginToRevenueCat() async {
    try {
      await Purchases.logIn(loginUserData.value.email);
      log('In App Purchase User Login Successful');
      setBoolToLocal(SharedPreferenceConst.IS_IN_APP_USER_LOGIN_DONE_AT_LEASE_ONCE, true);
      await getCustomerInfo();
    } catch (e) {
      log('In App Purchase User Login Failed: $e');
    }
  }

  Future<void> initRevenueCat() async {
    setLoading(true);
    await getStoreSubscriptionPlanList().then((value) {
      revenueCatSubscriptionOfferings(value);
    }).whenComplete(
      () {
        setLoading(false);
      },
    ).catchError((e) {
      log("Can't find revenueCat offerings");
    });
  }

  Package? getSelectedPlanFromRevenueCat(SubscriptionPlanModel selectedPlan) {
    if (revenueCatSubscriptionOfferings.value != null && revenueCatSubscriptionOfferings.value!.current != null && revenueCatSubscriptionOfferings.value!.current!.availablePackages.isNotEmpty) {
      int index = revenueCatSubscriptionOfferings.value!.current!.availablePackages
          .indexWhere((element) => element.storeProduct.identifier == (isIOS ? selectedPlan.appleInAppPurchaseIdentifier : selectedPlan.googleInAppPurchaseIdentifier));
      if (index > -1) {
        return revenueCatSubscriptionOfferings.value!.current!.availablePackages[index];
      }
    } else {
      return null;
    }
    return null;
  }

  Future<CustomerInfo?> getCustomerInfo({bool restore = false}) async {
    try {
      Purchases.invalidateCustomerInfoCache();
      final customerData = await Purchases.getCustomerInfo();

      if (isLoggedIn.value) {
        await checkSubscriptionSync(customerData: customerData);
      }

      return customerData;
    } catch (e) {
      log('Failed to fetch customer info: $e');
      return null;
    }
  }

  Future<Offerings?> getStoreSubscriptionPlanList() async {
    //Todo: manage api key
    /*if (!getBoolAsync(SharedPreferenceConst.IS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    }*/
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      if (e is PlatformException) {
        toast(e.message, print: true);
      } else {
        log('getStoreSubscriptionPlanList error: $e');
      }
    }
    return null;
  }

  Future<void> startPurchase({
    required Package selectedRevenueCatPackage,
    required Function(String transactionId) onComplete,
  }) async {
    //Todo: manage api key
    /*if (!getBoolAsync(SharedPreferenceConst.IS_IN_APP_SDK_INITIALISE_AT_LEASE_ONCE)) {
      await init();
    }*/

    try {
      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(
          selectedRevenueCatPackage,
          productChangeInfo: currentSubscription.value.activePlanInAppPurchaseIdentifier.isNotEmpty
              ? StoreProductChangeInfo(
                  currentSubscription.value.activePlanInAppPurchaseIdentifier,
                )
              : null,
        ),
      );

      // Grab transaction/order ID
      final transactionId = purchaseResult.customerInfo.originalAppUserId;

      onComplete.call(transactionId);
    } catch (e) {
      if (e is PlatformException) {
        toast(e.message);
      } else if (e is PurchasesError) {
        toast(e.message);
      } else {
        toast(e.toString());
      }
    }
  }

  Future<void> checkSubscriptionSync({CustomerInfo? customerData}) async {
    try {
      customerData ??= await getCustomerInfo();

      if (customerData == null) return;

      if (currentSubscription.value.activePlanInAppPurchaseIdentifier.isNotEmpty && currentSubscription.value.status == SubscriptionStatus.active) {
        if (customerData.activeSubscriptions.isEmpty) {
          cancelCurrentSubscription();
        } else if (!customerData.activeSubscriptions.contains(currentSubscription.value.activePlanInAppPurchaseIdentifier)) {
          await retryPendingSubscriptionData();
        }
      }
    } catch (e) {
      log('checkSubscriptionSync error: $e');
    }
  }

  Future<void> retryPendingSubscriptionData() async {
    final SubscriptionPlanModel? planReq = await getPendingSubscriptionData();
    if (planReq != null) {
      try {
        await CoreServiceApis.saveSubscriptionDetails(
          request: {
            ApiRequestKeys.planIdKey: planReq.planId,
            ApiRequestKeys.userIdKey: loginUserData.value.id,
            ApiRequestKeys.identifierKey: planReq.name.validate(),
            ApiRequestKeys.paymentStatusKey: PaymentStatus.PAID,
            ApiRequestKeys.paymentTypeKey: PaymentMethods.PAYMENT_METHOD_IN_APP_PURCHASE,
            ApiRequestKeys.transactionIdKey: planReq.transactionId.validate(),
            ApiRequestKeys.deviceIdKey: currentDevice.value.deviceId,
            ApiRequestKeys.activeInAppPurchaseIdentifierKey: planReq.activePlanInAppPurchaseIdentifier,
          },
        );
        await clearPendingSubscriptionData();
      } catch (e) {
        setBoolToLocal(SharedPreferenceConst.IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED, true);
        setJsonToLocal(SharedPreferenceConst.PURCHASE_REQUEST, planReq.toJson());
        log('retryPendingSubscriptionData error: $e');
      }
    }
  }

  Future<SubscriptionPlanModel?> getPendingSubscriptionData() async {
    Map<String, dynamic>? purchaseRequest = await getJsonFromLocal(SharedPreferenceConst.PURCHASE_REQUEST) ?? null;
    if (purchaseRequest != null) {
      return SubscriptionPlanModel.fromJson(purchaseRequest);
    }
    return null;
  }

  Future<void> clearPendingSubscriptionData() async {
    removeValue(SharedPreferenceConst.IS_PURCHASE_STORED);
    removeValue(SharedPreferenceConst.PURCHASE_REQUEST);
    removeValue(SharedPreferenceConst.IS_SUBSCRIPTION_PURCHASE_RESTORE_REQUIRED);
  }

  void cancelCurrentSubscription() {
    CoreServiceApis.cancelSubscription(
      request: {"id": currentSubscription.value.id, "user_id": loginUserData.value.id},
    ).then((value) async {
      final userData = getJSONAsync(SharedPreferenceConst.USER_DATA);
      userData['plan_details'] = SubscriptionPlanModel().toJson();
      currentSubscription(SubscriptionPlanModel());
      isCastingSupported(false);
      currentSubscription.value.activePlanInAppPurchaseIdentifier = '';
      removeValue(SharedPreferenceConst.CACHE_USER_SUBSCRIPTION_DATA);
    }).catchError((e) {
      log('cancelCurrentSubscription error: $e');
    });
  }

  /// Explicit restore purchases (important for iOS "Restore Purchases" button)
  Future<CustomerInfo?> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      log('Restore Purchases Successful');
      await checkSubscriptionSync(customerData: customerInfo);
      return customerInfo;
    } catch (e) {
      log('Restore Purchases Failed: $e');
      return null;
    }
  }
}