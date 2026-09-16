import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_controller.dart';
import 'package:streamit_laravel/screens/coming_soon/shimmer_coming_soon.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import '../../components/app_scaffold.dart';
import '../../main.dart';
import '../../utils/common_functions.dart';
import '../../utils/empty_error_state_widget.dart';
import 'components/coming_soon_component.dart';

class ComingSoonScreen extends StatelessWidget {
  final ComingSoonController comingSoonCont = Get.find<ComingSoonController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NewAppScaffold(
        isPinnedAppbar: true,
        scrollController: comingSoonCont.scrollController,
        isLoading: (comingSoonCont.isLoading.value && comingSoonCont.currentPage.value != 1).obs,
        currentPage: comingSoonCont.currentPage,
        appBarTitleText: locale.value.comingSoon,
        expandedHeight: MediaQuery.of(context).viewPadding.top,
        onRefresh: comingSoonCont.onRefresh,
        bottomSpace: Get.height * 0.18,
        appBarBottomWidget: comingSoonCont.availableFilter.isNotEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: HorizontalList(
                  itemCount: comingSoonCont.availableFilter.length,
                  itemBuilder: (context, index) {
                    String tab = comingSoonCont.availableFilter[index];
                    return Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: boxDecorationDefault(
                          color: comingSoonCont.currentFilterIndex.value == index ? appColorPrimary : Colors.transparent,
                          borderRadius: radius(20),
                          border: Border.all(color: comingSoonCont.currentFilterIndex.value == index ? appColorPrimary : iconColor),
                        ),
                        child: Text(
                          tab.getContentTypeTitle(),
                          style: primaryTextStyle(size: 14),
                        ),
                      ).onTap(
                        () {
                          comingSoonCont.currentFilterIndex(index);
                          comingSoonCont.onRefresh();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                    );
                  },
                ),
              )
            : null,
        applyLeadingBackButton: false,
        body: SnapHelperWidget(
          future: comingSoonCont.listContentFuture.value,
          initialData: cachedComingSoonList,
          loadingWidget: const ShimmerComingSoon(),
          errorBuilder: (error) {
            return Obx(
              () => AppNoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: comingSoonCont.onRefresh,
              ).center().visible(!comingSoonCont.isLoading.value),
            );
          },
          onSuccess: (res) {
            return Obx(
              () {
                if (comingSoonCont.isLoading.value && comingSoonCont.getCurrentPage() == 1) {
                  return const ShimmerComingSoon();
                } else if (comingSoonCont.listContent.isEmpty && !comingSoonCont.isLoading.value) {
                  return AppNoDataWidget(
                    title: comingSoonCont.currentFilterType.getEmptyComingSoonListMessage(),
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: comingSoonCont.onRetry,
                  ).visible(!comingSoonCont.isLoading.value);
                }
                return AnimatedWrap(
                  listAnimationType: commonListAnimationType,
                  runSpacing: 12,
                  spacing: 12,
                  itemCount: comingSoonCont.listContent.length,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  itemBuilder: (ctx, index) {
                    return ComingSoonComponent(
                      key: ValueKey(index),
                      comingSoonCont: comingSoonCont,
                      isLoading: comingSoonCont.isLoading.value,
                      onWatchListTap: () {
                        doIfLogin(
                          onLoggedIn: () async {
                            await comingSoonCont.saveWatchList(comingSoonData: comingSoonCont.listContent[index]);
                          },
                        );
                      },
                      onRemindMeTap: () {
                        doIfLogin(
                          onLoggedIn: () async {
                            if (comingSoonCont.listContent[index].isRemind.getBoolInt()) {
                              await comingSoonCont.deleteRemind(comingSoonData: comingSoonCont.listContent[index]);
                              return;
                            }
                            await comingSoonCont.saveRemind(isRemind: comingSoonCont.listContent[index].isRemind.getBoolInt(), comingSoonData: comingSoonCont.listContent[index]);
                          },
                        );
                      },
                      comingSoonDet: comingSoonCont.listContent[index],
                    );
                  },
                );
              },
            );
          },
        ),
        widgetsStackedOverBody: [
          Obx(() {
            final hasRemindLoading = comingSoonCont.loadingRemindItems.values.any((loading) => loading == true);
            final hasWatchlistLoading = comingSoonCont.loadingWatchlistItems.values.any((loading) => loading == true);
            final isLoading = hasRemindLoading || hasWatchlistLoading;

            return isLoading
                ? AbsorbPointer(
                    child: Container(
                      width: Get.width,
                      height: Get.height,
                      color: Colors.transparent,
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}