import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// @Author 90196
/// @DateTime 2021/7/5 9:29
/// @Description: 列表选择器控件
class ListSelectorView extends StatefulWidget {
  //列表数据
  final List<String> itemList;
  final int selectedIndex;
  final double itemHeight;

  //选择回调
  final Function(int)? onSelected;

  //取消选择
  final Function()? onCancel;

  //确认选择
  final Function(int)? onConfirm;

  ListSelectorView(
      {Key? key,
      required this.itemList,
      this.onSelected,
      this.onConfirm,
      this.itemHeight = 40,
      this.selectedIndex = 0,
      this.onCancel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ListSelectorViewState();
  }
}

class ListSelectorViewState extends State<ListSelectorView> {
  int currentIndex = 0;
  late ScrollController controller;

  int getCurrentSelected() {
    return currentIndex;
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.selectedIndex;
    controller = FixedExtentScrollController(initialItem: currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    var title = Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "取消",
            ),
          ),
          onTap: () {
            widget.onCancel?.call();
          },
        ),
        GestureDetector(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "确定",
              style: TextStyle(color: Colors.blue),
            ),
          ),
          onTap: () {
            widget.onConfirm?.call(currentIndex);
          },
        ),
      ]),
    );
    var listView = Stack(
      children: [
        ListWheelScrollView.useDelegate(
          controller: controller,
          physics: FixedExtentScrollPhysics(),
          useMagnifier: true,
          magnification: 1.5,
          diameterRatio: 1.5,
          itemExtent: widget.itemHeight,
          onSelectedItemChanged: (index) {
            this.currentIndex = index;
            widget.onSelected?.call(index);
          },
          childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Align(
                  alignment: Alignment.center,
                  child: Text(widget.itemList[index]),
                );
              },
              childCount: widget.itemList.length),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: widget.itemHeight,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey))),
          ),
        )
      ],
    );

    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title,
          Container(
            height: 250,
            child: listView,
          )
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        color: Colors.white,
      ),
    );
  }
}
