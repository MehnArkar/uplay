import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/controllers/library_controller.dart';
import 'package:uplayer/models/playlist.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/global_widgets.dart';
import 'package:uplayer/views/home/library/playlist_screen.dart';
import '../../global_ui/app_icon.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topPadding(),
        appBarPanel(),
        Expanded(
            child: playlistPanel()
        )
      ],
    );
  }

  Widget playlistPanel(){
    return ValueListenableBuilder(
      valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(),
      builder:(context,box,widget)=> GridView.builder(
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1/1.3,crossAxisSpacing: 25,mainAxisSpacing: 25),
        itemCount: box.length,
        padding: EdgeInsets.only(left: 25,right: 25,top: 25,bottom: 25+AppConstants.navBarHeight),
        itemBuilder: (context,index)=>eachPlaylist(box.getAt(index)!),
      ),
    );
  }



  Widget eachPlaylist(Playlist playlist){
    YoutubeVideo? coverVideo;
    if(playlist.videoList.isNotEmpty) {
      Random random = Random();
      int randomInt = random.nextInt(playlist.videoList.length);
      coverVideo = playlist.videoList[randomInt];
    }
    return GestureDetector(
      onTap: (){
        Get.to(PlaylistScreen(playlist: playlist,coverVideo: coverVideo,));
      },
      onLongPress:(){
        Get.find<LibraryController>().deletePlaylist(playlist.name);
      },
      child: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image:playlist.videoList.isNotEmpty?
                      DecorationImage(
                          image:CachedNetworkImageProvider(playlist.videoList.isNotEmpty?coverVideo!.thumbnails.high:'',),
                          fit: BoxFit.cover):
                      const DecorationImage(image: AssetImage('assets/images/place_holder.png'))
                  ),
                ),
            ),
            const SizedBox(height: 10,),
            Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playlist.name,style: AppConstants.textStyleMedium,),
                      Text('${playlist.videoList.length} songs',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),)
                    ],
                  ),
                )
            )
          ],
        ),
      )
    );
  }

  Widget appBarPanel(){
    return  Stack(
      children: [
        Container(
          width: double.maxFinite,
          padding:  const EdgeInsets.symmetric(vertical: 15),
          child:const  Center(child: AppIconWidget(),),
        ),
        Positioned(
            top: 0,
            bottom: 0,
            right: 25,
            child: IconButton(
                onPressed: () {
                  showCreatePlaylistDialog();
                },
                icon: const Icon(Iconsax.add_circle,color: Colors.grey,)))
      ],
    );
  }

  showCreatePlaylistDialog(){
    TextEditingController txtPlaylistName = TextEditingController();
    showDialog(
        context: Get.context!,
        builder: (context){
          return Dialog(
            insetPadding:const EdgeInsets.symmetric(horizontal: 25),
            backgroundColor: AppColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create Playlist',style: AppConstants.textStyleTitleMedium,),
                    const SizedBox(height: 15,),
                    TextField(
                      controller: txtPlaylistName,
                      style: AppConstants.textStyleMedium,
                      decoration: InputDecoration(
                        contentPadding:const EdgeInsets.only(left: 15,right: 15,bottom: 10),
                        hintText: 'Playlist Name',
                        hintStyle: AppConstants.textStyleMedium.copyWith(color: Colors.grey,fontWeight: FontWeight.normal),
                        fillColor: AppColors.colorTextField,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide:const BorderSide(color:AppColors.colorTextField)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide:const BorderSide(color:AppColors.colorTextField)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100),borderSide:const BorderSide(color:AppColors.colorTextField)),
                      ),
                    ),
                    const SizedBox(height: 25,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.maxFinite, 50),
                          maximumSize: const Size(double.maxFinite, 50),
                          elevation: 1,
                          backgroundColor: AppColors.primaryColor,
                          disabledBackgroundColor: AppColors.colorTextField,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        onPressed:(){
                          Get.find<LibraryController>().createNewPlaylist(txtPlaylistName.text.trim());
                        },
                        child: Center(
                          child: Text('Create',style: AppConstants.textStyleMedium,),
                        ))
                  ],
                )
              )
          );
        });
  }



}
