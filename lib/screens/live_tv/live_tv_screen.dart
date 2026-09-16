import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/content/components/auto_slider_component.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/live_tv/components/live_card.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_screen.dart';
import 'package:streamit_laravel/screens/live_tv/shimmer_live_tv.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/live_category_list.dart';
import 'live_tv_controller.dart';

class LiveTvScreen extends StatelessWidget {
  final LiveTVController liveTVCont = Get.find<LiveTVController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: liveTVCont.scrollController,
      applyLeadingBackButton: false,
      expandedHeight: Get.height * 0.40,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      onRefresh: liveTVCont.getLiveDashboardDetail,
      bodyPadding: EdgeInsets.zero,
      appBarTitleText: locale.value.liveTv,
      topbarChild: Obx(
        () {
          if (liveTVCont.isLoading.value) {
            return ShimmerWidget(
              height: Get.height * 0.40,
              width: Get.width,
            );
          } else if (liveTVCont.content.value != null) {
            return AutoSliderComponent(
              height: Get.height * 0.40,
              sliderLength: liveTVCont.content.value!.data.slider.length,
              sliderChildren: List.generate(
                liveTVCont.content.value!.data.slider.length,
                (index) {
                  final PosterDataModel data = liveTVCont.content.value!.data.slider[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => LiveContentDetailsScreen(), arguments: data);
                    },
                    child: Stack(
                      alignment: AlignmentGeometry.center,
                      children: [
                        CachedImageWidget(
                          url: data.posterImage.validate(),
                          width: Get.width,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: Container(
                            height: Get.height * 0.40,
                            width: double.infinity,
                            foregroundDecoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  black.withValues(alpha: 0.4),
                                  black.withValues(alpha: 0.2),
                                  black.withValues(alpha: 0.8),
                                  black.withValues(alpha: 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        PositionedDirectional(
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (data.details.category.isNotEmpty)...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    data.details.category,
                                    style: commonSecondaryTextStyle(size: 12),
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                ),
                                4.height,
                              ],
                              Text(
                                data.details.name,
                                style: commonW500PrimaryTextStyle(size: 20),
                                textAlign: TextAlign.center,
                              ),
                              8.height,
                              AppButton(
                                height: 40,
                                disabledColor: btnColor,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                color: cardColor,
                                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                enabled: true,
                                onTap: () {
                                  Get.to(() => LiveContentDetailsScreen(), arguments: data);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconWidget(imgPath: Assets.iconsPlayFill),
                                    12.width,
                                    Text(locale.value.watchNow, style: appButtonTextStyleWhite),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          top: MediaQuery.of(context).viewPadding.top + ResponsiveSize.getTop(16),
                          end: ResponsiveSize.getEnd(16),
                          child: const LiveCard(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const Offstage();
        },
      ),
      body: Obx(
        () => SnapHelperWidget(
          future: liveTVCont.contentFuture.value,
          initialData: cachedLiveTvDashboard,
          loadingWidget: const ShimmerLiveTv(),
          errorBuilder: (error) {
            return AppNoDataWidget(
              height: Get.height * 0.24,
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                liveTVCont.getLiveDashboardDetail();
              },
            ).center().visible(!liveTVCont.isLoading.value);
          },
          onSuccess: (res) {
            return liveTVCont.isLoading.value
                ? const ShimmerLiveTv()
                : !liveTVCont.isLoading.value && liveTVCont.content.value != null && liveTVCont.content.value!.data.categoryData.isEmpty
                    ? AppNoDataWidget(
                        height: Get.height * 0.24,
                        title: locale.value.noLiveTvChannels,
                        subTitle: locale.value.noLiveTvChannelsAreCurrentlyAvailable,
                        retryText: "",
                        imageWidget: const EmptyStateWidget(),
                      ).paddingSymmetric(horizontal: 16)
                    : liveTVCont.content.value != null
                        ? LiveCategoryListComponent(liveCategoryList: liveTVCont.content.value!.data.categoryData)
                        : const Offstage();
          },
        ),
      ),
    );
  }
}