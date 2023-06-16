import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/controllers/library_controller.dart';
import 'package:uplayer/models/playlist.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:uplayer/views/home/library/playlist_screen.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ValueListenableBuilder(
            valueListenable: Hive.box<Playlist>(AppConstants.boxLibrary).listenable(),
            builder:(context,box,widget)=> SliverGrid.builder(
                gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1),
                itemCount: box.length,
                itemBuilder: (context,index)=>eachPlaylist(box.getAt(index)!),
            ),
        )
      ],
    );
  }

  Widget eachPlaylist(Playlist playlist){
    return GestureDetector(
      onTap: (){
        Get.to(PlaylistScreen(playlist: playlist));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(15)),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Iconsax.music,color: AppColors.primaryColor,),
            Text('${playlist.name}-${playlist.videoList.length}')
          ],
        ),
      ),
    );
  }
}
