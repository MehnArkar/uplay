import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/home_controller.dart';
import 'package:uplayer/views/global_ui/super_scaffold.dart';

class HomeMainPage extends StatelessWidget {
   HomeMainPage({Key? key}) : super(key: key);

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return SuperScaffold(
        child: Column(
          children: [
            searchBar(),
            Expanded(child: videoList())
          ],
        ));
  }

  Widget searchBar(){
    return GetBuilder<HomeController>(
      builder:(controller) =>Container(
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
          width: Get.width,
        child: Row(
          children: [
            Expanded(child: TextField(
              controller: txtSearch,
            )),
            const SizedBox(width: 25,),
            MaterialButton(
              color: Colors.black,
                child:const Text('Search',style: TextStyle(color: Colors.white),),
                onPressed: (){
              controller.searchVideo(txtSearch.text.trim());
            })
          ],
        ),
      ),
    );
  }

  Widget videoList(){
    return GetBuilder<HomeController>(
        builder:(controller)=>controller.videoResult.isEmpty?Container():
            ListView(
              children: controller.videoResult.map((e) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(child: Text(controller.videoResult[1].url),),
                  Image.network(controller.videoResult[1].thumbnail.medium.url??'')
                ],
              )).toList(),
            )
    );
  }
}
