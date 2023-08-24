import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../models/playlist.dart';
import '../views/global_ui/dialog.dart';

class LibraryController extends GetxController{


  addNewToPlaylist(String playlistKey,List<String> selectVideoId){
    Box<Playlist> playlistBox = Hive.box<Playlist>(AppConstants.boxLibrary);
    Playlist newPlaylist = playlistBox.get(playlistKey)!;
    newPlaylist.videoList.addAll(selectVideoId);
    playlistBox.put(playlistKey, newPlaylist);
  }

  deleteVideoFromPlaylist(String playlistKey,String videoId){
    Box<Playlist> playlistBox = Hive.box<Playlist>(AppConstants.boxLibrary);
    Playlist newPlaylist = playlistBox.get(playlistKey)!;
    newPlaylist.videoList.remove(videoId);
    playlistBox.put(playlistKey, newPlaylist);
  }

  createNewPlaylist(Playlist playlist) async{
      Box<Playlist> libraryBox =  Hive.box<Playlist>(AppConstants.boxLibrary);
      if (!libraryBox.containsKey(playlist.name)) {
        await libraryBox.put(playlist.name,playlist);
        Get.back();
      } else {
        showCustomDialog(title: 'Playlist already exist!',
            contextTitle: '${playlist.name} already exist in the library.');
      }
  }

  deletePlaylist(String playlistName){
    Box<Playlist> libraryBox = Hive.box(AppConstants.boxLibrary);
    libraryBox.delete(playlistName);
  }

}