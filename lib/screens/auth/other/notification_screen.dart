import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_logo_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_detail_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/subscription_history_screen.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';
import 'package:streamit_laravel/screens/subscription/subscription_screen.dart';
import 'package:streamit_laravel/screens/subscription/subscription_history/rental_history_screen.dart';

import '../../../components/app_scaffold.dart';
import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../model/notification_model.dart';
import 'notification_controller.dart';
import 'notification_shimmer.dart';

class NotificationScreen extends StatelessWidget {
  final NotificationScreenController notificationController = Get.find<NotificationScreenController>();

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 1);
    return Obx(
      () => NewAppScaffold(
        expandedHeight: MediaQuery.of(context).viewPadding.top,
        scrollController: notificationController.scrollController,
        appBarTitleText: locale.value.notifications,
        isLoading: notificationController.isLoading,
        onRefresh: notificationController.onRefresh,
        isPinnedAppbar: true,
        actions: [
          Obx(() {
            if (notificationController.listContent.isEmpty) return const SizedBox.shrink();
            return IconButton(
              onPressed: () {
                notificationController.clearAllNotification();
              },
              icon: Icon(
                Icons.clear_all,
                color: iconColor,
              ),
            );
          }),
        ],
        body: Obx(
          () => SnapHelperWidget(
            future: notificationController.listContentFuture.value,
            errorBuilder: (error) {
              return AppNoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: SizedBox(height: 100, child: Center(child: CachedImageWidget(url: Assets.imagesNoNotification, color: textSecondaryColorGlobal, height: 80))),
                onRetry: () {
                  notificationController.getListData();
                },
              ).paddingSymmetric(horizontal: 32).visible(!notificationController.isLoading.value);
            },
            loadingWidget: const NotificationShimmer(),
            onSuccess: (notifications) {
              if (notifications.isEmpty && !notificationController.isLoading.value) {
                return AppNoDataWidget(
                  title: locale.value.stayTunedNoNew,
                  subTitle: locale.value.noNewNotificationsAt,
                  imageWidget: SizedBox(height: 100, child: Center(child: CachedImageWidget(url: Assets.imagesNoNotification, color: textSecondaryColorGlobal, height: 80))),
                  retryText: locale.value.reload,
                  onRetry: () {
                    notificationController.currentPage(1);
                    notificationController.getListData();
                  },
                ).paddingSymmetric(horizontal: 32);
              }
              return AnimatedWrap(
                spacing: dynamicSpacing.$2,
                runSpacing: dynamicSpacing.$2,
                itemCount: notifications.length,
                listAnimationType: commonListAnimationType,
                itemBuilder: (context, index) {
                  NotificationData notification = notifications[index];
                  return GestureDetector(
                    onTap: () {
                      final data = notification.data;
                      if (data != null) {
                        if (data.notificationType == NotificationType.movie_added) {
                          int? movieId = data.id;
                          if (movieId <= 0) return;
                          Get.to(() => ContentDetailsScreen(), arguments: PosterDataModel(id: movieId, details: ContentData(type: VideoType.movie)));
                        } else if (data.notificationType == NotificationType.tvshow_added ||
                            data.notificationType == NotificationType.episode_added ||
                            data.notificationType == NotificationType.season_added) {
                          int? tvShowId = data.id;
                          if (tvShowId <= 0) return;
                          Get.to(() => ContentDetailsScreen(), arguments: PosterDataModel(id: tvShowId, details: ContentData(type: VideoType.tvshow)));
                        } else if (data.notificationType == NotificationType.video_added) {
                          int? videoId = data.id;
                          if (videoId <= 0) return;
                          Get.to(() => ContentDetailsScreen(), arguments: PosterDataModel(id: videoId, details: ContentData(type: VideoType.video)));
                        } else if (data.notificationType == NotificationType.upcoming) {
                          int movieId = data.id;
                          String contentType = data.upcomingData.contentType;
                          if (movieId <= 0 || contentType.isEmpty) return;
                          Get.to(
                            () => ComingSoonDetailScreen(comingSoonData: ComingSoonModel(id: movieId, type: contentType)),
                            arguments: ComingSoonModel(id: movieId, type: contentType),
                          );
                        } else if (data.notificationType == NotificationType.continueWatch) {
                          int movieId = data.id;
                          String contentType = data.continueWatchData.contentType;
                          if (movieId <= 0 || contentType.isEmpty) return;
                          Get.to(() => ContentDetailsScreen(), arguments: PosterDataModel(id: movieId, details: ContentData(type: contentType)));
                        } else if (data.notificationType == NotificationType.subscription  || data.notificationType == NotificationType.cancelSubscription) {
                          Get.to(() => SubscriptionHistoryScreen());
                        } else if (data.notificationType == NotificationType.subscriptionExpireReminder || data.notificationType == NotificationType.expiryPlan) {
                          Get.to(() => SubscriptionScreen(launchDashboard: false));
                        } else if (data.notificationType == NotificationType.rentVideo || data.notificationType == NotificationType.purchaseVideo) {
                          if (data.rentVideo.contentId <= 0) return;
                          Get.to(() => ContentDetailsScreen(), arguments: PosterDataModel(id: data.rentVideo.contentId, details: ContentData(type: data.rentVideo.contentType)));
                        } else if (data.notificationType == NotificationType.purchaseExpireReminder || data.notificationType == NotificationType.rentExpireReminder) {
                          Get.to(() => RentalHistoryScreen());
                        }
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: Get.height * 0.15,
                      decoration: boxDecorationDefault(color: cardDarkColor, borderRadius: radius(6)),
                      child: Row(
                        children: [
                          if (notification.data!.thumbnailImage.validate().isNotEmpty)
                            Hero(
                              tag: 'thumbnail_${notification.data!.thumbnailImage.validate()}',
                              child: CachedImageWidget(
                                url: notification.data!.thumbnailImage.validate(),
                                width: Get.width * 0.30,
                                height: Get.height * 0.15,
                                fit: BoxFit.cover,
                                topLeftRadius: 6,
                                bottomLeftRadius: 6,
                              ),
                            )
                          else
                            AppLoaderWidget(size: Size(Get.width * 0.30, Get.height * 0.15)),
                          4.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                6.height,
                                if (notification.data!.subject.isNotEmpty) ...[
                                  Text(
                                    notification.data!.subject,
                                    style: boldTextStyle(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  2.height,
                                ],
                                if (notification.data!.description.isNotEmpty)
                                  Text(
                                    parseHtmlString(notification.data!.description),
                                    style: secondaryTextStyle(
                                      weight: FontWeight.w500,
                                      color: descriptionTextColor,
                                      size: ResponsiveSize.getFontSize((14).toDouble()),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(notification.notificationDatTime.timeAgo(), style: secondaryTextStyle(size: 12)),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () {
                                        notificationController.showDeleteNotificationBottomSheet(notification);
                                      },
                                      icon: IconWidget(
                                        imgPath: Assets.iconsTrash,
                                        size: 18,
                                        color: iconColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 8),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}