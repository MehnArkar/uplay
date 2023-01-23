import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/views/global_ui/animate_background.dart';
import 'package:uplayer/views/home/home_main_page.dart';
import 'package:uplayer/views/splas_screen/main_splash_screen.dart';

void main() {
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
      theme: ThemeData(
        fontFamily: 'Poppins',
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
    return  HomeMainPage();
  }
}



