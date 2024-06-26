import 'package:flutter/widgets.dart';

/// @Author 90196
/// @DateTime 2021/5/24 14:22
/// @Description: 数据共享控价
// 一个通用的InheritedWidget，保存任需要跨组件共享的状态
class InheritedProvider<T> extends InheritedWidget {
  InheritedProvider({required this.data, required Widget child, this.onChange})
      : super(child: child);

  //共享状态使用泛型
  final T data;

  /// 返回是否需要更新界面
  final bool Function(T)? onChange;

  @override
  bool updateShouldNotify(InheritedProvider<T> old) {
    //在此简单返回true，则每次更新都会调用依赖其的子孙节点的`didChangeDependencies`。
    return true;
  }
}

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  ChangeNotifierProvider({
    Key? key,
    required this.data,
    required this.child,
    this.onChange
  });

  final Widget child;
  final T data;
  /// 返回是否需要更新界面
  final bool Function(T)? onChange;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static T? of<T>(BuildContext context) {
    final provider =
    context.dependOnInheritedWidgetOfExactType<InheritedProvider<T>>();
    return provider?.data;
  }

  @override
  _ChangeNotifierProviderState<T> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  void update() {
    if (widget.onChange != null) {
      var shouldUpdate = widget.onChange!(widget.data);
      if (shouldUpdate) {
        setState(() => {});
      }
    } else {
      //如果数据发生变化（model类调用了notifyListeners），重新构建InheritedProvider
      setState(() => {});
    }
  }

  @override
  void didUpdateWidget(ChangeNotifierProvider<T> oldWidget) {
    //当Provider更新时，如果新旧数据不"=="，则解绑旧数据监听，同时添加新数据监听
    if (widget.data != oldWidget.data) {
      oldWidget.data.removeListener(update);
      widget.data.addListener(update);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // 给model添加监听器
    widget.data.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    // 移除model的监听器
    widget.data.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<T>(
      data: widget.data,
      child: widget.child,
      onChange: widget.onChange,
    );
  }
}