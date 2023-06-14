import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/services/youtube_service.dart';
import 'package:uplayer/utils/log/super_print.dart';

class SearchPageController extends GetxController with GetSingleTickerProviderStateMixin{
  //Search
  TextEditingController txtSearch = TextEditingController();
  GlobalKey cancelBtnKey = GlobalKey();
  double cancelBtnWidth = 0.0;
  FocusNode nodeTxtSearch = FocusNode();
  late AnimationController animation;
  ScrollController scrollController = ScrollController();
  bool isPined = false;


  List<YoutubeVideo> videoResult = [];
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

      if(scrollController.position.pixels>=scrollController.position.maxScrollExtent){
        superPrint('Load more');
        await loadMore();
      }
    });
  }

  search(String query) async{
    isSearching = true;
    update();


    videoResult = await YoutubeServices.search(query);


    isSearching=false;
    update();
  }

  loadMore() async{
    isLoadMore = true;
    update();

    List<YoutubeVideo> moreVideoList = await YoutubeServices.search(txtSearch.text,isLoadMore: true);
    videoResult.addAll(moreVideoList);

    isLoadMore=false;
    update();
  }




}