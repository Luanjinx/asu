import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/video_players/video_player.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';

class VideoScreen extends StatelessWidget {
  final bool isFromDownloads;
  final List<PosterDataModel> remainingEpisodes;
  final String title;

  final Function(ContentModel newEpisodeData)? onEpisodeChanged;

  const VideoScreen({
    super.key,
    this.isFromDownloads = false,
    this.remainingEpisodes = const <PosterDataModel>[],
    this.title = '',
    this.onEpisodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ContentModel? model = Get.arguments is ContentModel ? Get.arguments : null;
    final String tag = model != null ? 'video_controller_${model.id}' : UniqueKey().toString();

    return GetBuilder<VideoPlayersController>(
      tag: tag,
      init: Get.put(
        VideoPlayersController(
          remainingEpisodes: remainingEpisodes,
          isFromDownloads: isFromDownloads,
          onEpisodeChanged: onEpisodeChanged,
        ),
        permanent: false,
        tag: tag,
      ),
      builder: (controller) {
        return VideoPlayersComponent(controller: controller);
      },
    );
  }
}