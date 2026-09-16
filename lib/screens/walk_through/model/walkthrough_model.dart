class WalkthroughListResponse {
  bool status;
  String message;
  List<WalkthroughModel> data;

  WalkthroughListResponse({
    this.status = false,
    this.message = "",
    this.data = const <WalkthroughModel>[],
  });

  factory WalkthroughListResponse.fromJson(Map<String, dynamic> json) {
    return WalkthroughListResponse(
      status: json['status'] is bool ? json['status'] : false,
      message: json['message'] is String ? json['message'] : "",
      data: json['data'] is List ? List<WalkthroughModel>.from(json['data'].map((x) => WalkthroughModel.fromJson(x))) : [],
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

class WalkthroughModel {
  int id;
  String title;
  String description;
  String image;
  int status;

  WalkthroughModel({
    this.id = -1,
    this.title = "",
    this.description = "",
    this.image = "",
    this.status = -1,
  });

  factory WalkthroughModel.fromJson(Map<String, dynamic> json) {
    return WalkthroughModel(
      id: json['id'] is int ? json['id'] : -1,
      title: json['title'] is String ? json['title'] : "",
      description: json['description'] is String ? json['description'] : "",
      image: json['image'] is String ? json['image'] : "",
      status: json['status'] is int ? json['status'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'status': status,
    };
  }
}