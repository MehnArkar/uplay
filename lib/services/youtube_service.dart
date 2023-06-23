import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uplayer/models/youtube_video.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

String nextPageToken = '';
String prevPageToken = '';

class YoutubeServices{

  ///Search Youtube Videos using Youtube api v3
  // static Future<List<YoutubeVideo>> search(String searchedQuery,{bool isLoadMore=false}) async{
  //   List<YoutubeVideo> result = [];
  //   http.Response? response = await ApiService.getYoutubeVideo(searchedQuery,pageToken: isLoadMore?nextPageToken:null);
  //   if(response!=null){
  //     if(response.statusCode==200){
  //       var data = jsonDecode(response.body);
  //
  //       ///Get page token
  //        nextPageToken = data['nextPageToken']??'noMore';
  //        prevPageToken = data['prevPageToken']??'';
  //
  //        Iterable list = data['items'];
  //        for (var eachVideo in list) {
  //          YoutubeVideo video = YoutubeVideo.fromJson(eachVideo);
  //          result.add(video);
  //        }
  //
  //     }else{
  //       superPrint(response.body);
  //     }
  //   }else{
  //     showCustomDialog(title: 'Error', contextTitle: 'Something went wrong!');
  //   }
  //
  //   return result;
  // }


  ///Search youtube videos using youtube explode dart
  static Future<List<YoutubeVideo>> search(String searchedQuery,{bool isLoadMore=false}) async{
    List<YoutubeVideo> result = [];
    YoutubeExplode yt = YoutubeExplode();
    VideoSearchList list = await yt.search.search(searchedQuery);
    for (var eachVideoSearch in list) {
      YoutubeVideo video = YoutubeVideo(
          id: eachVideoSearch.id.toString(),
          title: eachVideoSearch.title,
          description: eachVideoSearch.description,
          thumbnails: Thumbnails(normal: eachVideoSearch.thumbnails.standardResUrl, medium: eachVideoSearch.thumbnails.mediumResUrl, high: eachVideoSearch.thumbnails.maxResUrl),
          url: eachVideoSearch.url,
          channelId: eachVideoSearch.channelId.toString(),
          channelTitle: eachVideoSearch.author,
      );
      result.add(video);
    }

    return result;
  }



}