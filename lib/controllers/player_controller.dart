import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayerController extends GetxController{

  @override
  void onInit() {
    super.onInit();
  }


  AudioPlayer player = AudioPlayer();
  final youtubeExplode = YoutubeExplode();
  YouTubeVideo? currentVideo;
  bool isLoading = false;


  play(YouTubeVideo video) async {
    //Stop player if playing another
    if(player.playing){
      player.stop();
    }

    //Update data
    currentVideo = video;
    isLoading = true;
    update();

    //Loadin music to play
    final manifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);
    final audioStreamInfo = manifest.muxed.withHighestBitrate();
    final audioUrl = audioStreamInfo.url;
    print(audioUrl);
    await player.setUrl(audioUrl.toString());

    //Loading finish
    isLoading= false;
    update();

    //Play
    player.play();
  }


  togglePlayPause(){
    if(player.playing){
      player.pause();
    }else{
      player.play();
    }
  }

  seek(bool isPrevious){
    if(isPrevious){
      player.seekToPrevious();
    }else{
      player.seekToNext();
    }
  }

}