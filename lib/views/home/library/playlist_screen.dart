import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/controllers/library_controller.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/utils/log/snap_bar.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/global_ui/video_widget.dart';
import '../../../controllers/player_controller.dart';
import '../../../models/playlist.dart';
import '../../../utils/constants/app_color.dart';

class PlaylistScreen extends StatelessWidget {
  final Playlist playlist;
  const PlaylistScreen({Key? key,required this.playlist}) : super(key: key);

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
    );
  }

  Widget topPanel(){
    YoutubeVideo coverVideo = Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).get(playlist.videoList.first)!;
    return ClipRRect(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.maxFinite,
            height: Get.height*0.25,
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(image: CachedNetworkImageProvider(coverVideo.thumbnails.high),fit: BoxFit.cover),
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
                                  onTap: () async{
                                    await Future.delayed(const Duration(milliseconds: 100));
                                    showAddSongSheet();
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Iconsax.music,color: Colors.white,size: 20,),
                                      const SizedBox(width: 10,),
                                      Text('Add new',style: AppConstants.textStyleMedium.copyWith(color: Colors.white),),
                                    ],
                                  )),
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
                                  )),
                            ];
                          })
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
                    borderRadius:  BorderRadius.only(topRight:  Radius.circular(Get.width*0.25/2),)
                ),
                child: Column(
                  children: [
                    SizedBox(height: Get.width*0.15/2+16,),
                    Expanded(child: videoListPanel())

                  ],
                ),

              ),
            ],
          ),
        ),
        Positioned(
            top: Get.height*0.25-(Get.width*0.15),
            left: 25,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                      Playlist currentPlaylist = Hive.box<Playlist>(AppConstants.boxLibrary).get(playlist.name)!;
                      List<YoutubeVideo> videoList = [];
                      for(int i=0;i<currentPlaylist.videoList.length;i++){
                        YoutubeVideo? video = Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).get(currentPlaylist.videoList[i]);
                        if(video!=null){
                          videoList.add(video);
                        }
                      }
                      Get.find<PlayerController>().playMulti(videoList);
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
                ),
                const SizedBox(width: 25,),
                GetBuilder<PlayerController>(
                  builder:(playerController)=> GestureDetector(
                    onTap: (){
                      bool isShuffle = playerController.player.shuffleModeEnabled;
                      playerController.player.setShuffleModeEnabled(isShuffle?false:true);
                    },
                    child: StreamBuilder<bool>(
                        stream: playerController.player.shuffleModeEnabledStream,
                        builder: (context,shapShot) {
                          bool isShuffel = shapShot.data??false;
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
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
                  ),
                )
              ],
            ))
      ],
    );
  }



  Widget videoListPanel(){
    return ValueListenableBuilder<Box<Playlist>>(
            valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(keys:[playlist.name]),
            builder:(context,box,widget) {
              Playlist currentPlaylist = box.get(playlist.name)!;
              return ListView.builder(
                padding: EdgeInsets.zero,
                  itemCount: currentPlaylist.videoList.length,
                  itemBuilder: (context, index){
                  YoutubeVideo? video = Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).get(currentPlaylist.videoList[index]);
                  return video==null?Container():VideoWidget(video:video,isOnlineVideo: false,);
                }
              );
            }
    );
  }


  showAddSongSheet(){
    TextEditingController txtSearch = TextEditingController();
    List<YoutubeVideo> allVideo = Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).values.toList();
    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.red,
        shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
        ),
        builder: (ctx){
          return SizedBox(
            width: Get.width,
            height: Get.height*0.9,
              child:  Container(
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
                              valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(),
                              builder: (context,box,widget){
                                List<String> currenIdList = box.get(playlist.name)!.videoList;
                                return CupertinoScrollbar(
                                  child: ListView.builder(
                                      itemCount: allVideo.length,
                                      itemBuilder: (context,index){
                                        YoutubeVideo currentVideo = allVideo[index];
                                        return ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            width: Get.width*0.15,
                                            height: Get.width*0.15,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                image: DecorationImage(image: CachedNetworkImageProvider(currentVideo.thumbnails.high??''),fit: BoxFit.cover)
                                            ),
                                          ),
                                          title: Text(currentVideo.title,style: AppConstants.textStyleMedium.copyWith(color: currenIdList.contains(currentVideo.id)?AppColors.primaryColor:Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                          subtitle: Text(currentVideo.channelTitle,style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),),
                                          trailing: Icon(Icons.check,color:currenIdList.contains(currentVideo.id)? AppColors.primaryColor:Colors.transparent,)
                                        );
                                      }),
                                );
                              })
                      ),
                      const SizedBox(height: 15,),
                      ElevatedButton(
                          onPressed: (){},
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

          );
        });
  }

}
