
import 'package:hive/hive.dart';

part 'youtube_video.g.dart';

@HiveType(typeId: 1,adapterName: 'YoutubeVideoAdapter')
class YoutubeVideo{
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  Thumbnails thumbnails;
  @HiveField(4)
  String url;
  @HiveField(5)
  String channelId;
  @HiveField(6)
  String channelTitle;
  @HiveField(7)
  bool isNetwork;
  YoutubeVideo({required this.id,required this.title,required this.description,required this.thumbnails,required this.url,required this.channelId,required this.channelTitle,this.isNetwork=false});

  factory YoutubeVideo.fromJson(Map<String,dynamic> json){
    String id = json['id']['videoId']??'';
    String url = 'https://www.youtube.com/watch?v=$id';
    return YoutubeVideo(
        id: id,
        title: json['snippet']['title']??'',
        description: json['snippet']['description']??'',
        thumbnails: Thumbnails.fromJson(json['snippet']['thumbnails']),
        url: url,
        channelId: json['id']['channelId']??'',
        channelTitle: json['snippet']['channelTitle'],);
  }
}


@HiveType(typeId: 3,adapterName: 'ThumbnailsAdapter')
class Thumbnails{
  @HiveField(0)
  String normal;
  @HiveField(1)
  String medium;
  @HiveField(2)
  String high;

  Thumbnails({required this.normal,required this.medium,required this.high});

  factory Thumbnails.fromJson(Map<String,dynamic> json){
    return Thumbnails(
        normal: json['default']['url'],
        medium: json['medium']['url'],
        high: json['high']['url']);
  }
}