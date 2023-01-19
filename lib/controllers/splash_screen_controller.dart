import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uplayer/models/splash_data.dart';

class SplashScreenController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    animationController = AnimationController(vsync: this,duration:const Duration(milliseconds: 1300));
    animationController.forward();
  }

  PageController pageController = PageController();
  int currentPageIndex = 0;
  List<SplashData> dataList = [
    SplashData(id: 0,
        title: 'Thousand of\nbest tracks and\npodcasts',
        image: 'assets/images/splash1.png'),
    SplashData(id: 1,
        title: 'Find your\nfavorite music\nand Enjoy!',
        image: 'assets/images/splash2.png'),
    SplashData(id: 2,
        title: 'Ready to enjoy\nmusic for you?\nLet’s Listen ...',
        image: 'assets/images/splash3.png'),
  ];


  onPageChange(index) {
    // print(index);
    // currentPageIndex = index;
    // update();
  }

  onClickNext(){
    if(currentPageIndex< dataList.length-1) {
      currentPageIndex = currentPageIndex+1;
      update();
      animationController.reset();
      animationController.forward();

      pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut);
    }
  }



}