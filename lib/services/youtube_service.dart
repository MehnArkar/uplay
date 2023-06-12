import 'package:uplayer/models/video.dart';
import 'package:youtube_api/youtube_api.dart';

class YoutubeServices{
  static LocalVideo convertToLocal(YouTubeVideo youTubeVideo){
    return LocalVideo(thumbnail: youTubeVideo.thumbnail.high.url??'', publishedAt: youTubeVideo.publishedAt, channelId: youTubeVideo.channelId, title: youTubeVideo.title, channelTitle: youTubeVideo.channelTitle, url: youTubeVideo.url);
  }
}