import 'package:get/get.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:youtube_api/youtube_api.dart';

class HomeController extends GetxController{
  static String key = 'YOUR_API_KEY';
  YoutubeAPI ytApi = YoutubeAPI(AppConstant.youTubeApiKey);
  List<YouTubeVideo> videoResult = [];




  Future<void> searchVideo(String query) async{
    videoResult = await ytApi.search(query);
    update();
  }
}