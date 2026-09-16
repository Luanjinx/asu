import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/components/banner_ad_component.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/components/continue_watch_component.dart';
import 'package:streamit_laravel/screens/home/components/person_component/person_component.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../../../../utils/common_base.dart';
import '../../content/components/auto_slider_component.dart';
import '../../content/components/horizontal_poster_list_component.dart';
import '../model/dashboard_res_model.dart';
import 'ad_component.dart';
import 'geners/genres_component.dart';
import 'language_component/language_component.dart';
import 'rate/rate_component.dart';

class CategoryListComponent extends StatelessWidget {
  final RxList<CategoryListModel> categoryList;
  final bool isSearch;
  final bool isLoading;
  final void Function(int mainIndex, int listIndex)? onRemoveAd;

  const CategoryListComponent({super.key, required this.categoryList, this.isSearch = false, this.isLoading = false, this.onRemoveAd});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (categoryList.isEmpty) return const SizedBox.shrink();
        return AnimatedWrap(
          runSpacing: 12,
          spacing: 12,
          listAnimationType: commonListAnimationType,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            final CategoryListModel category = categoryList[index];

            switch (category.sectionType) {
              case DashboardCategoryType.continueWatching:
                if (!isLoggedIn.value) return SizedBox.shrink();
                return ContinueWatchComponent(continueWatchList: category.data as List<PosterDataModel>);
              case DashboardCategoryType.top10:
                return HorizontalPosterListComponent(
                  movieDet: category,
                  isTop10: true,
                  isSearch: isSearch,
                  type: category.sectionType,
                );
              case DashboardCategoryType.advertisement:
                return AdComponent();
              case DashboardCategoryType.popularTvShow:
              case DashboardCategoryType.popularVideo:
              case DashboardCategoryType.popularMovie:
                return HorizontalPosterListComponent(
                  movieDet: category,
                  isSearch: isSearch,
                  type: category.sectionType,
                  isLoading: isLoading,
                );
              case DashboardCategoryType.channels:
                return HorizontalPosterListComponent(
                  movieDet: category,
                  isSearch: isSearch,
                  isTopChannel: true,
                  type: category.sectionType,
                  isLoading: isLoading,
                );
              case DashboardCategoryType.customAd:
                return AutoSliderComponent(
                  isAutoSlide: !category.data.any((element) => (element.type == VideoType.video)),
                  tag: DashboardCategoryType.customAd,
                  height: Get.height * 0.20,
                  sliderLength: category.data.length,
                  sliderChildren: List.generate(
                    category.data.length,
                    (i) {
                      final CustomAds data = category.data[i];
                      return BannerAdComponent(
                        bannerHeight: Get.height * 0.20,
                        adUrl: data.url,
                        adType: data.type,
                        redirectUrl: data.redirectUrl,
                        onVideoCompleted: () {
                          if (Get.isRegistered<AutoSliderController>(tag: DashboardCategoryType.customAd)) {
                            Get.find<AutoSliderController>(tag: DashboardCategoryType.customAd).nextPage();
                          }
                        },
                      ).paddingSymmetric(horizontal: 12);
                    },
                  ),
                ).paddingTop(20);
              case DashboardCategoryType.popularLanguage:
                return LanguageComponent(
                  languageDetails: category,
                  isLoading: isLoading,
                );
              case DashboardCategoryType.favoritePersonality:
              case DashboardCategoryType.personality:
                return PersonComponent(
                  personDetails: category,
                  isLoading: isLoading,
                  showViewAll: category.showViewAll,
                );
              case DashboardCategoryType.genres:
              case DashboardCategoryType.favoriteGenres:
                return GenreComponent(
                  genresDetails: category,
                  isLoading: isLoading,
                );
              case DashboardCategoryType.rateApp:
                return RateComponent(
                  rateDetails: category,
                  isLoading: isLoading,
                );
              default:
                return HorizontalPosterListComponent(
                  movieDet: category,
                  isSearch: isSearch,
                  isLoading: isLoading,
                  type: category.sectionType,
                );
            }
          },
        );
      },
    );
  }
}