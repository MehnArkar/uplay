import 'package:get/get.dart';


class DownloadController extends GetxController{
  // Map<String,YouTubeVideo> downloadingVideoMap={};
  //
  // download(LocalVideo video) async{
  //   PermissionStatus status = await Permission.storage.request();
  //   if(status.isGranted || status.isLimited) {
  //     //Get url
  //     YoutubeExplode youtubeExplode = YoutubeExplode();
  //     final manifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);
  //     final audioStreamInfo = manifest.audio.withHighestBitrate();
  //     final audioUrl = audioStreamInfo.url;
  //
  //     //Save Dir
  //     Directory dir = await getApplicationDocumentsDirectory();
  //
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: audioUrl.toString(),
  //       headers: {},
  //       fileName: '${video.title}.mp3',
  //       savedDir: dir.path,
  //       showNotification: true,
  //       openFileFromNotification: true,
  //     );
  //
  //   }
  // }
}