import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/addon_bridge/short_drama/short_drama_bridge.dart';
import 'package:streamit_laravel/ads/ads_helper.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/home/model/dashboard_res_model.dart';
import 'package:streamit_laravel/screens/slider/slider_controller.dart';
import 'package:streamit_laravel/screens/watch_list/model/watch_list_resp.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../../main.dart';
import '../../network/core_api.dart';
import '../../utils/common_base.dart';
import '../../utils/common_functions.dart';

class HomeController extends BaseController {
  RxBool showCategoryShimmer = false.obs;
  RxBool isWatchListLoading = false.obs;

  Rx<Future<DashboardDetailResponse>> dashboardDetailsFuture = Future(() => DashboardDetailResponse(data: DashboardModel())).obs;
  Rx<Future<DashboardDetailResponse>> dashboardOtherDetailsFuture = Future(() => DashboardDetailResponse(data: DashboardModel())).obs;

  SliderController sliderController = SliderController();

  RxList<CategoryListModel> dashboardOtherDetailsSectionList = RxList();

  //BannerAd
  BannerAd? bannerAd;
  RxBool isAdShow = false.obs;

  @override
  void onInit() {
    init(showLoader: true);
    initScrollListener(onNextPage: onNextPage);
    ShortDramaBridge.initHomeFeature(this);
    if(Platform.isAndroid) {
      showAppUpdateDialog(Get.context!);
    }
    super.onInit();
  }

  Future<void> init({
    bool showLoader = false,
    bool forceConfigSync = false,
    bool isOtherDetailLoad = false,
  }) async {
    isLastPage(false);
    getAppConfigurations(forceConfigSync);

    if (appConfigs.value.enableAds.getBoolInt()) bannerLoad();
    await Future.wait(
      [
        getNotificationCount(),
        sliderController.getBanner(type: BannerType.home, showLoader: showLoader),
        getDashboardDetail(showLoader: showLoader),
      ],
    );
    if(isOtherDetailLoad) {
      onNextPage();
    }
  }

  void onNextPage() {
    if (!isLastPage.value) {
      getOtherDashboardDetails(showLoader: true);
    }
  }

  Future<void> bannerLoad() async {
    bannerAd = BannerAd(
      adUnitId: AdHelper().bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          isAdShow(true);
        },
      ),
    );
    await bannerAd?.load();
  }

  ///Get Dashboard List
  Future<void> getDashboardDetail({bool showLoader = false}) async {
    showCategoryShimmer(showLoader);

    await dashboardDetailsFuture(CoreServiceApis.getDashboard()).then((value) async {
      value.data.continueWatch.validate().removeWhere((continueWatchData) {
        return calculatePendingPercentage(
              continueWatchData.details.duration.isEmpty || continueWatchData.details.duration == "00:00:00" ? "00:00:01" : continueWatchData.details.duration,
              continueWatchData.details.watchedDuration.isEmpty || continueWatchData.details.watchedDuration == "00:00:00" ? "00:00:01" : continueWatchData.details.watchedDuration,
            ).$1 ==
            1;
      });

      cachedDashboardDetailResponse = value;
      setIntToLocal(SharedPreferenceConst.DASHBOARD_DETAIL_LAST_CALL_TIME, DateTime.timestamp().millisecondsSinceEpoch);
      await createCategorySections(value.data, isFirstPage: true);
    }).whenComplete(
      () {
        showCategoryShimmer(false);
      },
    ).catchError((e) {
      showCategoryShimmer(false);
    });
  }

  Future<void> getNotificationCount() async {
    if(loginUserData.value.id < 1) return;
    await CoreServiceApis.getNotificationCount().then((value) async {
      appUnReadNotificationCount(value.data);
      setIntToLocal(SharedPreferenceConst.CACHE_UNREAD_NOTIFICATION_COUNT, appUnReadNotificationCount.value);
    }).catchError((e) {
      log('Notification Count Error: $e');
    });
  }

  Future<void> getOtherDashboardDetails({bool showLoader = false}) async {
    if (isLastPage.value || showCategoryShimmer.value) return;
    showCategoryShimmer(showLoader);
    await dashboardOtherDetailsFuture(CoreServiceApis.getDashboardDetailOtherData())
        .then((value) async {
          isLastPage(true);
          await createCategorySections(value.data, isFirstPage: false);
          showCategoryShimmer(false);
          final DashboardDetailResponse? oldData = cachedDashboardDetailResponse;
          cachedDashboardDetailResponse = value;
          if (oldData != null) {
            cachedDashboardDetailResponse!.data.continueWatch = oldData.data.continueWatch;
            cachedDashboardDetailResponse!.data.top10List = oldData.data.top10List;
            cachedDashboardDetailResponse!.data.latestList = oldData.data.latestList;
            cachedDashboardDetailResponse!.data.likeMovieList = oldData.data.likeMovieList;
            cachedDashboardDetailResponse!.data.viewedMovieList = oldData.data.viewedMovieList;
            cachedDashboardDetailResponse!.data.basedOnLastWatchMovieList = oldData.data.basedOnLastWatchMovieList;
          }

          setJsonToLocal(SharedPreferenceConst.CACHE_DASHBOARD_RESPONSE, cachedDashboardDetailResponse!.data.toJson());
        })
        .whenComplete(() => showCategoryShimmer(false))
        .catchError((e) {
          isLastPage(false);
          showCategoryShimmer(false);
        });
  }

  Future<void> createCategorySections(DashboardModel dashboard, {bool isFirstPage = true}) async {
    showCategoryShimmer(true);

    final DashboardModel newDashboardData = removeNotEnableModuleSections(dashboard);

    if (isFirstPage) {
      createDashboardFirstSectionList(newDashboardData);
    } else {
      createDashboardOtherSectionList(newDashboardData);
    }

    showCategoryShimmer(false);
  }

  DashboardModel removeNotEnableModuleSections(DashboardModel dashboard) {
    if (!appConfigs.value.enableMovie) {
      for (var list in [
        dashboard.basedOnLastWatchMovieList,
        dashboard.trendingInCountryMovieList,
        dashboard.trendingMovieList,
        dashboard.likeMovieList,
        dashboard.viewedMovieList,
        dashboard.payPerView,
      ]) {
        list.removeWhere((e) => e.details.type == VideoType.movie);
      }
    }

    if (!appConfigs.value.enableTvShow) {
      for (var list in [
        dashboard.basedOnLastWatchMovieList,
        dashboard.trendingInCountryMovieList,
        dashboard.trendingMovieList,
        dashboard.likeMovieList,
        dashboard.viewedMovieList,
        dashboard.payPerView,
      ]) {
        list.removeWhere((e) => e.details.type == VideoType.tvshow || e.details.type == VideoType.episode);
      }
    }

    if (!appConfigs.value.enableVideo) {
      for (var list in [
        dashboard.basedOnLastWatchMovieList,
        dashboard.trendingInCountryMovieList,
        dashboard.trendingMovieList,
        dashboard.likeMovieList,
        dashboard.viewedMovieList,
        dashboard.payPerView,
      ]) {
        list.removeWhere((e) => e.details.type == VideoType.video);
      }
    }

    return dashboard;
  }

  void addOrReplaceSection({
    required List<CategoryListModel> targetList,
    required CategoryListModel newSection,
    required int index,
    bool skipIfEmpty = false,
  }) {
    if (skipIfEmpty && newSection.data.isEmpty) return;
    int existingIndex = targetList.indexWhere((element) => element.sectionType == newSection.sectionType);
    if (existingIndex != -1) {
      targetList.removeAt(existingIndex);
    }
    existingIndex = -1;
    if (targetList.length > index) {
      targetList.insert(index, newSection);
      return;
    }

    if (existingIndex != -1) {
      if (targetList[existingIndex].data.isNotEmpty) {
        targetList[existingIndex] = newSection;
      } else {
        targetList.removeAt(existingIndex);
      }
    } else {
      targetList.add(newSection);
    }
  }

  void createDashboardFirstSectionList(DashboardModel dashboard) {
    if (appConfigs.value.enableContinueWatch) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.continueWatching,
          sectionType: DashboardCategoryType.continueWatching,
          data: dashboard.continueWatch,
        ),
        index: 0,
      );
    }

    addOrReplaceSection(
      targetList: dashboardOtherDetailsSectionList,
      newSection: CategoryListModel(
        name: dashboard.top10List?.name ?? '',
        sectionType: DashboardCategoryType.top10,
        data: dashboard.top10List?.data ?? [],
      ),
      index: 1,
    );

    if (isAdsAllowed) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          sectionType: DashboardCategoryType.customAd,
          data: dashboard.customAdList,
        ),
        index: 2,
      );
    } else {
      dashboardOtherDetailsSectionList.removeWhere(
          (element) => element.sectionType == DashboardCategoryType.customAd);
    }

    // 🎬 Latest Movies
    if (appConfigs.value.enableMovie) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.latestMovies,
          sectionType: DashboardCategoryType.latestMovies,
          data: dashboard.latestList?.data ?? [],
          showViewAll: dashboard.latestList!.data.length > 8,
        ),
        index: 3,
      );
    }

    // 💰 Pay Per View
    addOrReplaceSection(
      targetList: dashboardOtherDetailsSectionList,
      newSection: CategoryListModel(
        name: locale.value.payPerView,
        sectionType: DashboardCategoryType.payPerView,
        data: dashboard.payPerView,
        showViewAll: true,
      ),
      index: 4,
    );

    // 🌐 Languages
    addOrReplaceSection(
      targetList: dashboardOtherDetailsSectionList,
      newSection: CategoryListModel(
        name: dashboard.popularLanguageList?.name ?? locale.value.popularLanguages,
        sectionType: DashboardCategoryType.popularLanguage,
        data: dashboard.popularLanguageList?.languageList ?? [],
        showViewAll: true,
      ),
      index: 5,
    );

    // 🎥 Popular Movies
    if (appConfigs.value.enableMovie) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: dashboard.popularMovieList?.name ?? '',
          sectionType: DashboardCategoryType.popularMovie,
          data: dashboard.popularMovieList?.data ?? [],
          showViewAll: (dashboard.popularMovieList?.data ?? []).length > 9,
        ),
        index: 6,
      );
    }
  }

  Future<void> createDashboardOtherSectionList(DashboardModel dashboard) async {
    // 📺 Live TV Channels
    if (appConfigs.value.enableLiveTv) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: dashboard.topChannelList?.name ?? '',
          sectionType: DashboardCategoryType.channels,
          data: dashboard.topChannelList?.data ?? [],
          showViewAll: true,
        ),
        index: 7,
      );
    }

    // 📺 Popular TV Shows
    if (appConfigs.value.enableTvShow) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: dashboard.popularTvShowList?.name ?? '',
          sectionType: DashboardCategoryType.popularTvShow,
          data: dashboard.popularTvShowList?.data ?? [],
          showViewAll: dashboard.popularTvShowList!.data.length > 8,
        ),
        index: 8,
      );
    }

    // 👩‍🎤 Personalities
    addOrReplaceSection(
      targetList: dashboardOtherDetailsSectionList,
      newSection: CategoryListModel(
        name: dashboard.actorList?.name ?? '',
        sectionType: DashboardCategoryType.personality,
        data: dashboard.actorList?.data ?? [],
        showViewAll: true,
      ),
      index: 9,
    );

    // 🆓 Free Movies
    if (appConfigs.value.enableMovie) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: dashboard.freeMovieList?.name ?? '',
          sectionType: DashboardCategoryType.freeMovie,
          data: dashboard.freeMovieList?.data ?? [],
          showViewAll: true,
        ),
        index: 10,
      );
    }

    // 🎭 Genres
    addOrReplaceSection(
      targetList: dashboardOtherDetailsSectionList,
      newSection: CategoryListModel(
        name: locale.value.genres,
        sectionType: DashboardCategoryType.genres,
        data: dashboard.genreList?.data ?? [],
        showViewAll: true,
      ),
      index: 11,
    );

    // 📼 Popular Videos
    if (appConfigs.value.enableVideo) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.popularVideos,
          sectionType: DashboardCategoryType.popularVideo,
          data: dashboard.popularVideoList?.data ?? [],
          showViewAll: true,
        ),
        index: 12,
      );
    }

    if (isLoggedIn.value) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.basedOnYourPreviousWatch,
          sectionType: DashboardCategoryType.basedOnPreviousWatch,
          data: dashboard.basedOnLastWatchMovieList,
        ),
        index: 13,
      );

      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.mostLiked,
          sectionType: DashboardCategoryType.basedOnLikes,
          data: dashboard.likeMovieList,
          showViewAll: true,
        ),
        index: 14,
      );

      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.mostViewed,
          sectionType: DashboardCategoryType.basedOnViews,
          data: dashboard.viewedMovieList,
          showViewAll: true,
          isEachWordCapitalized: false
        ),
        index: 15,
      );
    }

    // 🔥 Trending
    await setJsonToLocal(
      SharedPreferenceConst.POPULAR_MOVIE,
      ListResponse(
        data: dashboard.trendingMovieList,
        name: locale.value.trendingMovies,
      ).toListJson(),
    );

    if (isLoggedIn.value) {
      // Trending in your country
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.trendingInYourCountry,
          sectionType: DashboardCategoryType.trendingInCountry,
          data: dashboard.trendingInCountryMovieList,
          showViewAll: true,
        ),
        index: 16,
      );

      // Favorite genres
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.favoriteGenres,
          sectionType: DashboardCategoryType.favoriteGenres,
          data: dashboard.favGenreList,
        ),
        index: 17,
      );

      // Favorite personalities
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        newSection: CategoryListModel(
          name: locale.value.yourFavoritePersonalities,
          sectionType: DashboardCategoryType.favoritePersonality,
          data: dashboard.favActorList,
        ),
        index: 18,
      );
    }

    dashboardOtherDetailsSectionList.removeWhere((element) => element.isOtherSection);

    // 🔄 Dynamic Other Sections
    for (final section in dashboard.otherSection) {
      addOrReplaceSection(
        targetList: dashboardOtherDetailsSectionList,
        skipIfEmpty: true,
        newSection: CategoryListModel(
          name: section.name,
          sectionType: '${DashboardCategoryType.otherSections}_${section.slug}',
          data: section.data,
          showViewAll: true,
          isOtherSection: true,
          slug: section.slug,
          type: section.type,
        ),
        index: dashboardOtherDetailsSectionList.length + 1,
      );
    }

    if(isLoggedIn.value) {
      if (appConfigs.value.enableAds.getBoolInt()) {
        addOrReplaceSection(
          targetList: dashboardOtherDetailsSectionList,
          newSection: CategoryListModel(
            sectionType: DashboardCategoryType.advertisement,
            data: [],
          ),
          index: dashboardOtherDetailsSectionList.length + 1,
        );
      }      
    }

    if(isLoggedIn.value) {
      if(appConfigs.value.enableRateUs) { 
        addOrReplaceSection(
          targetList: dashboardOtherDetailsSectionList,
          newSection: CategoryListModel(
            name: locale.value.rateOurApp,
            sectionType: DashboardCategoryType.rateApp,
            data: [],
            showViewAll: false,
          ),
          index: dashboardOtherDetailsSectionList.length + 1,
        );
      }
    }
  }

  Future<void> getAppConfigurations(bool forceSync) async {
    if (forceSync) CoreServiceApis.getAppConfigurations(forceSync: forceSync);
  }

  /// Remove a continue-watching item and refresh the section immediately.
  PosterDataModel? removeFromContinueWatching(int id) {
    final int sectionIndex = dashboardOtherDetailsSectionList.indexWhere(
      (element) => element.sectionType == DashboardCategoryType.continueWatching,
    );

    if (sectionIndex == -1) return null;

    final CategoryListModel section = dashboardOtherDetailsSectionList[sectionIndex];
    final List<PosterDataModel> updatedData = List<PosterDataModel>.from(section.data.cast<PosterDataModel>());
    final int removedIndex = updatedData.indexWhere((element) => element.id == id);
    if (removedIndex == -1) return null;

    final PosterDataModel removedItem = updatedData.removeAt(removedIndex);

    dashboardOtherDetailsSectionList[sectionIndex] = CategoryListModel(
      name: section.name,
      sectionType: section.sectionType,
      data: updatedData,
      showViewAll: section.showViewAll,
    );
    dashboardOtherDetailsSectionList.refresh();

    cachedDashboardDetailResponse?.data.continueWatch.removeWhere((element) => element.id == id);

    return removedItem;
  }

  /// Restore a previously removed continue-watching item (used on API failure).
  void addContinueWatchingItem(PosterDataModel item, {int? index}) {
    final int sectionIndex = dashboardOtherDetailsSectionList.indexWhere(
      (element) => element.sectionType == DashboardCategoryType.continueWatching,
    );

    if (sectionIndex == -1) return;

    final CategoryListModel section = dashboardOtherDetailsSectionList[sectionIndex];
    final List<PosterDataModel> updatedData = List<PosterDataModel>.from(section.data.cast<PosterDataModel>());
    final int insertIndex = (index != null && index >= 0 && index <= updatedData.length) ? index : updatedData.length;

    updatedData.insert(insertIndex, item);

    dashboardOtherDetailsSectionList[sectionIndex] = CategoryListModel(
      name: section.name,
      sectionType: section.sectionType,
      data: updatedData,
      showViewAll: section.showViewAll,
    );
    dashboardOtherDetailsSectionList.refresh();

    final int cacheLength = cachedDashboardDetailResponse?.data.continueWatch.length ?? 0;
    final int cacheInsertIndex = (index != null && index >= 0 && index <= cacheLength) ? index : cacheLength;
    cachedDashboardDetailResponse?.data.continueWatch.insert(cacheInsertIndex, item);
  }

  void removeAdFromSection(int mainIndex, int listIndex) {
    if (dashboardOtherDetailsSectionList.length > mainIndex) {
      final section = dashboardOtherDetailsSectionList[mainIndex];
      if (section.sectionType == DashboardCategoryType.customAd) {
        section.data.removeAt(listIndex);
        dashboardOtherDetailsSectionList[mainIndex] = section;
      }
    }
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    ShortDramaBridge.disposeHomeFeature(this);
    super.onClose();
  }
}