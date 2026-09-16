import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/network/network_utils.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class RazorPayService {
  static late Razorpay razorPay;
  static late String publicKey;
  static late String secretKey;
  num totalAmount = 0;

  String orderId = '';
  late Function(Map<String, dynamic>) onComplete;

  Future<bool> init({
    required String razorPublicKey,
    required String razorSecretKey,
    required num totalAmount,
    required int selectedPlanId,
    required Function(Map<String, dynamic>) onComplete,
  }) async {
    razorPay = Razorpay();

    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    publicKey = razorPublicKey;
    secretKey = razorSecretKey;
    this.totalAmount = totalAmount;
    this.onComplete = onComplete;
    log('-----------------------------------');
    log('totalAmount: $totalAmount');
    log('-----------------------------------');
    final data = await createRazorPayOrder(amount: totalAmount);

    if (data != null && data is Map<String, dynamic> && data.containsKey('id') && data['id'] is String && data['id'].isNotEmpty) {
      orderId = data['id'];
      return true;
    } else {
      return false;
    }
  }

  Future handlePaymentSuccess(PaymentSuccessResponse response) async {
    //Todo:
    // Capture the payment
    onComplete.call({
      'transaction_id': response.paymentId,
      'status': 'captured',
    });
    /*final bool captured = await captureRazorPayPayment(
      paymentId: response.paymentId!,
      amount: totalAmount,
    );

    if (captured) {
      onComplete.call({
        'transaction_id': response.paymentId,
        'status': 'captured',
      });
    } else {
      toast("Payment not captured. Please contact support.", print: true);
    }*/
  }

  void handlePaymentError(PaymentFailureResponse response) {
    toast(locale.value.paymentFailedMessage, print: true);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    if (response.walletName != null) {
      toast(response.walletName);
    }
  }

  Future<void> razorPayCheckout() async {
    final options = {
      'key': publicKey,
      'amount': (totalAmount * 100).round(),
      'name': APP_NAME,
      'theme.color': appColorPrimary.toHex(),
      'payment_capture': 1,
      if (orderId.isNotEmpty) 'order_id': orderId,
      'description': APP_NAME,
      'image': APP_MINI_LOGO_URL,
      'currency': await isIqonicProduct ? commonSupportedCurrency : appCurrency.value.currencyCode,
      'prefill': {'contact': loginUserData.value.mobile, 'email': loginUserData.value.email},
      'external': {
        'wallets': ['paytm']
      },
    };
    try {
      razorPay.open(options);
    } catch (e) {
      log("error in RazorPay:$e");
    }
  }

  String generateReceipt() {
    return "Receipt-${DateTime.now().millisecondsSinceEpoch}";
  }

  Future<dynamic> createRazorPayOrder({
    required num amount,
  }) async {
    final currency = await isIqonicProduct ? commonSupportedCurrency : appCurrency.value.currencyCode;
    final response = await getRemoteDataFromUrl(
      endPoint: 'https://api.razorpay.com/v1/orders',
      request: {
        "amount": (amount * 100).round(),
        "currency": currency,
        "receipt": generateReceipt(),
        "payment_capture": 1,
      },
      header: buildHeaderForRazorpay(secretKey, publicKey),
    );

    if (response != null) {
      log('-----------------------------------');
      log(response);
      log('-----------------------------------');
      return response;
    } else {
      return null;
    }
  }

  Future<bool> captureRazorPayPayment({
    required String paymentId,
    required num amount,
  }) async {
    final response = await getRemoteDataFromUrl(
      endPoint: 'https://api.razorpay.com/v1/payments/$paymentId/capture',
      request: {
        "amount": (amount * 100).round(),
        'currency': await isIqonicProduct ? commonSupportedCurrency : appCurrency.value.currencyCode,
      },
      header: buildHeaderForRazorpay(secretKey, publicKey),
    );

    log('-----------------------------------');
    log(jsonDecode(response));
    log('-----------------------------------');

    if (response != null) {
      final data = jsonDecode(response);
      if (data is Map<String, dynamic> && data.containsKey('status')) {
        log('-----------------------------------');
        log(data['status']);
        log('-----------------------------------');
        return data['status'] == 'captured';
      }
    }

    return false;
  }
}