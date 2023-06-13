import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uplayer/models/position_data.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../../controllers/player_controller.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../utils/constants/app_color.dart';
import '../global_ui/animate_background.dart';
import '../global_ui/global_widgets.dart';
import '../global_ui/super_scaffold.dart';
import 'package:marquee/marquee.dart';

class PlayerControllerPage extends StatelessWidget {
  const PlayerControllerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
      isTopSafe: false,
      isBotSafe:Platform.isAndroid?true:false,
      botColor: Colors.black,
      backgroundColor: Colors.black,
      child: bodyWidget(),
    );
  }

  Widget bodyWidget(){
    return GestureDetector(
      onHorizontalDragStart: (_){
        Get.back();
      },
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            const AnimateBackground(),
            childWidget(),
          ],
        ),
      ),
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
                        style:AppConstants.textStyleTitleSmall
                    )
                ),
                const SizedBox(width: 15,),
                const Icon(Icons.favorite_outline_outlined,color: Colors.white,)
              ],
            )
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
          progressBar(),
          const SizedBox(height: 25,),
          playControllPanel(),
        ],
      ),
    );
  }

  Widget progressBar(){
    PlayerController controller = Get.find();
    final positionStream = controller.player.positionStream;
    final durationStream = controller.player.durationStream;
    final bufferedPositionStream = controller.player.bufferedPositionStream;

    final combinedStream = CombineLatestStream(
      [positionStream, bufferedPositionStream,durationStream],
          (List<Duration?> values) {
        final position = values[0];
        final bufferedPosition = values[1];
        final durationStream = values[2]??Duration.zero;
        return PositionData(position!,  bufferedPosition!,durationStream);
      },
    );
    return StreamBuilder<PositionData>(
        stream: combinedStream,
        builder:(context,snapShot) {
          final playerData = snapShot.data as PositionData;
          return ProgressBar(
              progress: playerData.position,
              total: playerData.duration,
              buffered: playerData.bufferedPosition,
              progressBarColor: AppColors.primaryColor,
              bufferedBarColor: AppColors.primaryColor.withOpacity(0.5),
              baseBarColor: Colors.grey,
              thumbColor: AppColors.primaryColor,
              timeLabelTextStyle: AppConstants.textStyleSmall.copyWith(color: Colors.grey),
              onSeek: (duration){
                controller.player.seek(duration);
              },
          );
        }
      );
  }

  Widget playControllPanel(){
    PlayerController playerController = Get.find();
    return StreamBuilder<PlayerState>(
      stream: playerController.player.playerStateStream,
      builder: (context, snapshot) {
        PlayerState playerState = snapshot.data as PlayerState;
        return Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: (){
                    playerController.seek(true);
                  },
                  child:const Icon(Iconsax.previous5,color: Colors.white,size: 35,)),
              const SizedBox(width: 40,),
              GestureDetector(
                  onTap: (){
                    playerController.togglePlayPause();
                  },
                  child: CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(playerState.playing? Iconsax.pause5: Iconsax.play5 ,color: Colors.white,))),
              const SizedBox(width: 40,),
              GestureDetector(
                  onTap: (){
                    playerController.seek(false);
                  },
                  child:const Icon(Iconsax.next5,color: Colors.white,size: 35,))
            ],
          )
        );
      }
    );
  }

}
