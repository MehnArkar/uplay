class LocalVideo {
  String thumbnail;
  String? kind;
  String? id;
  String? publishedAt;
  String? channelId;
  String? channelUrl;
  String title;
  String? description;
  String channelTitle;
  String url;
  String? duration;

  LocalVideo({
    required this.thumbnail,
    this.kind,
    this.id,
    required this.publishedAt,
    required this.channelId,
    this.channelUrl,
    required this.title,
    this.description,
    required this.channelTitle,
    required this.url,
    this.duration});
}


