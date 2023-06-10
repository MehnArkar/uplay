import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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
    currentVideo = video;
    //Stop player if playing another
    if(player.playing){
      player.stop();
    }
    //Update data

    isLoading = true;
    update();

    String audioUrl = await getUrl(video);

    AudioSource source = AudioSource.uri(
      Uri.parse(audioUrl.toString()),
      tag: MediaItem(
        id: video.id??'0',
        album: '',
        title: video.title,
        artUri: Uri.parse(video.thumbnail.high.url??''),
      ),
    );
    await player.setAudioSource(source);

    //Loading finish
    isLoading= false;
    update();

    //Play
    player.play();
  }

  Future<String> getUrl(YouTubeVideo video) async{
    final manifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);
    final audioStreamInfo = manifest.audioOnly.sortByBitrate();
    String audioUrl = '';

    if (Platform.isIOS) {
      final List<AudioOnlyStreamInfo> m4aStreams = audioStreamInfo.where((element) => element.audioCodec.contains('mp4')).toList();

      if (m4aStreams.isNotEmpty) {
        audioUrl = m4aStreams.first.url.toString();
      }
    }else{
      audioUrl = audioStreamInfo.first.url.toString();
    }
    return audioUrl;
  }


  togglePlayPause(){
    if(player.playing){
      player.pause();
    }else{
      player.play();
    }
  }

  seek(bool isPrevious) {
    Duration currentDuration =  player.position;
    if(isPrevious){
      player.seek(currentDuration-const Duration(seconds: 15));
    }else{
      player.seek(currentDuration+const Duration(seconds: 15));
    }
  }

}

