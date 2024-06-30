///退出登陆的请求类
///参见Logout.json定义的/gateway/auth/oauth/revokeToken?access_token=:access_token&clientType=:clientType&uniqueCode=:uniqueCode&appType=:appType接口
class LogoutResp {
  ///状态码
  String? code;

  ///返回提示消息
  String? errMsg;

  ///是否成功
  bool? success;

  LogoutResp({this.code, this.errMsg, this.success});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['errMsg'] = this.errMsg;
    data['success'] = this.success;
    return data;
  }

  LogoutResp.fromJson(Map<dynamic, dynamic> json) {
    code = json['code'] is String ? json['code'] : json['code']?.toString();
    errMsg =
        json['errMsg'] is String ? json['errMsg'] : json['errMsg']?.toString();
    success = json['success'] is bool ? json['success'] : null;
  }

  @override
  String toString() {
    return "{\"code\": \"${code ?? ""}\", \"errMsg\": \"${errMsg ?? ""}\", \"success\": \"${success ?? ""}\"}";
  }
}
