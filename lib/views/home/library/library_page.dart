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
import 'package:uplayer/views/home/library/downloaded_playlist_screen.dart';
import 'package:uplayer/views/home/library/playlist_screen.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

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
        onTap: () async{
          Get.to(const DownloadedPlaylistScreen());
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

  Widget playlistPanel(){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Playlist',style: AppConstants.textStyleTitleMedium,),
          ValueListenableBuilder<Box<Playlist>>(
            valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(),
            builder:(context,box,_)=>
                Expanded(
                    child: GridView.builder(
                        shrinkWrap: true,
                        padding:  EdgeInsets.only(top: 25,bottom: AppConstants.navBarHeight+25),
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1/1.35,mainAxisSpacing: 25,crossAxisSpacing: 25),
                        itemCount: box.values.length+1,
                        itemBuilder: (context,index)=>
                            index!=box.values.length?
                                eachPlaylist(box.getAt(index)!):
                                createPlaylist()
                    )
                )
          )
        ],
    ),
      );
  }



  Widget eachPlaylist(Playlist playlist) {
    YoutubeVideo firstVideo =  Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).get(playlist.videoList.first)!;
    return GestureDetector(
      onTap: (){
        Get.to(PlaylistScreen(playlist: playlist));
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
                          image:CachedNetworkImageProvider(firstVideo.thumbnails.high),
                          fit: BoxFit.cover):
                      const DecorationImage(image: AssetImage('assets/images/place_holder.png'))
                  ),
                ),
            ),
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

  Widget createPlaylist(){
    return GestureDetector(
        onTap: showCreatePlaylistDialog,
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(Iconsax.add_circle,color: Colors.grey.withOpacity(0.5),size: 60,),
                ),
              ),
              const SizedBox(height: 10,),
              Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Create Playlist',style: AppConstants.textStyleMedium,))
              )
            ],
          ),
        )
    );
  }


  showCreatePlaylistDialog(){

   String playlistName = '';
   List<String> selectedVideosID = [];

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
        context: Get.context!,
        isScrollControlled: true,
        builder: (context){
          return StatefulBuilder(
            builder: (context,setUpdate) {
              return Container(
                      height: Get.height*0.85,
                      padding: const EdgeInsets.only(top: 25,right: 25,left: 25),
                      decoration: const BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius:BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create Playlist',style: AppConstants.textStyleTitleMedium.copyWith(color: Colors.white),),
                          const SizedBox(height: 25,),
                          TextField(
                            onChanged: (newValue){
                              setUpdate((){
                                playlistName=newValue;
                              });

                            },
                            style: AppConstants.textStyleMedium.copyWith(color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.2),
                              hintText: 'Playlist Name',
                              hintStyle: AppConstants.textStyleMedium.copyWith(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.transparent)
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.transparent)
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          ValueListenableBuilder<Box<YoutubeVideo>>(
                              valueListenable: Hive.box<YoutubeVideo>(AppConstants.boxDownloadedVideo).listenable(),
                              builder: (context,box,_){
                                return Expanded(
                                        child: ListView.builder(
                                            itemCount: box.values.length,
                                            itemBuilder: (context,index){
                                              YoutubeVideo video = box.getAt(index)!;
                                              return ListTile(
                                                onTap: (){
                                                  setUpdate((){
                                                    if(selectedVideosID.contains(video.id)){
                                                      selectedVideosID.remove(video.id);
                                                    }else{
                                                      selectedVideosID.add(video.id);
                                                    }
                                                  });
                                                },
                                                leading: Container(
                                                  width: Get.width*0.15,
                                                  height: Get.width*0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    image: DecorationImage(image: CachedNetworkImageProvider(video.thumbnails.high))
                                                  ),
                                                ),
                                                title: Text(
                                                  video.title,
                                                  style: AppConstants.textStyleMedium.copyWith(color:Colors.white),
                                                  maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                subtitle: Text(video.channelTitle.replaceFirst('VEVO','')??'',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),),
                                                trailing: selectedVideosID.contains(video.id)?
                                                const Icon(Icons.check,color: AppColors.primaryColor,):null,
                                              );
                                            }
                                        )

                                );
                              }),
                          const SizedBox(height: 15,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                              ),
                              backgroundColor: AppColors.primaryColor,
                              disabledBackgroundColor: Colors.grey.withOpacity(0.2),
                              minimumSize: const Size(double.infinity, 60)
                            ),
                              onPressed:playlistName.isNotEmpty && selectedVideosID.isNotEmpty?
                                  ()async{
                                      await Get.find<LibraryController>().createNewPlaylist(Playlist(name: playlistName, videoList: selectedVideosID));
                                  }:null,
                              child: Text('Create',style: AppConstants.textStyleTitleMedium.copyWith(color: Colors.white),)),

                          const SizedBox(height: 25,),
                        ],
                      ),
              );
            }
          );
        });
  }



}
