import 'package:hive/hive.dart';

part 'hive_poster_model.g.dart';

/// Hive model for poster/episode metadata snapshot
@HiveType(typeId: 2)
class HivePosterModel extends HiveObject {
  /// Poster row id (local key)
  @HiveField(0)
  int id;

  /// Associated content id
  @HiveField(1)
  int contentId;

  /// Watched percentage (0-100)
  @HiveField(2)
  double watchedProgress;

  /// Watched duration in seconds
  @HiveField(3)
  int watchedDuration;

  /// Total duration in seconds
  @HiveField(4)
  int totalDuration;

  /// JSON snapshot of PosterDataModel
  @HiveField(5)
  String contentPosterData;

  HivePosterModel({
    required this.id,
    required this.contentId,
    required this.contentPosterData,
    this.watchedProgress = 0.0,
    this.watchedDuration = 0,
    this.totalDuration = 0,
  });
}
