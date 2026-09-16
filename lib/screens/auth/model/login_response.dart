import 'package:streamit_laravel/screens/subscription/model/subscription_plan_model.dart';
import 'package:streamit_laravel/utils/common_functions.dart';

class UserResponse {
  bool status;
  UserData userData;
  String message;

  UserResponse({
    this.status = false,
    required this.userData,
    this.message = "",
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'] is bool ? json['status'] : false,
      userData: json['data'] is Map ? UserData.fromJson(json['data']) : UserData(planDetails: SubscriptionPlanModel()),
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': userData.toJson(),
      'message': message,
    };
  }
}

class UserData {
  int id;
  String firstName;
  String lastName;
  String email;
  String mobile;

  String countryCode;
  String loginType;
  String gender;
  String dateOfBirth;
  String address;
  int status;
  String apiToken;
  String fullName;
  String profileImage;
  SubscriptionPlanModel planDetails;
  String pin;
  int? otp;
  String? shortDramaSessionToken;

  UserData({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.mobile = "",
    this.countryCode = '',
    this.loginType = "",
    this.gender = "",
    this.dateOfBirth = "",
    this.address = "",
    this.status = -1,
    this.apiToken = "",
    this.fullName = "",
    this.profileImage = "",
    required this.planDetails,
    this.pin = "",
    this.otp = 0,
    this.shortDramaSessionToken,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      countryCode: json['country_code'] is String ? json['country_code'] : "",
      loginType: json['login_type'] is String ? json['login_type'] : "",
      gender: json['gender'] is String ? json['gender'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      address: json['address'] is String ? json['address'] : "",
      status: json['status'] is int ? json['status'] : -1,
      apiToken: json['api_token'] is String ? json['api_token'] : loginUserData.value.apiToken,
      fullName: json['full_name'] is String ? json['full_name'] : "",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      planDetails: json['plan_details'] is Map ? SubscriptionPlanModel.fromJson(json['plan_details']) : SubscriptionPlanModel(),
      shortDramaSessionToken: json['short_drama_session_token'] is String ? json['short_drama_session_token'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'country_code': countryCode,
      'login_type': loginType,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'address': address,
      'status': status,
      'api_token': apiToken,
      'full_name': fullName,
      'profile_image': profileImage,
      'plan_details': planDetails.toJson(),
      'short_drama_session_token': shortDramaSessionToken,
    };
  }
}