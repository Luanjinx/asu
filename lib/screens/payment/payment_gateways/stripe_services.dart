// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/main.dart';

import '../../../configs.dart';
import '../../../network/network_utils.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_functions.dart';

class StripeServices {
  static Future<void> stripePaymentMethod({
    required num amount,
    required Function(bool) loaderOnOff,
    required Function(Map<String, dynamic>) onComplete,
    required String publicKey,
    required String secretKey,
  }) async {
    loaderOnOff(true);
    try {
      Stripe.publishableKey = publicKey;
      Stripe.merchantIdentifier = STRIPE_merchantIdentifier;

      await Stripe.instance.applySettings().catchError((e) {
        toast(e.toString(), print: true);
        throw e.toString();
      });
      final paysheetData = await getStripePaymentIntents(
        amount: amount,
        loaderOnOff: loaderOnOff,
        secretKey: secretKey,
        addressLine1: loginUserData.value.address != '' ? loginUserData.value.address : 'No Address Line 1',
        city: loginUserData.value.address != '' ? loginUserData.value.address : 'No City',
        country: defaultCountry.countryCode,
        email: loginUserData.value.email,
        name: loginUserData.value.firstName,
        postalCode: '000000',
      );
      String? clientSecret = paysheetData == null ? null : paysheetData["client_secret"];
      String? tnxId = paysheetData == null ? null : paysheetData["transaction_id"];
      SetupPaymentSheetParameters setupPaymentSheetParameters = SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        style: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        appearance: const PaymentSheetAppearance(colors: PaymentSheetAppearanceColors(primary: appColorPrimary)),
        merchantDisplayName: APP_NAME,
        customerId: loginUserData.value.email,
        setupIntentClientSecret: clientSecret,
        billingDetails: BillingDetails(
          name: loginUserData.value.firstName,
          email: loginUserData.value.email,
          phone: loginUserData.value.mobile,
          address: Address(
            city: loginUserData.value.address != '' ? loginUserData.value.address : 'No City',
            country: defaultCountry.countryCode,
            line1: loginUserData.value.address != '' ? loginUserData.value.address : 'No Address Line 1',
            line2: loginUserData.value.address != '' ? loginUserData.value.address : 'No Address Line 2',
            postalCode: "000000",
            state: loginUserData.value.address != '' ? loginUserData.value.address : 'No State',
          ),
        ),
      );

      await Stripe.instance.initPaymentSheet(paymentSheetParameters: setupPaymentSheetParameters).then((value) async {
        await Stripe.instance.presentPaymentSheet().then((val) async {
          onComplete.call({
            'transaction_id': tnxId,
          });
        }).catchError((e) {
          toast(locale.value.paymentFailedMessage);
          loaderOnOff.call(false);
          log('Stripe present sheet method: $e');
        });
      }).catchError((e) {
        toast(e.toString());
        loaderOnOff.call(false);
        log('Stripe init sheet method: $e');
      });
    } catch (e) {
      toast(e.toString());
      loaderOnOff.call(false);
      log('stripePaymentMethod catch: $e');
    }
  }

  static Future<Map<String, dynamic>?> getStripePaymentIntents({
    required num amount,
    required String secretKey,
    required Function(bool) loaderOnOff,
    required String email,
    required String name,
    required String addressLine1,
    required String city,
    required String country,
    required String postalCode,
  }) async {
    try {
      var headers = {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      var body = {
        'amount': (amount * 100).toInt().toString(),
        'currency': await isIqonicProduct ? STRIPE_CURRENCY_CODE : appCurrency.value.currencyCode,
        'description': 'Name: ${loginUserData.value.firstName} - Email: ${loginUserData.value.email}',
        'shipping[name]': name,
        'shipping[address][line1]': addressLine1,
        'shipping[address][city]': city,
        'shipping[address][country]': country,
        'shipping[address][postal_code]': postalCode,
        'receipt_email': email,
      };

      var dio = Dio();
      dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

      Response response = await dio.post(
        STRIPE_URL,
        data: body,
        options: Options(
          headers: headers,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      await apiPrint(
        url: STRIPE_URL,
        request: jsonEncode(body),
        responseBody: jsonEncode(response.data),
        statusCode: response.statusCode ?? 0,
      );

      if (response.statusCode == 200) {
        loaderOnOff.call(false);
        var res = response.data;
        var paymentDetail = {"transaction_id": res["id"], "client_secret": res["client_secret"]};
        return paymentDetail;
      } else {
        loaderOnOff.call(false);
      }
    } catch (e) {
      loaderOnOff.call(false);
      if (e is DioException) {
        toast(e.message ?? e.toString(), print: true);
      } else {
        toast(e.toString(), print: true);
      }
    }
    return null;
  }
}