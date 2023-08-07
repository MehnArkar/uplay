import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/models/download_data.dart';
import 'package:uplayer/models/download_status.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/dialog.dart';
import '../utils/log/snap_bar.dart';

enum DownloadSegmente{download,complete}

class DownloadController extends GetxController{

  bool isPanned = false;
  //For animation
  double statusBarOpacity = 1;
  double statusBarHeight = 85;
  ScrollController scrollController = ScrollController();
  FileDownloader downloader = FileDownloader();
  DownloadSegmente selectedSegment = DownloadSegmente.download;


  @override
  void onInit() {
    super.onInit();
    initLoad();
    listenScrollController();
  }

  @override
  void onClose() {
    super.onClose();
  }

  initLoad()async{
    listenUpdate();
    await downloader.trackTasks();
    await downloader.resumeFromBackground();
    await resumeIncompleteDownload();
  }

  listenScrollController(){
    scrollController.addListener(() {
      if(scrollController.position.pixels>=60){
        if(!isPanned){
          isPanned=true;
          update();
        }
      }else{
        if(isPanned){
          isPanned=false;
          update();
        }
      }
    });
  }

  listenUpdate(){
    downloader.updates.listen((update) {
     Box<DownloadData> downloadBox = Hive.box<DownloadData>(AppConstants.boxDownload);
     String id = update.task.taskId;
     DownloadData existingData = downloadBox.get(id)!;
      if(update is TaskStatusUpdate){
        debugPrint(update.status.toString());
          downloadBox.put(
              id,
              DownloadData(
                  id: existingData.id,
                  progress: existingData.progress,
                  status: getStatus(update.status),
                  video: existingData.video,
                  url: existingData.url
              ));
          if(update.status==TaskStatus.complete){
            Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).put(existingData.video.id, existingData.video);
          }
      }else if(update is TaskProgressUpdate){
        debugPrint(update.progress.toString());
        downloadBox.put(
            id,
            DownloadData(
                id: existingData.id,
                progress: update.progress,
                status: existingData.status,
                video: existingData.video,
                url: existingData.url
            ));
      }
    });
  }

  resumeIncompleteDownload() async{
    List<DownloadData> dataList = Hive.box<DownloadData>(AppConstants.boxDownload).values.toList();
    for (var data in dataList) {
      if(data.status == DownloadStatus.enqueue || data.status == DownloadStatus.downloading){
        DownloadTask task = DownloadTask(
          url: data.url,
          filename: '${data.video.id}.mp3',
          updates: Updates.statusAndProgress, // request status and progress updates
          requiresWiFi: false,
          taskId: data.video.id,
          allowPause: true,
        );
        if(await downloader.taskCanResume(task)){
          await downloader.resume(task);
        }else{
          downloader.database.deleteRecordWithId(task.taskId);
          Hive.box<DownloadData>(AppConstants.boxDownload).delete(task.taskId);
        }
      }
    }
  }


  download(YoutubeVideo video) async{
    showLoadingDialog();
    String url = await Get.find<PlayerController>().getUrl(video);
    DownloadTask task = DownloadTask(
      url: url,
      filename: '${video.id}.mp3',
      updates: Updates.statusAndProgress, // request status and progress updates
      requiresWiFi: false,
      taskId: video.id,
      allowPause: true,
    );
    bool isSuccess = await downloader.enqueue(task);
    if(isSuccess){
      DownloadData downloadData = DownloadData(
          id: video.id,
          progress: 0.0,
          status: DownloadStatus.enqueue,
          video: video,
          url: url);
      Box<DownloadData> box = Hive.box<DownloadData>(AppConstants.boxDownload);
      box.put(video.id, downloadData);
      Get.back();
      showSnackBar('Your download is start');
    }else{
      Get.back();
      showSnackBar('Fail to download');
    }

  }

  DownloadStatus getStatus(TaskStatus status){
    DownloadStatus downloadStatus;
    switch(status){
      case TaskStatus.enqueued:
        downloadStatus = DownloadStatus.enqueue;
        break;
      case TaskStatus.running:
        downloadStatus = DownloadStatus.downloading;
        break;
      case TaskStatus.complete:
        downloadStatus = DownloadStatus.complete;
        break;
      case TaskStatus.notFound:
        downloadStatus = DownloadStatus.fail;
        break;
      case TaskStatus.failed:
        downloadStatus = DownloadStatus.fail;
        break;
      case TaskStatus.canceled:
        downloadStatus = DownloadStatus.fail;
        break;
      case TaskStatus.waitingToRetry:
        downloadStatus = DownloadStatus.fail;
        break;
      case TaskStatus.paused:
        downloadStatus = DownloadStatus.pause;
        break;
    }

    return downloadStatus;

  }

  onDeleteDownload(String id){
    downloader.cancelTaskWithId(id);
    downloader.database.deleteRecordWithId(id);
    Hive.box<DownloadData>(AppConstants.boxDownload).delete(id);
  }

  resetData(){
    isPanned = false;
    statusBarOpacity = 1;
  }


}