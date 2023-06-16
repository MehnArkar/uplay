import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/utils/log/super_print.dart';
import '../models/playlist.dart';

class LibraryController extends GetxController{

  addNewToPlaylist(String playlistKey,YoutubeVideo video){
    Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
    if(libraryBox.containsKey(playlistKey)){
        Playlist playlist = libraryBox.get(playlistKey)!;
        playlist.videoList.add(video);
        libraryBox.put(playlistKey, playlist);
    }else{
      libraryBox.put(playlistKey, Playlist(name: playlistKey, videoList: [video]));
    }
  }

}