import 'package:flutter/foundation.dart';

void superPrint(var content, {String title = 'Super Print'}) {
  String callerFrame = '';

  if (kDebugMode) {
    try {
      final stackTrace = StackTrace.current;
      final frames = stackTrace.toString().split("\n");
      callerFrame = frames[1];
    } catch (e) {
      print(e);
    }

    DateTime dateTime = DateTime.now();
    String dateTimeString =
        '${dateTime.hour} : ${dateTime.minute} : ${dateTime.second}.${dateTime.millisecond}';
    print('');
    print('- $title - ${callerFrame.split('(').last.replaceAll(')', '')}');
    print('____________________________');
    print(content);
    print('____________________________ $dateTimeString');
  }
}