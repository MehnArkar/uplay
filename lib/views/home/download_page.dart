import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:uplayer/controllers/download_controller.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<DownloadController>().getDownloadingTask();
    Get.find<DownloadController>().resetData();
    return GetBuilder<DownloadController>(
      builder: (downloadController) => Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: RefreshIndicator(
              onRefresh: () async{
                await downloadController.getDownloadingTask();
              },
              child: CustomScrollView(
                controller: downloadController.scrollController,
                slivers: [
                  SliverPersistentHeader(delegate: TopSpacingHeader()),
                  SliverPersistentHeader(delegate: DownloadStatusBarTitle()),
                  SliverPadding(
                    padding: EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 25,
                        bottom: AppConstants.navBarHeight + 25),
                    sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: downloadController.downloadingTask.length,
                            (context, index) {
                      String key = downloadController.downloadingTask.keys.elementAt(index);
                      DownloadTask currentTask = downloadController.downloadingTask[key]!;
                      YoutubeVideo? currentVideo;
                      String? videoId = currentTask.filename?.replaceAll('.mp3', '');
                      if (downloadController.downloadingVideo.containsKey(videoId)) {
                        currentVideo = downloadController.downloadingVideo[videoId];
                      }
                      return currentVideo == null
                          ? Container()
                          : eachDownloadWidget(currentTask, currentVideo);
                    })),
                  )
                ],
              ),
            ),
          ),
          if (downloadController.isPanned)
            Positioned(left: 0, right: 0, top: 0, child: statusBar())
        ],
      ),
    );
  }

  Widget statusBar() {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ),
        GetBuilder<DownloadController>(
          builder: (controller) => AnimatedOpacity(
            opacity: controller.isPanned ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(Get.context!).padding.top + 15,
                  bottom: 15),
              alignment: Alignment.center,
              child: Text(
                'Download',
                style: AppConstants.textStyleTitleSmall,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget eachDownloadWidget(DownloadTask task, YoutubeVideo video) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: Get.width * 0.15,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: Get.width * 0.15,
            height: Get.width * 0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(video.thumbnails.high ?? ''),
                    fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: SizedBox(
            height: Get.width * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  video.title,
                  style: AppConstants.textStyleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.5,),
                LinearPercentIndicator(
                  padding: EdgeInsets.zero,
                  percent: task.progress/100,
                  linearGradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withOpacity(0.5),
                        AppColors.primaryColor,
                      ]
                  ),
                  backgroundColor: Colors.grey.withOpacity(0.5),
                  barRadius: const Radius.circular(20),

                )
                // Container(
                //   color: Colors.blue,
                //   child: LinearProgressIndicator(
                //     value: task.progress / 100,
                //     color: AppColors.primaryColor,
                //   ),
                // )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class TopSpacingHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).padding.top,

    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => MediaQuery.of(Get.context!).padding.top;

  @override
  // TODO: implement minExtent
  double get minExtent => MediaQuery.of(Get.context!).padding.top;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

class DownloadStatusBarTitle extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<DownloadController>(
      builder: (controller) => Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.centerLeft,
        child: Text(
          'Download',
          style: AppConstants.textStyleTitleLarge.copyWith(
              color: Colors.white.withOpacity(controller.statusBarOpacity)),
        ),
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 60;

  @override
  // TODO: implement minExtent
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
