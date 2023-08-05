import 'package:hive/hive.dart';
import 'package:uplayer/models/download_status.dart';
import 'package:uplayer/models/youtube_video.dart';

part 'download_data.g.dart';

@HiveType(typeId: 6)
class DownloadData {
  @HiveField(0)
  String id;
  @HiveField(1)
  double progress;
  @HiveField(2)
  DownloadStatus status;
  @HiveField(3)
  YoutubeVideo video;
  @HiveField(4)
  String url;

  DownloadData({required this.id,required this.progress,required this.status,required this.video,required this.url});
}