import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/controllers/home_controller.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/home/search_page.dart';
import 'package:uplayer/views/home/home_page.dart';
import 'package:uplayer/views/home/playlist_page.dart';
import 'package:uplayer/views/home/download_page.dart';
import '../global_ui/animate_background.dart';
import '../player/mini_player_controll.dart';

class HomeMainPage extends StatelessWidget {
   HomeMainPage({Key? key}) : super(key: key);

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return SuperScaffold(
        isTopSafe: false,
        isBotSafe:Platform.isAndroid?true:false,
        botColor: Colors.black,
        backgroundColor: Colors.black,
        isResizeToAvoidBottomInset: false,
        child:bodyWidget());
  }

  Widget bodyWidget(){
    return Stack(
      alignment: Alignment.center,
      children: [
        const AnimateBackground(),
        shownPage(),
        Align(
          alignment: Alignment.bottomCenter,
            child: navBar()),
        Positioned(
            left: 15,
            right: 15,
            bottom: AppConstants.navBarHeight,
            child: const MiniPlayerControll())
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
     case NavBar.playlist:
       return const PlaylistPage();
     case NavBar.download:
       return const SearchPage();
     case NavBar.profile:
       return const DownloadPage();
   }
  }

  Widget navBar(){
   return ClipRRect(
     child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            height:AppConstants.navBarHeight,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: Platform.isIOS?15:0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                eachNavItem(icon: Iconsax.home,title: 'Home',navBar:NavBar.home),
                eachNavItem(icon: Iconsax.music_square,title: 'Playlist',navBar:NavBar.playlist),
                eachNavItem(icon: Iconsax.search_normal,title: 'Search',navBar:NavBar.download),
                eachNavItem(icon: Iconsax.arrow_down_2,title: 'Download',navBar:NavBar.profile),
              ],
            ),
          ),
        ],
      ),
   );
  }

  Widget eachNavItem({required IconData icon,required String title,required NavBar navBar}){
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
                  Icon(icon,color: controller.currentNavBar==navBar?AppColors.primaryColor:Colors.white,)
                  // SvgPicture.asset(icon,width: Get.height*0.03,height:  Get.height*0.03,color: controller.currentNavBar==navBar?AppColors.primaryColor:Colors.white,),
                ],
              ),
              const SizedBox(height: 3,),
              Text(title,style: AppConstants.textStyleSmall.copyWith(color: controller.currentNavBar==navBar?AppColors.primaryColor:Colors.white),)

            ],
          ),
        ),
      ),
    );
  }
}
