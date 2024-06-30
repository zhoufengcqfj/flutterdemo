///测试request参数request为空的请求类
///参见testRequestParamEmpty.json定义的/test/requestParamEmpty?page=:page&pageSize=:pageSize接口
class testRequestParamEmptyQueryParam {
  ///页数
  String? page;

  ///每页个数
  String? pageSize;

  testRequestParamEmptyQueryParam({this.page, this.pageSize});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['pageSize'] = this.pageSize;
    return data;
  }

  testRequestParamEmptyQueryParam.fromJson(Map<dynamic, dynamic> json) {
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
