import 'dart:io';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/log/super_print.dart';
import 'package:uplayer/views/global_ui/dialog.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class PlayerController extends GetxController{

  @override
  void onInit() {
    super.onInit();

    player.sequenceStateStream.listen((data) {
      if(data?.currentSource!=null){
        MediaItem? item = data?.currentSource?.tag as MediaItem;
        currentVideo = YoutubeVideo(id: item.id, title: item.title, description: '', thumbnails: Thumbnails(normal: item.artUri.toString(), medium: item.artUri.toString(), high: item.artUri.toString()), url: '', channelId: '', channelTitle: item.artist??'');
        update();
      }
    });

    player.positionStream.listen((duration) {
      if(Platform.isIOS && isOnlinePlaying){
        if(player.duration!=null && duration>=Duration(milliseconds: player.duration!.inMilliseconds~/2)){
          if(player.hasNext){
            player.seekToNext();
          }else{
            player.pause();
          }
        }
      }
    });

  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();

  }

  AudioPlayer player = AudioPlayer();
  final youtubeExplode = YoutubeExplode();
  YoutubeVideo? currentVideo;
  List<YoutubeVideo> playlistVideo = [];
  bool isLoading = false;
  bool isOnlinePlaying = false;
  bool isSinglePlaying = true;




  playSingle(YoutubeVideo video,{bool isNetwork = true}) async {
    isLoading = true;
    currentVideo = video;
    update();

    if(player.playing){
      player.stop();
    }
    //Update data

    isOnlinePlaying = isNetwork;
    if(isNetwork) {
      String audioUrl = await getUrl(video);
      superPrint(audioUrl);

      AudioSource source = AudioSource.uri(
        Uri.parse(audioUrl.toString()),
        tag: MediaItem(
          id: video.id ?? '0',
          title: video.title,
          artist: video.channelTitle,
          artUri: Uri.parse(video.thumbnails.high ?? ''),
        ),
      );
      await player.setAudioSource(source);
    }else{
      Directory dir = await getApplicationDocumentsDirectory();
      String audioUrl ='${dir.path}/${video.id}.mp3';
      superPrint(audioUrl);

      AudioSource source = AudioSource.file(
          audioUrl,
          tag: MediaItem(
            id: video.id??'0',
            title: video.title,
            artist: video.channelTitle,
            artUri: Uri.parse(video.thumbnails.high??''),
          ),
      );

      await player.setAudioSource(source);
    }

    //Loading finish
    isLoading= false;
    update();

    //Play
    player.play();

  }

  playMulti(List<YoutubeVideo> videoList,{bool isShuffle=false}) async{

    showLoadingDialog();

    isOnlinePlaying=false;

    Directory dir = await getApplicationDocumentsDirectory();
    List<AudioSource> audioSourceList = List.generate(videoList.length, (index) {
      YoutubeVideo currentVideo = videoList[index];
      return AudioSource.asset(
        '${dir.path}/${currentVideo.id}.mp3',
        tag: MediaItem(
          id: currentVideo.id??'0',
          title: currentVideo.title,
          artist: currentVideo.channelTitle,
          artUri: Uri.parse(currentVideo.thumbnails.high??''),
        ),
      );
    }).toList();

    AudioSource source = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder:DefaultShuffleOrder(),
        children: audioSourceList
    );

    await player.setAudioSource(source,initialIndex: 0,initialPosition: Duration.zero);

    if(player.shuffleModeEnabled){
      player.setShuffleModeEnabled(true);
    }

    Get.back();
    player.play();

  }


  Future<String> getUrl(YoutubeVideo video,[bool isDownloadUrl=false]) async{

    final manifest = await youtubeExplode.videos.streamsClient.getManifest(video.id);
    if(!isDownloadUrl) {
      final audioStreamInfo = manifest.audioOnly.sortByBitrate();
      String audioUrl = '';
      audioUrl = audioStreamInfo.first.url.toString();
      if (Platform.isIOS) {
        final List<AudioStreamInfo> m4aStreams = audioStreamInfo.where((element) {
          return element.audioCodec.contains('mp4');
        }).toList();
        if (m4aStreams.isNotEmpty) {
          audioUrl = m4aStreams.last.url.toString();
        }
      } else {
        audioUrl = audioStreamInfo.first.url.toString();
      }
      return audioUrl;
    }else{
      final audioStreamInfo = manifest.audioOnly.withHighestBitrate();
      return audioStreamInfo.url.toString();
    }
  }


  togglePlayPause(){
    if(player.playing){
      player.pause();
    }else{
      player.play();
    }
  }

}

