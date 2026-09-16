import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_dialog_widget.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/downloads/models/hive_content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';
import 'package:streamit_laravel/utils/extension/string_extension.dart';

import 'components/download_component.dart';
import 'download_controller.dart';
import 'download_shimmer.dart';

class DownloadScreen extends StatelessWidget {
  DownloadScreen({super.key});

  final DownloadController controller = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    return NewAppScaffold(
      scrollController: controller.scrollController,
      appBarTitleText: locale.value.yourDownloads,
      onRefresh: controller.onRefresh,
      isLoading: controller.isLoading,
      isPinnedAppbar: true,
      actions: [
          Obx(() {
            if (!controller.isMultiDownalodSelected.value) return const SizedBox.shrink();
            return IconButton(
              visualDensity: VisualDensity.compact,
              icon: IconWidget(imgPath: Assets.iconsTrash,color: appColorPrimary),
              onPressed: () {
                Get.bottomSheet(
                  AppDialogWidget(
                    image: Assets.iconsTrash,
                    imageColor: appColorPrimary,
                    title: locale.value.deleteMultipleDownload,
                    onAccept: () {
                      controller.deleteMultipleDownload();
                    },
                  ),
                  isScrollControlled: true,
                );
              },
            );
          }),
        ],
      appBarBottomWidget: controller.availableFilter.isNotEmpty
          ? Align(
              alignment: Alignment.centerLeft,
              child: HorizontalList(
                itemCount: controller.availableFilter.length,
                itemBuilder: (context, index) {
                  String tab = controller.availableFilter[index];
                  return Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: boxDecorationDefault(
                        color: controller.currentFilterIndex.value == index ? appColorPrimary : Colors.transparent,
                        borderRadius: radius(20),
                        border: Border.all(color: controller.currentFilterIndex.value == index ? appColorPrimary : iconColor),
                      ),
                      child: Text(
                        tab.getContentTypeTitle(),
                        style: primaryTextStyle(size: 14),
                      ),
                    ).onTap(
                      () {
                        controller.currentFilterIndex(index);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  );
                },
              ),
            )
          : null,
      body: Obx(
        () => SnapHelperWidget(
          future: controller.listContentFuture.value,
          loadingWidget: const DownloadShimmer(),
          onSuccess: (response) {
            return Obx(
              () {
                if (controller.isLoading.value) {
                  return const DownloadShimmer();
                }
                bool isChild = selectedAccountProfile.value.isChildProfile == 1;

                bool isRestricted(HiveContentModel item) {
                  if (!isChild) return false;
                  final parsed = controller.parsedContentCache[item.id];
                  if (parsed == null) return false;
                  final details = parsed['details'];
                  if (details is Map) {
                    return details['is_restricted'] == 1;
                  }
                  return false;
                }

                final filterType = controller.currentFilterType;
                List<HiveContentModel> activeList = [];
                final Map<String, List<HiveContentModel>> activeSeasons = {};

                if (filterType == VideoType.movie) {
                  activeList = controller.movies.where((e) => !isRestricted(e)).toList();
                } else if (filterType == VideoType.video) {
                  activeList = controller.videos.where((e) => !isRestricted(e)).toList();
                } else if (filterType == VideoType.tvshow) {
                  controller.tvShowSeasons.forEach((key, value) {
                    final filtered = value.where((e) => !isRestricted(e)).toList();
                    if (filtered.isNotEmpty) {
                      activeSeasons[key] = filtered;
                    }
                  });
                } else {
                  // Fallback if no filter or all?
                  // For now, if somehow empty filter, show nothing or all.
                  // Assuming availableFilter is populated properly.
                }

                if (activeList.isEmpty && activeSeasons.isEmpty) {
                  return AppNoDataWidget(
                    title: locale.value.noDownloadsFound,
                    subTitle: locale.value.downloadContentToWatchOffline,
                    imageWidget: IconWidget(imgPath: Assets.iconsDownload, color: iconColor, size: 85),
                    onRetry: () async {
                      await controller.getListData();
                    },
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (filterType == VideoType.tvshow) _buildTvShowsSliver(controller, activeSeasons) else _buildSliverList(activeList, controller),
                    ],
                  ),
                );
              },
            );
          },
          errorBuilder: (error) {
            return Obx(
              () => AppNoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: controller.onRefresh,
              ).center().visible(!controller.isLoading.value),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverList(List items, DownloadController controller) {
    if (items.isEmpty) return const Offstage();

    return AnimatedWrap(
      runSpacing: 12,
      spacing: 12,
      itemCount: items.length,
      itemBuilder: (context, index) {
        HiveContentModel downloadedData = items[index];
        return DownloadComponent(
          content: downloadedData,
          parsedContent: controller.parsedContentCache[downloadedData.id],
          onDelete: (title) {
            Get.bottomSheet(
              AppDialogWidget(
                image: Assets.iconsTrash,
                imageColor: appColorPrimary,
                title: locale.value.confirmDeleteDownload(title),
                onAccept: () {
                  controller.deleteDownload(downloadedData.id);
                },
              ),
              isScrollControlled: true,
            );
          },
        );
      },
    );
  }

  Widget _buildTvShowsSliver(DownloadController controller, Map<String, List<HiveContentModel>> seasons) {
    if (seasons.isEmpty) return const Offstage();

    return AnimatedWrap(
      runSpacing: 12,
      spacing: 12,
      itemCount: seasons.entries.length,
      itemBuilder: (context, index) {
        final entryIndex = index;
        final entry = seasons.entries.elementAt(entryIndex);

        String title = '${locale.value.season} ${entry.key}';
        if (entry.value.isNotEmpty) {
          final first = entry.value.first;
          final parsed = controller.parsedContentCache[first.id];
          if (parsed != null) {
            final parsedModel = ContentModel.fromContentJson(parsed);
            String showName = parsedModel.details.tvShowData?.name ?? '';
            String seasonName = '';

            if (parsedModel.details.seasonList.isNotEmpty) {
              final match = parsedModel.details.seasonList.firstWhere((s) => s.seasonId.toString() == entry.key || s.id.toString() == entry.key, orElse: () => SeasonData());
              if (match.name.isNotEmpty) seasonName = match.name;
            }

            if (seasonName.isEmpty) seasonName = '${locale.value.season} ${entry.key}';
            if (showName.isNotEmpty) {
              title = '$showName - $seasonName';
            } else {
              title = seasonName;
            }
          }
        }

        return ExpansionTile(
          controlAffinity: ListTileControlAffinity.trailing,
          visualDensity: VisualDensity.compact,
          dense: true,
          iconColor: iconColor,
          collapsedIconColor: iconColor,
          title: Text(
            title,
            style: boldTextStyle(),
          ),
          children: entry.value
              .map(
                (c) => DownloadComponent(
                  content: c,
                  parsedContent: controller.parsedContentCache[c.id],
                  onDelete: (title) {
                    Get.bottomSheet(
                      AppDialogWidget(
                        image: Assets.iconsTrash,
                        imageColor: appColorPrimary,
                        title: locale.value.confirmDeleteDownload(title),
                        onAccept: () {
                          controller.deleteDownload(c.id);
                        },
                      ),
                      isScrollControlled: true,
                    );
                  },
                ).paddingSymmetric(vertical: 6),
              )
              .toList(),
        );
      },
    );
  }
}