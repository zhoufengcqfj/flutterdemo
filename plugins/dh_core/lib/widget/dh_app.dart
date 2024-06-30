import 'package:flutter/widgets.dart';

/// @Author 90196
/// @DateTime 2021/5/28 16:28
/// @Description: 包裹在APP里的最外层控件，用于重启APP。
class DHApp extends StatefulWidget {
  final Widget child;

  DHApp({Key? key, required this.child}) : super(key: key);

  @override
  _DHAppState createState() => _DHAppState();

  static restart(BuildContext context) {
    context.findAncestorStateOfType<_DHAppState>()!.restartApp();
  }

  static Key getAppKey(BuildContext context) {
    return context.findAncestorStateOfType<_DHAppState>()!.key;
  }

}

class _DHAppState extends State<DHApp> {
  /// key 用于app启动标识，如果key改变，说明app已经重启，需要更新数据。
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      print("restart");
      _key = UniqueKey();
    });
  }

  get key => _key;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
