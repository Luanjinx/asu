import 'package:streamit_laravel/screens/device/model/device_model.dart';

class ErrorModel {
  int statusCode;
  String error;
  List<DeviceData> otherDevice;

  ErrorModel({
    this.statusCode = 0,
    this.error = "",
    this.otherDevice = const <DeviceData>[],
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      statusCode: json['status_code'] is int ? json['status_code'] : 0,
      error: json['error'] is String ? json['error'] : "",
      otherDevice: json['other_device'] is List ? List<DeviceData>.from(json['other_device'].map((x) => DeviceData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'other_device': otherDevice.map((e) => e.toJson()).toList(),
    };
  }
}