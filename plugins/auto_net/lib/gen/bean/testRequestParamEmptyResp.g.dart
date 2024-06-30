///测试request参数request为空的请求类
///参见testRequestParamEmpty.json定义的/test/requestParamEmpty?page=:page&pageSize=:pageSize接口
class testRequestParamEmptyResp {
  ///List数据
  List<String>? devices;

  testRequestParamEmptyResp({this.devices});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devices'] = this.devices;
    return data;
  }

  testRequestParamEmptyResp.fromJson(Map<dynamic, dynamic> json) {
    if (json['devices'] != null && json['devices'].isNotEmpty) {
      devices = json['devices'].cast<String>();
    }
  }

  @override
  String toString() {
    return "{\"devices\": [${devices?.join(",") ?? ""}]}";
  }
}
