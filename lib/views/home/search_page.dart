import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uplayer/controllers/search_page_controller.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:flutter/cupertino.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchPageController());
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(delegate: SearchTitleHeader()),
          // SliverPersistentHeader(pinned: true, delegate: SearchBarHeader())
          SliverAppBar(
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: Container(),
            elevation: 0,
            flexibleSpace: Container(
                padding:const EdgeInsets.symmetric(horizontal: 25),
                child:searchBarWidget()),
            pinned: true,

          )
        ],
      ),
    );
  }

  Widget searchBarWidget(){
    return GetBuilder<SearchPageController>(
        builder:(controller)=> GestureDetector(
          onTap: (){
            controller.isSearchBarExpend=!controller.isSearchBarExpend;
            controller.update();

          },
          child: Container(
            width: double.maxFinite,
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 2000),
              width: controller.isSearchBarExpend?Get.width*0.5:double.maxFinite,
              child: CupertinoSearchTextField(
                controller: controller.txtSearch,
                onTap: (){
                  controller.isSearchBarExpend=!controller.isSearchBarExpend;
                  controller.update();
                },
              ),
            ),
          ),
        )
    );
  }

}

class SearchTitleHeader extends SliverPersistentHeaderDelegate{
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.maxFinite,
      padding:const EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.centerLeft,
      child: Text('Search',style: AppConstants.textStyleTitleLarge,),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 60;

  @override
  // TODO: implement minExtent
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

}

