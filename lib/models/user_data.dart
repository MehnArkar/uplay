
import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 0,adapterName: 'UserDataAdapter')
class UserData{
  @HiveField(0)
  bool isFirstTime;

  UserData({required this.isFirstTime});
}