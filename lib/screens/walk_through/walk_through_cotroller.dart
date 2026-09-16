import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';

class WalkThroughController extends BaseController {
  RxInt currentPosition = 0.obs;
  Rx<PageController> pageController = PageController().obs;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    pageController(PageController(initialPage: 0));
  }

  @override
  void onClose() {
    pageController.value.dispose();
    super.onClose();
  }
}