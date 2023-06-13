import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/views/player/player_controller_page.dart';

import '../../utils/constants/app_constant.dart';

class MiniPlayerControll extends StatelessWidget {
  const MiniPlayerControll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      builder:(controller)=> StreamBuilder<PlayerState>(
        stream: controller.player.playerStateStream,
        builder:(context,snapshot){
          PlayerState playerState = snapshot.data as PlayerState;
          return playerState.processingState==ProcessingState.ready || playerState.processingState==ProcessingState.buffering? ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: GestureDetector(
              onTap: (){
                Get.to(const PlayerControllerPage(),transition: Transition.downToUp);
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                        ),
                        child: Container(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                    child: Row(
                      children: [
                         audioImage(controller) ,
                        const SizedBox(width: 15,),
                        Expanded(child: audioDetails(controller)),
                        const SizedBox(width: 15,),
                        audioController(controller)
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: audioProgress(controller))
                ],
              ),
            ),
          ):Container();
        }
      ),
    );
  }

  Widget audioImage(PlayerController controller){
    return Container(
      width: Get.width*0.13,
      height: Get.width*0.13,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: CachedNetworkImageProvider(controller.currentVideo==null?'':controller.currentVideo!.thumbnails.high),fit: BoxFit.cover)
      ),
    );
  }

  Widget audioDetails(PlayerController controller){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.currentVideo!.title,
          style: AppConstants.textStyleMedium,
          maxLines: 1,overflow: TextOverflow.ellipsis,),
        const SizedBox(height: 10,),
        StreamBuilder<Duration?>(
          stream: controller.player.positionStream,
          builder: (context,snapshot) {
            Duration? duration = snapshot.data;
            String minutes =duration!=null?(duration.inSeconds / 60).floor().toString().padLeft(2, '0'):'00';
            String seconds = duration!=null?(duration.inSeconds % 60).toString().padLeft(2, '0'):'00';
            return Text(
            '$minutes : $seconds',
            style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),);
          }
        )
      ],
    );
  }

  Widget audioController(PlayerController controller,){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
            onTap: (){
              controller.seek(true);
            },
            child:const Icon(Iconsax.previous5,color: Colors.white,)),
        const SizedBox(width: 10,),
        GestureDetector(
            onTap: (){
              controller.togglePlayPause();
            },
            child: Icon(controller.player.playerState.playing? Iconsax.pause5: Iconsax.play5 ,color: Colors.white,)),
        const SizedBox(width: 10,),
        GestureDetector(
            onTap: (){
              controller.seek(false);
            },
            child:const Icon(Iconsax.next5,color: Colors.white,))
      ],
    );
  }

  Widget audioProgress(PlayerController controller) {
    return StreamBuilder<Duration>(
      stream: controller.player.positionStream,
      builder: (context,snackshot) {
        double progress = 0;
        Duration currentDuration = snackshot.data??const Duration(seconds: 0);
        Duration totalDuration =  controller.player.duration??const Duration();
        if(totalDuration.inMilliseconds>0){
          progress = currentDuration.inMilliseconds/totalDuration.inMilliseconds;
        }
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LinearProgressIndicator(
            color: AppColors.primaryColor,
            backgroundColor: Colors.grey,
            value: progress,
        ),
          );
      }
    );
  }
}
