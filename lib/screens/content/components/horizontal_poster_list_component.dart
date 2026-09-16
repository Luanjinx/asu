import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/screens/content/content_list_screen.dart';
import 'package:streamit_laravel/screens/content/filtered_content_list_screen.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/rented_content/rental_list_screen.dart';
import 'package:streamit_laravel/screens/watch_list/watch_list_screen.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';

import '../../../utils/constants.dart';
import '../../channel_list/channel_list_screen.dart';
import 'content_poster_component.dart';

class HorizontalPosterListComponent extends StatelessWidget {
  final CategoryListModel movieDet;
  final bool isTop10;
  final bool isTopChannel;
  final bool isSearch;
  final bool isLoading;
  final bool isWatchList;
  final String type;

  const HorizontalPosterListComponent({
    super.key,
    required this.movieDet,
    this.isTop10 = false,
    required this.isSearch,
    this.isLoading = false,
    this.isWatchList = false,
    this.isTopChannel = false,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    if (movieDet.data.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewAllWidget(
          label: movieDet.isEachWordCapitalized ? movieDet.name.capitalizeEachWord() : movieDet.name, 
          showViewAll: !isTop10 && movieDet.showViewAll,
          onButtonPressed: () {
            if (isWatchList) {
              Get.to(() => WatchListScreen());
            } else if (isTopChannel) {
              Get.to(() => ChannelListScreen(title: movieDet.name.validate()));
            } else {
              if (type case DashboardCategoryType.popularVideo) {
                Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: VideoType.video, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=$type'}));
              } else if (type case DashboardCategoryType.popularTvShow) {
                Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: VideoType.tvshow, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=$type'}));
              } else if (type case DashboardCategoryType.popularMovie) {
                Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: VideoType.movie, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=$type'}));
              } else if (type case DashboardCategoryType.latestMovies) {
                Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: VideoType.movie, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=$type'}));
              } else if (type == DashboardCategoryType.basedOnLikes || type == DashboardCategoryType.basedOnViews) {
                Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: VideoType.movie, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=$type'}));
              } else if (type == DashboardCategoryType.trendingInCountry) {
                Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: VideoType.movie, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=$type'}));
              } else if (type case DashboardCategoryType.payPerView) {
                Get.to(() => RentalListScreen());
              } else if (type case DashboardCategoryType.freeMovie) {
                String param = '';
                param = '${ApiRequestKeys.searchTypeKey}=${VideoType.movie}';
                param += '&${ApiRequestKeys.accessKey}=${MovieAccess.freeAccess}';
                Get.to(
                  () => FilteredContentListScreen(
                    title: movieDet.name.validate(),
                    showFilter: false,
                  ),
                  arguments: ArgumentModel(stringArgument: param, intArgument: 0),
                );
              } else if (movieDet.isOtherSection) {
                if(movieDet.slug.isNotEmpty && movieDet.type.isNotEmpty) {
                  Get.to(() => ContentListScreen(title: movieDet.name.validate()), arguments: ArgumentModel(stringArgument: movieDet.type, extra: {'extraStringArguments': '${ApiRequestKeys.contentTypeKey}=${movieDet.slug}'}));
                }
              }
            }
          },
        ),
        HorizontalList(
          physics: isLoading ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
          runSpacing: 10,
          spacing: 10,
          itemCount: movieDet.data.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final PosterDataModel movie = movieDet.data[index];
            return ContentListComponent(
              contentData: movie,
              isLoading: isLoading,
              topTenIndex: isTop10 ? index : -1,
              isHorizontalList: isTopChannel,
            );
          },
        ),
      ],
    );
  }
}