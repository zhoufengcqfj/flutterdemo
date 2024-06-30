import 'package:dartpoet/dartpoet.dart';

///测试列表参数的请求类
///参见testRequestArr.json定义的/test/requestArr接口
class testRequestArrParam {
  ///组织节点OrgCode
  String? orgCode;

  ///List数据
  List<String>? deviceCodes;

  ///List数据
  List<String>? categories;
  FileSpec? fileSpec;
  PropertySpec? propertySpec;

  testRequestArrParam(
      {this.orgCode,
      this.deviceCodes,
      this.categories,
      this.fileSpec,
      this.propertySpec});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgCode'] = this.orgCode;
    data['deviceCodes'] = this.deviceCodes;
    data['categories'] = this.categories;
    data['fileSpec'] = this.fileSpec;
    data['propertySpec'] = this.propertySpec;
    return data;
  }

  testRequestArrParam.fromJson(Map<dynamic, dynamic> json) {
    orgCode = json['orgCode'] is String
        ? json['orgCode']
        : json['orgCode']?.toString();
    if (json['deviceCodes'] != null && json['deviceCodes'].isNotEmpty) {
      deviceCodes = json['deviceCodes'].cast<String>();
    }
    if (json['categories'] != null && json['categories'].isNotEmpty) {
      categories = json['categories'].cast<String>();
    }

  }

  @override
  String toString() {
    return "{\"orgCode\": \"${orgCode ?? ""}\", \"deviceCodes\": [${deviceCodes?.join(",") ?? ""}], \"categories\": [${categories?.join(",") ?? ""}], \"fileSpec\": \"${fileSpec ?? ""}\", \"propertySpec\": \"${propertySpec ?? ""}\"}";
  }
}
