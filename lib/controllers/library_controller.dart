import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../models/playlist.dart';
import '../views/global_ui/dialog.dart';

class LibraryController extends GetxController{

  TextEditingController txtPlaylistName = TextEditingController();
  List<YoutubeVideo> selectedVideos = [];

  addNewToPlaylist(String playlistKey,List<YoutubeVideo> video){
    // Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
    // if(libraryBox.containsKey(playlistKey)){
    //     Playlist playlist = libraryBox.get(playlistKey)!;
    //     playlist.videoList.addAll(video);
    //     libraryBox.put(playlistKey, playlist);
    // }else{
    //   libraryBox.put(playlistKey, Playlist(name: playlistKey, videoList: video));
    // }
  }

  createNewPlaylist() async{
      Box<Playlist> libraryBox =  Hive.box<Playlist>(AppConstants.boxLibrary);
      Playlist newPlaylist = Playlist(name: txtPlaylistName.text.trim(), videoList: selectedVideos,);
      if (!libraryBox.containsKey(txtPlaylistName.text.trim())) {
        await libraryBox.put(newPlaylist.name, newPlaylist);
        Get.back();
      } else {
        showCustomDialog(title: 'Playlist already exist!',
            contextTitle: '${txtPlaylistName.text.trim()} already exist in the library.');
      }
  }

  deletePlaylist(String playlistName){
    Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
    libraryBox.delete(playlistName);
  }

}