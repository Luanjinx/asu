import 'package:streamit_laravel/screens/content/model/content_model.dart';

class ListResponse {
  bool status;
  String message;
  String name;
  List<PosterDataModel> data;

  ListResponse({
    this.status = false,
    this.message = "",
    this.name = "",
    this.data = const <PosterDataModel>[],
  });

  factory ListResponse.fromListJson(Map<String, dynamic> json) {
    return ListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      name: json['name'] is String ? json['name'] : '',
      data: json['data'] is List ? List<PosterDataModel>.from(json['data'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
    );
  }

  Map<String, dynamic> toListJson() {
    return {
      'status': status,
      'message': message,
      'name': name,
      'data': data.map((e) => e.toPosterJson()).toList(),
    };
  }

  factory ListResponse.fromEpisodeJson(Map<String, dynamic> json) {
    return ListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      name: json['name'] is String ? json['name'] : '',
      data: json['data'] is List ? List<PosterDataModel>.from(json['data'].map((x) => PosterDataModel.fromEpisodeJson(x))) : [],
    );
  }

  Map<String, dynamic> toEpisodeJson() {
    return {
      'status': status,
      'message': message,
      'name': name,
      'data': data.map((e) => e.toPosterJson()).toList(),
    };
  }
}

class ChannelResponse {
  bool status;
  ChannelData data;
  String message;

  ChannelResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory ChannelResponse.fromJson(Map<String, dynamic> json) {
    return ChannelResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? ChannelData.fromJson(json['data']) : ChannelData(),
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

class ChannelData {
  List<PosterDataModel> channel;

  ChannelData({
    this.channel = const <PosterDataModel>[],
  });

  factory ChannelData.fromJson(Map<String, dynamic> json) {
    return ChannelData(
      channel: json['channel'] is List ? List<PosterDataModel>.from(json['channel'].map((x) => PosterDataModel.fromSliderJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel.map((e) => e.toPosterJson()).toList(),
    };
  }
}

class ChannelListResponse {
  bool status;
  String message;
  String name;
  List<PosterDataModel> data;

  ChannelListResponse({
    this.status = false,
    this.message = "",
    this.name = "",
    this.data = const <PosterDataModel>[],
  });

  factory ChannelListResponse.fromJson(Map<String, dynamic> json) {
    return ChannelListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      name: json['name'] is String ? json['name'] : '',
      data: json['data'] is List ? List<PosterDataModel>.from(json['data'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'name': name,
      'data': data.map((e) => e.toPosterJson()).toList(),
    };
  }
}

class ThumbnailListResponse {
  bool status;
  String message;
  String name;
  List<PosterDataModel> data;

  ThumbnailListResponse({
    this.status = false,
    this.message = "",
    this.name = "",
    this.data = const <PosterDataModel>[],
  });

  factory ThumbnailListResponse.fromContinueWatchJson(Map<String, dynamic> json) {
    return ThumbnailListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      name: json['name'] is String ? json['name'] : '',
      data: json['data'] is List ? List<PosterDataModel>.from(json['data'].map((x) => PosterDataModel.fromContinueWatchJson(x))) : [],
    );
  }

  Map<String, dynamic> toContinueWatchJson() {
    return {
      'status': status,
      'message': message,
      'name': name,
      'data': data.map((e) => e.toContinueWatchJson()).toList(),
    };
  }

  factory ThumbnailListResponse.fromEpisodeJson(Map<String, dynamic> json) {
    return ThumbnailListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      name: json['name'] is String ? json['name'] : '',
      data: json['data'] is List ? List<PosterDataModel>.from(json['data'].map((x) => PosterDataModel.fromContinueWatchJson(x))) : [],
    );
  }

  Map<String, dynamic> toEpisodeJson() {
    return {
      'status': status,
      'message': message,
      'name': name,
      'data': data.map((e) => e.toContinueWatchJson()).toList(),
    };
  }
}