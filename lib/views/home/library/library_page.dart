import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
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
        padding:const EdgeInsets.only(left: 25,right: 25,top: 25),
        itemBuilder: (context,index)=>eachPlaylist(box.getAt(index)!),
      ),
    );
  }



  Widget eachPlaylist(Playlist playlist){
    Random random = Random();
    int randomInt = random.nextInt(playlist.videoList.length);
    YoutubeVideo coverVideo = playlist.videoList[randomInt];
    return GestureDetector(
      onTap: (){
        Get.to(PlaylistScreen(playlist: playlist));
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
                      image: DecorationImage(image: CachedNetworkImageProvider(coverVideo.thumbnails.high),fit: BoxFit.cover)
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
                onPressed: (){
                  showCreatePlaylistSheet();
                },
                icon: const Icon(Iconsax.add_circle,color: Colors.white,)))
      ],
    );
  }

  showCreatePlaylistSheet(){

      showModalBottomSheet(
          context: Get.context!,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape:const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
          ),
          builder: (ctx){
            return
              ClipRRect(
                borderRadius:const BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                child: SizedBox(
                width: Get.width,
                height: Get.height*0.75,
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 20,
                              sigmaY: 20,
                              tileMode: TileMode.repeated
                            ),
                          child: Container(
                            color: Colors.white.withOpacity(0.15),
                          ),
                        )
                    ),
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Playlist',style: AppConstants.textStyleTitleMedium,),
                          const SizedBox(height: 10,),
                          TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              fillColor: Colors.grey,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:const BorderSide(color: Colors.transparent)
                                ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide:const BorderSide(color: AppColors.primaryColor,width: 1.5)
                              ),
                            ),
                          )

                        ],
                      ),
                    )
                  ],
                ),
            ),
              );
          });
  }

}