// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/network/auth_apis.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';

import '../../../utils/common_base.dart';

class ForgotPasswordController extends BaseController {
  RxBool isBtnEnable = false.obs;
  RxBool isResetLinSent = false.obs;
  final GlobalKey<FormState> forgotPassFormKey = GlobalKey();

  TextEditingController emailCont = TextEditingController();
  TextEditingController verifyCont = TextEditingController();

  @override
  void onClose() {
    emailCont.clear();
    super.onClose();
  }

  Future<void> saveForm() async {
    if (isLoading.value) return;

    setLoading(true);
    hideKeyBoardWithoutContext();
    Map<String, dynamic> req = {
      ApiRequestKeys.email: emailCont.text.trim(),
    };

    await AuthServiceApis.forgotPasswordApi(request: req).then((value) async {
      setLoading(false);
      emailCont.clear();
      isBtnEnable(false);
      isResetLinSent(true);
      successSnackBar(value.message);
    }).catchError((e) {
      setLoading(false);
      if (e is Map) {
        toast(e['error_message'].toString(), print: true);
      } else {
        toast(e.toString(), print: true);
      }
    });
  }

  void getBtnEnable() {
    if (emailCont.text.isNotEmpty) {
      isBtnEnable(true);
    } else {
      isBtnEnable(false);
    }
  }
}