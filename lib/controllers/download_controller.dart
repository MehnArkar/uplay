import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uplayer/controllers/library_controller.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/models/playlist.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../models/youtube_video.dart';
import '../utils/log/snap_bar.dart';
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
  Map<String,DownloadTask> downloadingTask = {};
  bool isPanned = false;

  //For animation
  double statusBarOpacity = 1;
  double statusBarHeight = 85;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    scrollController.addListener(() {
      if(scrollController.position.pixels<=statusBarHeight){
        isPanned = false;
        statusBarOpacity = 1-(scrollController.position.pixels/statusBarHeight);
        update();
      }else{
          if(!isPanned){
            isPanned = true;
            update();
          }
      }
    });


  }

  @override
  void onClose() {
    unbindBackgroundIsolate();
    super.onClose();
  }

  final ReceivePort port = ReceivePort();

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
      return;
    }
    port.listen((dynamic data) async {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus(data[1]);
      int progress = data[2];

      if(downloadingTask.keys.contains(id)){
        DownloadTask currentTask = downloadingTask[id]!;
        DownloadTask updateTask = DownloadTask(
            taskId: currentTask.taskId,
            status: status,
            progress: progress,
            url: currentTask.url,
            filename: currentTask.filename,
            savedDir: currentTask.savedDir,
            timeCreated: currentTask.timeCreated,
            allowCellular: currentTask.allowCellular);
        downloadingTask[id]=updateTask;
      }

      if(status==DownloadTaskStatus.complete) {
        ///If download complete remove form downloading and add to local
        await Future.delayed(Duration(milliseconds: 100));
        List<DownloadTask>? taskList = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE task_id='$id'");
        YoutubeVideo currentVideo = downloadingVideo[taskList?.first.filename?.replaceFirst('.mp3','')]!;
        ///Added to all Songs box
        await allVideoBox.put(currentVideo.id,currentVideo);

        ///Add to library box
        LibraryController libraryController = Get.find();
        libraryController.addNewToPlaylist('Saved Songs', currentVideo);

        ///Remove from variable
        downloadingVideo.remove(currentVideo.id);

        showSnackBar('Download complete');
      }

      update();
    });
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

   void download(YoutubeVideo video) async{
      showLoadingDialog();

      downloadingVideo.addEntries([MapEntry(video.id, video)]);
      update();

      //Get url
      String url = await Get.find<PlayerController>().getUrl(video);

      //Save Dir
      Directory dir = await getApplicationDocumentsDirectory();
      Get.back();

     try{
       await FlutterDownloader.enqueue(
           url: url,
           fileName: '${video.id}.mp3',
           savedDir: dir.path,
           showNotification: true,
           openFileFromNotification: false,
           saveInPublicStorage: false
       );
       showSnackBar('Your download is start');
     }catch(e){
       superPrint('error in download $e');
       showCustomDialog(title: 'Download fail', contextTitle: 'Something went wrong');
       allVideoBox.delete(video.id);
     }
  }
  
  Future<void> getDownloadingTask() async{
    downloadingTask.clear();
    List<DownloadTask> allTask =await FlutterDownloader.loadTasks()??[];
    List<DownloadTask> runningTask =  allTask.where((task) => task.status==DownloadTaskStatus.running).toList();
    for (var task in runningTask) {
      downloadingTask.addEntries([MapEntry(task.taskId, task)]);
    }
    update();
  }

  resetData(){
    isPanned = false;
    statusBarOpacity = 1;
  }


}