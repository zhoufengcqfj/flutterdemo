
class BusinessException extends Error implements TypeError {

  final int? httpCode;
  final int? errorCode;
  final String? errorMessage;
  final dynamic? error;
  BusinessException(this.httpCode,{this.errorCode = 0, this.errorMessage, this.error});
  String toString() =>
      "{'httpCode': $httpCode, 'errorCode': $errorCode, 'errorMessage': $errorMessage}";

}

class ErrorMessage{

  ErrorMessage();

  int? code;
  String? message;
  List<MessageI18n>? i18nMessage;

  factory ErrorMessage.fromJson(Map<String, dynamic> json) => ErrorMessage()
      ..code = json['code'] as int?
      ..message = json['message'] as String?
      ..i18nMessage = (json['i18nMessage'] as List<dynamic>?)
          ?.map((e) => MessageI18n.fromJson(e as Map<String, dynamic>))
          .toList();

  Map<String, dynamic> toJSon() => <String, dynamic>{
        'code': this.code,
        'message': this.message,
        'i18nMessage': this.i18nMessage,
      };

}

class MessageI18n{
  MessageI18n();
  String? iisKey;
  List<dynamic>? value;

  factory MessageI18n.fromJson(Map<String,dynamic> json) => MessageI18n()
    ..iisKey = json['iisKey'] as String?
    ..value =
    (json['value'] as List<dynamic>?)?.map((e) => e).toList();

  Map<String, dynamic> toJson() => <String, dynamic>{
    'iisKey': this.iisKey,
    'value': this.value,
  };
}