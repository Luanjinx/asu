import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/models/base_response_model.dart';
import 'package:streamit_laravel/network/core_api.dart';
import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/watch_list/model/watch_list_resp.dart';
import 'package:streamit_laravel/services/local_storage_service.dart';
import 'package:streamit_laravel/utils/api_end_points.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

import '../../utils/constants.dart';
import '../genres/model/genres_model.dart';
import '../home/model/dashboard_res_model.dart';

class SearchScreenController extends BaseListController<PosterDataModel> {
  TextEditingController searchCont = TextEditingController();
  FocusNode searchFocus = FocusNode();
  stt.SpeechToText speechToText = stt.SpeechToText();
  RxBool isListening = false.obs;
  RxList<String> popularSearchList = <String>[].obs;
  RxBool isLoadingPopularSearches = false.obs;
  Rx<CategoryListModel> defaultPopularList = CategoryListModel().obs;
  RxBool isTyping = false.obs;
  RxList<Cast> actorSearchResults = <Cast>[].obs;
  RxList<Cast> directorSearchResults = <Cast>[].obs;
  RxList<PosterDataModel> movieResults = <PosterDataModel>[].obs;
  RxList<PosterDataModel> tvShowResults = <PosterDataModel>[].obs;
  RxList<PosterDataModel> videoResults = <PosterDataModel>[].obs;
  RxList<PosterDataModel> seasonResults = <PosterDataModel>[].obs;
  RxList<PosterDataModel> episodeResults = <PosterDataModel>[].obs;
  RxList<PosterDataModel> channelResults = <PosterDataModel>[].obs;
  RxList<String> selectedCategories = <String>[].obs;
  RxList<GenreModel> genresList = <GenreModel>[].obs;
  RxList<int> selectedGenreIds = <int>[].obs;
  RxBool isLoadingGenres = false.obs;
  bool _hasFetchedGenres = false;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    searchCont.addListener(_onSearchChanged);
  }

  @override
  void onReady() {
    if (Get.arguments is ArgumentModel) {
      ArgumentModel argumentModel = Get.arguments as ArgumentModel;
      searchContent(params: argumentModel.stringArgument);
    } else
      init();
  }

  void _onSearchChanged() {
    final text = searchCont.text;
    isTyping.value = text.length > 2;

    if (isTyping.value) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        onSearch();
      });
    }
  }

  // Method to clear search text field
  void clearSearchField() {
    hideKeyBoardWithoutContext();
    searchCont.clear();

    isTyping.value = false;
    listContent.clear();
    actorSearchResults.clear();
    directorSearchResults.clear();
    movieResults.clear();
    tvShowResults.clear();
    videoResults.clear();
    seasonResults.clear();
    episodeResults.clear();
    channelResults.clear();
    selectedCategories.clear();
    selectedGenreIds.clear();
    init();
    refresh();
  }

  Future<void> searchContent({bool showLoader = true, String params = ''}) async {
    if (isLoading.value) return;
    setLoading(showLoader);

    await getListData(showLoader: showLoader, params: params);
  }

  //Get Search List
  @override
  Future<void> getListData({bool showLoader = true, String params = ''}) async {
    setLoading(showLoader);
    await CoreServiceApis.searchContentDetailed(queryParams: params).then(
      (response) {
        movieResults(response.movieList);
        tvShowResults(response.tvShowList);
        videoResults(response.videoList);
        seasonResults(response.seasonList);
        episodeResults(response.episodeList);
        channelResults(response.channelList);

        final List<PosterDataModel> contentResults = [
          ...response.movieList,
          ...response.tvShowList,
          ...response.videoList,
          ...response.seasonList,
          ...response.episodeList,
          ...response.channelList,
        ];

        listContentFuture(Future.value(contentResults));
        listContent(contentResults);
        actorSearchResults(response.actorList);
        directorSearchResults(response.directorList);
      },
    ).whenComplete(() => setLoading(false));
  }

  void onSearch() {
    if (searchCont.text.length > 2) {
      final params = [
        '${ApiRequestKeys.searchKey}=${searchCont.text}',
        if (buildSearchTypeParam() != null) buildSearchTypeParam()!,
        if (selectedGenreIds.isNotEmpty) '${ApiRequestKeys.genreId}=${selectedGenreIds.join(',')}',
      ].where((e) => e.isNotEmpty).join('&');
      searchContent(params: params);
    }
    isTyping.value = searchCont.text.isNotEmpty;
  }

  Future<void> startListening() async {
    final bool available = await speechToText.initialize(
      onStatus: (status) {
        if (status == 'done') {
          isListening(false);
        }
      },
      onError: (error) => log('onError: $error'),
    );
    if (available) {
      isListening(true);
      speechToText.listen(onResult: (result) {
        searchCont.text = result.recognizedWords;

        if (searchCont.text.length > 2) {
          onSearch();
        }
      });
    }
  }

  void stopListening() {
    speechToText.stop();
    isListening(false);
  }

  Future<void> saveSearch({required String searchQuery, required String type, required int searchId, bool resetAfterSave = true}) async {
    setLoading(true);
    CoreServiceApis.saveSearch(
      request: {
        ApiRequestKeys.searchQueryKey: searchQuery,
        ApiRequestKeys.profileIdKey: selectedAccountProfile.value.id,
        ApiRequestKeys.searchIdKey: searchId,
        ApiRequestKeys.typeKey: type,
      },
    ).catchError((e) {
      throw e;
    }).whenComplete(() {
      if (resetAfterSave) {
        hideKeyBoardWithoutContext();
        clearSearchField();
      }
      setLoading(false);
    });
  }

  ///Get search List
  Future<void> init() async {
    Map<String, dynamic>? defaultData = await getJsonFromLocal(SharedPreferenceConst.POPULAR_MOVIE) ?? null;
    if (defaultData != null) {
      ListResponse list = ListResponse.fromListJson(defaultData);
      defaultPopularList.value = CategoryListModel(showViewAll: false, sectionType: list.name.validate(), data: list.data);
    }

    if (isLoggedIn.value) {
      await getPopularSearches(showLoader: false);
    }
    await fetchGenres();
    refresh();
  }

  /// Fetch genres list
  Future<void> fetchGenres({bool force = false}) async {
    if (isLoadingGenres.value) return;
    if (_hasFetchedGenres && !force) return;
    isLoadingGenres(true);
    try {
      final List<GenreModel> tempList = <GenreModel>[];
      await CoreServiceApis.getGenresList(
        page: 1,
        genresList: tempList,
        lastPageCallBack: (isLast) {},
      );
      genresList(tempList);
      _hasFetchedGenres = true;
    } catch (e) {
      log('Error fetching genres: $e');
    } finally {
      isLoadingGenres(false);
    }
  }

  void toggleGenreSelection(int genreId) {
    if (selectedGenreIds.contains(genreId)) {
      selectedGenreIds.remove(genreId);
    } else {
      selectedGenreIds.add(genreId);
    }
    if (searchCont.text.length > 2) onSearch();
  }

  void toggleCategorySelection(String category) {
    selectedCategories.contains(category) ? selectedCategories.remove(category) : selectedCategories.add(category);

    if (searchCont.text.length > 2) onSearch();
  }

  String? buildSearchTypeParam() {
    if (selectedCategories.isEmpty) return null;

    const categoryMap = {
      'Movies': VideoType.movie,
      'TV Shows': VideoType.tvshow,
      'Videos': VideoType.video,
      'Seasons': VideoType.season,
      'Episodes': VideoType.episode,
      'Live TV': VideoType.liveTv,
      'Actors': 'actor',
      'Directors': 'director',
    };

    final videoTypes = selectedCategories.map((c) => categoryMap[c]).whereType<String>().toList();

    return videoTypes.isEmpty ? null : '${ApiRequestKeys.searchTypeKey}=${videoTypes.join(',')}';
  }

  /// Get Popular Searches
  Future<void> getPopularSearches({bool showLoader = false}) async {
    if (isLoadingPopularSearches.value) return;
    isLoadingPopularSearches(true);
    try {
      await CoreServiceApis.getPopularSearchList(
        page: 1,
        perPage: 5,
        popularSearchList: popularSearchList,
      );
    } catch (e) {
      log('Error fetching popular searches: $e');
    } finally {
      isLoadingPopularSearches(false);
    }
  }

  @override
  void onClose() {
    clearSearchField();
    searchCont.dispose();
    super.onClose();
  }
}