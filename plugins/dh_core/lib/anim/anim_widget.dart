
import 'package:flutter/widgets.dart';

/// @Author 90196
/// @DateTime 2021/5/14 14:01
/// @Description: 动画相关
class WidgetTransitionY extends StatelessWidget {

  WidgetTransitionY({required this.child, required this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => Container(child: Center(
    child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          transform: Matrix4.translationValues(0, animation.value, 0),
          child: child,
        ),
        child: child),
  ),);
}
