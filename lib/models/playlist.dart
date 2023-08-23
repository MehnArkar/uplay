
import 'package:hive_flutter/adapters.dart';

part 'playlist.g.dart';

@HiveType(typeId: 4)
class Playlist {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> videoList;
  Playlist({required this.name,required this.videoList});
}