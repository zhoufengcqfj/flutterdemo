import 'package:dh_core/utils/toast_util.dart';
import 'package:dh_core/widget/loading_dialog.dart';
import 'package:flutter/material.dart';

/// @Author 90196
/// @DateTime 2021/7/16 15:16
/// @Description: 通用State，包含基础控件使用
abstract class DHState<T extends StatefulWidget> extends State<T> {

  //辅助类
  late UiHelper uiHelper;

  @override
  void initState() {
    super.initState();
    uiHelper = new UiHelper(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    uiHelper.onDispose();
  }
}

/// Ui辅助功能
class UiHelper {

  ///判断语言
  bool isLanguageCode(String lang) {
    return Localizations.localeOf(context).languageCode == lang;
  }
  BuildContext context;

  UiHelper({required this.context});

  BuildContext? _dialogContext;

  /// 解决异步创建视图情况，马上dismiss但是无法dismiss的问题
  bool _showingDialog = false;
  bool _dismissDialog = false;

  void showProgressDialog({String text = ""}) {
    dismissProgressDialog();
    _showingDialog = true;
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          _dialogContext = context;
          if (_dismissDialog) {
            dismissProgressDialog();
          }
          return new WillPopScope(
            onWillPop: () async => true,
            child: LoadingDialog(
              showText: text.isNotEmpty,
              text: text,
            ),
          );
        }).then((value) {
      _showingDialog = false;
      return value;
    });
  }

  void dismissProgressDialog() {
    if (_dialogContext != null) {
      _dismissDialog = false;
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
    } else {
      if (_showingDialog) {
        _dismissDialog = true;
      }
    }
  }

  void onDispose() {
    dismissProgressDialog();
  }

  /// toast信息
  void showToast(String info) {
    ToastUtil.showToast(info);
  }
}