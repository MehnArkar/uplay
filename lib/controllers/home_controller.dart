import 'package:get/get.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:youtube_api/youtube_api.dart';

enum NavBar{home,playlist,download,profile}

class HomeController extends GetxController{
  NavBar currentNavBar = NavBar.home;


  onClickNavBar(NavBar navBar){
    currentNavBar=navBar;
    update();
  }




  // static String key = 'YOUR_API_KEY';
  // YoutubeAPI ytApi = YoutubeAPI(AppConstant.youTubeApiKey);
  // List<YouTubeVideo> videoResult = [];
  //
  //
  //
  //
  // Future<void> searchVideo(String query) async{
  //   videoResult = await ytApi.search(query);
  //   update();
  // }
}