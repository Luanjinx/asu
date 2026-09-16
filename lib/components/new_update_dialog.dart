import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/configs.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../main.dart';

class NewUpdateDialog extends StatelessWidget {
  final String version;
  final List<String> updates;
  final VoidCallback onUpdate;
  final VoidCallback onCancel;

  const NewUpdateDialog({
    super.key,
    required this.version,
    required this.updates,
    required this.onUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: ResponsiveSize.getHorizontalOnly(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient + Rocket
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 140,
                width: Get.width,
                decoration: boxDecorationDefault(
                  color: cardColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Lottie.asset(
                  Assets.lottieIcNewUpdate,
                  width: 150,
                  height: 150,
                ),
              ),
            ],
          ),
          // White Card Section
          Blur(
            child: Container(
              padding: ResponsiveSize.getSymmetricPadding(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$APP_NAME v$version', style: boldTextStyle(size: ResponsiveSize.getFontSize(20))),
                  const SizedBox(height: 12),
                  TypingAnimatedText(
                    valueKey: "Updates",
                    updates: updates,
                  ),
                  const SizedBox(height: 24),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: borderColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            locale.value.cancel,
                            style: commonPrimaryTextStyle(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(locale.value.updrade, style: boldTextStyle()),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TypingAnimatedText extends StatelessWidget {
  final bool isCenterText;
  final String valueKey;
  final List<String> updates;

  const TypingAnimatedText({super.key, required this.updates, required this.valueKey, this.isCenterText = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TypingController>(
      tag: valueKey, // ✅ ensures a unique instance per key
      init: TypingController()..startTyping(updates),
      builder: (controller) {
        return Obx(
          () {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controller.visibleTexts
                  .map(
                    (text) => Text(
                      text,
                      style: commonPrimaryTextStyle(),
                      textAlign: isCenterText ? TextAlign.center : TextAlign.start,
                    ).paddingOnly(bottom: 4),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}

class TypingController extends GetxController {
  RxList visibleTexts = <String>[].obs;

  void startTyping(List<String> updates, {Duration speed = const Duration(milliseconds: 50)}) {
    visibleTexts.clear();

    int lineIndex = 0;
    int charIndex = 0;
    final buffer = StringBuffer();

    Timer.periodic(speed, (timer) {
      if (lineIndex >= updates.length) {
        timer.cancel();
        return;
      }

      final fullLine = updates[lineIndex];

      if (charIndex < fullLine.length) {
        buffer.write(fullLine[charIndex]);
        if (visibleTexts.length <= lineIndex) {
          visibleTexts.add(buffer.toString());
        } else {
          visibleTexts[lineIndex] = buffer.toString();
        }
        charIndex++;
      } else {
        // move to next line
        lineIndex++;
        charIndex = 0;
        buffer.clear(); // clear buffer for next line
      }
    });
  }
}