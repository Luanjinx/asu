import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/components/loader_widget.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/search/components/categories_chips_list.dart';
import 'package:streamit_laravel/screens/search/components/genre_chips_list.dart';
import 'package:streamit_laravel/screens/search/components/search_text_field.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import 'components/empty_search_list_component.dart';
import 'components/popular_searches_component.dart';
import 'components/search_component.dart';
import 'search_controller.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchScreenController searchCont = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return NewAppScaffold(
        isPinnedAppbar: true,
        scrollController: searchCont.scrollController,
        isLoading: searchCont.isTyping.value ? false.obs : searchCont.isLoading,
        currentPage: searchCont.currentPage,
        applyLeadingBackButton: false,
        onRefresh: () {
          searchCont.onSwipeRefresh();
          searchCont.getPopularSearches(showLoader: false);
          searchCont.fetchGenres(force: true);
        },
        expandedHeight: MediaQuery.of(context).viewPadding.top,
        appBarTitleText: locale.value.search,
        appBarBottomWidget: Container(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SearchTextFieldComponent(searchCont: searchCont),
        ),
        body: Obx(
          () => Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  CategoriesChipsListComponent(searchCont: searchCont),
                  GenreChipsListComponent(searchCont: searchCont),
                  if (!searchCont.isTyping.value && searchCont.searchCont.text.isEmpty) PopularSearchesComponent(searchCont: searchCont),
                  AnimatedWrap(
                    runSpacing: 12,
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    listAnimationType: commonListAnimationType,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchComponent(searchController: searchCont).visible(searchCont.searchCont.text.isNotEmpty),
                            if (searchCont.defaultPopularList.value.data.isNotEmpty) EmptySearchListComponent(sectionCategoryData: searchCont.defaultPopularList.value),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: searchCont.isListening.isTrue
                      ? Container(
                          color: Colors.black.withValues(alpha: 0.7),
                          child: const VoiceSearchLoadingWidget().center(),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}