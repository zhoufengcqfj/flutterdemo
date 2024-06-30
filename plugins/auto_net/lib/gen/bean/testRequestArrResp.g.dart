///测试列表参数的请求类
///参见testRequestArr.json定义的/test/requestArr接口
class testRequestArrResp {
  ///List数据
  List<String>? devices;

  testRequestArrResp({this.devices});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devices'] = this.devices;
    return data;
  }

  testRequestArrResp.fromJson(Map<dynamic, dynamic> json) {
    if (json['devices'] != null && json['devices'].isNotEmpty) {
      devices = json['devices'].cast<String>();
    }
  }

  @override
  String toString() {
    return "{\"devices\": [${devices?.join(",") ?? ""}]}";
  }
}
