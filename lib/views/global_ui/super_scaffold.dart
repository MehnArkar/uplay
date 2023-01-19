

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuperScaffold extends StatelessWidget {
  final Widget child;
  final Color topColor;
  final Color botColor;
  final Color backgroundColor;
  final AppBar? appBar;
  final bool isTopSafe;
  final bool isBotSafe;
  final FloatingActionButton? floatingActionButton;
   SuperScaffold({Key? key,required this.child,this.floatingActionButton, this.topColor = Colors.white,this.botColor = Colors.white,this.backgroundColor=Colors.white,this.appBar,this.isBotSafe=true,this.isTopSafe=true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      body: Column(
        children: [
          if(isTopSafe)
          topPadding(topColor),
          Expanded(child: child),
          if(isBotSafe)
          botPadding(botColor),
        ],
      ),
    );
  }

  Widget topPadding(Color color){
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(Get.context!).padding.top,
      color: color,
    );
  }
}

Widget botPadding(Color color){
  return Container(
    width:double.maxFinite,
    height: MediaQuery.of(Get.context!).padding.bottom,
    color: color,
  );
}
