import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constant.dart';

class AppIconWidget extends StatelessWidget {
  const AppIconWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(AppConstants.appIcon,width: 25,height: 25,),
        const SizedBox(width: 5),
        const Text('UPlay',style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 25),),
      ],
    );
  }
}
