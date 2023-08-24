import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/models/playlist.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/global_ui/video_widget.dart';
import '../../../controllers/player_controller.dart';
import '../../../utils/constants/app_color.dart';

class DownloadedPlaylistScreen extends StatelessWidget {
  const DownloadedPlaylistScreen({Key? key}) : super(key: key);

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
    return ValueListenableBuilder<Box<YoutubeVideo>>(
      valueListenable: Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).listenable(),
      builder:(context,box,_)=> ClipRRect(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.maxFinite,
              height: Get.height*0.25,
              decoration: BoxDecoration(
                color: Colors.black,
                image:box.values.isNotEmpty?
                    DecorationImage(image: CachedNetworkImageProvider(box.values.first.thumbnails.high),fit: BoxFit.cover):
                    const DecorationImage(image: AssetImage('assets/images/place_holder.png'),fit: BoxFit.cover)
              )
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
                        Expanded(child: Center(child: Text('Downloaded Songs',style:AppConstants.textStyleTitleMedium,)),),
                        const SizedBox(width: 36,)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text('${box.values.length} songs',style: AppConstants.textStyleTitleSmall.copyWith(color: AppColors.primaryColor),)
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  Widget bodyWidget(){
    return ValueListenableBuilder<Box<YoutubeVideo>>(
      valueListenable: Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).listenable(),
      builder:(context,box,_)=> Stack(
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
                      Expanded(child: downloadedSongListPanel()),
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
                      if(box.values.isNotEmpty) {
                        Get.find<PlayerController>().playMulti(box.values.toList());
                      }
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
      ),
    );
  }
  Widget downloadedSongListPanel(){
    return ValueListenableBuilder<Box<YoutubeVideo>>(
        valueListenable: Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).listenable(),
        builder:(context,box,widget) {
          return box.values.isNotEmpty?
          ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                YoutubeVideo video = box.getAt(index)!;
                return Dismissible(
                  key: Key(video.id),
                  onDismissed: (_) {
                    Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).delete(video.id);
                    Box<Playlist> playlistBox = Hive.box<Playlist>(AppConstants.boxLibrary);
                    playlistBox.values.forEach((playlist) {
                      if(playlist.videoList.contains(video.id)){
                        playlist.videoList.remove(video.id);
                        playlistBox.put(playlist.name, playlist);
                      }
                    });
                  },
                  child: VideoWidget(video: video)
              );
              }
          ):
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.music_playlist,size: 60,color: Colors.grey.withOpacity(0.5),),
                const SizedBox(height: 25,),
                Text('No downloaded song',style: AppConstants.textStyleTitleMedium.copyWith(color: Colors.grey.withOpacity(0.5)),)

              ],
            ),
          ) ;
        }
    );
  }

}
