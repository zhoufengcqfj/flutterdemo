
import 'dart:async';

import 'package:dio/dio.dart';

/// [LogInterceptor] is used to print logs during network requests.
/// It's better to add [LogInterceptor] to the tail of the interceptor queue,
/// otherwise the changes made in the interceptor behind A will not be printed out.
/// This is because the execution of interceptors is in the order of addition.
/// @Author 90196
/// @DateTime 2021/7/5 10:46
/// @Description:
class DhLogInterceptor extends Interceptor {
  DhLogInterceptor({
    this.request = true,
    this.requestHeader = true,
    this.requestBody = false,
    this.responseHeader = true,
    this.responseBody = false,
    this.error = true,
    this.logPrint = show,
    this.isPrintIgnored,
  });

  /// Print request [Options]
  bool request;

  /// Print request header [Options.headers]
  bool requestHeader;

  /// Print request data [Options.data]
  bool requestBody;

  /// Print [Response.data]
  bool responseBody;

  /// Print [Response.headers]
  bool responseHeader;

  /// Print error message
  bool error;

  /// Log printer; defaults print log to console.
  /// In flutter, you'd better use debugPrint.
  /// you can also write log in a file, for example:
  ///```dart
  ///  var file=File("./log.txt");
  ///  var sink=file.openWrite();
  ///  dio.interceptors.add(LogInterceptor(logPrint: sink.writeln));
  ///  ...
  ///  await sink.close();
  ///```
  void Function(Object object) logPrint;

  ///是否忽略打印,true-忽略，false-打印
  bool Function(String url)? isPrintIgnored;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (isPrintIgnored?.call(options.uri.toString()) == false) {
      logPrint('*** Request ***');
      _printKV('uri', options.uri);
      //options.headers;

      if (request) {
        var infoMap = {};
        infoMap['method'] = options.method;
        infoMap['responseType'] = options.responseType.toString();
        infoMap['followRedirects'] = options.followRedirects;
        infoMap['connectTimeout'] = options.connectTimeout;
        infoMap['sendTimeout'] = options.sendTimeout;
        infoMap['receiveTimeout'] = options.receiveTimeout;
        infoMap["receiveDataWhenStatusError"] = options.receiveDataWhenStatusError;
        infoMap['extra'] = options.extra;
        logPrint(infoMap);
      }
      if (requestHeader) {
        logPrint('headers:');
        var infoMap = {};
        options.headers.forEach((key, value) {
          infoMap[key] = value;
        });
        logPrint(infoMap);
      }
      if (requestBody) {
        logPrint('data:');
        _printAll(options.data);
      }
      logPrint('');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (isPrintIgnored?.call(response.requestOptions.uri.toString()) == false) {
      logPrint('*** Response ***');
      _printResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (isPrintIgnored?.call(err.requestOptions.uri.toString()) == false) {
      if (error) {
        logPrint('*** DioError ***:');
        logPrint('uri: ${err.requestOptions.uri}');
        logPrint('$err');
        if (err.response != null) {
          _printResponse(err.response!);
        }
        logPrint('');
      }
    }

    handler.next(err);
  }

  void _printResponse(Response response) {
    if (isPrintIgnored?.call(response.requestOptions.uri.toString()) == false) {
      _printKV('uri', response.requestOptions.uri);
      if (responseHeader) {
        _printKV('statusCode', response.statusCode);
        if (response.isRedirect == false) {
          _printKV('redirect', response.realUri);
        }

        logPrint('headers:');
        var infoMap = {};
        response.headers.forEach((name, values) {
          infoMap[name] = values.join("\t");
        });
        logPrint(infoMap);
        // response.headers.forEach((key, v) =>
        //     _printKV(' $key', v.join('\r\n\t')));
      }
      if (responseBody) {
        logPrint('Response Text:');
        _printAll(response.toString());
      }
      logPrint('');
    }
  }

  void _printKV(String key, Object? v) {
    logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(logPrint);
  }
}

void show(Object obj) {
  String msg = obj.toString().trim();
  int index = 0;
  int segmentSize = 900;
  String logContent;
  while (index < msg.length) {
    if (msg.length <= index + segmentSize) {
      logContent = msg.substring(index);
    } else {
      logContent = msg.substring(index, segmentSize + index);
    }
    index += segmentSize;
    print(logContent);
  }
}
