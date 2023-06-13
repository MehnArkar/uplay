class YoutubeVideo{
  String id;
  String title;
  String description;
  Thumbnails thumbnails;
  String url;
  String channelId;
  String channelTitle;

  YoutubeVideo({required this.id,required this.title,required this.description,required this.thumbnails,required this.url,required this.channelId,required this.channelTitle});

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
        channelTitle: json['snippet']['channelTitle']);
  }
}

class Thumbnails{
  String normal;
  String medium;
  String high;

  Thumbnails({required this.normal,required this.medium,required this.high});

  factory Thumbnails.fromJson(Map<String,dynamic> json){
    return Thumbnails(
        normal: json['default']['url'],
        medium: json['medium']['url'],
        high: json['high']['url']);
  }
}