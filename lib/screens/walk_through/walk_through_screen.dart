// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/new_update_dialog.dart';
import 'package:streamit_laravel/routes/app_routes.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/screens/walk_through/model/walkthrough_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../main.dart';
import 'walk_through_cotroller.dart';

class WalkThroughScreen extends StatelessWidget {
  final List<WalkthroughModel> walkthroughPageList;
  final WalkThroughController walkThroughCont = Get.find<WalkThroughController>();

  WalkThroughScreen({super.key, required this.walkthroughPageList});

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isScrollableWidget: false,
      scrollController: walkThroughCont.scrollController,
      applyLeadingBackButton: false,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      expandedHeight: Get.height,
      collapsedHeight: Get.height,
      bodyPadding: EdgeInsets.zero,
      actions: [
        Obx(
          () => Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Get.offAll(() => DashboardScreen(), duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
              },
              child: Text(
                locale.value.lblSkip,
                style: commonPrimaryTextStyle(color: appColorPrimary),
              ),
            ).paddingDirectional(end: 24),
          ).visible(walkThroughCont.currentPosition.value < walkthroughPageList.length - 1),
        )
      ],
      topbarChild: Obx(
        () => PageView.builder(
          itemCount: walkthroughPageList.length,
          itemBuilder: (BuildContext context, int index) {
            WalkthroughModel page = walkthroughPageList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    CachedImageWidget(
                      url: page.image.validate(),
                      height: Get.height * 0.65,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: Get.height * 0.65,
                        width: Get.width,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              black.withValues(alpha: 0.01),
                              black.withValues(alpha: 0.06),
                              black.withValues(alpha: 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  page.title.toString(),
                  textAlign: TextAlign.center,
                  style: commonW500PrimaryTextStyle(size: 20),
                ),
                12.height,
                TypingAnimatedText(
                  isCenterText: true,
                  valueKey: '${AppRoutes.splash}_${page.description.toString()}',
                  updates: [page.description.toString()],
                ),
              ],
            );
          },
          controller: walkThroughCont.pageController.value,
          scrollDirection: Axis.horizontal,
          onPageChanged: (num) {
            walkThroughCont.currentPosition.value = num;
          },
        ),
      ),
      body: const Offstage(),
      widgetsStackedOverBody: [
        PositionedDirectional(
          bottom: ResponsiveSize.getBottom(24),
          start: ResponsiveSize.getStart(16),
          end: ResponsiveSize.getEnd(16),
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              DotIndicator(
                pageController: walkThroughCont.pageController.value,
                pages: walkthroughPageList,
                indicatorColor: white,
                unselectedIndicatorColor: white.withValues(alpha: 0.5),
                currentBoxShape: BoxShape.circle,
                boxShape: BoxShape.circle,
                dotSize: 6,
                currentDotSize: 7,
              ),
              Obx(
                () {
                  final currentPageIndex = walkThroughCont.currentPosition.value;
                  final isLastPage = currentPageIndex >= walkthroughPageList.length - 1;

                  return AppButton(
                    margin: ResponsiveSize.getHorizontalOnly(16),
                    width: Get.width * 0.4,
                    text: isLastPage ? locale.value.lblGetStarted : locale.value.lblNext,
                    color: appColorPrimary,
                    disabledColor: btnColor,
                    textStyle: appButtonTextStyleWhite,
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius / 2)),
                    onTap: () async {
                      if (isLastPage || walkthroughPageList.length == 1) {
                        Get.offAll(() => DashboardScreen(), duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                      } else {
                        walkThroughCont.pageController.value.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.linearToEaseOut);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}