import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';
import '../player/player_bottom_sheet.dart';

class VideoWidget extends StatelessWidget {
  final YoutubeVideo video;
  final Widget? trailingWidget;
  final bool isOnlineVideo;
  const VideoWidget({super.key,required this.video,this.trailingWidget,this.isOnlineVideo=true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(

      builder: (controller) {
        return  StreamBuilder<PlayerState>(
              stream: controller.player.playerStateStream,
            builder: (context,snapShot) {
              return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 25),
              leading: videoThumbnail(controller,snapShot),
              title: Text(
                video.title,
                style: AppConstants.textStyleMedium.copyWith(color: controller.currentVideo!=null && controller.currentVideo!.id==video.id && snapShot.data!=null && snapShot.data!.processingState!=ProcessingState.completed?AppColors.primaryColor:Colors.white),
                maxLines: 1,overflow: TextOverflow.ellipsis,),

               subtitle: Text(video.channelTitle.replaceFirst('VEVO','')??'',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),),
                trailing: trailingWidget,
                onTap: (){
                  if(controller.currentVideo?.id!=video.id) {
                    controller.playSingle(video,isNetwork: isOnlineVideo);
                  }else{
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context)=>const PlayerBottomSheet());
                  }
                },
        );
            }
          );
      }
    );
  }

  Widget videoThumbnail(PlayerController controller,AsyncSnapshot<PlayerState> snapShot){
    return  Container(
        width: Get.width*0.15,
        height: Get.width*0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: CachedNetworkImageProvider(video.thumbnails.high??''),fit: BoxFit.cover),
        ),
        child: controller.currentVideo !=null && controller.currentVideo!.id == video.id && (snapShot.data?.processingState!=ProcessingState.completed)?
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
              controller.isLoading?
              const CupertinoActivityIndicator(color: AppColors.primaryColor,):
              Lottie.asset('assets/lottie/wave.json',),

            ],
          ),
        )
            :
        Container()
    );
  }
}
