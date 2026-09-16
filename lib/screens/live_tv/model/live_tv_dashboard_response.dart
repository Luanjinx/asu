import 'package:streamit_laravel/screens/content/model/content_model.dart';

class LiveChannelDashboardResponse {
  bool status;
  LivePosterDataModel data;
  String message;

  LiveChannelDashboardResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory LiveChannelDashboardResponse.fromJson(Map<String, dynamic> json) {
    return LiveChannelDashboardResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? LivePosterDataModel.fromJson(json['data']) : LivePosterDataModel(),
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

class LivePosterDataModel {
  List<PosterDataModel> slider;
  List<CategoryData> categoryData;

  LivePosterDataModel({
    this.slider = const <PosterDataModel>[],
    this.categoryData = const <CategoryData>[],
  });

  factory LivePosterDataModel.fromJson(Map<String, dynamic> json) {
    return LivePosterDataModel(
      slider: json['slider'] is List ? List<PosterDataModel>.from(json['slider'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      categoryData: json['category_data'] is List ? List<CategoryData>.from(json['category_data'].map((x) => CategoryData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slider': slider.map((e) => e.toPosterJson()).toList(),
      'category_data': categoryData.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryData {
  int id;
  String name;
  String description;
  String categoryImage;
  List<PosterDataModel> channelData;
  int status;

  CategoryData({
    this.id = -1,
    this.name = "",
    this.description = "",
    this.categoryImage = "",
    this.channelData = const <PosterDataModel>[],
    this.status = -1,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      description: json['description'] is String ? json['description'] : "",
      categoryImage: json['category_image'] is String ? json['category_image'] : "",
      channelData: json['channel_data'] is List ? List<PosterDataModel>.from(json['channel_data'].map((x) => PosterDataModel.fromPosterJson(x))) : [],
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_image': categoryImage,
      'channel_data': channelData.map((e) => e.toPosterJson()).toList(),
      'status': status,
    };
  }
}