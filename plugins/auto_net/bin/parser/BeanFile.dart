/// 用于生成Bean类的数据
class BeanFile {
  /// 协议内容
  Map<String, dynamic> info;

  /// 文件名称
  String fileName;

  /// 模块
  String module = "";

  BeanFile(this.fileName, this.info, {this.module = ""});
}
