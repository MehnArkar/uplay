import 'dart:math';

import 'package:get/get.dart';
import 'package:uplayer/controllers/player_controller.dart';

import '../utils/constants/app_constant.dart';

class GlobalController extends GetxController{

  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  initLoad(){
    setTextScaleFactor();
    initController();
  }

  initController() {
     Get.put(PlayerController());
  }

  Future<void> setTextScaleFactor() async{
    double sh = 856.7272727272727; // redmi note 11 global
    double sw = 392.72727272727275;
    double sd = sqrt((sw * sw) + (sh * sh));
    double w = Get.width;
    double h = Get.height;
    double d = sqrt((w * w) + (h * h));
    AppConstants.textScaleFactor = d / sd;
  }
}