import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/content_list_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../main.dart';
import 'floating_action_controller.dart';

class FloatingButton extends StatelessWidget {
  FloatingButton({super.key});

  FloatingController get floatingController => Get.find<FloatingController>();

  @override
  Widget build(BuildContext context) {
    final listMenu = [
      if (appConfigs.value.enableVideo) _buildFab(locale.value.videos),
      if (appConfigs.value.enableMovie) _buildFab(locale.value.movies),
      if (appConfigs.value.enableTvShow) _buildFab(locale.value.tVShows),
    ];
    return Obx(
      () => Stack(
        children: [
          PositionedDirectional(
            bottom: 44,
            top: -100,
            start: 0,
            end: 0,
            child: IgnorePointer(
              child: Container(
                height: 500,
                width: double.infinity,
                foregroundDecoration: BoxDecoration(
                  gradient: floatingController.isExpanded.isTrue
                      ? LinearGradient(
                          colors: [black.withValues(alpha: 0.0), black.withValues(alpha: 0.2), black.withValues(alpha: 0.4), black.withValues(alpha: 0.9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              24.height,
              if (floatingController.isExpanded.value) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: boxDecorationDefault(
                    color: cardColor.withValues(alpha: 0.8),
                    borderRadius: radius(28),
                  ),
                  child: Row(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: listMenu,
                  ),
                )
              ],
              24.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (listMenu.length > 1)
                    InkWell(
                      onTap: floatingController.toggle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: boxDecorationDefault(
                          borderRadius: BorderRadius.circular(32),
                          color: greyBtnColor,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale.value.all,
                              style: boldTextStyle(size: 16, weight: FontWeight.w600),
                            ),
                            6.width,
                            AnimatedIcon(
                              size: 18,
                              color: primaryTextColor,
                              icon: AnimatedIcons.menu_close,
                              progress: floatingController.animation,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...listMenu
                ],
              ),
              const SizedBox(height: 56)
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildFab(String label) {
  return InkWell(
    onTap: () {
      final FloatingController floatingController = Get.find<FloatingController>();
      if (label == locale.value.videos) {
        Get.to(() => ContentListScreen(), arguments: ArgumentModel(stringArgument: VideoType.video, extra: { 'banner': true }));
      } else if (label == locale.value.tVShows) {
        Get.to(() => ContentListScreen(), arguments: ArgumentModel(stringArgument: VideoType.tvshow, extra: { 'banner': true }));
      } else {
        Get.to(() => ContentListScreen(), arguments: ArgumentModel(stringArgument: VideoType.movie, extra: { 'banner': true }));
      }
      floatingController.toggle();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: boxDecorationDefault(borderRadius: BorderRadius.circular(32), color: greyBtnColor),
      alignment: Alignment.center,
      child: Text(
        label,
        style: boldTextStyle(size: 16, weight: FontWeight.w600),
      ),
    ),
  );
}