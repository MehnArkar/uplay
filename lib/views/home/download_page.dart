import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/download_controller.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/log/super_print.dart';

import '../../utils/constants/app_constant.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<DownloadController>().getDownloadingTask();
    return GetBuilder<DownloadController>(
        builder:(controller)=>
        controller.isLoading?
        const Center(
          child: CupertinoActivityIndicator(color: AppColors.primaryColor,),
        ):
        ListView.builder(
          padding:const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
          itemCount: controller.downloadingTask.length,
          itemBuilder: (BuildContext context, int index) {
            String key = controller.downloadingTask.keys.elementAt(index);
            DownloadTask currentTask = controller.downloadingTask[key]!;
            YoutubeVideo? currentVideo;
            String? videoId = currentTask.filename?.replaceAll('.mp3', '');

            if(controller.downloadingVideo.containsKey(videoId)){
              currentVideo  = controller.downloadingVideo[videoId];
            }
            return currentVideo==null?Container():eachDownloadWidget(currentTask,currentVideo);
          },

        )

    );
  }

  Widget eachDownloadWidget(DownloadTask task,YoutubeVideo video){
    return Row(
      children: [
        Container(
          margin:const EdgeInsets.only(bottom: 15),
          width: Get.width*0.15,
          height: Get.width*0.15,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: CachedNetworkImageProvider(video.thumbnails.high??''),fit: BoxFit.cover)
          ),
        ),
        const SizedBox(width: 15,),
        Expanded(
            child: SizedBox(
              height: Get.width*0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: AppConstants.textStyleMedium,
                    maxLines: 1,overflow: TextOverflow.ellipsis,),
                   LinearProgressIndicator(
                    value: task.progress/100,
                    color: AppColors.primaryColor,)

                ],),
            )),
      ],
    );
  }
}
