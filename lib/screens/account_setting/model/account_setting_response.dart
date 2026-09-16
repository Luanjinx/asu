import 'package:streamit_laravel/screens/device/model/device_model.dart';
import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';

class AccountSettingResponse {
  bool status;
  AccountSettingModel data;
  String message;

  AccountSettingResponse({
    this.status = false,
    required this.data,
    this.message = "",
  });

  factory AccountSettingResponse.fromJson(Map<String, dynamic> json) {
    return AccountSettingResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is Map ? AccountSettingModel.fromJson(json['data']) : AccountSettingModel(yourDevice: DeviceData(), planDetails: SubscriptionPlanModel()),
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

class AccountSettingModel {
  int isParentalLockEnabled;
  SubscriptionPlanModel planDetails;
  String registerMobileNumber;
  DeviceData yourDevice;
  List<DeviceData> otherDevice;

  AccountSettingModel({
    this.isParentalLockEnabled = 0,
    required this.planDetails,
    this.registerMobileNumber = "",
    required this.yourDevice,
    this.otherDevice = const <DeviceData>[],
  });

  factory AccountSettingModel.fromJson(Map<String, dynamic> json) {
    return AccountSettingModel(
      isParentalLockEnabled: json['is_parental_lock_enable'] is int ? json['is_parental_lock_enable'] : 0,
      planDetails: json['plan_details'] is Map ? SubscriptionPlanModel.fromJson(json['plan_details']) : SubscriptionPlanModel(),
      registerMobileNumber: json['register_mobile_number'] is String ? json['register_mobile_number'] : "",
      yourDevice: json['your_device'] is Map ? DeviceData.fromJson(json['your_device']) : DeviceData(),
      otherDevice: json['other_device'] is List ? List<DeviceData>.from(json['other_device'].map((x) => DeviceData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plan_details': planDetails.toJson(),
      'register_mobile_number': registerMobileNumber,
      'your_device': yourDevice.toJson(),
      'other_device': otherDevice.map((e) => e.toJson()).toList(),
    };
  }
}