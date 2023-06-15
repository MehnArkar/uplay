import 'package:hive_flutter/hive_flutter.dart';
import 'package:uplayer/models/user_data.dart';
import 'package:uplayer/utils/constants/app_constant.dart';

class LocalService{
  static Future<void> registerHiveAdapter() async{
    Hive.registerAdapter(UserDataAdapter());
  }

  ///Open initial hive box
  static Future<void> openInitialBox() async{
    await Hive.openBox<UserData>(AppConstants.boxUserData);
  }
}