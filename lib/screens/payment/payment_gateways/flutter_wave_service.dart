import 'package:flutter/material.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/network_utils.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:uuid/uuid.dart';

class FlutterWaveService {
  final Customer customer = Customer(
    name: loginUserData.value.firstName,
    phoneNumber: loginUserData.value.mobile,
    email: loginUserData.value.email,
  );

  Future<void> checkout({
    required BuildContext ctx,
    required num totalAmount,
    required bool isTestMode,
    required Function(Map<String, dynamic>) onComplete,
    required Function(bool) loderOnOFF,
    required String publicKey,
    required String secretKey,
  }) async {
    String transactionId = const Uuid().v1();

    Flutterwave flutterWave = Flutterwave(
      context: getContext,
      publicKey: publicKey,
      currency: appCurrency.value.currencyCode,
      redirectUrl: BASE_URL,
      txRef: transactionId,
      amount: totalAmount.validate().toStringAsFixed(Constants.DECIMAL_POINT),
      customer: customer,
      paymentOptions: "ussd, card, payattitude, barter, bank transfer",
      customization: Customization(title: APP_NAME, logo: APP_MINI_LOGO_URL),
      isTestMode: isTestMode,
    );

    await flutterWave.charge().then((value) {
      if (value.status == "successful") {
        verifyPayment(
          transactionId: value.transactionId.validate(),
          flutterWaveSecretKey: secretKey,
          loderOnOFF: loderOnOFF,
        ).then((isSuccess) async {
          if (isSuccess) {
            onComplete.call({
              'transaction_id': value.transactionId.validate(),
            });
          } else {
            toast(locale.value.paymentFailedMessage);
          }
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        toast(locale.value.paymentFailedMessage);
      }
    });
  }
}

//region FlutterWave Verify Transaction API
Future<bool> verifyPayment({required String transactionId, required String flutterWaveSecretKey, required Function(bool) loderOnOFF}) async {
  try {
    var res = await getApiResponse(
      "https://api.flutterwave.com/v3/transactions/$transactionId/verify",
      headers: buildHeaderForFlutterWave(flutterWaveSecretKey),
    );

    loderOnOFF.call(false);
    return res["status"] == "success";
  } catch (e) {
    if (e is Map<String, dynamic> && e.containsKey('message')) {
      toast(e['message'] ?? e['error_message']);
      return false;
    }
    toast(e.toString(), print: true);
  }
  return false;
}
//endregion