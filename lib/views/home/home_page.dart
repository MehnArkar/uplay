import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/home_page_controller.dart';
import 'package:uplayer/views/global_ui/app_icon.dart';
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
        appBarPanel(),
        Expanded(child: imageBannerPanel()),
      ],
    );
  }

  Widget appBarPanel(){
    return const Padding(
      padding:  EdgeInsets.symmetric(vertical: 15),
      child:  Center(child: AppIconWidget(),),
    );
  }

  Widget imageBannerPanel(){
    return Container();
  }
}
