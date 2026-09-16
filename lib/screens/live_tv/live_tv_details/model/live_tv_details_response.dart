import 'package:streamit_laravel/screens/content/model/content_model.dart';

class LiveShowDetailResponse {
  bool status;
  ContentModel data;
  String message;

  LiveShowDetailResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory LiveShowDetailResponse.fromJson(Map<String, dynamic> json) {
    return LiveShowDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? ContentModel.fromLiveContentJson(json['data']) : ContentModel(details: ContentData(), downloadData: DownloadDataModel(downloadQualities: [])),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toLiveContentJson(),
      'message': message,
    };
  }
}