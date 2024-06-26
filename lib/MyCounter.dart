import 'package:flutter/cupertino.dart';

import 'UserInfo.dart';

class MyCounter with ChangeNotifier {
  UserInfo _userInfo = UserInfo("leo", 10);
  UserInfo get userInfo => _userInfo;

  void add() {
    _userInfo.age++;
    notifyListeners();
  }
}