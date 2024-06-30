import 'package:flutter/widgets.dart';

/// @Author 90196
/// @DateTime 2021/5/20 13:40
/// @Description:
class EmptyView extends StatelessWidget {
  final Image image;
  final String info;

  EmptyView({Key? key, required this.image, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.vertical,
      children: [image, Text(info)],
    );
  }
}
