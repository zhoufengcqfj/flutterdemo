
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// created by 90196 on 2021/04/25
/// KV数据存储封装
class Store {

  static Future<SharedPreferences>? sp;

  static init() async {
    if (sp == null) {
      sp = SharedPreferences.getInstance();
    }
  }

  static Future<int?> getInt(String key) {
    return _get<int>(key);
  }

  static Future<bool?> getBool(String key) {
    return _get<bool>(key);
  }

  static Future<String?> getString(String key) {
    return _get<String>(key);
  }

  static Future<double?> getDouble(String key) {
    return _get<double>(key);
  }

  static Future<List<String>?> getStringList(String key) {
    return _get<List<String>>(key);
  }

  static Future<T?> getObject<T>(String key) {
    return _get<T>(key);
  }

  static void setInt(String key, value) {
    return _set(key, value);
  }

  static void setBool(String key, value) {
    return _set(key, value);
  }

  static void setString(String key, value) {
    return _set(key, value);
  }

  static void setDouble(String key, value) {
    return _set(key, value);
  }

  static void setStringList(String key, value) {
    return _set(key, value);
  }

  static void setObject<T>(String key, value) {
    return _set(key, value);
  }

  /// 数据获取归口处理
  static Future<T?> _get<T>(String key) {
    // 确认初始化完成
    init();
    if (T == int) {
      return sp!.then((value) => value.getInt(key) as T?);
    } else if (T == String) {
      return sp!.then((value) => value.getString(key) as T?);
    } else if (T == bool) {
      return sp!.then((value) => value.getBool(key) as T?);
    } else if (T == double) {
      return sp!.then((value) => value.getDouble(key) as T?);
    } else if (T.toString() == "List<String>") {
      return sp!.then((value) => value.getStringList(key) as T?);
    } else {
      return sp!.then((value) => value.getString(key)).then((data) {
        if (data != null) {
          return json.decode(data) as T?;
        } else {
          return null;
        }
      });
    }
  }

  /// 数据存储归口处理
  static void _set(String key, dynamic v) {
    // 确认初始化完成
    init();
    if (v.runtimeType == int) {
      sp!.then((value) => value.setInt(key, v));
    } else if (v.runtimeType == String) {
      sp!.then((value) => value.setString(key, v));
    } else if (v.runtimeType == bool) {
      sp!.then((value) => value.setBool(key, v));
    } else if (v.runtimeType == double) {
      sp!.then((value) => value.setDouble(key, v));
    } else if (v.runtimeType.toString() == "List<String>") {
      sp!.then((value) => value.setStringList(key, v));
    } else {
      String stringData = json.encode(v);
      sp!.then((value) => value.setString(key, stringData));
    }
  }

  static void remove(String key) {
    // 确认初始化完成
    init();
    sp!.then((value) => value.remove(key));
  }

}