import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///统一 toast
class ToastUtil {
  static void showToast(String content) {
    Fluttertoast.showToast(
        msg: content,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black38,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
