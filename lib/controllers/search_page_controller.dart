import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_api/youtube_api.dart';

import '../utils/constants/app_constant.dart';

class SearchPageController extends GetxController with GetSingleTickerProviderStateMixin{
  //Search
  TextEditingController txtSearch = TextEditingController();
  GlobalKey cancelBtnKey = GlobalKey();
  double cancelBtnWidth = 0.0;
  FocusNode nodeTxtSearch = FocusNode();
  late AnimationController animation;

  YoutubeAPI ytApi = YoutubeAPI(AppConstants.youTubeApiKey);
  List<YouTubeVideo> videoResult = [];
  bool isSearching = false;




  @override
  void onInit() {
    super.onInit();
    animation = AnimationController(vsync: this,duration: const Duration(milliseconds: 200));

    nodeTxtSearch.addListener(() {
      if(nodeTxtSearch.hasFocus){
        animation.forward();
      }else{
        animation.reverse();
      }
    });
  }
  search(String query) async{
    isSearching = true;
    update();

    videoResult = await ytApi.search(query,type: 'video',videoDuration: 'short',);

    isSearching=false;
    update();
  }


}