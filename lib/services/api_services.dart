import 'package:http/http.dart' as http;
import 'package:uplayer/utils/log/super_print.dart';

import '../utils/constants/app_constant.dart';

class ApiService{

  static Future<http.Response?> getYoutubeVideo(String searchedQuery,{String? pageToken}) async{
    String url;
    if(pageToken!=null){
      url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=15&pageToken=$pageToken&q=${Uri.encodeQueryComponent(searchedQuery)}&key=${AppConstants.youTubeApiKey}';
    }else{
      url = 'https://youtube.googleapis.com/youtube/v3/search?part=snippet&&maxResults=15&q=${Uri.encodeQueryComponent(searchedQuery)}&key=${AppConstants.youTubeApiKey}';
    }

    http.Response? response;
    try{
      response = await http.get(Uri.parse(url));
    }catch(e){
      superPrint('Error in getYoutubeVideo : $e');
    }
    return response;
  }


}