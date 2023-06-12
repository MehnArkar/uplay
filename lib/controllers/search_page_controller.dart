import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uplayer/models/video.dart';
import 'package:uplayer/services/youtube_service.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../utils/constants/app_constant.dart';

class SearchPageController extends GetxController with GetSingleTickerProviderStateMixin{
  //Search
  TextEditingController txtSearch = TextEditingController();
  GlobalKey cancelBtnKey = GlobalKey();
  double cancelBtnWidth = 0.0;
  FocusNode nodeTxtSearch = FocusNode();
  late AnimationController animation;
  ScrollController scrollController = ScrollController();
  bool isPined = false;

  YoutubeAPI ytApi = YoutubeAPI(AppConstants.youTubeApiKey);
  List<LocalVideo> videoResult = [];
  bool isSearching = false;
  bool isLoadMore = false;




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

    scrollController.addListener(() async {
      if(scrollController.position.pixels>=60){
        isPined=true;
        update();
      }else{
        isPined=false;
        update();
      }

      if(scrollController.position.pixels==scrollController.position.maxScrollExtent){
        await loadMore();
      }
    });
  }

  search(String query) async{
    isSearching = true;
    update();

    List<YouTubeVideo> youtubeVideoList = await ytApi.search(query,type: 'video',videoDuration: 'short',);
    for (var eachVideo in youtubeVideoList) {
      videoResult.add(YoutubeServices.convertToLocal(eachVideo));
    }

    isSearching=false;
    update();
  }

  loadMore() async{
    isLoadMore = true;
    update();

    List<YouTubeVideo> youtubeVideoList = await ytApi.nextPage();
    for (var eachVideo in youtubeVideoList) {
      videoResult.add(YoutubeServices.convertToLocal(eachVideo));
    }

    isLoadMore=false;
    update();
  }




}