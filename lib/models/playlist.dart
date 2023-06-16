import 'package:hive/hive.dart';
import 'package:uplayer/models/youtube_video.dart';

part 'playlist.g.dart';

@HiveType(typeId: 4,adapterName: 'PlaylistAdapter')
class Playlist{
  @HiveField(0)
  String name;
  @HiveField(1)
  List<YoutubeVideo> videoList;
  Playlist({required this.name,required this.videoList});
}