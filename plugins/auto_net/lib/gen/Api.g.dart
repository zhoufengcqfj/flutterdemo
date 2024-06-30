import 'package:dh_net/Request.dart';
import 'bean/testRequestArrParam.g.dart';
import 'bean/testRequestArrResp.g.dart';
import 'bean/testParamEmptyResp.g.dart';
import 'bean/testRequestParamParam.g.dart';
import 'bean/testRequestParamResp.g.dart';
import 'bean/testRequestParamQueryParam.g.dart';
import 'package:dartpoet/dartpoet.dart';
import 'bean/testRequestParamEmptyResp.g.dart';
import 'bean/testRequestParamEmptyQueryParam.g.dart';

///根据ProtoJson文件的定义自动生成的请求文件
class Api {
  ///测试列表参数
  static Future<testRequestArrResp> testRequestArr(
      List<testRequestArrParam>? data) async {
    return Request.post("/test/requestArr", data: data)
        .then((value) => testRequestArrResp.fromJson(value));
  }

  ///测试列表参数
  static Future<testParamEmptyResp> testParamEmpty() async {
    return Request.get("/test/paramEmpty",
            headers: {"Content-Type": "application/json"})
        .then((value) => testParamEmptyResp.fromJson(value));
  }

  ///测试request参数
  static Future<testRequestParamResp> testRequestParam(
      testRequestParamQueryParam param, testRequestParamParam data) async {
    return Request.post("/test/requestParam?page=:page&pageSize=:pageSize",
            data: data, params: param.toJson())
        .then((value) => testRequestParamResp.fromJson(value));
  }



  ///测试request参数request为空
  static Future<testRequestParamEmptyResp> testRequestParamEmpty(
      testRequestParamEmptyQueryParam param) async {
    return Request.get("/test/requestParamEmpty?page=:page&pageSize=:pageSize",
            params: param.toJson())
        .then((value) => testRequestParamEmptyResp.fromJson(value));
  }
}
