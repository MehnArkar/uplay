import 'package:get/get.dart';
import 'package:youtube_api/youtube_api.dart';

import '../utils/constants/app_constant.dart';

class HomePageController extends GetxController{
  static String key = 'YOUR_API_KEY';
  YoutubeAPI ytApi = YoutubeAPI(AppConstant.youTubeApiKey);
  List<YouTubeVideo> videoResult = [];




  Future<void> searchVideo(String query) async{
    videoResult = await ytApi.search(query,type: 'video', );
    update();
  }
  
  Future<void> popularInthisRegion() async{
    videoResult = await ytApi.getTrends(regionCode: 'MM104');
    update();
  }
}