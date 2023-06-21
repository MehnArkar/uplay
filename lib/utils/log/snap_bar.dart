import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';

void showSnackBar(String title) {
  final snackBar = SnackBar(
    content: Text(title,style: AppConstants.textStyleSmall.copyWith(fontWeight: FontWeight.w600),),
    duration: const Duration(seconds: 1),
    backgroundColor: AppColors.primaryColor,
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}