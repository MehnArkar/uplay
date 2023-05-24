import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_api/youtube_api.dart';

import '../utils/constants/app_constant.dart';

class HomePageController extends GetxController{
  static String key = 'YOUR_API_KEY';
  YoutubeAPI ytApi = YoutubeAPI(AppConstants.youTubeApiKey);
  List<YouTubeVideo> videoResult = [];
  AudioPlayer player = AudioPlayer();




  Future<void> searchVideo(String query) async{
    videoResult = await ytApi.search(query,type: 'video',regionCode: 'MM');
    update();
  }
  
  Future<void> popularInthisRegion() async{
    videoResult = await ytApi.getTrends(regionCode: 'MM104');
    update();
  }



}