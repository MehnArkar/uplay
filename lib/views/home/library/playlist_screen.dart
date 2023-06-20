import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';

import '../../../controllers/download_controller.dart';
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
        child: ValueListenableBuilder<Box<Playlist>>(
            valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(keys:[playlist.name]),
            builder:(context,box,widget) {
              Playlist? currentPlaylist = box.get(playlist.name);
              List<YoutubeVideo> videoList = currentPlaylist!.videoList;
              return ListView.builder(
                  itemCount: videoList.length,
                  itemBuilder: (context, index) => eachVideo(videoList[index])
              );
            }
    )
    );
  }

  Widget eachVideo(YoutubeVideo video){
     return GetBuilder<PlayerController>(
      builder:(playerController)=> StreamBuilder<PlayerState>(
          stream: playerController.player.playerStateStream,
          builder: (context,snapShot) {
            return GestureDetector(
              onTap: (){
                playerController.play(video,isNetwork: false);
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

}
