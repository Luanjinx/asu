import 'package:hive/hive.dart';

part 'hive_content_model.g.dart';

/// Hive model for downloaded content (movies/episodes/videos)
@HiveType(typeId: 1)
class HiveContentModel extends HiveObject {
  /// Content id from API
  @HiveField(0)
  int id;

  /// Thumbnail image URL (snapshot)
  @HiveField(1)
  String thumbnailImage;

  /// JSON snapshot of ContentModel (to avoid needing its adapter)
  @HiveField(2)
  String contentData;

  /// Local encrypted file path (.enc)
  @HiveField(3)
  String? localFilePath;

  /// Local thumbnail file path
  @HiveField(8)
  String? localThumbnailPath;

  /// Whether file is downloaded and available offline
  @HiveField(4)
  bool isDownloaded;

  /// Watched percentage (0-100)
  @HiveField(5)
  double watchedProgress;

  /// Watched duration in seconds
  @HiveField(6)
  int watchedDuration;

  /// Total duration in seconds
  @HiveField(7)
  int totalDuration;

  /// The profile ID associated with this download
  @HiveField(9)
  int profileId;

  /// Time when the download was completed (milliseconds since epoch)
  @HiveField(10)
  int? downloadDate;

  HiveContentModel({
    required this.id,
    required this.thumbnailImage,
    required this.contentData,
    this.localFilePath,
    this.localThumbnailPath,
    this.isDownloaded = false,
    this.watchedProgress = 0.0,
    this.watchedDuration = 0,
    this.totalDuration = 0,
    this.profileId = -1,
    this.downloadDate,
  });
}
