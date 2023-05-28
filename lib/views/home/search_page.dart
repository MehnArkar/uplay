import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uplayer/controllers/player_controller.dart';
import 'package:uplayer/controllers/search_page_controller.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/constants/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Get.put(SearchPageController());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      SearchPageController controller = Get.find();
      RenderBox renderBox = controller.cancelBtnKey.currentContext!.findRenderObject() as RenderBox;
      controller.cancelBtnWidth = renderBox.size.width;
      controller.update();
    });
    return SafeArea(
      child: CustomScrollView(
        controller: Get.find<SearchPageController>().scrollController,
        slivers: [
          SliverPersistentHeader(delegate: SearchTitleHeader()),
          // SliverPersistentHeader(pinned: true, delegate: SearchBarHeader())
          GetBuilder<SearchPageController>(
            builder:(controller)=> SliverAppBar(
              foregroundColor: Colors.transparent,
              backgroundColor:Colors.transparent,
              leading: Container(),
              elevation: 0,
              flexibleSpace: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:const EdgeInsets.symmetric(horizontal: 25),
                  color:  Colors.transparent,
                  child:searchBarWidget()),
              pinned: true,

            ),
          ),
          GetBuilder<SearchPageController>(
              builder:(controller)=>
                  controller.isSearching?
                      const SliverFillRemaining(
                        child: Center(child: CupertinoActivityIndicator(color: AppColors.primaryColor,),),
                      ):
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) => eachResultList(controller.videoResult[index]),
                              childCount:controller.videoResult.length,)
                      )
          ),
          GetBuilder<SearchPageController>(
              builder:(controller)=> SliverPadding(padding: EdgeInsets.only(bottom:controller.isSearching?0 :AppConstants.navBarHeight)))
        ],
      ),
    );
  }

  Widget searchBarWidget(){
    return GetBuilder<SearchPageController>(
        builder:(controller)=> AnimatedBuilder(
            animation: controller.animation,
            builder: (context,child){
              return Stack(
                alignment: Alignment.centerRight,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CupertinoSearchTextField(
                          focusNode: controller.nodeTxtSearch,
                          style:const TextStyle(color: Colors.white),
                          onSubmitted: (searchText) async{
                              await controller.search(searchText);
                          },
                        ),
                      ),
                      SizedBox(
                      width: controller.cancelBtnWidth*controller.animation.value,
                      )
                    ],
                  ),
                  Positioned(
                    right:-(controller.cancelBtnWidth- (controller.cancelBtnWidth*controller.animation.value)),
                    child: Opacity(
                      opacity: controller.animation.value,
                      child: CupertinoButton(
                        key: controller.cancelBtnKey,
                        padding:const EdgeInsets.only(left: 15),
                        onPressed: (){
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                        child:const Text('Cancel',style: TextStyle(color: AppColors.primaryColor),),
                      ),
                    ),
                  )
                ],
              );
            })
    );
  }

  Widget eachResultList(YouTubeVideo video){
    return GetBuilder<PlayerController>(
      builder:(playerController)=> GestureDetector(
        onTap: (){
          playerController.play(video);
        },
        child: Container(
          padding:const EdgeInsets.symmetric(horizontal: 25),
          margin:const EdgeInsets.only(bottom: 15),
          color: Colors.transparent,
          child: Row(
            children: [
              Container(
                width: Get.width*0.15,
                height: Get.width*0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: CachedNetworkImageProvider(video.thumbnail.high.url??''),fit: BoxFit.cover)
                ),
                child: playerController.currentVideo !=null && playerController.currentVideo!.id ==video.id?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: Center(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 1.0,
                                      sigmaY: 1.0,
                                    ),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.25),
                                    ),
                                  ),
                                ),
                              ),
                              if(playerController.isLoading)
                                const CupertinoActivityIndicator(color: AppColors.primaryColor,)
                            ],
                          ),
                        )
                       :
                      Container()
              ),
              const SizedBox(width: 15,),
              Expanded(
                  child: SizedBox(
                    height: Get.width*0.15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: AppConstants.textStyleMedium.copyWith(color: playerController.currentVideo!=null && playerController.currentVideo!.id==video.id?AppColors.primaryColor:Colors.white),
                          maxLines: 1,overflow: TextOverflow.ellipsis,),
                        Text(video.duration??'',style: AppConstants.textStyleSmall.copyWith(color: Colors.grey),)

              ],),
                  )),
              const SizedBox(width: 15,),
              const Icon(Iconsax.arrow_down_2,color: Colors.grey,)
            ],
          ),
        ),
      ),
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

