class NotificationResponse {
  List<NotificationData> notificationData;
  int unReadNotificationCount;
  String message;
  bool status;

  NotificationResponse({
    this.notificationData = const <NotificationData>[],
    this.unReadNotificationCount = -1,
    this.message = "",
    this.status = false,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      notificationData: json['notification_data'] is List ? List<NotificationData>.from(json['notification_data'].map((x) => NotificationData.fromJson(x))) : [],
      unReadNotificationCount: json['unread_notification_count'] is int ? json['unread_notification_count'] : -1,
      message: json['message'] is String ? json['message'] : "",
      status: json['status'] is bool ? json['status'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification_data': notificationData.map((e) => e.toJson()).toList(),
      'unread_notification_count': unReadNotificationCount,
      'message': message,
      'status': status,
    };
  }
}

class NotificationData {
  int id;
  String notificationId;
  NotificationDetail? data;
  int isAlreadyRead;

  String notificationDatTime;

  NotificationData({
    this.id = -1,
    this.notificationId = "",
    this.isAlreadyRead = 0,
    this.data,
    this.notificationDatTime = "",
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] is int ? json['id'] : -1,
      notificationId: json['notification_id'] is String ? json['notification_id'] : "",
      data: json['data'] is Map ? NotificationDetail.fromJson(json['data']) : null,
      isAlreadyRead: json['is_already_read'] is int ? json['is_already_read'] : 0,
      notificationDatTime: json['date_time'] is String ? json['date_time'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification_id': notificationId,
      'data': data?.toJson(),
      'is_already_read': isAlreadyRead,
      'date_time': notificationDatTime,
    };
  }
}

class NotificationDetail {
  int id;
  String subject;
  String description;
  String notificationType;
  String thumbnailImage;
  NotificationRent rentVideo;
  UpcomingData upcomingData;
  ContinueWatchData continueWatchData;

  NotificationDetail({
    this.id = -1,
    this.subject = "",
    this.description = "",
    this.notificationType = "",
    this.thumbnailImage = "",
    this.rentVideo = const NotificationRent(),
    this.upcomingData = const UpcomingData(),
    this.continueWatchData = const ContinueWatchData(),
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      id: json['id'] is int ? json['id'] : -1,
      subject: json['subject'] is String ? json['subject'] : "",
      description: json['description'] is String ? json['description'] : "",
      notificationType: json['notification_type'] is String ? json['notification_type'] : "",
      thumbnailImage: json['thumbnail_image'] is String ? json['thumbnail_image'] : "",
      rentVideo: json['rent_video'] is Map
          ? NotificationRent.fromJson(json['rent_video'])
          : json['purchase_video'] is Map
              ? NotificationRent.fromJson(json['purchase_video'])
              : const NotificationRent(),
      upcomingData: json['upcoming_data'] is Map ? UpcomingData.fromJson(json['upcoming_data']) : const UpcomingData(),
      continueWatchData: json['continue_watch_data'] is Map ? ContinueWatchData.fromJson(json['continue_watch_data']) : const ContinueWatchData(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'notification_type': notificationType,
      'thumbnail_image': thumbnailImage,
      'rent_video': rentVideo.toJson(),
      'upcoming_data': upcomingData.toJson(),
      'continue_watch_data': continueWatchData.toJson(),
    };
  }
}

class UpcomingData {
  final int entertainmentId;
  final String contentType;

  const UpcomingData({this.entertainmentId = -1, this.contentType = ""});

  factory UpcomingData.fromJson(Map<String, dynamic> json) {
    return UpcomingData(
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      contentType: json['content_type'] is String ? json['content_type'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entertainment_id': entertainmentId,
      'content_type': contentType,
    };
  }
}

class ContinueWatchData {
  final int entertainmentId;
  final String contentType;

  const ContinueWatchData({this.entertainmentId = -1, this.contentType = ""});

  factory ContinueWatchData.fromJson(Map<String, dynamic> json) {
    return ContinueWatchData(
      entertainmentId: json['entertainment_id'] is int ? json['entertainment_id'] : -1,
      contentType: json['content_type'] is String ? json['content_type'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entertainment_id': entertainmentId,
      'content_type': contentType,
    };
  }
}

class MovieData {
  int movieId;

  MovieData({this.movieId = -1});

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      movieId: json['movie_id'] is int ? json['movie_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
    };
  }
}

class TvShowData {
  int tvShowId;

  TvShowData({this.tvShowId = -1});

  factory TvShowData.fromJson(Map<String, dynamic> json) {
    return TvShowData(
      tvShowId: json['tv_show_id'] is int ? json['tv_show_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tv_show_id': tvShowId,
    };
  }
}

class SeasonData {
  int seasonId;
  int tvShowId;

  SeasonData({this.seasonId = -1, this.tvShowId = -1});

  factory SeasonData.fromJson(Map<String, dynamic> json) {
    return SeasonData(
      seasonId: json['season_id'] is int ? json['season_id'] : -1,
      tvShowId: json['tv_show_id'] is int ? json['tv_show_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season_id': seasonId,
      'tv_show_id': tvShowId,
    };
  }
}

class EpisodeData {
  int episodeId;
  int tvShowId;

  EpisodeData({this.episodeId = -1, this.tvShowId = -1});

  factory EpisodeData.fromJson(Map<String, dynamic> json) {
    return EpisodeData(
      episodeId: json['episode_id'] is int ? json['episode_id'] : -1,
      tvShowId: json['tv_show_id'] is int ? json['tv_show_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'episode_id': episodeId,
      'tv_show_id': tvShowId,
    };
  }
}

class NotificationVideoData {
  int videoId;

  NotificationVideoData({this.videoId = -1});

  factory NotificationVideoData.fromJson(Map<String, dynamic> json) {
    return NotificationVideoData(
      videoId: json['video_id'] is int ? json['video_id'] : -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video_id': videoId,
    };
  }
}

class NotificationRent {
  final int contentId;
  final String contentType;

  const NotificationRent({this.contentId = -1, this.contentType = ""});

  factory NotificationRent.fromJson(Map<String, dynamic> json) {
    return NotificationRent(
      contentId: json['content_id'] is int ? json['content_id'] : -1,
      contentType: json['content_type'] is String ? json['content_type'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content_id': contentId,
      'content_type': contentType,
    };
  }
}