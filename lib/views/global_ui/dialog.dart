import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/utils/constants/app_color.dart';

showCustomDialog({required String title,required String contextTitle,String submitText='Ok', String cancleText='Cancel',VoidCallback? onClickedSubmit,VoidCallback? onClickCancel,}){
  if(Platform.isIOS){
    showDialog(context: Get.context!, builder: (context){
      return CupertinoAlertDialog(
        title: Text(title.tr,style:const TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
        content: Text(contextTitle.tr,style:const TextStyle(color: Colors.black,),),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child:  Text(cancleText.tr),
            onPressed: () {
              if(onClickCancel!=null){
                onClickCancel();
              }else{
                Get.back();
              }
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child:  Text(submitText.tr),
            onPressed: () {
              if(onClickedSubmit!=null){
                onClickedSubmit();
              }else{
                Get.back();
              }
            },
          ),
        ],
      );
    });
  }else{
    showDialog(context: Get.context!, builder: (context){
      return AlertDialog(
        title: Text(title.tr,style:const TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 18),),
        content: Text(contextTitle.tr,style:const TextStyle(color: Colors.black,),),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child:  Text(cancleText.tr),
            onPressed: () {
              if(onClickCancel!=null){
                onClickCancel();
              }else{
                Get.back();
              }
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child:  Text(submitText.tr),
            onPressed: () {
              if(onClickedSubmit!=null){
                onClickedSubmit();
              }else{
                Get.back();
              }
            },
          ),
        ],
      );
    });
  }
}


showLoadingDialog(){
  showGeneralDialog(
      context: Get.context!,
      barrierDismissible: false,
      pageBuilder: (BuildContext buildContext,
          Animation animation,
          Animation secondaryAnimation){
        return Container(
          width: Get.width,
          height: Get.height,
          color: Colors.black.withOpacity(0.1),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 20.0,
                          sigmaY: 20.0,
                        ),
                        child: Container(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:const EdgeInsets.all(20),
                    child:const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}