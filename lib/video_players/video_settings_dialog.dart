import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';

import '../utils/colors.dart';

class VideoSettingsDialog extends StatelessWidget {
  final VideoPlayersController videoPlayerController;

  const VideoSettingsDialog({
    super.key,
    required this.videoPlayerController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: appScreenBackgroundDark,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: List.generate(
                      8,
                      (i) => (appColorSecondary).withValues(
                        alpha: [0.16, 0.14, 0.12, 0.10, 0.08, 0.04, 0.02, 0.01][i],
                      ),
                    ),
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.value.settings,
                      style: boldTextStyle(),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Get.back(),
                      icon: IconWidget(
                        imgPath: Assets.iconsX,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              // Tab Bar
              Container(
                decoration: boxDecorationDefault(
                  color: appScreenBackgroundDark,
                  border: Border(
                    bottom: BorderSide(color: borderColorDark, width: 1),
                  ),
                ),
                child: Builder(
                  builder: (BuildContext tabContext) {
                    final TabController tabController = DefaultTabController.of(tabContext);
                    return TabBar(
                      controller: tabController,
                      indicatorColor: appColorPrimary,
                      labelColor: appColorPrimary,
                      unselectedLabelColor: darkGrayTextColor,
                      labelStyle: boldTextStyle(),
                      unselectedLabelStyle: commonPrimaryTextStyle(),
                      tabs: [
                        Tab(text: locale.value.quality),
                        Tab(text: locale.value.subtitle),
                      ],
                    );
                  },
                ),
              ),
              // Tab Bar View
              Expanded(
                child: TabBarView(
                  children: [
                    // Quality Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildVideoQualityOptions(context),
                    ),
                    // Subtitle Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildSubtitleTab(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQualityOption(BuildContext context, String label, VideoData link, bool isSelected) {
    return SettingItemWidget(
      padding: EdgeInsets.zero,
      splashColor: appScreenBackgroundDark,
      highlightColor: appScreenBackgroundDark,
      hoverColor: appScreenBackgroundDark,
      title: "$label${link.quality.toLowerCase() != QualityConstants.defaultQualityKey.toLowerCase() ? ' (${link.quality})' : ''} ",
      titleTextStyle: commonSecondaryTextStyle(color: isSelected ? appColorPrimary : null),
      trailing: isSelected ? IconWidget(imgPath: Assets.iconsCheck, size: 20, color: appColorPrimary) : const Offstage(),
      onTap: () async {
        Get.back();
        videoPlayerController.changeQuality(link);
      },
    );
  }

  Widget _buildVideoQualityOptions(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      listAnimationType: commonListAnimationType,
      itemCount: videoPlayerController.videoModel.videoQualities.length,
      itemBuilder: (context, index) {
        VideoData link = videoPlayerController.videoModel.videoQualities[index];
        bool isSelected = videoPlayerController.currentQuality.value.quality == link.quality;

        if (link.quality == QualityConstants.defaultQualityKey) {
          return buildQualityOption(context, locale.value.defaultLabel, link, isSelected);
        } else if (link.quality == QualityConstants.low) {
          return buildQualityOption(context, locale.value.lowQuality, link, isSelected);
        } else if (link.quality == QualityConstants.medium) {
          return buildQualityOption(context, locale.value.mediumQuality, link, isSelected);
        } else if (link.quality == QualityConstants.high) {
          return buildQualityOption(context, locale.value.highQuality, link, isSelected);
        } else if (link.quality == QualityConstants.veryHigh) {
          return buildQualityOption(context, locale.value.veryHighQuality, link, isSelected);
        } else if (link.quality == QualityConstants.ultra2K) {
          return buildQualityOption(context, locale.value.ultraQuality, link, isSelected);
        } else if (link.quality == QualityConstants.ultra4K) {
          return buildQualityOption(context, locale.value.ultraQuality, link, isSelected);
        } else if (link.quality == QualityConstants.ultra8K) {
          return buildQualityOption(context, locale.value.ultraQuality, link, isSelected);
        } else {
          return const Offstage();
        }
      },
    );
  }

  Widget _buildSubtitleTab(BuildContext context) {
    return AnimatedWrap(
      spacing: 16,
      runSpacing: 16,
      listAnimationType: commonListAnimationType,
      itemCount: videoPlayerController.videoModel.subtitleList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return buildSubtitleOption(
            SubtitleModel(language: locale.value.off.capitalizeEachWord()),
            videoPlayerController.currentSubtitle.value.id < 0,
          );
        }
        SubtitleModel subtitle = videoPlayerController.videoModel.subtitleList[index - 1];
        return buildSubtitleOption(
          subtitle,
          videoPlayerController.currentSubtitle.value.id == subtitle.id,
        );
      },
    );
  }

  Widget buildSubtitleOption(SubtitleModel subtitle, bool isSelected) {
    return SettingItemWidget(
      padding: EdgeInsets.zero,
      splashColor: appScreenBackgroundDark,
      highlightColor: appScreenBackgroundDark,
      hoverColor: appScreenBackgroundDark,
      title: subtitle.language,
      titleTextStyle: commonSecondaryTextStyle(color: null),
      trailing: isSelected ? IconWidget(imgPath: Assets.iconsCheck, size: 20, color: appColorPrimary) : const Offstage(),
      onTap: () async {
        Get.back();
        videoPlayerController.currentSubtitle(subtitle);

        await videoPlayerController.playerManager.setSubtitle(subtitle.subtitleFileURL);
      },
    );
  }
}