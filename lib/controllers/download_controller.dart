import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uplayer/controllers/player_controller.dart';

import '../models/youtube_video.dart';
import '../views/global_ui/dialog.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}


class DownloadController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void onClose() {
    unbindBackgroundIsolate();
    super.onClose();
  }

  final ReceivePort port = ReceivePort();

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        port.sendPort, 'downloader_send_port');
    print('GG $isSuccess');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    port.listen((dynamic data) {
      // String id = data[0];
      // DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      // int progress = data[2];
      // DownloadTask task = downloadsList[id]!;
      // DownloadTask downloadTask = DownloadTask(taskId: task.taskId, status: status, progress: progress, url: task.url, filename: task.filename, savedDir: task.savedDir, timeCreated: task.timeCreated, allowCellular: task.allowCellular);
      // downloadsList[id]=downloadTask;
      // setState(() {
      // });
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

   download(YoutubeVideo video) async{
    PermissionStatus status = await Permission.storage.request();
    if(status == PermissionStatus.granted || status == PermissionStatus.limited) {
      //Get url
      String url = await Get.find<PlayerController>().getUrl(video);

      //Save Dir
      Directory dir = await getApplicationDocumentsDirectory();

      final taskId = await FlutterDownloader.enqueue(
        url: url,
        fileName: '${video.id}.mp3',
        savedDir: dir.path,
        showNotification: true,
        openFileFromNotification: false,
        saveInPublicStorage: true
      );
    }else{
      showCustomDialog(title: 'Permission denied!', contextTitle: 'Please give storage permission to download');
    }
  }

}