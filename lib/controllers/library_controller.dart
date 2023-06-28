import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/dialog.dart';
import '../models/playlist.dart';

class LibraryController extends GetxController{

  List<YoutubeVideo> selectedVideos = [];

  addNewToPlaylist(String playlistKey,List<YoutubeVideo> video){
    Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
    if(libraryBox.containsKey(playlistKey)){
        Playlist playlist = libraryBox.get(playlistKey)!;
        playlist.videoList.addAll(video);
        libraryBox.put(playlistKey, playlist);
    }else{
      libraryBox.put(playlistKey, Playlist(name: playlistKey, videoList: video));
    }
  }

  createNewPlaylist(String playlistName) {
    if (playlistName.isNotEmpty) {
      Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
      Playlist newPlaylist = Playlist(name: playlistName, videoList: []);
      if (!libraryBox.containsKey(playlistName)) {
        libraryBox.put(playlistName, newPlaylist);
        Get.back();
      } else {
        showCustomDialog(title: 'Playlist already exist!',
            contextTitle: '$playlistName already exist in the library.');
      }
    }else{
      Get.back();
    }
  }

  deletePlaylist(String playlistName){
    Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
    libraryBox.delete(playlistName);
  }

}