import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePinController extends GetxController {
  RxBool isBtnEnable = false.obs;

  final TextEditingController pinController = TextEditingController();

  void enableSubmitButton() {
    isBtnEnable.value = pinController.text.isNotEmpty;
  }

  void onUpdatePin() {
    isBtnEnable.value = pinController.text.isNotEmpty;
  }
}