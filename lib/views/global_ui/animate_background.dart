import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/app_color.dart';

class AnimateBackground extends StatefulWidget {
  const AnimateBackground({Key? key}) : super(key: key);

  @override
  State<AnimateBackground> createState() => _AnimateBackgroundState();
}

class _AnimateBackgroundState extends State<AnimateBackground> {
  double circleSize =  Get.height*0.15;
  Rx<double>  x=0.0.obs,y=0.0.obs;
  double xSpeed = 20, ySpeed = 20, speed = 350;


  @override
  initState() {
    super.initState();
    // update();
  }

  update() {
    Timer.periodic(Duration(milliseconds: speed.toInt()), (timer) {
      double screenWidth =Get.width;
      double screenHeight = Get.height;
      x.value += xSpeed;
      y.value += ySpeed;

      if (x.value + circleSize >= screenWidth) {
        xSpeed = -xSpeed;
        x.value = screenWidth - circleSize;

      } else if (x.value <= 0) {
        xSpeed = -xSpeed;
        x.value = 0;

      }

      if (y.value + circleSize >= screenHeight) {
        ySpeed = -ySpeed;
        y.value = screenHeight - circleSize;
      } else if (y.value <= 0) {
        ySpeed = -ySpeed;
        y.value = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
          ()=> Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: speed.toInt()),
              left: x.value,
              top: y.value,
              child: blurBall()
            ),
            Positioned.fill(child:
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20,sigmaY: 20),
                child: Container(color: Colors.black.withOpacity(0.5),),),
            ))
          ],
        ),
      ),
    );
  }


  Widget blurBall(){
    return Container(
      width:circleSize,
      height:circleSize,
      decoration:const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                spreadRadius: 50,
                blurRadius: 50,
                color:AppColors.primaryColor
            )
          ]
      ),
    );
  }
}