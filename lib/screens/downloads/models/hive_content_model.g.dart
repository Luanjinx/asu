// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_content_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveContentModelAdapter extends TypeAdapter<HiveContentModel> {
  @override
  final int typeId = 1;

  @override
  HiveContentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveContentModel(
      id: fields[0] as int,
      thumbnailImage: fields[1] as String,
      contentData: fields[2] as String,
      localFilePath: fields[3] as String?,
      localThumbnailPath: fields[8] as String?,
      isDownloaded: fields[4] as bool,
      watchedProgress: fields[5] as double,
      watchedDuration: (fields[6] as int?) ?? 0,
      totalDuration: (fields[7] as int?) ?? 0,
      profileId: (fields[9] as int?) ?? -1,
      downloadDate: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiveContentModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.thumbnailImage)
      ..writeByte(2)
      ..write(obj.contentData)
      ..writeByte(3)
      ..write(obj.localFilePath)
      ..writeByte(8)
      ..write(obj.localThumbnailPath)
      ..writeByte(4)
      ..write(obj.isDownloaded)
      ..writeByte(5)
      ..write(obj.watchedProgress)
      ..writeByte(6)
      ..write(obj.watchedDuration)
      ..writeByte(7)
      ..write(obj.totalDuration)
      ..writeByte(9)
      ..write(obj.profileId)
      ..writeByte(10)
      ..write(obj.downloadDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HiveContentModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}