import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/ads/managers/ad_manager.dart';
import 'package:streamit_laravel/main.dart';
import 'package:streamit_laravel/screens/review/model/review_model.dart';
import 'package:streamit_laravel/utils/common_functions.dart';
import 'package:streamit_laravel/utils/constants.dart';

class ContentResponse {
  bool status;
  ContentModel data;
  String message;

  ContentResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory ContentResponse.fromJson(Map<String, dynamic> json) {
    return ContentResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map
          ? ContentModel.fromContentJson(json['data'])
          : ContentModel(
              details: ContentData(),
              downloadData: DownloadDataModel(downloadQualities: []),
            ),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toContentJson(),
      'message': message,
    };
  }
}

class ContentModel {
  int id;
  ContentData details;
  DownloadDataModel downloadData;
  List<VideoData> trailerData;
  List<VideoData> videoQualities;
  List<Cast> cast;
  List<Cast> directors;
  List<PosterDataModel> suggestedContent;
  List<SubtitleModel> subtitleList;
  RentalData? rentalData;
  AdsData? adsData;

  Review? reviews;

  // Local file path for downloaded content (offline playback)
  String? localFilePath;

  bool get isDownloadDetailsAvailable => downloadData.downloadEnable.getBoolInt() && downloadData.isDownloadQualitiesAvailable;

  bool get isTrailerAvailable => trailerData.isNotEmpty;

  bool get isVideoQualitiesAvailable => videoQualities.isNotEmpty;

  bool get isCastDetailsAvailable => cast.isNotEmpty;

  bool get isDirectorDetailsAvailable => directors.isNotEmpty;

  bool get isSuggestedContentAvailable => suggestedContent.isNotEmpty;

  bool get isAdsAvailable => adsData != null && isAdsAllowed;

  bool get isRentDetailsAvailable => rentalData != null;

  bool get isOneTimePurchase => isRentDetailsAvailable && rentalData!.access == MovieAccess.oneTimePurchase;

  bool get isReviewAvailable => reviews != null;

  String get buttonTitle => details.hasContentAccess.getBoolInt()
      ? details.watchedDuration.isNotEmpty
          ? locale.value.resume
          : locale.value.watchNow
      : details.access == MovieAccess.payPerView
          ? isOneTimePurchase
              ? locale.value.oneTime
              : locale.value.rent
          : details.access == MovieAccess.paidAccess
              ? locale.value.subscribe
              : locale.value.watchNow;

  VideoData get defaultQuality =>
      videoQualities.isNotEmpty ? videoQualities.firstWhere((element) => (element.quality == QualityConstants.defaultQualityKey || element.quality.isEmpty) && element.url.isNotEmpty) : VideoData();

  bool get isTvShow => details.type == VideoType.tvshow;

  bool get isEpisode => details.type == VideoType.episode;

  bool get isVideo => details.type == VideoType.video;

  bool get isSeason => details.type == VideoType.season;

  int get entertainmentId => isEpisode || isSeason
      ? details.tvShowData!.id
      : id > -1
          ? id
          : 0;

  ContentModel({
    this.id = -1,
    required this.details,
    required this.downloadData,
    this.trailerData = const <VideoData>[],
    this.videoQualities = const <VideoData>[],
    this.cast = const <Cast>[],
    this.directors = const <Cast>[],
    this.suggestedContent = const <PosterDataModel>[],
    this.subtitleList = const <SubtitleModel>[],
    this.adsData,
    this.rentalData,
    this.localFilePath,
    this.reviews,
  });

  factory ContentModel.fromContentJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] is int ? json['id'] : -1,
      details: json['details'] is Map ? ContentData.fromDetailsJson(json['details']) : ContentData(),
      downloadData: json['download_data'] is Map ? DownloadDataModel.fromJson(json['download_data']) : DownloadDataModel(downloadQualities: []),
      trailerData: json['trailer_data'] is List ? List<VideoData>.from(json['trailer_data'].map((x) => VideoData.fromTrailerJson(x))) : [],
      videoQualities: json['video_qualities'] is List ? List<VideoData>.from(json['video_qualities'].map((x) => VideoData.fromQualityJson(x))) : [],
      cast: json['actors'] is List ? List<Cast>.from(json['actors'].map((x) => Cast.fromListJson(x))) : [],
      directors: json['directors'] is List ? List<Cast>.from(json['directors'].map((x) => Cast.fromListJson(x))) : [],
      suggestedContent: json['suggested_content'] is List ? List<PosterDataModel>.from(json['suggested_content'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      adsData: json['ads_data'] is Map ? AdsData.fromJson(json['ads_data']) : null,
      rentalData: json['rental_data'] is Map ? RentalData.fromJson(json['rental_data']) : null,
      subtitleList: json['subtitle_info'] is List ? List<SubtitleModel>.from(json['subtitle_info'].map((x) => SubtitleModel.fromJson(x))) : [],
      reviews: json['review'] is Map ? Review.fromJson(json['review']) : null,
    );
  }

  Map<String, dynamic> toContentJson() {
    return {
      'id': id,
      'details': details.toDetailsJson(),
      'download_data': downloadData.toJson(),
      'trailer_data': trailerData.map((e) => e.toTrailerJson()).toList(),
      'video_quality': videoQualities.map((e) => e.toQualityJson()).toList(),
      'actors': cast.map((e) => e.toListJson()).toList(),
      'directors': directors.map((e) => e.toListJson()).toList(),
      'suggested_content': suggestedContent.map((e) => e.toPosterJson()).toList(),
      'ads_data': adsData?.toJson(),
      'rental_data': rentalData?.toJson(),
      'subtitle_info': subtitleList.map((e) => e.toJson()).toList(),
      'review': reviews?.toJson(),
    };
  }

  factory ContentModel.fromLiveContentJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] is int ? json['id'] : -1,
      details: json['details'] is Map ? ContentData.fromLiveContentDetailsJson(json['details']) : ContentData(),
      videoQualities: json['video_qualities'] is List ? List<VideoData>.from(json['video_qualities'].map((x) => VideoData.fromQualityJson(x))) : [],
      suggestedContent: json['suggested_content'] is List ? List<PosterDataModel>.from(json['suggested_content'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      downloadData: DownloadDataModel(downloadQualities: []),
    );
  }

  Map<String, dynamic> toLiveContentJson() {
    return {
      'id': id,
      'details': details.toLiveContentDetailsJson(),
      'video_qualities': videoQualities.map((e) => e.toQualityJson()).toList(),
      'suggested_content': suggestedContent.map((e) => e.toPosterJson()).toList(),
    };
  }
}

class ContentData {
  int id;
  String name;
  String type;
  int isDeviceSupported;
  int isInWatchList;
  int isLiked;
  int isAgeRestrictedContent;
  int hasContentAccess;
  int requiredPlanLevel;
  List<String> genres;
  String language;
  String duration;
  String watchedDuration;
  String introEndsAt;
  String introStartsAt;
  String contentRating;
  String releaseDate;
  String imdbRating;
  String access;
  String description;
  String thumbnailImage;

  String category;
  TvShowData? tvShowData;
  List<SeasonData> seasonList;

  String get releaseYear => releaseDate.isNotEmpty ? DateTime.tryParse(releaseDate)?.year.toString() ?? "" : "";

  bool get isTvShowDetailsAvailable => tvShowData != null;

  bool get isSeasonAvailable => seasonList.isNotEmpty;

  //region getters
  bool get isEpisode => type == VideoType.episode;

  bool get isSeason => type == VideoType.season;

  bool get isVideo => type == VideoType.video;

  int get entertainmentId => isSeason
      ? tvShowData!.id
      : id > -1
          ? id
          : 0;

  String get entertainmentType => isSeason ? VideoType.tvshow : type;

  ContentData({
    this.name = "",
    this.type = "",
    this.id = -1,
    this.isDeviceSupported = 0,
    this.isInWatchList = 0,
    this.isLiked = 0,
    this.isAgeRestrictedContent = 0,
    this.genres = const <String>[],
    this.language = "",
    this.duration = "",
    this.watchedDuration = "",
    this.introEndsAt = "",
    this.introStartsAt = "00:00:00",
    this.contentRating = "",
    this.releaseDate = "",
    this.imdbRating = "",
    this.access = "",
    this.description = "",
    this.thumbnailImage = "",
    this.category = "",
    this.hasContentAccess = 0,
    this.requiredPlanLevel = -1,
    this.tvShowData,
    this.seasonList = const <SeasonData>[],
  });

  factory ContentData.fromDetailsJson(Map<String, dynamic> json) {
    return ContentData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      isDeviceSupported: json['is_device_supported'] is int ? json['is_device_supported'] : 0,
      isInWatchList: json['is_in_watchlist'] is int ? json['is_in_watchlist'] : 0,
      isLiked: json['is_like'] is int ? json['is_like'] : 0,
      isAgeRestrictedContent: json['is_restricted'] is int ? json['is_restricted'] : 0,
      hasContentAccess: json['has_content_access'] is int ? json['has_content_access'] : 0,
      requiredPlanLevel: json['required_plan_level'] is int ? json['required_plan_level'] : -1,
      genres: json['genres'] is List ? List<String>.from(json['genres'].map((x) => x)) : [],
      language: json['language'] is String ? json['language'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      watchedDuration: json['watched_duration'] is String ? json['watched_duration'] : "",
      introEndsAt: json['intro_ends_at'] is String ? json['intro_ends_at'] : "",
      introStartsAt: json['intro_starts_at'] is String ? json['intro_starts_at'] : "00:00:00",
      contentRating: json['content_rating'] is String ? json['content_rating'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      imdbRating: json['imdb_rating'] is String ? json['imdb_rating'] : "",
      access: json['access'] is String ? json['access'] : "",
      description: json['description'] is String ? json['description'] : "",
      thumbnailImage: json['thumbnail_image'] is String
          ? json['thumbnail_image']
          : json['poster_image'] is String
              ? json['poster_image']
              : "",
      tvShowData: json['tv_show_data'] is Map ? TvShowData.fromJson(json['tv_show_data']) : TvShowData(),
      seasonList: json['season_data'] is List
          ? List<SeasonData>.from(json['season_data'].map((x) => SeasonData.fromJson(x)))
          : json['season_data'] is Map
              ? [
                  SeasonData.fromJson(json['season_data']),
                ]
              : [],
    );
  }

  Map<String, dynamic> toDetailsJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_device_supported': isDeviceSupported,
      'is_restricted': isAgeRestrictedContent,
      'is_in_watchlist': isInWatchList,
      'is_like': isLiked,
      'genres': genres.map((e) => e).toList(),
      'language': language,
      'duration': duration,
      'watched_duration': watchedDuration,
      'intro_ends_at': introEndsAt,
      'intro_starts_at': introStartsAt,
      'content_rating': contentRating,
      'release_date': releaseDate,
      'imdb_rating': imdbRating,
      'access': access,
      'description': description,
      'thumbnail_image': thumbnailImage,
      'has_content_access': hasContentAccess,
      'required_plan_level': requiredPlanLevel,
      'tv_show_data': tvShowData?.toJson(),
      'season_data': seasonList.map((e) => e.toJson()).toList(),
    };
  }

  factory ContentData.fromLiveContentDetailsJson(Map<String, dynamic> json) {
    return ContentData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      isDeviceSupported: json['is_device_supported'] is int ? json['is_device_supported'] : 0,
      isAgeRestrictedContent: json['is_restricted'] is int ? json['is_restricted'] : 0,
      hasContentAccess: json['has_content_access'] is int ? json['has_content_access'] : 0,
      requiredPlanLevel: json['required_plan_level'] is int ? json['required_plan_level'] : -1,
      access: json['access'] is String ? json['access'] : "",
      description: json['description'] is String ? json['description'] : "",
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      category: json['category'] is String ? json['category'] : "",
    );
  }

  Map<String, dynamic> toLiveContentDetailsJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_device_supported': isDeviceSupported,
      'access': access,
      'description': description,
      'thumbnail_image': thumbnailImage,
      'has_content_access': hasContentAccess,
      'required_plan_level': requiredPlanLevel,
      'category': category,
    };
  }

  ContentModel toContentModel() {
    return ContentModel(
      id: id,
      details: this,
      downloadData: DownloadDataModel(downloadQualities: []),
      // Add other default or empty fields as necessary
    );
  }

  factory ContentData.fromSliderDetailsJson(Map<String, dynamic> json) {
    return ContentData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String
          ? json['name']
          : json['title'] is String
              ? json['title']
              : "",
      type: json['type'] is String ? json['type'] : "",
      isInWatchList: json['is_in_watchlist'] is int ? json['is_in_watchlist'] : 0,
      isAgeRestrictedContent: json['is_restricted'] is int ? json['is_restricted'] : 0,
      hasContentAccess: json['has_content_access'] is int ? json['has_content_access'] : 0,
      requiredPlanLevel: json['required_plan_level'] is int ? json['required_plan_level'] : -1,
      genres: json['genres'] is List ? List<String>.from(json['genres'].map((x) => x)) : [],
      language: json['language'] is String ? json['language'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      description: json['description'] is String ? json['description'] : "",
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      imdbRating: json['imdb_rating'] is String ? json['imdb_rating'] : "",
      access: json['access'] is String ? json['access'] : "",
      tvShowData: json['tv_show_data'] is Map ? TvShowData.fromJson(json['tv_show_data']) : TvShowData(),
      seasonList: json['season_data'] is List ? List<SeasonData>.from(json['season_data'].map((x) => SeasonData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toSliderDetailsJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_device_supported': isDeviceSupported,
      'is_restricted': isAgeRestrictedContent,
      'is_in_watchlist': isInWatchList,
      'genres': genres.map((e) => e).toList(),
      'language': language,
      'duration': duration,
      'release_date': releaseDate,
      'imdb_rating': imdbRating,
      'access': access,
      'has_content_access': hasContentAccess,
      'required_plan_level': requiredPlanLevel,
      'tv_show_data': tvShowData?.toJson(),
      'season_data': seasonList.map((e) => e.toJson()).toList(),
    };
  }

  factory ContentData.fromListJson(Map<String, dynamic> json) {
    return ContentData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String
          ? json['name']
          : json['title'] is String
              ? json['title']
              : "",
      type: json['type'] is String ? json['type'] : "",
      isDeviceSupported: json['is_device_supported'] is int ? json['is_device_supported'] : -1,
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      access: json['access'] is String ? json['access'] : "",
      hasContentAccess: json['has_content_access'] is int ? json['has_content_access'] : -1,
      requiredPlanLevel: json['required_plan_level'] is int ? json['required_plan_level'] : -1,
      tvShowData: json['tv_show_data'] is Map ? TvShowData.fromJson(json['tv_show_data']) : null,
      imdbRating: json['imdb_rating'] is String ? json['imdb_rating'] : "",
      seasonList: json['season_data'] is List ? List<SeasonData>.from(json['season_data'].map((x) => SeasonData.fromJson(x))) : const <SeasonData>[],
      category: json['category'] is String ? json['category'] : "",
    );
  }

  Map<String, dynamic> toListJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_device_supported': isDeviceSupported,
      'content_rating': contentRating,
      'release_date': releaseDate,
      'access': access,
      'thumbnail_image': thumbnailImage,
      'has_content_access': hasContentAccess,
      'required_plan_level': requiredPlanLevel,
      'imdb_rating': imdbRating,
      if (tvShowData != null) 'tv_show_data': tvShowData!.toJson(),
      if (seasonList.isNotEmpty) 'season_data': seasonList.map((e) => e.toJson()).toList(),
    };
  }

  factory ContentData.fromContinueWatchJson(Map<String, dynamic> json) {
    final String contentType = json['type'] is String ? json['type'] : "";
    return ContentData(
      name: json['name'] is String ? json['name'] : "",
      type: contentType,
      id: json['episode_id'] is int
          ? json['episode_id']
          : json['id'] is int
              ? json['id']
              : -1,
      duration: json['total_duration'] is String ? json['total_duration'] : "",
      watchedDuration: json['watched_duration'] is String ? json['watched_duration'] : "",
      isDeviceSupported: json['is_device_supported'] is int ? json['is_device_supported'] : -1,
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      access: json['access'] is String ? json['access'] : "",
      hasContentAccess: json['has_content_access'] is int ? json['has_content_access'] : -1,
      requiredPlanLevel: json['required_plan_level'] is int ? json['required_plan_level'] : -1,
      tvShowData: contentType == VideoType.tvshow && json['tv_show_data'] is Map ? TvShowData.fromJson(json['tv_show_data']) : null,
    );
  }

  Map<String, dynamic> toContinueWatchJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_device_supported': isDeviceSupported,
      'content_rating': contentRating,
      'release_date': releaseDate,
      'access': access,
      'thumbnail_image': thumbnailImage,
      'has_content_access': hasContentAccess,
      'required_plan_level': requiredPlanLevel,
      'total_duration': duration,
      'watched_duration': watchedDuration,
    };
  }

  factory ContentData.fromEpisodeJson(Map<String, dynamic> json) {
    return ContentData(
      name: json['name'] is String ? json['name'] : "",
      type: json['type'] is String ? json['type'] : "",
      description: json['short_description'] is String ? json['short_description'] : "",
      duration: json['duration'] is String ? json['duration'] : "",
      watchedDuration: json['watched_duration'] is String ? json['watched_duration'] : "",
      isDeviceSupported: json['is_device_supported'] is int ? json['is_device_supported'] : -1,
      releaseDate: json['release_date'] is String ? json['release_date'] : "",
      access: json['access'] is String ? json['access'] : "",
      hasContentAccess: json['has_content_access'] is int ? json['has_content_access'] : -1,
      requiredPlanLevel: json['required_plan_level'] is int ? json['required_plan_level'] : -1,
      imdbRating: json['imdb_rating'] is String ? json['imdb_rating'] : "",
      tvShowData: json['tv_show_data'] is Map<String, dynamic> ? TvShowData.fromJson(json['tv_show_data']) : null,
    );
  }

  Map<String, dynamic> toEpisodeJson() {
    return {
      'name': name,
      'type': type,
      "short_description": description,
      'is_device_supported': isDeviceSupported,
      'content_rating': contentRating,
      'release_date': releaseDate,
      'access': access,
      'thumbnail_image': thumbnailImage,
      'has_content_access': hasContentAccess,
      'required_plan_level': requiredPlanLevel,
      'total_duration': duration,
      'watched_duration': watchedDuration,
      'imdb_rating': imdbRating,
      "tv_show_data": tvShowData,
    };
  }
}

class TvShowData {
  int id;
  String name;
  int seasonId;
  int totalEpisode;
  String episodeName;

  TvShowData({
    this.id = -1,
    this.name = "",
    this.seasonId = -1,
    this.totalEpisode = -1,
    this.episodeName = "",
  });

  factory TvShowData.fromJson(Map<String, dynamic> json) {
    return TvShowData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      seasonId: json['season_id'] is int ? json['season_id'] : -1,
      totalEpisode: json['total_episode'] is int ? json['total_episode'] : -1,
      episodeName: json['episode_name'] is String ? json['episode_name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'season_id': seasonId,
      'total_episode': totalEpisode,
      'episode_name': episodeName,
    };
  }
}

class SeasonData {
  int id;
  String name;
  int seasonId;
  int totalEpisode;

  SeasonData({
    this.id = -1,
    this.name = "",
    this.seasonId = -1,
    this.totalEpisode = -1,
  });

  factory SeasonData.fromJson(Map<String, dynamic> json) {
    return SeasonData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      seasonId: json['season_id'] is int ? json['season_id'] : -1,
      totalEpisode: json['total_episode'] is int ? json['total_episode'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'season_id': seasonId,
      'total_episode': totalEpisode,
    };
  }
}

class DownloadDataModel {
  int downloadEnable;
  int downloadId;
  List<DownloadQualities> downloadQualities;

  bool get isDownloadQualitiesAvailable => downloadQualities.isNotEmpty;

  DownloadDataModel({
    this.downloadEnable = -1,
    this.downloadId = 0,
    this.downloadQualities = const <DownloadQualities>[],
  });

  factory DownloadDataModel.fromJson(Map<String, dynamic> json) {
    return DownloadDataModel(
      downloadEnable: json['download_enable'] is int ? json['download_enable'] : -1,
      downloadId: json['download_id'] is int ? json['download_id'] : 0,
      downloadQualities: json['download_quality'] is List ? List<DownloadQualities>.from(json['download_quality'].map((x) => DownloadQualities.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'download_enable': downloadEnable,
      'download_quality': downloadQualities.map((e) => e).toList(),
    };
  }
}

class DownloadQualities {
  int id;
  String urlType;
  String url;
  String quality;

  DownloadQualities({
    this.id = -1,
    this.urlType = "",
    this.url = "",
    this.quality = "",
  });

  factory DownloadQualities.fromJson(Map<String, dynamic> json) {
    return DownloadQualities(
      id: json['id'] is int ? json['id'] : -1,
      urlType: json['url_type'] is String ? json['url_type'] : "",
      url: json['url'] is String ? json['url'] : "",
      quality: json['quality'] is String ? json['quality'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url_type': urlType,
      'url': url,
      'quality': quality,
    };
  }
}

class VideoData {
  int id;
  String urlType;
  String url;
  String quality;
  String posterImage;

  String title;

  VideoData({
    this.id = -1,
    this.urlType = "",
    this.url = "",
    this.quality = QualityConstants.defaultQuality,
    this.posterImage = '',
    this.title = '',
  });

  factory VideoData.fromTrailerJson(Map<String, dynamic> json) {
    return VideoData(
      id: json['id'] is int ? json['id'] : -1,
      urlType: json['url_type'] is String ? json['url_type'] : "",
      url: json['url'] is String ? json['url'] : "",
      title: json['title'] is String ? json['title'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      quality: json['quality'] is String && (json['quality'] as String).isNotEmpty ? json['quality'] : QualityConstants.defaultQuality,
    );
  }

  Map<String, dynamic> toTrailerJson() {
    return {
      'id': id,
      'url_type': urlType,
      'url': url,
      'title': title,
      'poster_image': posterImage,
      'quality': quality,
    };
  }

  factory VideoData.fromQualityJson(Map<String, dynamic> json) {
    return VideoData(
      id: json['id'] is int ? json['id'] : -1,
      urlType: json['url_type'] is String ? json['url_type'] : "",
      url: json['url'] is String ? json['url'] : "",
      quality: json['quality'] is String ? json['quality'] : "",
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
    );
  }

  Map<String, dynamic> toQualityJson() {
    return {
      'id': id,
      'url_type': urlType,
      'url': url,
      'quality': quality,
      'poster_image': posterImage,
    };
  }
}

class Cast {
  int id;
  String name;
  String profileImage;
  String designation;
  String bio;
  String placeOfBirth;
  String dob;
  String topGenre;
  int totalMovies;
  int totalTvShows;
  num rating;

  Cast({
    this.id = -1,
    this.name = "",
    this.profileImage = "",
    this.designation = "",
    this.bio = "",
    this.placeOfBirth = "",
    this.dob = "",
    this.rating = 0.0,
    this.topGenre = '',
    this.totalMovies = 0,
    this.totalTvShows = 0,
  });

  factory Cast.fromListJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      designation: json['role'] is String
          ? json['role']
          : json['type'] is String
              ? json['type']
              : "",
    );
  }

  Map<String, dynamic> toListJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'role': designation,
    };
  }

  factory Cast.fromDetailsJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      designation: json['role'] is String
          ? json['role']
          : json['type'] is String
              ? json['type']
              : "",
      bio: json['bio'] is String ? json['bio'] : "",
      placeOfBirth: json['birth_place'] is String ? json['birth_place'] : "",
      dob: json['birth_date'] is String ? json['birth_date'] : "",
      rating: json['rating'] is num ? json['rating'] : 0.0,
      topGenre: json['top_genres'] is String ? json['top_genres'] : '',
      totalTvShows: json['total_tv_show'] is int ? json['total_tv_show'] : 0,
      totalMovies: json['total_movies'] is int ? json['total_movies'] : 0,
    );
  }

  Map<String, dynamic> toDetailsJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'role': designation,
      'bio': bio,
      'place_of_birth': placeOfBirth,
    };
  }
}

class PosterDataModel {
  int id;
  String posterImage;
  ContentData details;
  DownloadDataModel? downloadData;
  RentalData? rentalData;

  List<VideoData> trailerData;

  //region getters
  bool get isEpisode => details.type == VideoType.episode;

  bool get isTvShow => details.type == VideoType.tvshow;

  bool get isSeason => details.type == VideoType.season;

  bool get isRentDetailsAvailable => rentalData != null;

  bool get isTrailerDataAvailable => trailerData.isNotEmpty;

  bool get isDownloadDetailsAvailable => downloadData != null;

  int get entertainmentId => details.isSeason && details.isTvShowDetailsAvailable
      ? details.tvShowData!.id
      : details.id > -1
          ? details.id
          : id > -1
              ? id
              : -1;

  String get entertainmentType => details.isSeason ? VideoType.tvshow : details.type;

  PosterDataModel({
    this.id = -1,
    this.posterImage = '',
    required this.details,
    this.downloadData,
    this.rentalData,
    this.trailerData = const <VideoData>[],
  });

  factory PosterDataModel.fromPosterJson(Map<String, dynamic> json) {
    return PosterDataModel(
      id: json['id'] is int ? json['id'] : -1,
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      details: json['details'] is Map ? ContentData.fromListJson(json['details']) : ContentData(),
      downloadData: json['download_data'] is Map ? DownloadDataModel.fromJson(json['download_data']) : null,
      rentalData: json['rental_data'] is Map ? RentalData.fromJson(json['rental_data']) : null,
    );
  }

  Map<String, dynamic> toPosterJson() {
    return {
      'id': id,
      'poster_image': posterImage,
      'details': details.toListJson(),
      'download_data': downloadData?.toJson(),
      'rental_data': rentalData?.toJson(),
    };
  }

  factory PosterDataModel.fromSliderJson(Map<String, dynamic> json) {
    return PosterDataModel(
      id: json['id'] is int ? json['id'] : -1,
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      details: json['details'] is Map ? ContentData.fromSliderDetailsJson(json['details']) : ContentData(),
    );
  }

  Map<String, dynamic> toSliderJson() {
    return {
      'id': id,
      'poster_image': posterImage,
      'details': details.toSliderDetailsJson(),
    };
  }

  factory PosterDataModel.fromThumbnailJson(Map<String, dynamic> json) {
    return PosterDataModel(
      id: json['id'] is int ? json['id'] : -1,
      posterImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      details: json['details'] is Map ? ContentData.fromListJson(json['details']) : ContentData(),
    );
  }

  Map<String, dynamic> toThumbnailJson() {
    return {
      'id': id,
      'thumbnail_image': posterImage,
      'details': details.toListJson(),
    };
  }

  factory PosterDataModel.fromContinueWatchJson(Map<String, dynamic> json) {
    return PosterDataModel(
      id: json['id'] is int ? json['id'] : -1,
      posterImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      details: json['details'] is Map ? ContentData.fromContinueWatchJson(json['details']) : ContentData(),
    );
  }

  Map<String, dynamic> toContinueWatchJson() {
    return {
      'id': id,
      'thumbnail_image': posterImage,
      'details': details.toContinueWatchJson(),
    };
  }

  factory PosterDataModel.fromEpisodeJson(Map<String, dynamic> json) {
    return PosterDataModel(
      id: json['id'] is int ? json['id'] : -1,
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      details: json['details'] is Map ? ContentData.fromEpisodeJson(json['details']) : ContentData(),
      downloadData: json['download_data'] is Map ? DownloadDataModel.fromJson(json['download_data']) : null,
      rentalData: json['rental_data'] is Map ? RentalData.fromJson(json['rental_data']) : null,
    );
  }

  Map<String, dynamic> toEpisodeJson() {
    return {
      'id': id,
      'poster_image': posterImage,
      'details': details.toEpisodeJson(),
      'download_data': downloadData?.toJson(),
      'rental_data': rentalData?.toJson(),
    };
  }

  factory PosterDataModel.fromSearchPosterJson(Map<String, dynamic> json) {
    return PosterDataModel(
      id: json['id'] is int ? json['id'] : -1,
      posterImage: json['poster_image'] is String ? json['poster_image'] : "",
      details: json['details'] is Map ? ContentData.fromListJson(json['details']) : ContentData(),
      rentalData: json['rental_data'] is Map ? RentalData.fromJson(json['rental_data']) : null,
      trailerData: json['trailer_data'] is List ? List<VideoData>.from(json['trailer_data'].map((x) => VideoData.fromTrailerJson(x))) : [],
    );
  }

  Map<String, dynamic> toSearchPosterJson() {
    return {
      'id': id,
      'poster_image': posterImage,
      'details': details.toListJson(),
      'rental_data': rentalData?.toJson(),
      'trailer_data': trailerData.map((e) => e.toTrailerJson()).toList(),
    };
  }
}

class AdsData {
  List<CustomAds> customAds;
  VastAds vastAds;

  bool get isCustomAdsAvailable => customAds.isNotEmpty && isAdsAllowed;

  bool get isBannerAdsAvailable => bannerAds.isNotEmpty && isAdsAllowed;

  bool get isPlayerAdsAvailable => playerAds.isNotEmpty && isAdsAllowed;

  bool get isVastAdsAvailable => vastAds.overlayAdUrl.isNotEmpty || vastAds.preRoleAdUrl.isNotEmpty || vastAds.midRoleAdUrl.isNotEmpty || vastAds.postRoleAdUrl.isNotEmpty;

  List<CustomAds> get bannerAds => isCustomAdsAvailable ? customAds.where((element) => element.adType == AdSlotType.banner.name).toList() : const <CustomAds>[];

  List<CustomAds> get playerAds => isCustomAdsAvailable ? customAds.where((element) => element.adType == AdSlotType.player.name).toList() : const <CustomAds>[];

  AdsData({
    this.customAds = const <CustomAds>[],
    required this.vastAds,
  });

  factory AdsData.fromJson(Map<String, dynamic> json) {
    return AdsData(
      customAds: json['custom_ads'] is List ? List<CustomAds>.from(json['custom_ads'].map((x) => CustomAds.fromJson(x))) : [],
      vastAds: json['vast_ads'] is Map ? VastAds.fromJson(json['vast_ads']) : VastAds(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custom_ads': customAds.map((e) => e.toJson()).toList(),
      'vast_ads': vastAds.toJson(),
    };
  }
}

class CustomAds {
  String type;
  String adType;
  String url;
  String redirectUrl;

  CustomAds({
    this.type = "",
    this.adType = "",
    this.url = "",
    this.redirectUrl = "",
  });

  factory CustomAds.fromJson(Map<String, dynamic> json) {
    return CustomAds(
      type: json['type'] is String ? json['type'] : "",
      adType: json['placement'] is String ? json['placement'] : "",
      url: json['url'] is String ? json['url'] : "",
      redirectUrl: json['redirect_url'] is String ? json['redirect_url'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'placement': adType,
      'url': url,
      'redirect_url': redirectUrl,
    };
  }
}

class VastAds {
  List<String> overlayAdUrl;
  List<String> preRoleAdUrl;
  List<String> midRoleAdUrl;
  List<String> postRoleAdUrl;

  VastAds({
    this.overlayAdUrl = const <String>[],
    this.preRoleAdUrl = const <String>[],
    this.midRoleAdUrl = const <String>[],
    this.postRoleAdUrl = const <String>[],
  });

  bool get isAdsAvailable => overlayAdUrl.isNotEmpty || preRoleAdUrl.isNotEmpty || midRoleAdUrl.isNotEmpty || postRoleAdUrl.isNotEmpty;

  bool get isOverlayAdAvailable => overlayAdUrl.isNotEmpty;

  bool get isPreRoleAdAvailable => preRoleAdUrl.isNotEmpty;

  bool get isMidRoleAdAvailable => midRoleAdUrl.isNotEmpty;

  bool get isPostRoleAdAvailable => postRoleAdUrl.isNotEmpty;

  factory VastAds.fromJson(Map<String, dynamic> json) {
    return VastAds(
      overlayAdUrl: json['overlay_ad_url'] is List ? List<String>.from(json['overlay_ad_url'].map((x) => x)) : [],
      preRoleAdUrl: json['pre_role_ad_url'] is List ? List<String>.from(json['pre_role_ad_url'].map((x) => x)) : [],
      midRoleAdUrl: json['mid_role_ad_url'] is List ? List<String>.from(json['mid_role_ad_url'].map((x) => x)) : [],
      postRoleAdUrl: json['post_role_ad_url'] is List ? List<String>.from(json['post_role_ad_url'].map((x) => x)) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overlay_ad_url': overlayAdUrl.map((e) => e).toList(),
      'pre_role_ad_url': preRoleAdUrl.map((e) => e).toList(),
      'mid_role_ad_url': midRoleAdUrl.map((e) => e).toList(),
      'post_role_ad_url': postRoleAdUrl.map((e) => e).toList(),
    };
  }
}

class SubtitleModel {
  int id;
  String language;
  String languageCode;
  String subtitleFileURL;
  int isDefaultLanguage;

  SubtitleModel({
    this.id = -1,
    this.isDefaultLanguage = 0,
    this.language = "",
    this.subtitleFileURL = "",
    this.languageCode = '',
  });

  factory SubtitleModel.fromJson(Map<String, dynamic> json) {
    return SubtitleModel(
      id: json['id'] is int ? json['id'] : -1,
      isDefaultLanguage: json['is_default'] is int ? json['is_default'] : -1,
      subtitleFileURL: json['subtitle_file'] is String ? json['subtitle_file'] : '',
      language: json['language'] is String ? json['language'] : '',
      languageCode: json['language_code'] is String ? json['language_code'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_default': isDefaultLanguage,
      'subtitle_file_url': subtitleFileURL,
      'language': language,
      'language_code': languageCode,
    };
  }
}

class RentalData {
  num price;
  num discount;
  num discountedPrice;
  int accessDuration;
  int availabilityDays;
  String access;

  bool get isOneTimePurchase => access == MovieAccess.oneTimePurchase;

  RentalData({
    this.price = 0.0,
    this.discount = 0.0,
    this.discountedPrice = 0.0,
    this.accessDuration = -1,
    this.availabilityDays = -1,
    this.access = '',
  });

  factory RentalData.fromJson(Map<String, dynamic> json) {
    return RentalData(
      price: json['price'] is num ? json['price'] : 0.0,
      discount: json['discount'] is num ? json['discount'] : 0.0,
      discountedPrice: json['discounted_price'] is num ? json['discounted_price'] : 0.0,
      accessDuration: json['access_duration'] is int ? json['access_duration'] : -1,
      availabilityDays: json['availability_days'] is int ? json['availability_days'] : -1,
      access: json['access'] is String ? json['access'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'discount': discount,
      'discounted_price': discountedPrice,
      'access_duration': accessDuration,
      'availability_days': availabilityDays,
      'access': access,
    };
  }
}