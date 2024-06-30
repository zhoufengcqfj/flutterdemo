import 'package:dh_net/Request.dart';
import 'bean/LogoutResp.g.dart';
import 'bean/LogoutQueryParam.g.dart';

///根据ProtoJson文件的定义自动生成的请求文件
class Api {
  ///退出登陆
  static Future<LogoutResp> logout(LogoutQueryParam param) async {
    return Request.delete(
            "/gateway/auth/oauth/revokeToken?access_token=:access_token&clientType=:clientType&uniqueCode=:uniqueCode&appType=:appType",
            params: param.toJson())
        .then((value) => LogoutResp.fromJson(value));
  }
}
