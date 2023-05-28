import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uplayer/controllers/home_page_controller.dart';
import 'package:uplayer/views/global_ui/animate_background.dart';
import 'package:uplayer/views/global_ui/app_icon.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' ;
import '../global_ui/global_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    HomePageController c = Get.find();
    return Column(
      children: [
        topPadding(),
        topPanel(),
        Expanded(child: imageBannerPanel()),
      ],
    );
  }

  Widget topPanel(){
    return const Center(child: AppIconWidget(),);
  }

  Widget imageBannerPanel(){
    return Container();
  }
}
