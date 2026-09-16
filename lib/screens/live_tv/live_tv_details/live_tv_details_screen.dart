import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_controller.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_shimmer_screen.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/video_players/video_screen.dart';

import '../../../components/app_scaffold.dart';
import '../../../utils/common_functions.dart';

class LiveContentDetailsScreen extends StatelessWidget {
  final LiveContentDetailsController contentDetailsController = Get.find<LiveContentDetailsController>();

  LiveContentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewAppScaffold(
        scrollController: contentDetailsController.scrollController,
        applyLeadingBackButton: !isPipModeOn.value,
        hideAppBar: isPipModeOn.value,
        currentPage: 1.obs,
        isLoading: contentDetailsController.isLoading,
        scaffoldBackgroundColor: appScreenBackgroundDark,
        expandedHeight: Get.height * 0.35,
        collapsedHeight: Get.height * 0.24,
        onRefresh: contentDetailsController.onSwipeRefresh,
        topbarChild: contentDetailsController.showShimmer.value
            ? ShimmerWidget(
                height: Get.height * 0.45,
                width: Get.width,
              )
            : contentDetailsController.hasContent
                ? Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CachedImageWidget(
                        height: Get.height * 0.45,
                        width: Get.width,
                        fit: BoxFit.cover,
                        url: contentDetailsController.content.value!.details.thumbnailImage,
                      ),
                      IgnorePointer(
                        ignoring: true,
                        child: Container(
                          height: Get.height * 0.45,
                          width: Get.width,
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                black.withValues(alpha: 0.001),
                                black.withValues(alpha: 0.002),
                                black.withValues(alpha: 1),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Offstage(),
        body: Obx(
          () => SnapHelperWidget<ContentModel>(
            future: contentDetailsController.contentFuture.value,
            loadingWidget: const LiveTvDetailsShimmerScreen(),
            errorBuilder: (error) {
              return AppNoDataWidget(
                height: Get.height * 0.24,
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
              ).center().visible(!contentDetailsController.isLoading.value);
            },
            onSuccess: (data) {
              return Obx(
                () {
                  if (contentDetailsController.content.value != null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        if (contentDetailsController.content.value!.details.category.isNotEmpty)
                          Text(
                            contentDetailsController.content.value!.details.category,
                            style: commonSecondaryTextStyle(),
                          ),
                        Text(
                          data.details.name,
                          style: boldTextStyle(size: ResponsiveSize.getFontSize(Constants.labelTextSize)),
                        ),
                        watchNowButton(
                          contentData: contentDetailsController.content.value!,
                          onPaymentReturnCallBack: () {
                            contentDetailsController.onSwipeRefresh();
                          },
                          callBack: () {
                            Get.to(
                              () => VideoScreen(isFromDownloads: false),
                              arguments: contentDetailsController.content.value,
                            );
                          },
                        ),
                        if (data.details.description.isNotEmpty) ...[
                          readMoreTextWidget(data.details.description),
                        ],
                        if (contentDetailsController.content.value!.isSuggestedContentAvailable)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16,
                            children: [
                              Text(locale.value.suggestedChannels, style: boldTextStyle()),
                              AnimatedWrap(
                                runSpacing: getDynamicSpacing().$2,
                                spacing: getDynamicSpacing().$2,
                                listAnimationType: commonListAnimationType,
                                alignment: WrapAlignment.start,
                                itemCount: contentDetailsController.content.value!.suggestedContent.length,
                                itemBuilder: (context, index) {
                                  final suggestedContent = contentDetailsController.content.value!.suggestedContent[index];
                                  return ContentListComponent(
                                    isHorizontalList: true,
                                    contentData: suggestedContent,
                                    onTap: () {
                                      contentDetailsController.argumentData = suggestedContent;
                                      contentDetailsController.update([contentDetailsController.argumentData]);
                                      contentDetailsController.getLiveShowDetail();
                                      contentDetailsController.scrollController.animateTo(
                                        0,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          )
                      ],
                    );
                  }
                  return AppNoDataWidget(
                    title: locale.value.noChannelDetails,
                    subTitle: locale.value.channelInformationIsNotAvailable,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: contentDetailsController.onSwipeRefresh,
                  ).center().visible(!contentDetailsController.isLoading.value);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}