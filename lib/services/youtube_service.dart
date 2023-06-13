import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/services/api_services.dart';
import 'package:uplayer/utils/log/super_print.dart';
import 'package:uplayer/views/global_ui/dialog.dart';

String nextPageToken = '';
String prevPageToken = '';

class YoutubeServices{

  static Future<List<YoutubeVideo>> search(String searchedQuery,{bool isLoadMore=false}) async{
    List<YoutubeVideo> result = [];
    http.Response? response = await ApiService.getYoutubeVideo(searchedQuery,pageToken: isLoadMore?nextPageToken:null);
    if(response!=null){
      if(response.statusCode==200){
        var data = jsonDecode(response.body);

        ///Get page token
         nextPageToken = data['nextPageToken']??'noMore';
         prevPageToken = data['prevPageToken']??'';

         Iterable list = data['items'];
         for (var eachVideo in list) {
           YoutubeVideo video = YoutubeVideo.fromJson(eachVideo);
           result.add(video);
         }

      }
    }else{
      showCustomDialog(title: 'Error', contextTitle: 'Something went wrong!');
    }

    superPrint(result.first.url);
    return result;
  }

}