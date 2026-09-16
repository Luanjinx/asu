import 'package:streamit_laravel/screens/content/model/content_model.dart';

class PayPerViewModel {
  bool status;
  String message;
  ContentModel data;

  PayPerViewModel({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory PayPerViewModel.fromJson(Map<String, dynamic> json) {
    return PayPerViewModel(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? ContentModel.fromContentJson(json['data']) : ContentModel(details: ContentData(), downloadData: DownloadDataModel(downloadQualities: [])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toContentJson(),
    };
  }
}