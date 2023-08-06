import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:uplayer/controllers/download_controller.dart';
import 'package:uplayer/models/download_data.dart';
import 'package:uplayer/models/download_status.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';



class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DownloadController>(
      builder: (downloadController) => Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            width: Get.width,
            height: Get.height,
            child: CustomScrollView(
              controller: downloadController.scrollController,
              slivers: [
                SliverPersistentHeader(delegate: TopSpacingHeader(),pinned: true,),
                SliverPersistentHeader(delegate: DownloadStatusBarTitle(),pinned: false,),
                SliverPersistentHeader(delegate: SlidingSegmentedHeader(),pinned: true,),
                GetBuilder<DownloadController>(
                  builder:(controller)=> ValueListenableBuilder(
                      valueListenable: Hive.box<DownloadData>(AppConstants.boxDownload).listenable(),
                      builder: (context,data,_){
                        List<DownloadData> dataList;
                        if(controller.selectedSegment==DownloadSegmente.download) {
                          dataList = data.values.toList().where((data) => data.status != DownloadStatus.complete ).toList();
                        }else{
                          dataList = data.values.toList().where((data) => data.status == DownloadStatus.complete ).toList();
                        }
                        return dataList.isNotEmpty? SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) => downloadWidget(dataList[index]),
                                childCount: dataList.length),
                        ):
                        SliverFillRemaining(
                          child: Center(child: Text('No data',style: AppConstants.textStyleTitleMedium.copyWith(color: Colors.grey),),),
                        );
                      }
                  ),
                )

              ],
            ),
          ),
          // if (downloadController.isPanned)
          //   Positioned(left: 0, right: 0, top: 0, child: statusBar())
        ],
      ),
    );
  }

  Widget downloadWidget(DownloadData data){
    return Dismissible(
        key: Key(data.id),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          leading: Container(
            width: Get.width*0.15,
            height: Get.width*0.15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)
            ),
            child: CachedNetworkImage(
                imageUrl: data.video.thumbnails.high
            ),
          ),
          title: Text(data.video.title,style: AppConstants.textStyleMedium,maxLines: 1,overflow: TextOverflow.ellipsis,),
          subtitle:data.status!=DownloadStatus.complete?LinearPercentIndicator(
            padding: EdgeInsets.zero,
            percent: data.progress<0?0:data.progress,
            progressColor: AppColors.primaryColor,
            backgroundColor: Colors.grey,
            barRadius: const Radius.circular(10),
          ):
          Text('Complete',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),)
          ,
        ),
        onDismissed: (direction){
          Get.find<DownloadController>().onDeleteDownload(data.id);
        },
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
}

class TopSpacingHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<DownloadController>(
      builder:(controller)=> AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.maxFinite,
          height: MediaQuery.of(context).padding.top,
          color:controller.isPanned?Colors.black:Colors.transparent ,
      ),
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

class SlidingSegmentedHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
   return GetBuilder<DownloadController>(
     builder:(controller)=> AnimatedContainer(
       duration: const Duration(milliseconds: 200),
       color: controller.isPanned?Colors.black:Colors.transparent,
       height: 40,
       width: double.maxFinite,
       padding: const EdgeInsets.symmetric(horizontal: 25),
       child: CupertinoSlidingSegmentedControl<DownloadSegmente>(
         groupValue: controller.selectedSegment,
         thumbColor: AppColors.secondaryColor,
           children:  const {
             DownloadSegmente.download:Text('Download'),
             DownloadSegmente.complete:Text('Complete'),
           },
           onValueChanged: (value){
           if(value!=null) {
             controller.selectedSegment = value;
             controller.update();
           }
           })
     ),
   );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 40;

  @override
  // TODO: implement minExtent
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
   return true;
  }


}
