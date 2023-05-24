import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uplayer/controllers/home_page_controller.dart';
import 'package:uplayer/views/global_ui/animate_background.dart';
import 'package:uplayer/views/global_ui/app_icon.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' ;
import '../../global_ui/global_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    HomePageController c = Get.find();
    c.searchVideo('Zig get well soon');
    return Column(
      children: [
        topPadding(),
        topPanel(),
        Expanded(child: imageBannerPanel()),
      ],
    );
  }

  Widget topPanel(){
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/search_icon.svg',width: 25,height: 25,),
          const Spacer(),
          const AppIconWidget(),
          const Spacer(),
          SvgPicture.asset('assets/icons/setting.svg',width: 25,height: 25,),
        ],
      ),
    );
  }

  Widget imageBannerPanel(){
    return GetBuilder<HomePageController>(
        builder:(controller)=> controller.videoResult.isNotEmpty?
            SizedBox(
              child: ListView.builder(
                itemCount: controller.videoResult.length,
                itemBuilder: (BuildContext context, int index) {
                  YouTubeVideo currentVideo = controller.videoResult[index];
                  return GestureDetector(
                    onTap: () async{
                      if(!controller.player.playing) {
                        final youtube = YoutubeExplode();
                        final manifest = await youtube.videos.streamsClient
                            .getManifest(controller.videoResult[index].id);
                        final audioStreamInfo = manifest.audioOnly
                            .withHighestBitrate();
                        final audioUrl = audioStreamInfo.url;

                        print(audioUrl);

                        await controller.player.setUrl(audioUrl.toString());
                        await controller.player.setAsset(audioUrl.toString());
                        controller.player.play();
                      }else{
                        controller.player.stop();
                      }


                    },
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(currentVideo.title,style: TextStyle(color: Colors.white),),
                          Image.network(currentVideo.thumbnail.medium.url!,width: Get.width*0.15,),
                          Text(currentVideo.url??'',style: TextStyle(color: Colors.white),),
                          Divider(color: Colors.white,)
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
            :
        Container()
    );
  }
}
