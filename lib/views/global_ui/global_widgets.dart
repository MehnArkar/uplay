import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Widget topPadding(){
  return SizedBox(
    height: MediaQuery.of(Get.context!).padding.top,
  );
}

Widget botPadding(){
  return SizedBox(
    height: MediaQuery.of(Get.context!).padding.bottom,
  );
}