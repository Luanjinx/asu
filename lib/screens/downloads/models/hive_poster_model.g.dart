// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_poster_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HivePosterModelAdapter extends TypeAdapter<HivePosterModel> {
  @override
  final int typeId = 2;

  @override
  HivePosterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HivePosterModel(
      id: fields[0] as int,
      contentId: fields[1] as int,
      contentPosterData: fields[5] as String,
      watchedProgress: fields[2] as double,
      watchedDuration: fields[3] as int,
      totalDuration: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HivePosterModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contentId)
      ..writeByte(2)
      ..write(obj.watchedProgress)
      ..writeByte(3)
      ..write(obj.watchedDuration)
      ..writeByte(4)
      ..write(obj.totalDuration)
      ..writeByte(5)
      ..write(obj.contentPosterData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is HivePosterModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}