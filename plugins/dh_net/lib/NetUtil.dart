import 'dart:io';

// import 'package:wifi/wifi.dart';

class NetUtil {

  static Future<String> get getIp async {
    return Future.value("0.0.0.0");//await Wifi.ip;
  }

  static Future<String> get getMac async {
    return Future.value("aa:aa:aa:aa:aa");//await Wifi.ssid;
  }
}