import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppConstants {
  //Key
  static const String youTubeApiKey = 'AIzaSyB_0-Q0_Scv_Zx1zZFA98X7iTfWStNywL0';

  //Hive Database
  static const String boxUserData = 'userData';
  static const String boxLibrary = 'library';
  static const String boxDownload = 'download';

  //Icon
  static const String appIcon = 'assets/icons/appIcon.svg';
  static const String homeIcon = 'assets/icons/home.svg';
  static const String playlistIcon = 'assets/icons/playlist.svg';
  static const String downloadIcon = 'assets/icons/download.svg';
  static const String profileIcon = 'assets/icons/profile.svg';
  static const String ellipseIcon = 'assets/icons/ellipse.svg';

  static  double textScaleFactor = 1.0;

  static  TextStyle textStyleSmall = Theme.of(Get.context!).textTheme.bodySmall!;
  static  TextStyle textStyleMedium = Theme.of(Get.context!).textTheme.bodyMedium!;
  static  TextStyle textStyleLarge = Theme.of(Get.context!).textTheme.bodyLarge!;


  static  TextStyle textStyleTitleSmall = Theme.of(Get.context!).textTheme.titleSmall!;
  static  TextStyle textStyleTitleMedium = Theme.of(Get.context!).textTheme.titleMedium!;
  static  TextStyle textStyleTitleLarge = Theme.of(Get.context!).textTheme.titleLarge!;

  //Size
  static double navBarHeight = Platform.isIOS?Get.height*0.08+(MediaQuery.of(Get.context!).padding.bottom) :Get.height*0.08;
  static double topPaddingSize = MediaQuery.of(Get.context!).padding.top;




}