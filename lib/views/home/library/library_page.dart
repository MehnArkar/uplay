import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/controllers/library_controller.dart';
import 'package:uplayer/models/playlist.dart';
import 'package:uplayer/models/youtube_video.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/global_ui/global_widgets.dart';
import 'package:uplayer/views/global_ui/video_widget.dart';
import 'package:uplayer/views/home/library/playlist_screen.dart';
import '../../global_ui/app_icon.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topPadding(),
        titlePanel(),
        downloadedSongsPanel(),
        Expanded(child: playlistPanel())
      ],
    );
  }

  Widget titlePanel(){
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.centerLeft,
      child: Text(
        'Library',
        style: AppConstants.textStyleTitleLarge.copyWith(color: Colors.white),
      ),
    );
  }
  
  Widget downloadedSongsPanel(){
    return ValueListenableBuilder<Box<YoutubeVideo>>(
      valueListenable: Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).listenable(),
      builder:(context,box,_) =>InkWell(
        onTap: (){
          Get.to(PlaylistScreen(playlist: Playlist(name: 'Downloaded Songs', videoList: box.values.toList()), coverVideo: box.values.first));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Container(
                  width: Get.width*0.12,
                  height: Get.width*0.12,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: SvgPicture.asset(AppConstants.appIcon,width: 25,height: 25,),
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: SizedBox(
                    height: Get.width*0.12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          Text('Downloaded Songs',style: AppConstants.textStyleMedium,),
                          Text('${box.values.length} Songs',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),)
                    ],),
                  ),
                ),
                const SizedBox(width: 16,),
                const Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 18,)
              ],
            )
          )
        ),
      ),
    );
  }

  Widget allVideoPanel(){
    return ValueListenableBuilder(
        valueListenable: Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).listenable(),
        builder: (context,box,widget)=>ListView.builder(
          itemCount: box.values.length,
          itemBuilder: ( context,index)=>VideoWidget(video: box.getAt(index)!,isOnlineVideo: false,),

        )
    );
  }

  Widget playlistPanel(){
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Playlist',style: AppConstants.textStyleTitleMedium,),
              const SizedBox(width: 16,),
              const Icon(Iconsax.add_circle,color: AppColors.secondaryColor,)
            ],
          ),
          ValueListenableBuilder<Box<Playlist>>(
            valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(),
            builder:(context,box,_)=>
                Expanded(
                child:box.values.isNotEmpty?
                GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 16,childAspectRatio: 1/1.2),
                    itemBuilder: (context,index)=>eachPlaylist(box.getAt(index)!)):
                Center(
                  child: Text('No Playlist',style: AppConstants.textStyleTitleMedium.copyWith(color: Colors.grey),),
                )
            ),
          )
        ],
    ),
      );
  }



  Widget eachPlaylist(Playlist playlist){
    return GestureDetector(
      onTap: (){
        Get.to(PlaylistScreen(playlist: playlist,coverVideo: playlist.videoList.first,));
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
                          image:CachedNetworkImageProvider(playlist.videoList.isNotEmpty?playlist.videoList.first.thumbnails.high:'',),
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
