import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/splas_screen/main_splash_screen.dart';

import 'controllers/global_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Future.delayed(const Duration(milliseconds: 1000));
  Get.put(GlobalController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uplay',
      navigatorObservers: <NavigatorObserver>[routeObserver],
      theme: ThemeData(
        fontFamily: 'SFPro',
        primarySwatch: Colors.blue,
      ),
      home:const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainSplashScreen();
  }
}



