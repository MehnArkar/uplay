import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/splash_screen_controller.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/app_icon.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';

class MainSplashScreen extends StatelessWidget {
  const MainSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SplashScreenController());
    return
      SuperScaffold(
          isTopSafe: false,
          isBotSafe: false,
          botColor: Colors.black,
          backgroundColor: Colors.black,
          child: bodyWidget());
  }

  Widget bodyWidget(){
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          pageViewPanel(),
          overlayWidget(),
        ],
      ),
    );
  }

  Widget pageViewPanel(){
    return GetBuilder<SplashScreenController>(
      builder:(controller)=> PageView(
        onPageChanged:(index){
          controller.onPageChange(index);
        },
        physics:const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children:controller.dataList.map((e) => Image.asset(e.image,fit: BoxFit.cover,)).toList()
      ),
    );
  }

  Widget overlayWidget(){
    return GetBuilder<SplashScreenController>(
      builder:(controller)=> Container(
        width: Get.width,
        height: Get.height,
        padding:const EdgeInsets.all(25),
        child: Column(
          children: [
            SizedBox(height:MediaQuery.of(Get.context!).padding.top ,),
            const AppIconWidget(),
            const Spacer(),

            AnimatedBuilder(
              animation: controller.animationController,
              builder: (BuildContext context, Widget? child) {
                return Transform.translate(
                  offset: Offset(-((controller.animationController.value*30)-30), 0),
                  child: Opacity(
                    opacity: controller.animationController.value,
                    child: Container(
                        width: double.maxFinite,
                        alignment: Alignment.centerLeft,
                        child: Text(controller.dataList[controller.currentPageIndex].title,style:const TextStyle(fontSize: 35,color: Colors.white,),)),
                  ),
                );
              },

            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                dotIndicator(controller),
                const Spacer(),
                nextCircularBtn(controller)
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget eachSplashScreenPage(String image,String title){
    return Container();
  }

  Widget dotIndicator(SplashScreenController controller){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: controller.dataList.map((e) => AnimatedContainer(
        duration:const Duration(milliseconds: 300),
        width:controller.currentPageIndex==e.id?50: 10,
        height: 10,
        margin:const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color:controller.currentPageIndex==e.id?Colors.red:Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),

      )).toList()
    );
  }

  Widget nextCircularBtn(SplashScreenController controller){
  return  GestureDetector(
      onTap: (){
        controller.onClickNext();
      },
      child: CircleAvatar(
        radius: Get.width*0.075,
        backgroundColor: AppColors.primaryColor,
        child:const RotatedBox(
            quarterTurns: 2,
            child:  Icon(Icons.arrow_back,color: Colors.white,)),
      ),
    );
  }

}
