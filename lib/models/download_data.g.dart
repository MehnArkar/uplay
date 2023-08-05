// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadDataAdapter extends TypeAdapter<DownloadData> {
  @override
  final int typeId = 6;

  @override
  DownloadData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadData(
      id: fields[0] as String,
      progress: fields[1] as double,
      status: fields[2] as DownloadStatus,
      video: fields[3] as YoutubeVideo,
      url: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.progress)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.video)
      ..writeByte(4)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
