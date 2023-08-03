import 'package:flutter/material.dart';
import 'package:uplayer/utils/constants/app_color.dart';
import 'package:uplayer/utils/log/super_print.dart';

class AnimatedDot extends StatefulWidget {
  const AnimatedDot({Key? key}) : super(key: key);

  @override
  State<AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<AnimatedDot> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  double bounceHeight = 3;
  double dotSize = 5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation1 = Tween<double>(begin: -bounceHeight, end: bounceHeight).animate(
        CurvedAnimation(parent: _controller,
            curve: const Interval(0, 0.6, curve: Curves.easeInOut)));
    _animation2 = Tween<double>(begin: -bounceHeight, end: bounceHeight).animate(
        CurvedAnimation(parent: _controller,
            curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)));
    _animation3 = Tween<double>(begin: -bounceHeight, end: bounceHeight).animate(
        CurvedAnimation(parent: _controller,
            curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)));

    _controller.forward();

    _controller.addListener(() {
      if(_controller.isDismissed){
        _controller.forward();
      }else if(_controller.isCompleted){
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return animatedDots();
  }

  Widget animatedDots(){
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dot(
              position: _animation1.value,
            ),
            SizedBox(
              width: dotSize,
            ),
            dot(
              position: _animation2.value,
            ),
            SizedBox(
              width: dotSize,
            ),
            dot(
              position: _animation3.value,
            ),
          ],
        );
      },
    );
  }

  Widget dot({required double position}){
    return Container(
      height: dotSize,
      width: dotSize,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
      ),
      transform: Matrix4.translationValues(0, -position, 0),
    );
  }
}
