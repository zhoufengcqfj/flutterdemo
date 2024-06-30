import 'dart:convert';
import 'dart:io';
import 'package:dh_core/debug/dh_log.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dh_error.dart';
import 'package:dh_net/interceptors/DhLogInterceptor.dart';
import 'package:dh_core/data/dh_store.dart';
import 'package:dh_core/utils/shared_preferences_utils.dart';

/// 请求类封装
class Request {
  static String _ip = '';
  static String _port = '';
  static String _token = '';

  //缓存乐橙认证信息
  static String lcToken = '';
  static String lcAndroidCode = '';
  static String lcIosCode = '';
  static String lcRealmName = '';

  //开发环境
  // static String _testip = '124.160.108.60';
  // static String _testport = '14001';

  //测试环境
  static String _testip = '8.136.236.121';
  static String _testport = '80';

  //线上环境
  // static String _testip = 'https://cloud.wisualarm.com';
  // static String _testport = '443';
  static RequestInfo getInfo() {
    return RequestInfo(_ip, _port, _token);
  }

  // 创建 Dio 实例
  static Dio? _dio;

  static init(String ip, String port,
      {int? connectTimeout,
      int? receiveTimeout,
      bool Function(String)? isPrintIgnored}) {
    _ip = _testip;
    _port = _testport;
    _dio = Dio(BaseOptions(
      // baseUrl: 'https://$_ip:$_port/',
      baseUrl: 'http://$_testip:$_testport/',
      // baseUrl: 'https://www.wanandroid.com/',
      connectTimeout: connectTimeout == null ? 30000 : connectTimeout,
      receiveTimeout: receiveTimeout == null ? 30000 : receiveTimeout,
    ));
    _dio!.interceptors.add(DhLogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: false,
      responseHeader: true,
      isPrintIgnored: isPrintIgnored,
    ));
    (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      ///设置代理
      // client.findProxy = (uri) {
      //   return HttpClient.findProxyFromEnvironment(uri, environment: {
      //     "http_proxy": 'http://192.168.42.174:8888',
      //     "https_proxy": 'https://10.33.79.77:8888',
      //   });
      // };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
  }

  static setToken(String token) {
    _token = token;
  }

  static String getToken() => _token;

  static RegExp typeReg = new RegExp(r"{([\S].*?)}");

  ///将路径中的占位符用数据填充
  static String getUrl(String url, List<String> data) {
    int count = 0;
    return url.replaceAllMapped(typeReg, (match) {
      return data[count++];
    });
  }

  static CancelToken _cancelToken = CancelToken();

  static Future<DioError> cancelRequest() {
    _cancelToken.cancel(DioErrorType.cancel);
    return _cancelToken.whenCancel;
  }

  // _request 是核心函数，所有的请求都会走这里
  static Future<T> _request<T>(String path, String method,
      {Map? params,
      data,
      Map<String, dynamic>? headers,
      bool upload = false}) async {
    Log.it(
      'request',
      "path :${path}, params :${params} ,data :${data} ,headers:${headers}",
    );
    // restful 请求处理
    if (params != null) {
      params.forEach((key, value) {
        if (path.indexOf(key) != -1) {
          path = path.replaceFirst(":$key", value.toString());
        }
      });
    }
    if (headers == null) {
      headers = Map<String, dynamic>();
    }
    if (!path.contains("gateway/auth/user/getSalt")) {
      String token = await SharedPreferencesUtils.getString("KEY_ACCESSTOKEN");
      int userId = await SharedPreferencesUtils.getInt("KEY_USERID");

      Log.it('_request', "token :${token},userId:${userId}");
      var timestamp = new DateTime.now().millisecondsSinceEpoch;

      headers.addEntries([MapEntry("Accept", 'application/json')]);
      headers.addEntries([MapEntry("Content-Type", 'application/json')]);
      headers.addEntries([MapEntry("Accept-Language", 'zh-CN')]);
      headers.addEntries([MapEntry("clientType", 1)]);
      headers.addEntries([MapEntry("nonce", "app-${timestamp}-${timestamp}")]);
      headers.addEntries([MapEntry("timestamp", timestamp)]);
      headers.addEntries([MapEntry("userId", userId)]);
      headers.addEntries([MapEntry("version", "v12")]);
      headers.addEntries([MapEntry("timeoffset", -28800000)]);
      headers.addEntries([MapEntry("Authorization", "Bearer " + token)]);
    }
    Log.it('request', "发送的数据");
    try {
      Response response = await _dio!.request<T>(path,
          cancelToken: _cancelToken,
          data: upload ? FormData.fromMap(data) : data,
          options: Options(method: method, headers: headers));
      Log.it('request', "接收的数据：" + response.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          if (response.data is Map) {
            return response.data;
          } else if (response.data != null &&
              response.data != "" &&
              (response.data.toString().trim().startsWith("{") ||
                  response.data.toString().trim().startsWith("["))) {
            return json.decode(response.data.toString());
          } else {
            return json.decode(json.encode({"code": 200, "message": "响应格式错误"}));
          }
        } catch (e) {
          print(e);
          //LogUtil.v(e, tag: '解析响应数据异常');
          return Future.error(response);
        }
      } else {
        print(response.statusCode);
        return _parseRes(response);
      }
    } on DioError catch (e, s) {
      print(e);
      if (e.response != null && e.response!.statusCode == 401) {
        return Future.error(e);
      } else if (e.response != null) {
        return _parseRes(e.response!);
      }
      return Future.error(BusinessException(-1, error: e));
    } catch (e, s) {
      print(e);
      //LogUtil.v(e, tag: '未知异常');
      return Future.error(BusinessException(-1, error: e));
    }
  }

  static Future<T> _parseRes<T>(Response response) {
    print('aaa44==' + response.data.toString());
    int? code = 0;
    String? message = "";
    try {
      if (response.data != null && response.data is Map) {
        ErrorMessage ret = ErrorMessage.fromJson(response.data);
        code = ret.code;
        message = ret.message;
        if (ret.i18nMessage != null && ret.i18nMessage!.length > 0) {
          MessageI18n messageI18n = ret.i18nMessage![0];
          if (messageI18n.value != null && messageI18n.value!.length > 0) {
            message = messageI18n.value![0].toString();
          }
        }
      }
    } catch (e) {
      print(e);
    }
    return Future.error(BusinessException(response.statusCode,
        errorCode: code, errorMessage: message));
  }

  // 处理 Dio 异常
  static String _dioError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return "网络连接超时，请检查网络设置";
        break;
      case DioErrorType.receiveTimeout:
        return "服务器异常，请稍后重试！";
        break;
      case DioErrorType.sendTimeout:
        return "网络连接超时，请检查网络设置";
        break;
      case DioErrorType.response:
        return "服务器异常，请稍后重试！";
        break;
      case DioErrorType.cancel:
        return "请求已被取消，请重新请求";
        break;
      case DioErrorType.other:
        return "网络异常，请稍后重试！";
        break;
      default:
        return "Dio异常";
    }
  }

  // 处理 Http 错误码
  static void _handleHttpError(int? errorCode) {
    String message;
    switch (errorCode) {
      case 400:
        message = '请求语法错误';
        break;
      case 401:
        message = '未授权，请登录';
        break;
      case 403:
        message = '拒绝访问';
        break;
      case 404:
        message = '请求出错';
        break;
      case 408:
        message = '请求超时';
        break;
      case 500:
        message = '服务器异常';
        break;
      case 501:
        message = '服务未实现';
        break;
      case 502:
        message = '网关错误';
        break;
      case 503:
        message = '服务不可用';
        break;
      case 504:
        message = '网关超时';
        break;
      case 505:
        message = 'HTTP版本不受支持';
        break;
      default:
        message = '请求失败，错误码：$errorCode';
    }
    //EasyLoading.showError(message);
  }

  static Future<T> get<T>(String path,
      {Map? params, data, Map<String, dynamic>? headers}) {
    return _request(path, 'get', params: params, data: data, headers: headers);
  }

  static Future<T> post<T>(String path,
      {Map? params, data, Map<String, dynamic>? headers}) {
    return _request(path, 'post', params: params, data: data, headers: headers);
  }

  static Future<T> put<T>(String path,
      {Map? params, data, Map<String, dynamic>? headers}) {
    return _request(path, 'put', params: params, data: data, headers: headers);
  }

  static Future<T> delete<T>(String path,
      {Map? params, data, Map<String, dynamic>? headers}) {
    return _request(path, 'delete',
        params: params, data: data, headers: headers);
  }

  static Future uploadFile(String path,
      {Map? params,
      data,
      Map<String, dynamic>? headers,
      String method = "post"}) {
    return _request(path, method, params: params, data: data, upload: true);
  }

// 这里只写了 get 和 post，其他的别名大家自己手动加上去就行
}

/// 请求信息,用于isolate复制
class RequestInfo {
  String ip;
  String port;
  String token;

  RequestInfo([this.ip = '', this.port = '', this.token = '']);
}
