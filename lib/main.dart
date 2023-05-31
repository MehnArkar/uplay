import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';
import 'package:uplayer/views/splas_screen/main_splash_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'controllers/global_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 1000));
  Get.put(GlobalController());
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
        textTheme:const TextTheme(
          bodySmall:TextStyle(fontSize: 12,color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.white),

          titleSmall: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),
          titleMedium: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.white),
          titleLarge: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.white),
        )
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




