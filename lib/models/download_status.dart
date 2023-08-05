import 'package:hive/hive.dart';

part 'download_status.g.dart';

@HiveType(typeId: 5)
enum DownloadStatus{
  @HiveField(0)
  enqueue,
  @HiveField(1)
  downloading,
  @HiveField(2)
  complete,
  @HiveField(3)
  fail,
 @HiveField(4)
  pause}