import 'dart:convert';

import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/controllers/base_controller.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/utils/common_base.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

import '../content/model/content_model.dart';
import '../downloads/models/hive_content_model.dart';

class DownloadController extends BaseListController<HiveContentModel> {
  RxList<HiveContentModel> movies = <HiveContentModel>[].obs;
  RxList<HiveContentModel> tvShows = <HiveContentModel>[].obs;
  RxList<HiveContentModel> videos = <HiveContentModel>[].obs;
  RxMap<String, List<HiveContentModel>> tvShowSeasons = <String, List<HiveContentModel>>{}.obs;

  RxList<String> availableFilter = <String>[].obs;
  RxInt currentFilterIndex = 0.obs;
  late Worker _configWorker;

  final Map<int, Map<String, dynamic>> parsedContentCache = {};

  RxBool isMultiDownalodSelected = false.obs;
  RxList<int> selectedDownloadIds = <int>[].obs;

  @override
  void onInit() {
    getListData();
    super.onInit();
    initScrollListener();
    _updateFilterTabs();
    _configWorker = ever(appConfigs, (_) => _updateFilterTabs());
  }

  @override
  Future<void> getListData({bool showLoader = true}) async {
    setLoading(showLoader);
    await listContentFuture(() async {
      return hiveService.getAllContent().toList();
    }())
        .then((value) async {
      listContent.assignAll(value);
      await loadDownloads();
    }).catchError((e) {
      setLoading(false);
      log(e.toString());
    });
  }

  Future<void> loadDownloads() async {
    setLoading(true);
    try {
      final validProfileIds = _getValidProfileIds();

      await _performSmartDelete(validProfileIds);

      final allContent = _getFilteredContent(validProfileIds);

      await _processAndCategorizeContent(allContent);
    } finally {
      setLoading(false);
    }
  }

  Future<void> _performSmartDelete(List<int> validProfileIds) async {
    if (!appSmartDownloadDeleteOn.value) return;

    final allowedProfileIds = validProfileIds.where((id) => id > 0).toList();
    if (allowedProfileIds.isEmpty) return;

    // Delete only completed downloads for the active/valid profiles.
    for (var item in listContent.where((e) => allowedProfileIds.contains(e.profileId) && e.watchedProgress >= 100.0).toList()) {
      try {
        await hiveService
            .deleteContentWithFiles(item.id)
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () => false,
            )
            .then(
          (value) {
            if (value) {
              listContent.remove(item);
            }
          },
        );
      } catch (e) {
        log('Error performing smart delete for ${item.id}: $e');
      }
    }
    listContent.refresh();
  }

  List<int> _getValidProfileIds() {
    final validProfileIds = <int>[];

    if (cachedProfileDetails != null) {
      validProfileIds.addAll(cachedProfileDetails!.data.profileList.map((e) => e.id));
    }

    if (!validProfileIds.contains(selectedAccountProfile.value.id)) {
      validProfileIds.add(selectedAccountProfile.value.id);
    }

    return validProfileIds;
  }

  List<HiveContentModel> _getFilteredContent(List<int> validProfileIds) {
    final allowedProfileIds = validProfileIds.where((id) => id > 0).toList();
    if (allowedProfileIds.isEmpty) return listContent.toList();

    // Keep items with matching profile ids; also keep items with unknown/legacy profile ids (<=0) so they don't vanish after restart.
    return listContent.where((element) => element.profileId <= 0 || allowedProfileIds.contains(element.profileId)).toList();
  }

  Future<void> _processAndCategorizeContent(List<HiveContentModel> allContent) async {
    final parsedPayloads = _parseDownloadPayloads(allContent.map((item) => item.contentData).toList());

    final movieList = <HiveContentModel>[];
    final tvShowList = <HiveContentModel>[];
    final videoList = <HiveContentModel>[];
    final groupedSeasons = <String, List<HiveContentModel>>{};

    parsedContentCache.clear();

    for (int index = 0; index < allContent.length; index++) {
      final item = allContent[index];
      final info = index < parsedPayloads.length ? parsedPayloads[index] : null;

      if (info == null) continue;

      final rawContent = _extractRawContent(info);
      final type = _determineContentType(info, rawContent);
      final seasonId = _resolveSeasonId(info, rawContent);

      if (rawContent != null) {
        parsedContentCache[item.id] = rawContent;
      }

      _categorizeContent(item, type, seasonId, movieList, tvShowList, videoList, groupedSeasons);
    }

    _updateObservables(movieList, tvShowList, videoList, groupedSeasons);
  }

  Map<String, dynamic>? _extractRawContent(Map<String, dynamic> info) {
    final content = info['content'];
    return content is Map ? Map<String, dynamic>.from(content) : null;
  }

  String _determineContentType(Map<String, dynamic> info, Map<String, dynamic>? rawContent) {
    String type = (info['type'] ?? '').toString();

    if (type.isEmpty && rawContent != null) {
      try {
        final inferred = ContentModel.fromContentJson(rawContent);
        if (inferred.details.type.isNotEmpty) {
          type = inferred.details.type;
        }
      } catch (_) {}
    }

    return type;
  }

  void _categorizeContent(
    HiveContentModel item,
    String type,
    String seasonId,
    List<HiveContentModel> movieList,
    List<HiveContentModel> tvShowList,
    List<HiveContentModel> videoList,
    Map<String, List<HiveContentModel>> groupedSeasons,
  ) {
    switch (type) {
      case VideoType.movie:
        movieList.add(item);
        break;
      case VideoType.tvshow:
      case VideoType.episode:
        tvShowList.add(item);
        groupedSeasons.putIfAbsent(seasonId, () => <HiveContentModel>[]).add(item);
        break;
      case VideoType.video:
        videoList.add(item);
        break;
    }
  }

  void _updateObservables(
    List<HiveContentModel> movieList,
    List<HiveContentModel> tvShowList,
    List<HiveContentModel> videoList,
    Map<String, List<HiveContentModel>> groupedSeasons,
  ) {
    // Sort by downloading date descending
    int sortByDate(HiveContentModel a, HiveContentModel b) {
      return (b.downloadDate ?? 0).compareTo(a.downloadDate ?? 0);
    }

    movieList.sort(sortByDate);
    tvShowList.sort(sortByDate); // This list tracks all episodes flatly if needed, but we use groupedSeasons
    videoList.sort(sortByDate);

    // Sort episodes within seasons
    for (var season in groupedSeasons.values) {
      season.sort(sortByDate);
    }

    movies.assignAll(movieList);
    tvShows.assignAll(tvShowList);
    videos.assignAll(videoList);
    tvShowSeasons.assignAll(groupedSeasons);
  }

  void _updateFilterTabs() {
    final List<String> tabs = <String>[];
    if (appConfigs.value.enableMovie) tabs.add(VideoType.movie);
    if (appConfigs.value.enableTvShow) tabs.add(VideoType.tvshow); // "Episode" in UI? User asked for Movie, Episode, Video
    if (appConfigs.value.enableVideo) tabs.add(VideoType.video);

    // Ensure we have at least these if config is weird or to match user request
    // If config is missing, maybe default to all?
    // User requested "Movie, Episode, Video".
    // I will adhere to appConfigs but ensure the mapping is correct.

    availableFilter.assignAll(tabs);
    if (availableFilter.isEmpty) {
      // Fallback or empty
    } else {
      // adjust index if out of bounds
      if (currentFilterIndex.value >= availableFilter.length) {
        currentFilterIndex.value = 0;
      }
    }
  }

  String get currentFilterType {
    if (availableFilter.isEmpty || currentFilterIndex.value >= availableFilter.length) return '';
    return availableFilter[currentFilterIndex.value];
  }

  Future<void> deleteDownload(int id) async {
    await hiveService.deleteContent(id);
    await getListData(showLoader: true);
    successSnackBar(locale.value.downloadDeletedSuccessfully);
  }

  Future<void> deleteMultipleDownload() async {
    for (var id in selectedDownloadIds) {
      await hiveService.deleteContent(id);
    }
    isMultiDownalodSelected.value = false;
    selectedDownloadIds.clear();
    await getListData(showLoader: true);
    successSnackBar(locale.value.downloadDeletedSuccessfully);
  }

  @override
  void onClose() {
    _configWorker.dispose();
    super.onClose();
  }
}

// ============================================================================
// Parsing Utilities
// ============================================================================

List<Map<String, dynamic>?> _parseDownloadPayloads(List<String> payloads) {
  final result = List<Map<String, dynamic>?>.filled(payloads.length, null, growable: false);

  for (int i = 0; i < payloads.length; i++) {
    result[i] = _parsePayload(payloads[i]);
  }

  return result;
}

Map<String, dynamic>? _parsePayload(String raw) {
  try {
    final decoded = jsonDecode(raw);
    final root = _ensureMap(decoded);
    final data = _ensureMap(root['data']);
    final content = data.isNotEmpty ? data : root;
    final details = _ensureMap(content['details']);
    final parsedType = (details['type'] ?? content['type'] ?? '').toString();

    return {
      'content': content,
      'type': parsedType,
      'seasonId': _extractSeasonIdFromRaw(content),
    };
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> _ensureMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, dynamic val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

// ============================================================================
// Season ID Resolution
// ============================================================================

String _resolveSeasonId(Map<String, dynamic> info, Map<String, dynamic>? rawContent) {
  final parsedSeasonId = (info['seasonId'] ?? '').toString();
  if (_isValidSeasonId(parsedSeasonId)) {
    return parsedSeasonId;
  }

  if (rawContent != null) {
    try {
      final seasonIdFromRaw = _extractSeasonIdFromRaw(rawContent);
      if (_isValidSeasonId(seasonIdFromRaw)) return seasonIdFromRaw;

      final content = ContentModel.fromContentJson(rawContent);
      final seasonIdFromModel = _seasonIdFromContentModel(content);
      if (_isValidSeasonId(seasonIdFromModel)) return seasonIdFromModel;
    } catch (_) {}
  }

  return '0';
}

String _extractSeasonIdFromRaw(Map<String, dynamic> rawContent) {
  final details = _ensureMap(rawContent['details']);
  final tvShowData = _ensureMap(details['tv_show_data']);

  return _firstValidSeasonId([
    _pickSeasonId(tvShowData),
    _pickSeasonId(details),
  ]);
}

String _seasonIdFromContentModel(ContentModel content) {
  final fromTvShowData = content.details.tvShowData?.seasonId ?? -1;
  if (fromTvShowData > 0) return fromTvShowData.toString();

  if (content.details.seasonList.isNotEmpty) {
    final inferredFromName = _inferSeasonNumberFromTitle(content.details.name);

    if (inferredFromName > 0) {
      final matchByNum = content.details.seasonList.firstWhere(
        (s) => s.seasonId == inferredFromName || s.id == inferredFromName,
        orElse: () => SeasonData(),
      );
      if (matchByNum.seasonId > 0) return matchByNum.seasonId.toString();
      if (matchByNum.id > 0) return matchByNum.id.toString();
    }

    final bestSeasonId = content.details.seasonList.fold<int>(
      -1,
      (prev, s) => s.seasonId > prev ? s.seasonId : prev,
    );
    if (bestSeasonId > 0) return bestSeasonId.toString();

    for (final season in content.details.seasonList) {
      if (season.id > 0) return season.id.toString();
    }
  }

  return '';
}

int _inferSeasonNumberFromTitle(String title) {
  final match = RegExp(r'[Ss]\s*([0-9]+)').firstMatch(title);
  if (match != null) {
    final parsed = int.tryParse(match.group(1) ?? '');
    if (parsed != null && parsed > 0) return parsed;
  }
  return -1;
}

String _pickSeasonId(Map<String, dynamic> map) {
  return _firstValidSeasonId([
    (map['season_id'] ?? '').toString(),
    (map['season_number'] ?? '').toString(),
    (map['seasonId'] ?? '').toString(),
  ]);
}

String _firstValidSeasonId(List<String> candidates) {
  for (final raw in candidates) {
    if (_isValidSeasonId(raw)) return raw;
  }
  return '';
}

bool _isValidSeasonId(String raw) {
  if (raw.isEmpty) return false;
  final normalized = raw.toLowerCase();
  return normalized != '-1' && normalized != '0' && normalized != 'null';
}