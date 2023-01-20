import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/home_controller.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/home/download_page/download_page.dart';
import 'package:uplayer/views/home/home_page/home_page.dart';
import 'package:uplayer/views/home/playlist_page/playlist_page.dart';
import 'package:uplayer/views/home/profile_page/profile_page.dart';

class HomeMainPage extends StatelessWidget {
   HomeMainPage({Key? key}) : super(key: key);

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return SuperScaffold(
      topColor: Colors.black,
      botColor: Colors.black,
      backgroundColor: Colors.black,
        child:bodyWidget());
  }

  Widget bodyWidget(){
    return Stack(
      alignment: Alignment.center,
      children: [
        shownPage(),
        Align(
          alignment: Alignment.bottomCenter,
            child: navBar())
      ],
    );
  }

  Widget shownPage(){
    return GetBuilder<HomeController>(builder: (controller)=>switchPage(controller.currentNavBar));
  }

  Widget switchPage(NavBar navBar){
   switch(navBar){
     case NavBar.home:
       return const HomePage();
       break;
     case NavBar.playlist:
       return const PlaylistPage();
       break;
     case NavBar.download:
       return const DownloadPage();
       break;
     case NavBar.profile:
       return const ProfilePage();
       break;
   };
  }

  Widget navBar(){
    return Container(
      width: double.maxFinite,
      padding:const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          eachNavItem(icon: AppConstant.homeIcon,title: 'Home',navBar:NavBar.home),
          eachNavItem(icon: AppConstant.playlistIcon,title: 'Playlist',navBar:NavBar.playlist),
          eachNavItem(icon: AppConstant.downloadIcon,title: 'Download',navBar:NavBar.download),
          eachNavItem(icon: AppConstant.profileIcon,title: 'Profile',navBar:NavBar.profile),

        ],
      ),
    );
  }

  Widget eachNavItem({required String icon,required String title,required NavBar navBar}){
    return GetBuilder<HomeController>(
      builder:(controller)=> GestureDetector(
        onTap:() {controller.onClickNavBar(navBar);},
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: Get.height*0.022,
                    height: Get.height*0.022,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 10,
                              blurRadius: 10,
                              color:controller.currentNavBar==navBar? AppColors.primaryColor.withOpacity(0.3):Colors.transparent
                          )
                        ]

                    ),
                  ),
                  SvgPicture.asset(icon,width: Get.height*0.03,height:  Get.height*0.03,color: controller.currentNavBar==navBar?AppColors.primaryColor:Colors.white,),
                ],
              ),
              const SizedBox(height: 3,),
              Text(title,style: TextStyle(color:controller.currentNavBar==navBar?AppColors.primaryColor: Colors.white,fontSize: 10),)

            ],
          ),
        ),
      ),
    );
  }
}
