

/// created by 90196 on 2021/04/25
/// KV数据存储封装

import 'package:dh_core/widget/dh_app.dart';
import 'package:flutter/widgets.dart';

/// created by 90196 on 2021/04/25
/// APP运行期业务数据缓存管理，重启app会导致数据丢失。
/// 数据清除在获取的时候根据Key来判断。
/// 所有业务的缓存类都要实现CacheBin接口
class DHCache {

  static bool isOperationApp = false;
  static Key? _appKey;
  static DHCache _instance = new DHCache();

  /// 获取缓存类或者新建缓存类
  static T getCacheOrBuild<T extends CacheBin>(BuildContext context, String key, T Function(BuildContext, ) buildFactory) {
    T result;
    var currentKey = DHApp.getAppKey(context);
    if (currentKey != _appKey) {
      //key不同，说明app重启
      _instance.clearData();
      _appKey = currentKey;
    }
    result = _instance.getData<T>(key) ?? buildFactory(context);
    _instance.putData(key, result);
    return result;
  }

  Map<String, CacheBin> _data = Map();

  /// 根据key获取缓存类
  T? getData<T>(String key) {
    return _data[key] as T?;
  }

  void putData<T extends CacheBin>(String key, T data) {
    _data.putIfAbsent(key, () => data);
  }

  /// APP重启的时候，会清空缓存以达到清除数据的功能。
  void clearData() {
    ///清理内存数据
    _data.forEach((key, value) {
      value.clear();
    });
    /// 清理data中的数据
    _data.clear();
  }

}

/// 数据仓库的接口，所有业务缓存，如果使用DHCache，必须要
abstract class CacheBin {

  void clear();
}

/// Map缓存
class MapCache<T> extends CacheBin {

  Map<String, T> _data = Map();

  void putData(String key, T data) {
    _data.putIfAbsent(key, () => data);
  }

  bool hasData(String key) => _data.containsKey(key);

  T? getData(String key) {
    return _data[key];
  }

  Iterable<String> getKeys() {
    return _data.keys;
  }

  Iterable<T> getValues() {
    return _data.values;
  }

  String? getKey(T value) {
    return _data.entries.where((element) => element.value == value).first.key;
  }

  @override
  void clear() {
    _data.clear();
  }
}

///不限制value类型的map存储
class MapCacheDynamic extends MapCache {

  ///通过类型获取指定类型数据
  T getDataWithType<T>(String key) {
    return getData(key) as T;
  }
}

/// list数据缓存
class ListCache<T> extends CacheBin {

  List<T> _data = <T>[];

  void putData(T data) {
    _data.add(data);
  }

  void putDataList(List<T> data) {
    _data.addAll(data);
  }

  T? getData(int index) {
    var result;
    if (index < _data.length) {
      result = _data[index];
    }
    return result;
  }

  Iterable<T> getDataRange(int start, int end) {
    return _data.getRange(start, end);
  }

  List<T> filter(bool Function(T) filter) {
    List<T> result = [];
    _data.forEach((element) {
      if (filter(element)) {
        result.add(element);
      }
    });
    return result;
  }

  int get length => _data.length;

  bool hasData() {
    return length > 0;
  }

  @override
  void clear() {
    _data.clear();
  }
}