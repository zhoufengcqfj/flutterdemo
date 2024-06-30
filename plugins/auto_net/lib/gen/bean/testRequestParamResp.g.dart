///测试request参数的请求类
///参见testRequestParam.json定义的/test/requestParam?page=:page&pageSize=:pageSize接口
class testRequestParamResp {
  ///List数据
  List<String>? devices;

  testRequestParamResp({this.devices});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devices'] = this.devices;
    return data;
  }

  testRequestParamResp.fromJson(Map<dynamic, dynamic> json) {
    if (json['devices'] != null && json['devices'].isNotEmpty) {
      devices = json['devices'].cast<String>();
    }
  }

  @override
  String toString() {
    return "{\"devices\": [${devices?.join(",") ?? ""}]}";
  }
}
