import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/routes/app_routes.dart';
import 'package:streamit_laravel/screens/dashboard/dashboard_screen.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/add_profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/components/profile_component.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_controller.dart';
import 'package:streamit_laravel/screens/profile/watching_profile/watching_profile_shimmer.dart';
import 'package:streamit_laravel/screens/slider/banner_widget.dart';
import 'package:streamit_laravel/addon_bridge/short_drama/short_drama_bridge.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';

import '../../../main.dart';

class WatchingProfileScreen extends StatelessWidget {
  final WatchingProfileController watchingProfileController = Get.find<WatchingProfileController>();

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing(crossAxisChildrenCount: 3, screenPadding: 32);
    return NewAppScaffold(
      isLoading: watchingProfileController.isLoading,
      scrollController: watchingProfileController.scrollController,
      applyLeadingBackButton: false,
      expandedHeight: watchingProfileController.sliderController.listContent.isEmpty && !watchingProfileController.sliderController.isLoading.value ? null : Get.height * 0.44,
      bodyPadding: EdgeInsets.zero,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      onRefresh: () async {
        await watchingProfileController.init();
      },
      topbarChild: BannerWidget(
        sliderController: watchingProfileController.sliderController,
        expandedHeight: Get.height * 0.56,
        tag: AppRoutes.watchingProfile,
        isFromWatchingProfile: true,
      ),
      body: Obx(
        () {
          if (watchingProfileController.showShimmer.value) return const WatchingProfileShimmer();
          if (watchingProfileController.errorMessage.isNotEmpty && !watchingProfileController.isLoading.value)
            return Obx(
              () {
                return AppNoDataWidget(
                  title: watchingProfileController.errorMessage.value,
                  retryText: locale.value.reload,
                  imageWidget: const ErrorStateWidget(),
                  onRetry: () {
                    watchingProfileController.onRetry();
                  },
                ).paddingSymmetric(horizontal: 32);
              },
            );

          return Container(
            height: Get.height,
            padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
            decoration: boxDecorationDefault(
              color: cardColor,
              borderRadius: radius(22),
              gradient: LinearGradient(
                colors: [
                  appColorSecondary.withValues(alpha: 0.2),
                  black.withValues(alpha: 0.4),
                  black,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: CustomScrollView(
              slivers: [
                /// Title section
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      28.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          16.width.expand(flex: 1),
                          Text(
                            locale.value.whoIsWatching,
                            style: commonW600PrimaryTextStyle(size: 20),
                          ).expand(flex: 2),
                          GestureDetector(
                            onTap: () {
                              watchingProfileController.isEdit(!watchingProfileController.isEdit.value);
                            },
                            child: Obx(
                              () => TextIcon(
                                text: watchingProfileController.isEdit.value ? locale.value.close : locale.value.edit,
                                textStyle: boldTextStyle(size: 14, color: secondaryTextColor),
                                prefix: IconWidget(
                                  imgPath: watchingProfileController.isEdit.value ? Assets.iconsX : Assets.iconsPencilSimpleLine,
                                  color: iconColor,
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      28.height,
                    ],
                  ),
                ),

                /// Profiles grid + add/edit tiles
                SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: dynamicSpacing.$2,
                    mainAxisSpacing: dynamicSpacing.$2,
                    childAspectRatio: 0.79,
                  ),
                  itemCount: accountProfiles.length + 2,
                  itemBuilder: (context, index) {
                    if (index < accountProfiles.length) {
                      WatchingProfileModel profile = accountProfiles[index];
                      return Obx(
                        () => ProfileComponent(
                          profile: profile,
                          imageSize: dynamicSpacing.$1,
                          isEdit: watchingProfileController.isEdit.value,
                          showDelete: accountProfiles.where((element) => element.isChildProfile == 0).length > 1,
                          onSelectedProfile: () {
                            if (Get.arguments is ArgumentModel && (Get.arguments as ArgumentModel).boolArgument) {
                              Get.back(result: true);
                            } else {
                              ShortDramaBridge.resumePendingDeepLink().then((resumed) {
                                if (!resumed) {
                                  Get.offAll(() => DashboardScreen());
                                }
                              });
                            }
                          },
                          onRefreshCallback: () async {
                            watchingProfileController.isEdit(false);
                            watchingProfileController.onSwipeRefresh();
                          },
                        ),
                      );
                    } else if (index == accountProfiles.length) {
                      return Column(
                        spacing: 8,
                        children: [
                          AddProfileComponent(
                            onRefreshCallback: () async {
                              watchingProfileController.isEdit(false);
                              watchingProfileController.isEdit(false);
                              watchingProfileController.onSwipeRefresh();
                            },
                            size: dynamicSpacing.$1,
                            isEdit: false,
                            onEditSelectionUpdate: (isEditOn) {
                              watchingProfileController.isEdit(isEditOn);
                            },
                          ),
                          Text(
                            '',
                            style: secondaryTextStyle(),
                          ),
                        ],
                      );
                    } else
                      return const SizedBox.shrink();
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}