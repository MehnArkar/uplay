import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/log/snap_bar.dart';
import 'package:uplayer/views/global_ui/dialog.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService{

  static download(YoutubeVideo video) async{
    PermissionStatus status = await Permission.storage.request();
    if(status == PermissionStatus.granted || status == PermissionStatus.limited) {
      //Get url
      String url = await Get.find<PlayerController>().getUrl(video,true);
      //Save Dir
      Directory dir = await getApplicationDocumentsDirectory();

      final taskId = await FlutterDownloader.enqueue(
        url: url.toString(),
        headers: {},
        fileName: '${video.title}.mp3',
        savedDir: dir.path,
        showNotification: true,
        openFileFromNotification: true,
      );

    }else{
      showCustomDialog(title: 'Permission denied!', contextTitle: 'Please give storage permission to download');
    }

  }

  // static download(String url) async{
  //   final Directory saveDir = await getApplicationDocumentsDirectory();
  //   final taskId =  FlutterDownloader.enqueue(
  //     url: url,
  //     headers: {}, // optional: header send with url (auth token etc)
  //     savedDir: saveDir.path,
  //     showNotification: true, // show download progress in status bar (for Android)
  //     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  //   )
  // }
}