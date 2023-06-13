import 'package:get/get.dart';

enum NavBar{home,playlist,download,profile}

class HomeController extends GetxController{
  NavBar currentNavBar = NavBar.home;


  onClickNavBar(NavBar navBar){
    currentNavBar=navBar;
    update();
  }





}