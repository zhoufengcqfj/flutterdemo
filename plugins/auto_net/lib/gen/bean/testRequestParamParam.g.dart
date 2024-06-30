///测试request参数的请求类
///参见testRequestParam.json定义的/test/requestParam?page=:page&pageSize=:pageSize接口
class testRequestParamParam {
  ///param1
  String? requestParam;

  testRequestParamParam({this.requestParam});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestParam'] = this.requestParam;
    return data;
  }

  testRequestParamParam.fromJson(Map<dynamic, dynamic> json) {
    requestParam = json['requestParam'] is String
        ? json['requestParam']
        : json['requestParam']?.toString();
  }

  @override
  String toString() {
    return "{\"requestParam\": \"${requestParam ?? ""}\"}";
  }
}
