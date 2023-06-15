import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../models/youtube_video.dart';
import '../utils/log/super_print.dart';
import '../views/global_ui/dialog.dart';
import 'package:hive_flutter/hive_flutter.dart';

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}


class DownloadController extends GetxController{
  Box<YoutubeVideo> allVideoBox = Hive.box<YoutubeVideo>(AppConstants.boxAllVideos);
  Map<String,YoutubeVideo> downloadingVideo ={};

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
    port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      int progress = data[2];
      if(status==DownloadTaskStatus.complete) {
        ///If download complete remove form downloading and add to local
        List<DownloadTask>? taskList = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE task_id='$id'");
        YoutubeVideo currentVideo = downloadingVideo[taskList?.first.filename?.replaceFirst('.mp3','')]!;
        await allVideoBox.put(currentVideo.id,currentVideo);
        downloadingVideo.remove(currentVideo.id);
        update();
      }
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

   download(YoutubeVideo video) async{

      downloadingVideo.addEntries([MapEntry(video.id, video)]);
      update();

      //Get url
      String url = await Get.find<PlayerController>().getUrl(video);

      //Save Dir
      Directory dir = await getApplicationDocumentsDirectory();

     try{
       await FlutterDownloader.enqueue(
           url: url,
           fileName: '${video.id}.mp3',
           savedDir: dir.path,
           showNotification: true,
           openFileFromNotification: false,
           saveInPublicStorage: true
       );
     }catch(e){
       superPrint('error in download $e');
       showCustomDialog(title: 'Download fail', contextTitle: 'Something went wrong');
       allVideoBox.delete(video.id);
     }

  }



}