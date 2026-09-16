// ignore_for_file: deprecated_member_use
import 'package:get/get.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';

class FloatingController extends BaseController {
  RxBool isExpanded = false.obs;

  void toggle() {
    isExpanded.value = !isExpanded.value;
    if (isExpanded.value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void onClose() {
    // _controller.dispose();
    super.onClose();
  }
}