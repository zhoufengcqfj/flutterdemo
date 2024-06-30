
export 'utils/dh_encrypt.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class DhCore {

  static final String DIRECTORY_MUSIC = "Music";

  static final String DIRECTORY_PICTURES = "Pictures";

  static final String DIRECTORY_MOVIES = "Movies";

  static final String DIRECTORY_DOWNLOADS = "Download";

  static final String DIRECTORY_DCIM = "DCIM";

  static final String DIRECTORY_DOCUMENTS = "Documents";

  static const MethodChannel _channel =
      const MethodChannel('dh_core');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 获取安卓外部存储目录，Environment.getExternalStorageDirectory()
  static Future<String> getExternalStorageDirectory() async {
    if (!Platform.isAndroid) {
      throw UnsupportedError("Only android supported");
    }
    return await _channel.invokeMethod('getExternalStorageDirectory');
  }

  /// 获取安卓外部存储公有目录Environment.getExternalStoragePublicDirectory(type)
  static Future<String> getExternalStoragePublicDirectory(String type) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError("Only android supported");
    }
    return await _channel
        .invokeMethod('getExternalStoragePublicDirectory', {"type": type});
  }

  static Future<String?> getProxyHost() async {
    return await _channel.invokeMethod('getProxyHost');
  }

  static Future<String?> getProxyPort() async {
    return await _channel.invokeMethod('getProxyPort');
  }

}
