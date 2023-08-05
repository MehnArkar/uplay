import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uplayer/controllers/download_controller.dart';
import 'package:uplayer/models/download_data.dart';
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
            child: RefreshIndicator(
              onRefresh: () async{
              },
              child: CustomScrollView(
                controller: downloadController.scrollController,
                slivers: [
                  SliverPersistentHeader(delegate: TopSpacingHeader()),
                  SliverPersistentHeader(delegate: DownloadStatusBarTitle()),
                  ValueListenableBuilder(
                      valueListenable: Hive.box<DownloadData>(AppConstants.boxDownload).listenable(),
                      builder: (context,data,_){
                        return SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (context, index) => downloadWidget(data.getAt(index)!),
                                childCount: data.values.length),
                        );
                      }
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

  Widget downloadWidget(DownloadData data){
    return ListTile(
      title: Text(data.video.title),
      subtitle: LinearProgressIndicator(
        value: data.progress<0?0:data.progress,
        color: AppColors.primaryColor,
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
