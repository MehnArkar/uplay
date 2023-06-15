// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_video.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YoutubeVideoAdapter extends TypeAdapter<YoutubeVideo> {
  @override
  final int typeId = 1;

  @override
  YoutubeVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YoutubeVideo(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      thumbnails: fields[3] as Thumbnails,
      url: fields[4] as String,
      channelId: fields[5] as String,
      channelTitle: fields[6] as String,
      isNetwork: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, YoutubeVideo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.thumbnails)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.channelId)
      ..writeByte(6)
      ..write(obj.channelTitle)
      ..writeByte(7)
      ..write(obj.isNetwork);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YoutubeVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ThumbnailsAdapter extends TypeAdapter<Thumbnails> {
  @override
  final int typeId = 3;

  @override
  Thumbnails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Thumbnails(
      normal: fields[0] as String,
      medium: fields[1] as String,
      high: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Thumbnails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.normal)
      ..writeByte(1)
      ..write(obj.medium)
      ..writeByte(2)
      ..write(obj.high);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
