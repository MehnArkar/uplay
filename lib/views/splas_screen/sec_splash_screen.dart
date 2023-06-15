import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:uplayer/views/home/home_main_page.dart';

import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';
import '../global_ui/app_icon.dart';

class SecondarySplashScreen extends StatefulWidget {
  const SecondarySplashScreen({Key? key}) : super(key: key);

  @override
  State<SecondarySplashScreen> createState() => _SecondarySplashScreenState();
}

class _SecondarySplashScreenState extends State<SecondarySplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this,duration:const Duration(milliseconds: 1000));
    animationController.forward();

    onInitLoad();
  }

  onInitLoad() async{
    await Future.delayed(const Duration(milliseconds: 1500));
    Get.offAll(()=>HomeMainPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child:Center(
        child: AnimatedBuilder(
          animation: animationController,
          builder:(context,child)=> Opacity(
              opacity: animationController.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AppConstants.appIcon,width: Get.width*0.2,height:Get.width*0.2,),
                  const SizedBox(width: 35),
                  const Text('UPlay',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 25),),
                ],
              )
          ),
        ),
      ),
    );
  }
}
