class NotificationCountResponse {
  bool status;
  int data;

  NotificationCountResponse({
    this.status = false,
    required this.data,
  });

  factory NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    return NotificationCountResponse(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is int ? json['data'] : 0,
    );
  }
}