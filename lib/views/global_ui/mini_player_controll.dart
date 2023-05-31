import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/constants/app_constant.dart';

class MiniPlayerControll extends StatelessWidget {
  const MiniPlayerControll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      builder:(controller)=> StreamBuilder<PlayerState>(
        stream: controller.player.playerStateStream,
        builder:(context,snapshot){
          PlayerState playerState = snapshot.data!;
          return playerState.processingState==ProcessingState.ready || playerState.processingState==ProcessingState.buffering? ClipRRect(
            borderRadius: BorderRadius.circular(200),
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
                  padding:const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
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
              ],
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
          image: DecorationImage(image: CachedNetworkImageProvider(controller.currentVideo!.thumbnail.high.url!),fit: BoxFit.cover)
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
            child:const Icon(Iconsax.previous,color: Colors.white,)),
        const SizedBox(width: 10,),
        GestureDetector(
            onTap: (){
              controller.togglePlayPause();
            },
            child: Icon(controller.player.playerState.playing? Iconsax.pause:Iconsax.play,color: Colors.white,)),
        const SizedBox(width: 10,),
        GestureDetector(
            onTap: (){
              controller.seek(false);
            },
            child:const Icon(Iconsax.next,color: Colors.white,))
      ],
    );
  }
}
