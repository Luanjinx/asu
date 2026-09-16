import 'package:streamit_laravel/configs.dart';

class ReviewResponse {
  bool status;
  String message;
  List<ReviewModel> data;

  ReviewResponse({
    this.status = false,
    this.message = "",
    this.data = const <ReviewModel>[],
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<ReviewModel>.from(json['data'].map((x) => ReviewModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Review {
  int totalReviews;
  ReviewModel? myReview;
  List<ReviewModel> otherReviewList;

  Review({this.totalReviews = 0, this.myReview, this.otherReviewList = const []});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      totalReviews: json['total_reviews'] is int ? json['total_reviews'] : 0,
      myReview: json['my_review'] != null ? ReviewModel.fromJson(json['my_review']) : null,
      otherReviewList: json['other_reviews'] is List ? List<ReviewModel>.from(json['other_reviews'].map((x) => ReviewModel.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_reviews': totalReviews,
      'my_review': myReview?.toJson(),
      'other_reviews': otherReviewList.map((e) => e.toJson()).toList(),
    };
  }
}

class ReviewModel {
  int id;
  int entertainmentId;
  int rating;
  String review;
  int userId;
  String username;
  String profileImage;
  String updatedAt;

  ReviewModel({
    this.id = -1,
    this.entertainmentId = -1,
    this.rating = -1,
    this.review = "",
    this.userId = -1,
    this.username = "${APP_NAME} user",
    this.profileImage = "",
    this.updatedAt = '',
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : -1,
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      rating: json['rating'] is int ? json['rating'] : -1,
      review: json['review'] is String ? json['review'] : "",
      userId: json['user_id'] is int ? json['user_id'] : -1,
      username: json['username'] is String ? json['username'] : "${APP_NAME} user",
      profileImage: json['profile_image'] is String ? json['profile_image'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entertainment_id': entertainmentId,
      'rating': rating,
      'review': review,
      'user_id': userId,
      'username': username,
      'profile_image': profileImage,
      'updated_at': updatedAt,
    };
  }
}