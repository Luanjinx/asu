import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/live_tv/model/live_tv_dashboard_response.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../channel_list/channel_list_screen.dart';

class LiveHorizontalComponent extends StatelessWidget {
  final CategoryData channelData;
  final double? height;
  final double? width;

  const LiveHorizontalComponent({super.key, required this.channelData, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: channelData.name,
          showViewAll: channelData.channelData.length > 4,
          onButtonPressed: () {
            Get.to(() => ChannelListScreen(title: channelData.name.validate()), arguments: ArgumentModel(intArgument: channelData.id));
          },
        ),
        if (channelData.channelData.isNotEmpty)
          HorizontalList(
            runSpacing: dynamicSpacing.$2,
            spacing: dynamicSpacing.$2,
            itemCount: channelData.channelData.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final PosterDataModel movie = channelData.channelData[index];
              return ContentListComponent(
                contentData: movie,
                isHorizontalList: true,
              );
            },
          ),
      ],
    ).visible(channelData.channelData.isNotEmpty);
  }
}