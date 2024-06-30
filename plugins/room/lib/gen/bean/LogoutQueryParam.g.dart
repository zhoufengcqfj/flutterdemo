///退出登陆的请求类
///参见Logout.json定义的/gateway/auth/oauth/revokeToken?access_token=:access_token&clientType=:clientType&uniqueCode=:uniqueCode&appType=:appType接口
class LogoutQueryParam {
  ///token
  String? access_token;

  ///clientType
  int? clientType;

  ///uniqueCode
  String? uniqueCode;

  ///appType
  int? appType;

  LogoutQueryParam(
      {this.access_token, this.clientType, this.uniqueCode, this.appType});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.access_token;
    data['clientType'] = this.clientType;
    data['uniqueCode'] = this.uniqueCode;
    data['appType'] = this.appType;
    return data;
  }

  LogoutQueryParam.fromJson(Map<dynamic, dynamic> json) {
    access_token = json['access_token'] is String
        ? json['access_token']
        : json['access_token']?.toString();
    clientType = json['clientType'] is int ? json['clientType'] : null;
    uniqueCode = json['uniqueCode'] is String
        ? json['uniqueCode']
        : json['uniqueCode']?.toString();
    appType = json['appType'] is int ? json['appType'] : null;
  }

  @override
  String toString() {
    return "{\"access_token\": \"${access_token ?? ""}\", \"clientType\": \"${clientType ?? ""}\", \"uniqueCode\": \"${uniqueCode ?? ""}\", \"appType\": \"${appType ?? ""}\"}";
  }
}
