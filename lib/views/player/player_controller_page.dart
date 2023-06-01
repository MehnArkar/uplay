import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../../controllers/player_controller.dart';
import '../global_ui/animate_background.dart';
import '../global_ui/global_widgets.dart';
import '../global_ui/super_scaffold.dart';

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
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Stack(
        children: [
          const AnimateBackground(),
          childWidget(),
        ],
      ),
    );
  }

  Widget childWidget(){
    return Column(
      children: [
        topPadding(),
        topPannel(),
        SizedBox(height: Get.height*0.02,),
        videoDetails(),
        const Spacer(),
        controllerPanel(),
        const Spacer(),

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
                  image: DecorationImage(image: CachedNetworkImageProvider(controller.currentVideo?.thumbnail.high.url??''),fit: BoxFit.cover)
                ),
              ),
            ),
            const SizedBox(height: 25,),
            Text(controller.currentVideo!.title,style:AppConstants.textStyleTitleSmall,)
          ],
    ),
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
        ],
      ),
    );
  }

  Widget progressBar(){
    return Container();
  }
}
