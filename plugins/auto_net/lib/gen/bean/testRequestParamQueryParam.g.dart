///测试request参数的请求类
///参见testRequestParam.json定义的/test/requestParam?page=:page&pageSize=:pageSize接口
class testRequestParamQueryParam {
  ///页数
  String? page;

  ///每页个数
  String? pageSize;

  testRequestParamQueryParam({this.page, this.pageSize});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    return data;
  }

  testRequestParamQueryParam.fromJson(Map<dynamic, dynamic> json) {
    page = json['page'] is String ? json['page'] : json['page']?.toString();
    pageSize = json['pageSize'] is String
        ? json['pageSize']
        : json['pageSize']?.toString();
  }

  @override
  String toString() {
    return "{\"page\": \"${page ?? ""}\", \"pageSize\": \"${pageSize ?? ""}\"}";
  }
}
