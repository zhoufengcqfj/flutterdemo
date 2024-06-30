import 'package:dh_core/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// 通用加载弹框
/// LoadingDialog.
class LoadingDialog extends Dialog {
  Color? bgColor;
  Color? textColor;
  String? text = '';
  double width = 100;
  double height = 100;
  double fontSize = 14;
  bool showText = true;

  LoadingDialog(
      {Key? key,
      this.fontSize = 14.0,
      this.textColor = Colors.white,
      this.bgColor = const Color(0x50000000),
      this.height = 100,
      this.width = 100,
      this.showText = true,
      this.text = '正在加载...'});

  @override
  Widget build(BuildContext context) {
    double padding = 10;
    var animSize = showText
        ? this.width - this.fontSize * 2 - padding * 2
        : this.width - padding * 2;
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new Container(
          decoration: new ShapeDecoration(
              color: bgColor,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.all(new Radius.circular(10)))),
          width: this.width,
          height: this.height,
          padding: EdgeInsets.all(padding),
          child: new Column(children: <Widget>[
            // CircularProgressIndicator(),
            SizedBox(
              width: animSize,
              height: animSize,
              child: Lottie.asset(Assets.json.commonLoadingLottie,
                  repeat: true, fit: BoxFit.contain),
            ),
            Offstage(
              offstage: !showText,
              child: new Text(
                this.text ?? '',
                style:
                    TextStyle(fontSize: this.fontSize, color: this.textColor),
                softWrap: false,
              ),
            )
          ], mainAxisAlignment: MainAxisAlignment.spaceEvenly),
        ),
      ),
    );
  }
}
