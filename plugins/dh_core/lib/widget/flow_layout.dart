import 'package:flutter/material.dart';

class FlowLayout extends StatefulWidget {
  List<String>? list; //数据源
  Color? unSelectedColor; //初始背景色
  Color? selectColor; //选中时背景色
  OnItemClickListener? listener;
  Color? unSelectedBorderSlideColor; //未选中时边框色值
  Color? selectedBorderSlideColor; //选中时边框色值
  int? maxSelectSize; //最多选择的个数
  double? borderRadius; //边框圆角
  double? textSize; //字体大小
  Color? selectedTextColor; //选中时字体色值
  Color? unSelectTextColor; //未选中时字体色值
  double? marge; //间距

  FlowLayout(
      {@required this.list,
      this.unSelectedColor,
      this.selectColor,
      this.unSelectedBorderSlideColor,
      this.selectedBorderSlideColor,
      this.maxSelectSize,
      this.borderRadius,
      this.textSize,
      this.selectedTextColor,
      this.unSelectTextColor,
      this.marge,
      this.listener});

  @override
  FlowLayoutState createState() => FlowLayoutState(
      list: list,
      unSelectedColor: unSelectedColor,
      selectColor: selectColor,
      unSelectedBorderSlideColor: unSelectedBorderSlideColor,
      selectedBorderSlideColor: selectedBorderSlideColor,
      maxSelectSize: maxSelectSize,
      borderRadius: borderRadius,
      listener: listener);
}

class FlowLayoutState extends State<FlowLayout> {
  List<String>? list;
  Color? unSelectedColor;
  Color? selectColor;
  Color? unSelectedBorderSlideColor;
  Color? selectedBorderSlideColor;
  int? maxSelectSize;
  double? borderRadius;
  double? textSize;
  Color? selectedTextColor;
  Color? unSelectTextColor;
  double? marge;

  OnItemClickListener? listener;
  List<String> selectList = <String>[];
  List<int> selectIndexList = <int>[];

  FlowLayoutState(
      {@required this.list,
      this.unSelectedColor,
      this.selectColor,
      this.unSelectedBorderSlideColor,
      this.selectedBorderSlideColor,
      this.maxSelectSize,
      this.borderRadius,
      this.textSize,
      this.selectedTextColor,
      this.unSelectTextColor,
      this.marge,
      this.listener});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal, //主轴的方向
      spacing: marge ?? 5, // 主轴方向的间距

      children: _buildListWidget(list!, maxSelectSize!),
    );
  }

  List<Widget> _buildListWidget(List<String> list, int maxSize) {
    var listWidget = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      if (selectIndexList.length > 0) {
        if (selectIndexList.contains(i)) {
          listWidget.add(_buildSingleText(list[i], i, true, maxSize));
        } else {
          listWidget.add(_buildSingleText(list[i], i, false, maxSize));
        }
      } else {
        listWidget.add(_buildSingleText(list[i], i, false, maxSize));
      }
    }

    return listWidget;
  }

  Widget _buildSingleText(String item, int index, bool select, int maxSize) {
    var _maxSelectSize = maxSize;
    var text;
    if (select) {
      text = _buildSpecialWidget(item);
    } else {
      text = _buildNormalWidget(item);
    }

    return GestureDetector(
      child: text,
      onTap: () {
        var set = new Set();

        set.addAll(selectList);

        if (_maxSelectSize == set.toList().cast().length) {
          if (!selectIndexList.contains(index)) {
            return;
          } else {
            setSelectData(index, select);
          }
        } else {
          setSelectData(index, select);
        }
      },
    );
  }

  setSelectData(int index, bool select) {
    setState(() {
      if (select) {
        selectList.remove(list![index]);
        selectIndexList.remove(index);
        listener!.onItemClick(selectList);
      } else {
        selectList.add(list![index]);
        selectIndexList.add(index);
        listener!.onItemClick(selectList);
      }
    });
  }

  /*点击时widget*/
  Widget _buildSpecialWidget(String desc) {
    return Chip(
      label: Text(
        desc,
        style: TextStyle(
            color: selectedTextColor ?? Color(0xff343a40),
            fontSize: textSize ?? 14),
      ),
      backgroundColor: selectColor ?? Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          side: BorderSide(
              color: selectedBorderSlideColor ?? Colors.yellow, width: 1)),
    );
  }

/*未点击时widget*/
  Widget _buildNormalWidget(String desc) {
    return Chip(
      label: Text(desc,
          style: TextStyle(
              color: selectedTextColor ?? Color(0xff343a40),
              fontSize: textSize ?? 14)),
      backgroundColor: unSelectedColor ?? Color(0xFFD6D6D6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          side: BorderSide(
              color: unSelectedBorderSlideColor ?? Colors.transparent,
              width: 1)),
    );
  }
}

// abstract class
abstract class OnItemClickListener {
  onItemClick(List<String> list);
}
