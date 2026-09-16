import 'package:streamit_laravel/screens/profile/watching_profile/model/profile_watching_model.dart';

import '../../subscription/model/subscription_plan_model.dart';

class ProfileDetailResponse {
  bool status;
  String message;
  ProfileModel data;

  ProfileDetailResponse({
    this.status = false,
    this.message = "",
    required this.data,
  });

  factory ProfileDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDetailResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is Map ? ProfileModel.fromJson(json['data']) : ProfileModel(planDetails: SubscriptionPlanModel()),
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

class ProfileModel {
  int id;
  String firstName;
  String lastName;
  String fullName;
  String email;
  String mobile;

  String countryCode;
  String gender;
  String dateOfBirth;
  String address;
  String loginType;
  String emailVerifiedAt;
  String profileImage;
  SubscriptionPlanModel planDetails;
  List<WatchingProfileModel> profileList;

  ProfileModel({
    this.id = -1,
    this.firstName = "",
    this.lastName = "",
    this.fullName = "",
    this.email = "",
    this.mobile = "",
    this.gender = "",
    this.dateOfBirth = "",
    this.address = "",
    this.loginType = '',
    this.emailVerifiedAt = "",
    this.profileImage = "",
    required this.planDetails,
    this.profileList = const <WatchingProfileModel>[],
    this.countryCode = '',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] is int ? json['id'] : -1,
      firstName: json['first_name'] is String ? json['first_name'] : "",
      lastName: json['last_name'] is String ? json['last_name'] : "",
      fullName: json['full_name'] is String ? json['full_name'] : "",
      email: json['email'] is String ? json['email'] : "",
      mobile: json['mobile'] is String ? json['mobile'] : "",
      countryCode: json['country_code'] is String ? json['country_code'] : "",
      gender: json['gender'] is String ? json['gender'] : "",
      dateOfBirth: json['date_of_birth'] is String ? json['date_of_birth'] : "",
      address: json['address'] is String ? json['address'] : "",
      loginType: json['login_type'] is String ? json['login_type'] : "",
      emailVerifiedAt: json['email_verified_at'] is String ? json['email_verified_at'] : "",
      profileImage: json['file_url'] is String
          ? json['file_url']
          : json['profile_image'] is String
              ? json['profile_image']
              : "",
      planDetails: json['plan_details'] is Map ? SubscriptionPlanModel.fromJson(json['plan_details']) : SubscriptionPlanModel(),
      profileList: json['watching_profiles'] is List ? List<WatchingProfileModel>.from(json['watching_profiles'].map((x) => WatchingProfileModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'country_code': countryCode,
      'mobile': mobile,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'address': address,
      'login_type': loginType,
      'email_verified_at': emailVerifiedAt,
      'profile_image': profileImage,
      'media': [],
      'plan_details': planDetails.toJson(),
      'watching_profiles': profileList.map((e) => e.toJson()).toList(),
    };
  }
}