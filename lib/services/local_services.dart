import 'package:hive_flutter/hive_flutter.dart';
import 'package:uplayer/models/user_data.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import '../models/playlist.dart';

class LocalService{
  static Future<void> registerHiveAdapter() async{
    Hive.registerAdapter(UserDataAdapter());
    Hive.registerAdapter(YoutubeVideoAdapter());
    Hive.registerAdapter(ThumbnailsAdapter());
    Hive.registerAdapter(PlaylistAdapter());
  }

  ///Open initial hive box
  static Future<void> openInitialBox() async{
    await Hive.openBox<UserData>(AppConstants.boxUserData);
    await Hive.openBox<YoutubeVideo>(AppConstants.boxAllVideos);
    await Hive.openBox<Playlist>(AppConstants.boxLibrary);
  }
}