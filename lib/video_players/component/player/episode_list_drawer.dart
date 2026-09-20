import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/cached_image_widget.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class EpisodeListDrawer extends StatelessWidget {
  final VideoPlayersController videoPlayerController;

  const EpisodeListDrawer({
    super.key,
    required this.videoPlayerController,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: appScreenBackgroundDark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                    locale.value.episodes,
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
            // Episodes List
            Expanded(
              child: Obx(() {
                final episodes = videoPlayerController.allEpisodes;
                if (episodes.isEmpty) {
                  return Center(
                    child: Text(
                      locale.value.noDataFound,
                      style: primaryTextStyle(),
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: episodes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final episode = episodes[index];
                    final isPlaying = videoPlayerController.videoModel.id == episode.id;

                    return GestureDetector(
                      onTap: () {
                        if (!isPlaying) {
                          Get.back(); // close drawer
                          videoPlayerController.playSpecificEpisode(episode);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: boxDecorationDefault(
                          color: isPlaying ? appColorPrimary.withValues(alpha: 0.15) : cardColor,
                          borderRadius: radius(8),
                          border: Border.all(
                            color: isPlaying ? appColorPrimary : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Thumbnail
                            SizedBox(
                              width: 100,
                              height: 60,
                              child: Stack(
                                children: [
                                  CachedImageWidget(
                                    url: episode.posterImage,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    radius: 6,
                                  ),
                                  if (isPlaying)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: radius(6),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.play_circle_fill, color: appColorPrimary, size: 24),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            12.width,
                            // Title & Duration
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    episode.details.name.capitalizeEachWord(),
                                    style: boldTextStyle(
                                      size: 14,
                                      color: isPlaying ? appColorPrimary : textPrimaryColorGlobal,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  4.height,
                                  if (episode.details.duration.isNotEmpty)
                                    Text(
                                      episode.details.duration,
                                      style: secondaryTextStyle(size: 12),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
