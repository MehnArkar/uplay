import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uplayer/views/global_ui/progress_bar.dart';
import '../../controllers/player_controller.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';
import '../global_ui/animate_background.dart';
import '../global_ui/global_widgets.dart';

class PlayerBottomSheet extends StatelessWidget {
  const PlayerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light
        )
    );
    return Material(
      color: Colors.black,
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: bodyWidget(),
      ),
    );



  }

  Widget bodyWidget(){
    return Stack(
      children: [
        const AnimateBackground(),
        childWidget(),
      ],
    );
  }

  Widget childWidget(){
    return Column(
      children: [
        topPadding(),
        topPannel(),
        const Spacer(),
        videoDetails(),
        const Spacer(),
        controllerPanel(),
        const Spacer(),
        if(Platform.isIOS)
          botPadding()

      ],
    );
  }

  Widget topPannel(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Container(
              padding:const EdgeInsets.all(0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.5),width: 1.5)
              ),
              child:const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.grey,),
            ),
          ),
          Text('Now Playing',style: AppConstants.textStyleTitleMedium,),
          const Icon(Icons.more_vert_rounded,color: Colors.grey,)
        ],
      ),
    );
  }

  Widget videoDetails(){
    return GetBuilder<PlayerController>(
      builder:(controller)=> Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image: CachedNetworkImageProvider(controller.currentVideo?.thumbnails.high??''),fit: BoxFit.cover)
                  ),
                ),
              ),
              const SizedBox(height: 25,),
              Row(
                children: [
                  Expanded(
                      child: Text(controller.currentVideo!.title,
                        style:AppConstants.textStyleTitleSmall,
                        maxLines: 1,
                      )
                  ),
                  const SizedBox(width: 15,),
                  const Icon(Icons.favorite_outline_outlined,color: Colors.white,)
                ],
              ),
              const SizedBox(height: 10,),
              Text(controller.currentVideo!.channelTitle,
                style: AppConstants.textStyleMedium.copyWith(color: Colors.grey),)
            ]),
      ),
    );
  }

  Widget controllerPanel(){
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AudioProgressBar(),
          const SizedBox(height: 25,),
          playControllPanel(),
        ],
      ),
    );
  }

  Widget playControllPanel(){
    PlayerController playerController = Get.find();
    return StreamBuilder<PlayerState>(
        stream: playerController.player.playerStateStream,
        builder: (context, snapshot) {
          final PlayerState? playerState = snapshot.data;

          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: playerController.player.hasPrevious?
                      (){
                    playerController.player.seekToPrevious();
                  }:null,
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  icon:const Icon(Iconsax.previous5,size: 35,)),
              const SizedBox(width: 40,),
              GestureDetector(
                  onTap: (){
                    playerController.togglePlayPause();
                  },
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.primaryColor,
                            child: Icon(playerState!=null? playerState.playing? Iconsax.pause5: Iconsax.play5 :Iconsax.pause,color: Colors.white,)),
                        if(playerController.isLoading)
                        const SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator())
                      ],
                    ),
                  )),
              const SizedBox(width: 40,),
              IconButton(
                  onPressed: playerController.player.hasNext?
                      (){
                    // playerController.player.seek(Duration(seconds: playerController.player.position.inSeconds+15),index: playerController.player.currentIndex);
                    playerController.player.seekToNext();
                  }:null,
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  icon:const Icon(Iconsax.next5,size: 35,)),
            ],
          );
        }
    );
  }

}
