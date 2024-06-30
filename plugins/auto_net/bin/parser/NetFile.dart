import 'NetApi.dart';

/// 包含协议文件信息，协议等信息的类
class NetFile {
  //协议内容
  NetApi api;

  //文件名称
  String fileName;

  //子目录名称
  String? subDirName;

  //parse阶段生成
  String paramClassName;
  String pathParamClassName;
  String respClassName;

  NetFile(this.fileName, this.api, this.paramClassName, this.pathParamClassName,
      this.respClassName,
      [this.subDirName]);
}
