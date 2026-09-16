import 'package:streamit_laravel/screens/content/model/content_model.dart';

class SearchResponse {
  bool status;
  String message;
  List<PosterDataModel> movieList;
  List<PosterDataModel> tvShowList;
  List<PosterDataModel> videoList;
  List<PosterDataModel> seasonList;
  List<PosterDataModel> episodeList;
  List<PosterDataModel> channelList;
  List<Cast> actorList;
  List<Cast> directorList;

  SearchResponse({
    this.status = false,
    this.message = "",
    this.movieList = const <PosterDataModel>[],
    this.tvShowList = const <PosterDataModel>[],
    this.videoList = const <PosterDataModel>[],
    this.seasonList = const <PosterDataModel>[],
    this.episodeList = const <PosterDataModel>[],
    this.channelList = const <PosterDataModel>[],
    this.actorList = const <Cast>[],
    this.directorList = const <Cast>[],
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      movieList: json['movieList'] is List ? List<PosterDataModel>.from(json['movieList'].map((x) => PosterDataModel.fromSearchPosterJson(x))) : [],
      tvShowList: json['tvshowList'] is List ? List<PosterDataModel>.from(json['tvshowList'].map((x) => PosterDataModel.fromSearchPosterJson(x))) : [],
      videoList: json['videoList'] is List ? List<PosterDataModel>.from(json['videoList'].map((x) => PosterDataModel.fromSearchPosterJson(x))) : [],
      seasonList: json['seasonList'] is List ? List<PosterDataModel>.from(json['seasonList'].map((x) => PosterDataModel.fromSearchPosterJson(x))) : [],
      episodeList: json['episodeList'] is List ? List<PosterDataModel>.from(json['episodeList'].map((x) => PosterDataModel.fromSearchPosterJson(x))) : [],
      channelList: json['channelList'] is List ? List<PosterDataModel>.from(json['channelList'].map((x) => PosterDataModel.fromSearchPosterJson(x))) : [],
      actorList: _parseCastList(json, 'actors_list', 'actor_list'),
      directorList: _parseCastList(json, 'directors_list', 'director_list'),
    );
  }

  static List<Cast> _parseCastList(Map<String, dynamic> json, String key1, String key2) {
    final dynamic castData = json[key1] ?? json[key2];
    if (castData is List) {
      return List<Cast>.from(castData.map((x) => Cast.fromListJson(x)));
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'movieList': movieList.map((e) => e.toSearchPosterJson()).toList(),
      'tvshowList': tvShowList.map((e) => e.toSearchPosterJson()).toList(),
      'videoList': videoList.map((e) => e.toSearchPosterJson()).toList(),
      'seasonList': seasonList.map((e) => e.toSearchPosterJson()).toList(),
      'episodeList': episodeList.map((e) => e.toSearchPosterJson()).toList(),
      'channelList': channelList.map((e) => e.toSearchPosterJson()).toList(),
      'actors_list': actorList.map((e) => e.toListJson()).toList(),
      'directors_list': directorList.map((e) => e.toListJson()).toList(),
    };
  }
}