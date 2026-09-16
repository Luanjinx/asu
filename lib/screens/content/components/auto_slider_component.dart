import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/utils/colors.dart';

class AutoSliderComponent extends StatelessWidget {
  final int sliderLength;
  final double height;

  final bool isAutoSlide;
  final List<Widget> sliderChildren;
  final Widget? positionChild;
  final String? tag;

  late final String _instanceTag = tag ?? UniqueKey().toString();

  late final AutoSliderController autoSliderController;

  AutoSliderComponent({
    super.key,
    required this.height,
    required this.sliderLength,
    required this.sliderChildren,
    this.positionChild,
    this.tag,
    this.isAutoSlide = true,
  }) {
    autoSliderController = Get.isRegistered<AutoSliderController>(tag: _instanceTag)
        ? Get.find<AutoSliderController>(tag: _instanceTag)
        : Get.put<AutoSliderController>(
            AutoSliderController(
              sliderLength,
              isAutoSlide,
            ),
            tag: _instanceTag,
          );
    autoSliderController.isAutoSlide = isAutoSlide;
    autoSliderController.sliderLength = sliderLength;
  }

  @override
  Widget build(BuildContext context) {
    if (sliderLength == 0) return const Offstage();

    return GetBuilder<AutoSliderController>(
      init: autoSliderController,
      tag: _instanceTag,
      autoRemove: false,
      builder: (controller) {
        return Stack(
          children: [
            SizedBox(
              height: height,
              width: Get.width,
              child: PageView(
                controller: autoSliderController.pageController,
                children: sliderChildren,
              ),
            ),
            positionChild ?? Offstage(),
            if (sliderLength > 1)
              PositionedDirectional(
                bottom: 0,
                start: 16,
                end: 16,
                child: DotIndicator(
                  pageController: autoSliderController.pageController,
                  pages: sliderChildren,
                  indicatorColor: white,
                  unselectedIndicatorColor: darkGrayColor,
                  currentBoxShape: BoxShape.rectangle,
                  boxShape: BoxShape.rectangle,
                  borderRadius: radius(3),
                  currentBorderRadius: radius(3),
                  currentDotSize: 12,
                  currentDotWidth: 6,
                  dotSize: 6,
                ),
              )
          ],
        );
      },
    );
  }
}

class AutoSliderController extends GetxController {
  int sliderLength;

  bool isAutoSlide;
  PageController pageController = PageController(initialPage: 0);
  late final VoidCallback pageListener;
  int currentPage = 0;
  Timer? sliderTimer;

  AutoSliderController(this.sliderLength, this.isAutoSlide);

  @override
  void onInit() {
    super.onInit();
    pageListener = () {
      currentPage = pageController.page.validate().toInt();
    };
    pageController = PageController(initialPage: currentPage);
    pageController.addListener(pageListener);
    if (isAutoSlide) startAutoSlider();
  }

  void startAutoSlider() {
    // Cancel existing timer to avoid duplicates
    sliderTimer?.cancel();

    if (sliderLength >= 2) {
      sliderTimer = Timer.periodic(
        const Duration(milliseconds: AUTO_SLIDER_SECOND),
        (Timer timer) {
          _animateToNextPage();
        },
      );
    }
  }

  void stopAutoSlider() {
    sliderTimer?.cancel();
  }

  void nextPage() {
    stopAutoSlider();
    _animateToNextPage();
    startAutoSlider();
  }

  void _animateToNextPage() {
    if (currentPage < sliderLength - 1) {
      currentPage++;
    } else {
      currentPage = 0;
    }

    if (pageController.hasClients) {
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 950),
        curve: Curves.easeInToLinear,
      );
    }
  }

  @override
  void onClose() {
    sliderTimer?.cancel();
    pageController.removeListener(pageListener);
    // Defer disposal to avoid build-phase access on a just-disposed controller
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.dispose();
    });
    super.onClose();
  }
}