import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_no_data_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/coming_soon/coming_soon_detail_screen.dart';
import 'package:streamit_laravel/screens/coming_soon/model/coming_soon_response.dart';
import 'package:streamit_laravel/screens/content/components/content_poster_component.dart';
import 'package:streamit_laravel/screens/content/content_details_screen.dart';
import 'package:streamit_laravel/screens/content/content_list_shimmer.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/components/person_component/person_card.dart';
import 'package:streamit_laravel/screens/live_tv/live_tv_details/live_tv_details_screen.dart';
import 'package:streamit_laravel/screens/search/search_controller.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';
import 'package:streamit_laravel/utils/empty_error_state_widget.dart';

class SearchComponent extends StatelessWidget {
  SearchComponent({super.key, required this.searchController});

  final SearchScreenController searchController;

  @override
  Widget build(BuildContext context) {
    final dynamicSpacing = getDynamicSpacing();

    return Obx(
      () {
        if (searchController.isLoading.value && searchController.isTyping.value) {
          return ContentListShimmer(
            width: dynamicSpacing.$1,
            spacing: dynamicSpacing.$2,
          );
        }

        final bool hasActorResults = searchController.actorSearchResults.isNotEmpty;
        final bool hasDirectorResults = searchController.directorSearchResults.isNotEmpty;
        final List<_SearchSection> contentSections = [
          _SearchSection(title: locale.value.movies, items: searchController.movieResults),
          _SearchSection(title: locale.value.tVShows, items: searchController.tvShowResults),
          _SearchSection(title: locale.value.videos, items: searchController.videoResults),
          _SearchSection(title: locale.value.season, items: searchController.seasonResults),
          _SearchSection(title: locale.value.episode, items: searchController.episodeResults),
          _SearchSection(title: locale.value.liveTv, items: searchController.channelResults),
        ];
        final bool hasContentResults = contentSections.any((section) => section.items.isNotEmpty);

        if (!hasActorResults && !hasDirectorResults && !hasContentResults) {
          return AppNoDataWidget(
            title: locale.value.sorryCouldnFindYourSearch,
            subTitle: locale.value.trySomethingNew,
            retryText: locale.value.searchAgain,
            imageWidget: const ErrorStateWidget(),
            onRetry: searchController.clearSearchField,
          ).visible(!searchController.isLoading.value).paddingBottom(32);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasActorResults) ...[
              Text(locale.value.actors, style: boldTextStyle()),
              12.height,
              AnimatedWrap(
                spacing: dynamicSpacing.$2,
                runSpacing: dynamicSpacing.$2,
                listAnimationType: commonListAnimationType,
                itemCount: searchController.actorSearchResults.length,
                itemBuilder: (context, index) {
                  return PersonCard(
                    castData: searchController.actorSearchResults[index],
                    height: Get.height * 0.18,
                    width: dynamicSpacing.$1,
                  );
                },
              ),
              24.height,
            ],
            if (hasDirectorResults) ...[
              Text(locale.value.directors, style: boldTextStyle()),
              12.height,
              AnimatedWrap(
                spacing: dynamicSpacing.$2,
                runSpacing: dynamicSpacing.$2,
                listAnimationType: commonListAnimationType,
                itemCount: searchController.directorSearchResults.length,
                itemBuilder: (context, index) {
                  return PersonCard(
                    castData: searchController.directorSearchResults[index],
                    height: Get.height * 0.18,
                    width: dynamicSpacing.$1,
                  );
                },
              ),
              24.height,
            ],
            for (final section in contentSections)
              if (section.items.isNotEmpty) ...[
                Text(section.title, style: boldTextStyle()),
                12.height,
                AnimatedWrap(
                  spacing: 12,
                  runSpacing: 12,
                  listAnimationType: commonListAnimationType,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  itemCount: section.items.length,
                  itemBuilder: (context, index) {
                    PosterDataModel searchData = section.items[index];
                    return ContentListComponent(
                      contentData: searchData,
                      onTap: () {
                        if (isLoggedIn.value)
                          searchController.saveSearch(
                            searchQuery: searchData.details.name,
                            type: searchData.details.type,
                            searchId: searchData.id,
                            resetAfterSave: false,
                          );
                        if (searchData.details.releaseDate.isNotEmpty && isComingSoon(searchData.details.releaseDate)) {
                          final comingSoonData = ComingSoonModel.fromJson(searchData.details.toListJson());
                          Get.to(
                            () => ComingSoonDetailScreen(
                              comingSoonData: comingSoonData,
                            ),
                            arguments: comingSoonData,
                          );
                        } else if (searchData.details.type == VideoType.liveTv) {
                          Get.to(() => LiveContentDetailsScreen(), arguments: searchData);
                        } else {
                          Get.to(() => ContentDetailsScreen(), arguments: searchData);
                        }
                      },
                    );
                  },
                ),
                24.height,
              ],
          ],
        );
      },
    );
  }
}

class _SearchSection {
  final String title;
  final List<PosterDataModel> items;

  _SearchSection({required this.title, required this.items});
}