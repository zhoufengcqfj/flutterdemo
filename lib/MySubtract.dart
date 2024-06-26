
import 'package:flutter/cupertino.dart';

import 'UserInfo.dart';

class MySubtract extends ChangeNotifier {
  UserInfo _userInfo = UserInfo("jim", 100);
  UserInfo get userInfo => _userInfo;

  void sub() {
    _userInfo.age--;
    notifyListeners();
  }
}