import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:uplayer/controllers/library_controller.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/utils/log/snap_bar.dart';
import 'package:uplayer/utils/log/super_print.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/player/player_controller_page.dart';

import '../../../controllers/download_controller.dart';
import '../../../controllers/player_controller.dart';
import '../../../models/playlist.dart';
import '../../../utils/constants/app_color.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;
  final YoutubeVideo? coverVideo;
  const PlaylistScreen({Key? key,required this.playlist, required this.coverVideo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
        isTopSafe: false,
        isBotSafe:Platform.isAndroid?true:false,
        botColor: Colors.black,
        backgroundColor: Colors.black,
        isResizeToAvoidBottomInset: false,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            topPanel(),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: bodyWidget())
          ],
        )


    //     child: ValueListenableBuilder<Box<Playlist>>(
    //         valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(keys:[playlist.name]),
    //         builder:(context,box,widget) {
    //           Playlist? currentPlaylist = box.get(playlist.name);
    //           List<YoutubeVideo> videoList = currentPlaylist!.videoList;
    //           return ListView.builder(
    //               itemCount: videoList.length,
    //               itemBuilder: (context, index) => eachVideo(videoList[index])
    //           );
    //         }
    // )
    );
  }

  Widget topPanel(){
    return ClipRRect(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.maxFinite,
            height: Get.height*0.25,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(image: CachedNetworkImageProvider(coverVideo!=null?coverVideo!.thumbnails.high??'':''),fit: BoxFit.cover),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10.0,
                  sigmaY: 10.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
            ),
          ),
          Positioned(
              left: 25,
              right: 25,
              top: MediaQuery.of(Get.context!).padding.top,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: Container(
                          padding:const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.2)
                          ),
                          child:const Icon(Icons.arrow_back_ios_new_rounded,size: 20,color: Colors.white,),
                        ),
                      ),
                      Expanded(child: Center(child: Text(playlist.name,style:AppConstants.textStyleTitleMedium,)),),
                      PopupMenuButton(
                        color: AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Container(
                          padding:const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.2)
                          ),
                          child:const Icon(Icons.more_vert_rounded,size: 20,color: Colors.white,),
                        ),
                          itemBuilder: (context){
                            return [
                              PopupMenuItem(
                                  onTap: (){
                                    Get.back();
                                    Get.find<LibraryController>().deletePlaylist(playlist.name);
                                    showSnackBar('${playlist.name} deleted!');
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Iconsax.trash,color: Colors.red,size: 20,),
                                      const SizedBox(width: 10,),
                                      Text('Delete',style: AppConstants.textStyleMedium.copyWith(color: Colors.red),),
                                    ],
                                  ))
                            ];
                          })
                      // Container(
                      //   padding:const EdgeInsets.all(8),
                      //   alignment: Alignment.center,
                      //   decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.black.withOpacity(0.2)
                      //   ),
                      //   child:const Icon(Icons.more_vert_rounded,size: 20,color: Colors.white,),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Text('${playlist.videoList.length} songs',style: AppConstants.textStyleTitleSmall.copyWith(color: Colors.grey),)
                ],
              )
          )
        ],
      ),
    );
  }

  Widget bodyWidget(){
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: double.maxFinite,
                height: Get.height-(Get.height*0.25-(Get.width*0.15/2)),
                decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius:  BorderRadius.only(topLeft: Radius.circular(Get.width*0.25/2),topRight:  Radius.circular(Get.width*0.25/2),)
                ),
                child: Column(
                  children: [
                    controllerPanel(),
                    Expanded(child: videoListPanel())

                  ],
                ),

              ),
            ],
          ),
        ),
        Positioned(
            top: Get.height*0.25-(Get.width*0.15),
            child: GestureDetector(
              onTap: (){
                Get.find<PlayerController>().playPlaylist(playlist.videoList);
              },
              child: Container(
                width: Get.width*0.15,
                height: Get.width*0.15,
                decoration:const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor
                ),
                child:const Icon(Iconsax.play5,color: Colors.white,),
              ),
            ))
      ],
    );
  }
  
  Widget controllerPanel(){
    PlayerController playerController = Get.find();
    return Padding(
      padding:const  EdgeInsets.only(left: 25,right: 25,top: 25,bottom: 25),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
                onTap: (){
                  bool isShuffle = playerController.player.shuffleModeEnabled;
                  playerController.player.setShuffleModeEnabled(isShuffle?false:true);
                },
                child: StreamBuilder<bool>(
                  stream: playerController.player.shuffleModeEnabledStream,
                  builder: (context,shapShot) {
                    bool isShuffel = shapShot.data??false;
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isShuffel?AppColors.primaryColor:Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color:isShuffel?AppColors.primaryColor: Colors.white)
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Iconsax.shuffle,color: Colors.white,),
                          const SizedBox(width: 10,),
                          Text('Shuffle',style: AppConstants.textStyleMedium,),
                        ],
                      ),
                    );
                  }
                ),
              )
          ),
          SizedBox(width: Get.width*0.15+30,),
          Expanded(
              child: GestureDetector(
                onTap: (){
                    showAddSongSheet();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.add,color: Colors.white,),
                      const SizedBox(width: 5,),
                      Text('Add Song',style: AppConstants.textStyleMedium,),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget eachVideo(YoutubeVideo video){
     return GetBuilder<PlayerController>(
      builder:(playerController)=> StreamBuilder<PlayerState>(
          stream: playerController.player.playerStateStream,
          builder: (context,snapShot) {
            return GestureDetector(
              onTap: (){
                if(playerController.currentVideo?.id!=video.id) {
                  playerController.play(video, isNetwork: false);
                }else{
                  Get.to(const PlayerControllerPage(),transition: Transition.downToUp,duration:const Duration(milliseconds: 500));
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
                            image: DecorationImage(image: CachedNetworkImageProvider(video.thumbnails.high??''),fit: BoxFit.cover)
                        ),
                        child: playerController.currentVideo !=null && playerController.currentVideo!.id ==video.id && (snapShot.data!.processingState!=ProcessingState.completed)?
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
                              const CupertinoActivityIndicator(color: AppColors.primaryColor,) :
                              Lottie.asset('assets/lottie/wave.json',)
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
                                style: AppConstants.textStyleMedium.copyWith(color: playerController.currentVideo!=null && playerController.currentVideo!.id==video.id && snapShot.data!.processingState!=ProcessingState.completed?AppColors.primaryColor:Colors.white),
                                maxLines: 1,overflow: TextOverflow.ellipsis,),
                              Text(video.channelTitle.replaceFirst('VEVO','')??'',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),)

                            ],),
                        )),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Widget videoListPanel(){
    return ValueListenableBuilder<Box<Playlist>>(
            valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(keys:[playlist.name]),
            builder:(context,box,widget) {
              Playlist? currentPlaylist = box.get(playlist.name);
              List<YoutubeVideo> videoList = currentPlaylist!.videoList;
              return ListView.builder(
                padding: EdgeInsets.zero,
                  itemCount: videoList.length,
                  itemBuilder: (context, index) => eachVideo(videoList[index])
              );
            }
    );
  }

  showAddSongSheet(){
    TextEditingController txtSearch = TextEditingController();
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
        ),
        builder: (ctx){
          return SizedBox(
              width: Get.width,
              height: Get.height*0.9,
              child: GetBuilder<LibraryController>(
                builder:(libraryController)=> Container(
                  padding:const EdgeInsets.symmetric(horizontal: 25,),
                  decoration:const BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15,),
                      Center(
                        child: Container(
                          width: Get.width*0.15,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(2.5)
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text('Add new',style: AppConstants.textStyleTitleMedium,),
                      const SizedBox(height: 15,),
                      TextField(
                        controller: txtSearch,
                        decoration: InputDecoration(
                          contentPadding:const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                          hintText: 'Search',
                          hintStyle: AppConstants.textStyleMedium.copyWith(color: Colors.grey,fontWeight: FontWeight.normal),
                          fillColor: AppColors.colorTextField,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide:const BorderSide(color:AppColors.colorTextField)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide:const BorderSide(color:AppColors.colorTextField)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide:const BorderSide(color:AppColors.colorTextField)),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Expanded(
                          child:ValueListenableBuilder<Box<Playlist>>(
                              valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(keys: ['Saved Songs']),
                              builder: (context,box,widget){
                                List<YoutubeVideo> allSongs = [];
                                Playlist? playlist = box.get('Saved Songs');
                                if(playlist!=null){
                                 allSongs = playlist.videoList;
                                }
                                return CupertinoScrollbar(
                                  child: ListView.builder(
                                      itemCount: allSongs.length,
                                      itemBuilder: (context,index){
                                        YoutubeVideo currentVideo = allSongs[index];
                                        return ListTile(
                                          onTap: (){
                                            if(libraryController.selectedVideos.contains(currentVideo)){
                                              libraryController.selectedVideos.remove(currentVideo);
                                            }else {
                                              libraryController.selectedVideos.add(currentVideo);
                                            }
                                            libraryController.update();
                                          },
                                          leading: Container(
                                            width: Get.width*0.15,
                                            height: Get.width*0.15,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                image: DecorationImage(image: CachedNetworkImageProvider(currentVideo.thumbnails.high??''),fit: BoxFit.cover)
                                            ),
                                          ),
                                          title: Text(currentVideo.title,style: AppConstants.textStyleMedium.copyWith(color: libraryController.selectedVideos.contains(currentVideo)?AppColors.primaryColor:Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                          subtitle: Text(currentVideo.channelTitle,style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),),
                                          trailing: Icon(Icons.check,color:libraryController.selectedVideos.contains(currentVideo)? AppColors.primaryColor:Colors.transparent,)
                                        );
                                      }),
                                );
                              })
                      ),
                      const SizedBox(height: 15,),
                      ElevatedButton(
                          onPressed:libraryController.selectedVideos.isEmpty?null:
                              (){},
                          style: ElevatedButton.styleFrom(
                            minimumSize:const Size(double.maxFinite, 50),
                            disabledBackgroundColor: AppColors.colorTextField,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            )
                          ),
                          child: Text('Add',style: AppConstants.textStyleTitleSmall,)),
                      const SizedBox(height: 25,),
                    ],
                  ),
            ),
              ),
          );
        });
  }

}
