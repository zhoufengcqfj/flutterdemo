import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  //
  static Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  //
  static setInt(String key, int value) {
    getSharedPreferences().then((prefs) {
      prefs.setInt(key, value);
    });
  }

  //
  static setString(String key, String value) {
    getSharedPreferences().then((prefs) {
      prefs.setString(key, value);
    });
  }

  //
  static Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key)??"";

  }

  static Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? -1;

  }

  //
  static setBool(String key, bool value) {
    getSharedPreferences().then((prefs) {
      prefs.setBool(key, value);
    });
  }

  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  //
  static setDouble(String key, double value) {
    getSharedPreferences().then((prefs) {
      prefs.setDouble(key, value);
    });
  }

  //
  static setStringList(String key, List<String> value) {
    getSharedPreferences().then((prefs) {
      prefs.setStringList(key, value);
    });
  }

  // 移除
  static remove(String key) {
    getSharedPreferences().then((prefs) {
      prefs.remove(key);
    });
  }

  static Future<void> putStringList(String key, List<String> counter) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, counter);
  }

  static Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

/*  *//***
   *
   * 存数据
   *//*

  static Object savePreference(
      BuildContext context, String key, Object value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw new Exception("不能得到这种类型");
    }
  }

  *//***
   * 取数据
   *
   *//*
  static Future getPreference(
      Object context, String key, Object defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (defaultValue is int) {
      return prefs.getInt(key);
    } else if (defaultValue is double) {
      return prefs.getDouble(key);
    } else if (defaultValue is bool) {
      return prefs.getBool(key);
    } else if (defaultValue is String) {
      return prefs.getString(key);
    } else if (defaultValue is List) {
      return prefs.getStringList(key);
    } else {
      throw new Exception("不能得到这种类型");
    }
  }

  *//***
   * 删除指定数据
   *//*
  static void remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key); //删除指定键
  }

  *//***
   * 清空整个缓存
   *//*
  static void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear(); ////清空缓存
  }*/
}
