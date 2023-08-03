import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../controllers/player_controller.dart';
import '../../models/position_data.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerController controller = Get.find();
    final positionStream = controller.player.positionStream;
    final durationStream = controller.player.durationStream;
    final bufferedPositionStream = controller.player.bufferedPositionStream;

    final combinedStream = CombineLatestStream(
      [positionStream, bufferedPositionStream,durationStream],
          (List<Duration?> values) {
        final position = values[0];
        final bufferedPosition = values[1];
        final durationStream = values[2]??Duration.zero;
        return PositionData(position!,  bufferedPosition!,durationStream);
      },
    );
    return StreamBuilder<PositionData>(
        stream: combinedStream,
        builder:(context,snapShot) {
          final PositionData? playerData = snapShot.data;
          final Duration total = getTotalDuration(controller,playerData);
          final Duration progress = getProgressDuration(controller,playerData,total);
          final Duration buffered = getBufferDuration(controller, playerData,total);
          return ProgressBar(
            progress: progress,
            total: total,
            buffered: buffered,
            progressBarColor: AppColors.primaryColor,
            bufferedBarColor: AppColors.primaryColor.withOpacity(0.5),
            baseBarColor: Colors.grey,
            thumbColor: AppColors.primaryColor,
            timeLabelTextStyle: AppConstants.textStyleSmall.copyWith(color: Colors.grey),
            onSeek: (duration){
              controller.player.seek(duration,index: controller.player.currentIndex);
            },
          );
        }
    );
  }
  Duration getTotalDuration(PlayerController controller ,PositionData? playerData){
    if(Platform.isIOS && controller.isOnlinePlaying) {
      return playerData != null ? Duration(milliseconds: playerData.duration.inMilliseconds ~/ 2) :
      Duration.zero;
    }else{
      return playerData != null ? playerData.duration : Duration.zero;
    }
  }

  Duration getProgressDuration(PlayerController controller,PositionData? playerData,Duration total){
    if(Platform.isIOS && controller.isOnlinePlaying){
      return playerData!=null? playerData.position>total?total:playerData.position: Duration.zero;
    }else{
      return playerData!=null? playerData.position: Duration.zero;
    }
  }

  Duration getBufferDuration(PlayerController controller,PositionData? playerData,Duration total) {
    if (Platform.isIOS && controller.isOnlinePlaying) {
      return playerData != null ? playerData.bufferedPosition > total
          ? total
          : playerData.bufferedPosition : Duration.zero;
    } else {
      return playerData != null ? playerData.bufferedPosition : Duration.zero;
    }
  }

}
