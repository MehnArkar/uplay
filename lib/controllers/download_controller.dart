import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadController extends GetxController{
  Map<String,YouTubeVideo> downloadingVideoMap={};

  download(YouTubeVideo video) async{
    PermissionStatus status = await Permission.storage.request();
    if(status.isGranted || status.isLimited) {
      //Get url
      YoutubeExplode youtubeExplode = YoutubeExplode();
      final manifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);
      final audioStreamInfo = manifest.audio.withHighestBitrate();
      final audioUrl = audioStreamInfo.url;

      //Save Dir
      Directory dir = await getApplicationDocumentsDirectory();

      final taskId = await FlutterDownloader.enqueue(
        url: audioUrl.toString(),
        headers: {},
        fileName: '${video.title}.mp3',
        savedDir: dir.path,
        showNotification: true,
        openFileFromNotification: true,
      );

      downloadingVideoMap.assign(taskId ?? '', video);
    }
  }
}