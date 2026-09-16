import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/generated/assets.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';

import '../../../main.dart';
import '../../../utils/colors.dart';
import '../../../utils/common_base.dart';
import '../../../utils/common_functions.dart';

class CategoriesChipsListComponent extends StatelessWidget {
  const CategoriesChipsListComponent({super.key, required this.searchCont});

  final SearchScreenController searchCont;

  static const List<String> categories = [
    'Movies',
    'TV Shows',
    'Videos',
    'Seasons',
    'Episodes',
    'Live TV',
    'Actors',
    'Directors',
  ];

  String getCategoryLabel(String category) {
    switch (category) {
      case 'Movies':
        return locale.value.movies;
      case 'TV Shows':
        return locale.value.tVShows;
      case 'Videos':
        return locale.value.videos;
      case 'Seasons':
        return locale.value.season;
      case 'Episodes':
        return locale.value.episode;
      case 'Live TV':
        return locale.value.liveTv;
      case 'Actors':
        return locale.value.actors;
      case 'Directors':
        return locale.value.directors;
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMovieEnabled = appConfigs.value.enableMovie;
    final bool isTvShowEnabled = appConfigs.value.enableTvShow;
    final bool isVideoEnabled = appConfigs.value.enableVideo;
    final bool isLiveTvEnabled = appConfigs.value.enableLiveTv;

    final filteredCategories = categories.where((category) {
      if (category == 'Movies' && !isMovieEnabled) return false;
      if (category == 'TV Shows' && !isTvShowEnabled) return false;
      if (category == 'Videos' && !isVideoEnabled) return false;
      if ((category == 'Seasons' || category == 'Episodes') && !isTvShowEnabled) return false;
      if (category == 'Live TV' && !isLiveTvEnabled) return false;
      return true;
    }).toList();

    // Drop any disabled selections so they are not used in searches.
    searchCont.selectedCategories.removeWhere(
      (c) => !filteredCategories.contains(c),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconWidget(
                imgPath: Assets.iconsFilter,
                color: context.primaryColor,
                size: 18,
              ),
              8.width,
              Text(
                locale.value.categories,
                style: commonPrimaryTextStyle(size: 16),
              ),
            ],
          ),
          8.height,
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filteredCategories.map((category) {
                  final isSelected = searchCont.selectedCategories.contains(category);
                  return GestureDetector(
                    onTap: () => searchCont.toggleCategorySelection(category),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: boxDecorationDefault(
                        color: isSelected ? context.primaryColor : cardColor,
                        borderRadius: BorderRadius.circular(4),
                        border: isSelected ? null : Border.all(color: iconColor.withValues(alpha: 0.3), width: 1),
                      ),
                      child: Text(
                        getCategoryLabel(category),
                        style: commonSecondaryTextStyle(color: isSelected ? white : null),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}