import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uplayer/controllers/download_controller.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/controllers/search_page_controller.dart';
import 'package:uplayer/models/playlist.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:uplayer/views/global_ui/animation/animated_dot.dart';
import 'package:uplayer/views/player/player_controller_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    SearchPageController contoller = Get.put(SearchPageController());
    contoller.isPined=false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SearchPageController controller = Get.find();
      RenderBox renderBox = controller.cancelBtnKey.currentContext!.findRenderObject() as RenderBox;
      controller.cancelBtnWidth = renderBox.size.width;
      controller.update();
    });
    return CustomScrollView(
      controller: Get.find<SearchPageController>().scrollController,
      slivers: [
        SliverPersistentHeader(delegate: TopSpacingHeader(),pinned: true,),
        SliverPersistentHeader(delegate: SearchTitleHeader(),pinned: false,),
        SliverPersistentHeader(pinned: true, delegate: SearchBarHeader()),
        GetBuilder<SearchPageController>(
            builder:(controller)=>
                controller.isSearching?
                    const SliverFillRemaining(
                      child: Center(child: CupertinoActivityIndicator(color: AppColors.primaryColor,),),
                    ):
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => eachVideoList(controller.videoResult[index]),
                            childCount:controller.videoResult.length,)
                    )
        ),
        GetBuilder<SearchPageController>(
            builder:(controller)=> SliverPadding(padding: EdgeInsets.only(bottom:controller.isSearching?0 :AppConstants.navBarHeight)))
      ],
    );
  }


  Widget eachVideoList(YoutubeVideo video){
    return GetBuilder<PlayerController>(
      builder:(playerController)=> StreamBuilder<PlayerState>(
        stream: playerController.player.playerStateStream,
        builder: (context,snapShot) {
          return GestureDetector(
            onTap: (){
              if(playerController.currentVideo?.id!=video.id) {
                playerController.play(video);
              }else{
                Get.to(const PlayerControllerPage());
              }
            },
            child: Container(
              padding:const EdgeInsets.symmetric(horizontal: 25),
              margin:const EdgeInsets.only(bottom: 15),
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: Get.width*0.15,
                    height: Get.width*0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(image: CachedNetworkImageProvider(video.thumbnails.high??''),fit: BoxFit.cover),
                    ),
                    child: playerController.currentVideo !=null && playerController.currentVideo!.id ==video.id && (snapShot.data?.processingState!=ProcessingState.completed)?
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: Center(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 1.0,
                                          sigmaY: 1.0,
                                        ),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.25),
                                        ),
                                      ),
                                    ),
                                  ),
                                  playerController.isLoading?
                                    const AnimatedDot() :
                                    Lottie.asset('assets/lottie/wave.json',),

                                ],
                              ),
                            )
                           :
                          Container()
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                      child: SizedBox(
                        height: Get.width*0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // playerController.currentVideo!=null && playerController.currentVideo!.id==video.id?
                            // Marquee(
                            //     text: video.title,
                            //     style: AppConstants.textStyleMedium.copyWith(color: AppColors.primaryColor),
                            // ):
                            Text(
                              video.title,
                              style: AppConstants.textStyleMedium.copyWith(color: playerController.currentVideo!=null && playerController.currentVideo!.id==video.id && snapShot.data!=null && snapShot.data!.processingState!=ProcessingState.completed?AppColors.primaryColor:Colors.white),
                              maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Text(video.channelTitle.replaceFirst('VEVO','')??'',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),)

                  ],),
                      )),
                  const SizedBox(width: 15,),
                  GetBuilder<DownloadController>(
                    builder:(controller)=> ValueListenableBuilder<Box<Playlist>>(
                      valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(),
                      builder:(context,box,widget) {
                        bool isDownloaded = false;
                        Playlist? playlist = box.get('Saved Songs');
                        if(playlist!=null){
                          if((playlist.videoList.where((each) => each.id==video.id)).isNotEmpty){
                            isDownloaded = true;
                          }
                        }
                        return isDownloaded || controller.downloadingVideo.containsKey(video.id) ?
                            Container()
                            : GestureDetector(
                            onTap: () {
                              Get.find<DownloadController>().download(video);
                            },
                            child: const Icon(
                              Iconsax.arrow_down_2, color: Colors.grey,));
                      }
                    ),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

}

class SearchTitleHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.maxFinite,
      padding:const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.centerLeft,
      child: Text('Search',style: AppConstants.textStyleTitleLarge,),
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

class TopSpacingHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<SearchPageController>(
      builder:(controller)=> AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.maxFinite,
        height: MediaQuery.of(context).padding.top,
        color: controller.isPined?Colors.black:Colors.transparent,
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

class SearchBarHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return GetBuilder<SearchPageController>(
        builder:(controller)=> AnimatedBuilder(
            animation: controller.animation,
            builder: (context,child){
              return AnimatedContainer(
                width: double.maxFinite,
                height: 66,
                duration:const Duration(milliseconds: 200),
                padding:const EdgeInsets.only(left: 25,right: 25,bottom: 15,top: 15),
                color: controller.isPined?Colors.black:Colors.transparent,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoSearchTextField(
                            focusNode: controller.nodeTxtSearch,
                            style:const TextStyle(color: Colors.white),
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            onSubmitted: (searchText) async{
                              await controller.search(searchText);
                            },
                          ),
                        ),
                        SizedBox(
                          width: controller.cancelBtnWidth*controller.animation.value,
                        )
                      ],
                    ),
                    Positioned(
                      right:-(controller.cancelBtnWidth- (controller.cancelBtnWidth*controller.animation.value)),
                      child: Opacity(
                        opacity: controller.animation.value,
                        child: CupertinoButton(
                          key: controller.cancelBtnKey,
                          padding:const EdgeInsets.only(left: 15),
                          onPressed: (){
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          child:const Text('Cancel',style: TextStyle(color: AppColors.primaryColor),),
                        ),
                      ),
                    )
                  ],
                ),
              );
            })
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 66;

  @override
  // TODO: implement minExtent
  double get minExtent => 66;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

