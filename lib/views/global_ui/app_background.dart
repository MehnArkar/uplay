import 'dart:ui';

import 'package:blobs/blobs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uplayer/utils/constants/app_color.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
           Positioned(
                bottom: -Get.width*0.5,
                right: -Get.width,
                child: Blob.animatedRandom(
                    size: Get.width*2,
                    duration:const Duration(milliseconds:1800),
                    edgesCount:5,
                    loop:  true,
                    styles: BlobStyles(
                      color: AppColors.primaryColor
                    ),
                )
            ),

          Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 280,
                  sigmaY: 280
                ),
                child: Container(color: Colors.black.withOpacity(0.6),),
              )
          )
        ],
      ),
    );
  }
}
