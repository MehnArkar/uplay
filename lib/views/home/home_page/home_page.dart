import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/home_page_controller.dart';
import 'package:uplayer/views/global_ui/animate_background.dart';
import 'package:uplayer/views/global_ui/app_icon.dart';
import 'package:youtube_api/youtube_api.dart';

import '../../global_ui/global_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    HomePageController c = Get.find();
    c.searchVideo('Justin Bieber');
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
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentVideo.title,style: TextStyle(color: Colors.white),),
                        Image.network(currentVideo.thumbnail.medium.url!,width: Get.width*0.15,),
                        Text(currentVideo.description??'',style: TextStyle(color: Colors.white),),
                        Divider(color: Colors.white,)
                      ],
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
