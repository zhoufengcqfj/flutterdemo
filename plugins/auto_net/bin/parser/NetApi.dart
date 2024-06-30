
/// 解析之后的实体
/// 注意：添加项之后，记得在toJson中添加赋值哦
/// 注意：添加项之后，记得在toJson中添加赋值哦
/// 注意：添加项之后，记得在toJson中添加赋值哦
class NetApi {
  ///接口描述
  String description ="";
  ///请求方法
  String method = "";
  ///url,非json指定，会添加参数
  String url = "";
  ///基础Url，会添加到url头部
  String? baseUrl;
  ///接口名称,如果不指定，使用文件名称
  String? name;
  ///请求头
  Map<String, dynamic>? headers;
  ///外部bean引用，直接使用外部定义的共享bean
  Map<String, dynamic>? import;
  ///请求参数
  dynamic? request;
  ///返回结果
  dynamic? response;
  ///路径参数
  Map<String, dynamic>? urlPathParam;
  ///Url参数
  Map<String, dynamic>? urlParam;

  static NetApi fromJson(Map jsonData) {
    NetApi api = NetApi();
    api.description = jsonData["description"];
    api.method = jsonData["method"];
    var urlParam = jsonData["urlParam"];
    if (urlParam != null && urlParam is Map) {
      var param = "?";
      urlParam.forEach((key, value) {
        param += "$key=:$key&";
      });
      api.url = jsonData["url"] + param.substring(0, param.length - 1);
    } else {
      api.url = jsonData["url"];
    }
    api.baseUrl = jsonData["baseUrl"];
    api.name = jsonData["name"];
    api.headers = jsonData["headers"];
    api.request = jsonData["request"];
    api.response = jsonData["response"];
    api.urlPathParam = jsonData["urlPathParam"];
    api.urlParam = jsonData["urlParam"];
    api.import = jsonData["import"];
    return api;
  }

  /// 是否具有路径参数
  bool hasPathParam() {
    return urlPathParam != null && urlPathParam!.isNotEmpty;
  }
}