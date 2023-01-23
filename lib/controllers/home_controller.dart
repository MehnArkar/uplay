import 'package:get/get.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:youtube_api/youtube_api.dart';

enum NavBar{home,playlist,download,profile}

class HomeController extends GetxController{
  NavBar currentNavBar = NavBar.home;


  onClickNavBar(NavBar navBar){
    currentNavBar=navBar;
    update();
  }





}