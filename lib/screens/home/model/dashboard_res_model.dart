import 'package:streamit_laravel/screens/content/model/content_model.dart';
import 'package:streamit_laravel/screens/watch_list/model/watch_list_resp.dart';

import '../../genres/model/genres_model.dart';
import '../../person/model/person_model.dart';

class DashboardDetailResponse {
  bool status;
  String message;
  DashboardModel data;

  DashboardDetailResponse({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory DashboardDetailResponse.fromJson(Map<String, dynamic> json) {
    return DashboardDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? DashboardModel.fromJson(json['data']) : DashboardModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class DashboardModel {
  List<PosterDataModel> continueWatch;
  List<PosterDataModel> basedOnLastWatchMovieList;
  List<PosterDataModel> likeMovieList;
  List<PosterDataModel> viewedMovieList;
  List<CustomAds> customAdList;
  ListResponse? top10List;
  ListResponse? latestList;
  ListResponse? topChannelList;
  ListResponse? popularMovieList;
  ListResponse? popularTvShowList;
  ListResponse? popularVideoList;
  List<PosterDataModel> trendingMovieList;
  List<PosterDataModel> trendingInCountryMovieList;

  List<PosterDataModel> payPerView;
  ListResponse? freeMovieList;
  GenresResponse? genreList;
  LanguageResponse? popularLanguageList;
  CastListResponse? actorList;
  List<GenreModel> favGenreList;
  List<Cast> favActorList;
  List<OtherSectionModel> otherSection;

  int unreadNotificationCount;

  DashboardModel({
    this.continueWatch = const <PosterDataModel>[],
    this.likeMovieList = const <PosterDataModel>[],
    this.viewedMovieList = const <PosterDataModel>[],
    this.basedOnLastWatchMovieList = const <PosterDataModel>[],
    this.customAdList = const <CustomAds>[],
    this.top10List,
    this.latestList,
    this.topChannelList,
    this.popularMovieList,
    this.popularTvShowList,
    this.popularVideoList,
    this.trendingMovieList = const <PosterDataModel>[],
    this.trendingInCountryMovieList = const <PosterDataModel>[],
    this.payPerView = const <PosterDataModel>[],
    this.freeMovieList,
    this.genreList,
    this.popularLanguageList,
    this.favActorList = const <Cast>[],
    this.favGenreList = const <GenreModel>[],
    this.actorList,
    this.otherSection = const <OtherSectionModel>[],
    this.unreadNotificationCount = 0,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      continueWatch: json['continue_watch'] is List ? List<PosterDataModel>.from(json['continue_watch'].map((x) => PosterDataModel.fromContinueWatchJson(x))) : [],
      basedOnLastWatchMovieList: json['based_on_last_watch'] is List ? List<PosterDataModel>.from(json['based_on_last_watch'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      likeMovieList: json['based_on_likes'] is List ? List<PosterDataModel>.from(json['based_on_likes'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      viewedMovieList: json['based_on_views'] is List ? List<PosterDataModel>.from(json['based_on_views'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      top10List: json['top_10'] is Map ? ListResponse.fromListJson(json['top_10']) : ListResponse(data: []),
      customAdList: json['custom_ads'] is List ? List<CustomAds>.from(json['custom_ads'].map((x) => CustomAds.fromJson(x))) : [],
      latestList: json['latest_movie'] is Map ? ListResponse.fromListJson(json['latest_movie']) : ListResponse(data: []),
      topChannelList: json['top_channel'] is Map ? ListResponse.fromListJson(json['top_channel']) : ListResponse(data: []),
      popularMovieList: json['popular_movie'] is Map ? ListResponse.fromListJson(json['popular_movie']) : ListResponse(data: []),
      popularTvShowList: json['popular_tvshow'] is Map ? ListResponse.fromListJson(json['popular_tvshow']) : ListResponse(data: []),
      popularVideoList: json['popular_videos'] is Map ? ListResponse.fromListJson(json['popular_videos']) : ListResponse(data: []),
      trendingMovieList: json['trending_movies'] is List ? List<PosterDataModel>.from(json['trending_movies'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      trendingInCountryMovieList: json['trending_in_country'] is List ? List<PosterDataModel>.from(json['trending_in_country'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      payPerView: json['pay_per_view'] is List ? List<PosterDataModel>.from(json['pay_per_view'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      freeMovieList: json['free_movie'] is Map ? ListResponse.fromListJson(json['free_movie']) : ListResponse(data: []),
      genreList: json['genres'] is Map ? GenresResponse.fromJson(json['genres']) : GenresResponse(data: []),
      popularLanguageList: json['popular_language'] is Map ? LanguageResponse.fromJson(json['popular_language']) : LanguageResponse(languageList: []),
      actorList: json['personality'] is Map ? CastListResponse.fromJson(json['personality']) : CastListResponse(data: []),
      favGenreList: json['favorite_genres'] is List ? List<GenreModel>.from(json['favorite_genres'].map((x) => GenreModel.fromJson(x))) : [],
      favActorList: json['favorite_personality'] is List ? List<Cast>.from(json['favorite_personality'].map((x) => Cast.fromListJson(x))) : [],
      otherSection: json['other_section'] is List ? List<OtherSectionModel>.from(json['other_section'].map((x) => OtherSectionModel.fromJson(x))) : [],
      unreadNotificationCount: json['unread_notification_count'] is int ? json['unread_notification_count'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'continue_watch': continueWatch.map((e) => e.toContinueWatchJson()).toList(),
      'top_10': top10List?.toListJson(),
      'based_on_likes': likeMovieList.map((e) => e.toPosterJson()).toList(),
      'based_on_views': viewedMovieList.map((e) => e.toPosterJson()).toList(),
      'base_on_last_watch': basedOnLastWatchMovieList.map((e) => e.toPosterJson()).toList(),
      'custom_ads': customAdList.map((e) => e.toJson()).toList(),
      'latest_movie': latestList?.toListJson(),
      'top_channel': topChannelList?.toListJson(),
      'popular_movie': popularMovieList?.toListJson(),
      'popular_tvshow': popularTvShowList?.toListJson(),
      'popular_videos': popularVideoList?.toListJson(),
      'trending_movies': trendingMovieList.map((e) => e.toPosterJson()).toList(),
      'trending_in_country': trendingInCountryMovieList.map((e) => e.toPosterJson()).toList(),
      'pay_per_view': payPerView.map((e) => e.toPosterJson()).toList(),
      'free_movie': freeMovieList?.toListJson(),
      'genres': genreList?.toJson(),
      'popular_language': popularLanguageList?.toJson(),
      'personality': actorList?.toJson(),
      'favorite_genres': favGenreList.map((e) => e.toJson()).toList(),
      'favorite_personality': favActorList.map((e) => e.toListJson()).toList(),
      'other_section': otherSection.map((e) => e.toJson()).toList(),
    };
  }
}

class SliderResponse {
  bool status;
  SliderData data;
  String message;

  SliderResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory SliderResponse.fromJson(Map<String, dynamic> json) {
    return SliderResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? SliderData.fromJson(json['data']) : SliderData(),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class SliderData {
  List<PosterDataModel> slider;
  int unreadNotificationCount;

  SliderData({
    this.slider = const <PosterDataModel>[],
    this.unreadNotificationCount = -1,
  });

  factory SliderData.fromJson(Map<String, dynamic> json) {
    return SliderData(
      slider: json['slider'] is List ? List<PosterDataModel>.from(json['slider'].map((x) => PosterDataModel.fromSliderJson(x))) : [],
      unreadNotificationCount: json['unread_notification_count'] is int ? json['unread_notification_count'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slider': slider.map((e) => e.toSliderJson()).toList(),
      'unread_notification_count': unreadNotificationCount,
    };
  }
}

class CategoryListModel {
  String name;
  String sectionType;
  List<dynamic> data;
  bool showViewAll;
  bool isOtherSection;
  String slug;
  String type;
  bool isEachWordCapitalized;

  CategoryListModel({
    this.name = "",
    this.sectionType = "",
    this.data = const <dynamic>[],
    this.showViewAll = false,
    this.isOtherSection = false,
    this.slug = "",
    this.type = "",
    this.isEachWordCapitalized = true,
  });
}

class LanguageResponse {
  String name;
  List<LanguageModel> languageList;

  LanguageResponse({this.name = '', this.languageList = const <LanguageModel>[]});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      name: json['name'] is String ? json['name'] : "",
      languageList: json['data'] is List ? List<LanguageModel>.from(json['data'].map((x) => LanguageModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': languageList.map((e) => e.toJson()).toList(),
    };
  }
}

class LanguageModel {
  int id;
  String name;

  String languageImage;

  LanguageModel({
    this.id = -1,
    this.name = "",
    this.languageImage = '',
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      languageImage: json['language_image'] is String ? json['language_image'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'language_image': languageImage,
    };
  }
}

class OtherSectionModel {
  String slug;
  String name;
  String type;
  List<PosterDataModel> data;

  OtherSectionModel({
    this.slug = '',
    this.name = '',
    this.type = '',
    this.data = const <PosterDataModel>[],
  });

  factory OtherSectionModel.fromJson(Map<String, dynamic> json) {
    return OtherSectionModel(
      slug: json['slug'] is String ? json['slug'] : '',
      name: json['name'] is String ? json['name'] : '',
      type: json['type'] is String ? json['type'] : '',
      data: json['data'] is List ? List<PosterDataModel>.from(json['data'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'type': type,
      'data': data.map((e) => e.toPosterJson()).toList(),
    };
  }
}