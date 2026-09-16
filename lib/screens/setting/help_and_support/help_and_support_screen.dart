import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/shimmer_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/auth/model/about_page_res.dart';
import 'package:streamit_laravel/screens/setting/faq/f_a_q_screen.dart';
import 'package:streamit_laravel/screens/setting/help_and_support/help_and_support_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

class HelpAndSupportScreen extends StatelessWidget {
  HelpAndSupportScreen({super.key});

  final HelpAndSupportController settingController = Get.find<HelpAndSupportController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      isPinnedAppbar: true,
      scrollController: settingController.scrollController,
      scaffoldBackgroundColor: appScreenBackgroundDark,
      appBarTitleText: locale.value.helpAndSupport,
      isLoading: settingController.isLoading,
      onRefresh: settingController.onRefresh,
      body: Obx(
        () {
          return SnapHelperWidget(
            future: settingController.listContentFuture.value,
            loadingWidget: _buildShimmer(),
            errorBuilder: (error) {
              return AppNoDataWidget(
                title: error,
                retryText: locale.value.retry,
                onRetry: () {
                  settingController.onRetry();
                },
                imageWidget: const EmptyStateWidget(),
              );
            },
            onSuccess: (data) {
              return AnimatedWrap(
                spacing: 16,
                runSpacing: 16,
                listAnimationType: commonListAnimationType,
                itemCount: settingController.listContent.length,
                itemBuilder: (context, index) {
                  AboutDataModel page = settingController.listContent[index];
                  return SettingItemWidget(
                    subTitleTextStyle: commonSecondaryTextStyle(),
                    splashColor: appScreenBackgroundDark,
                    highlightColor: appScreenBackgroundDark,
                    hoverColor: appScreenBackgroundDark,
                    decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(8)),
                    title: page.name,
                    leading: Container(
                      decoration: BoxDecoration(
                        color: appColorPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconWidget(imgPath: page.slug.getPageIcon()),
                    ),
                    trailing: Icon(
                      size: 18,
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor,
                    ),
                    radius: radius(0),
                    onTap: () {
                      if (page.url.isNotEmpty) {
                        launchUrlCustomURL(page.url.validate());
                      } else if (page.slug == AppPages.faq) {
                        Get.to(() => FAQScreen());
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      itemCount: 16,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: cardColor, borderRadius: radius(8)),
          child: Row(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerWidget(
                height: 2 * Constants.shimmerTextSize,
                width: 2 * Constants.shimmerTextSize,
                radius: 6,
              ),
              ShimmerWidget(
                height: Constants.shimmerTextSize,
                width: Get.width,
                radius: 6,
              ).expand(),
              ShimmerWidget(
                height: 2 * Constants.shimmerTextSize,
                width: 2 * Constants.shimmerTextSize,
                radius: 6,
                child: IconWidget(imgPath: Assets.iconsCaretRight),
              ),
            ],
          ),
        );
      },
    );
  }
}