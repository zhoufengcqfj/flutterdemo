
import 'dart:io';

import 'package:dartpoet/dartpoet.dart';

/// 插件约定
/// 定义一些默认的参数
class Contracts {

  ///获取执行脚本的目录
  static Directory getRoot() => Directory.current;

  ///获取输出目录
  static Directory getOutputDir(Directory root) {
    return Directory(root.path + genDir);
  }

  static Directory getBeanDir(Directory outDir) {
    return Directory(outDir.path + beanDir);
  }

  /// 根据协议文件名称获取类名。
  /// e.g. UserFirstLogin.json -> UserFirstLogin
  static String getClassNameByFileName(String fileName) {
    return fileName.split(".")[0];
  }

  /// 生成dart文件的扩展名
  static String genDartExtension = ".g.dart";

  /// 生成文件输出目录
  static String genDir = "/lib/gen";

  /// protoJson定义目录
  static String protoJsonDir = "/protoJson";

  /// beanJson定义目录
  static String beanJsonDir = "/beanJson";

  /// bean生成dir
  static String beanDir = "/bean";

  /// 参数bean后缀
  static String suffixParam = "Param";

  /// 路径请求参数bean后缀
  static String suffixPathParam = "QueryParam";

  /// 返回结果bean后缀
  static String suffixResp = "Resp";

  /// dart 缩进
  static String indent = "  ";

  /// beanGen的bean声明的key
  static String beanKey = "bean";
  static String extendsKey = "extends";

  static Map<String, TypeToken> typeMap = {
    "int": TypeToken.ofInt(),
    "Integer": TypeToken.ofInt(),
    "bool": TypeToken.ofBool(),
    "Bool": TypeToken.ofBool(),
    "boolean": TypeToken.ofBool(),
    "Boolean": TypeToken.ofBool(),
    "double": TypeToken.ofDouble(),
    "Double": TypeToken.ofDouble(),
    "float": TypeToken.ofDouble(),
    "Float": TypeToken.ofDouble(),
    "long": TypeToken.ofInt(),
    "Long": TypeToken.ofInt(),
    "map": TypeToken.ofMap(),
    "Map": TypeToken.ofMap(),
    "object": TypeToken.ofDynamic(),
    "Object": TypeToken.ofDynamic(),
    "String": TypeToken.ofString(),
    "int?": TypeToken.ofIntN(),
    "Integer?": TypeToken.ofIntN(),
    "bool?": TypeToken.ofBoolN(),
    "Bool?": TypeToken.ofBoolN(),
    "boolean?": TypeToken.ofBoolN(),
    "Boolean?": TypeToken.ofBoolN(),
    "double?": TypeToken.ofDoubleN(),
    "Double?": TypeToken.ofDoubleN(),
    "float?": TypeToken.ofDoubleN(),
    "Float?": TypeToken.ofDoubleN(),
    "long?": TypeToken.ofIntN(),
    "Long?": TypeToken.ofIntN(),
    "map?": TypeToken.ofMapN(),
    "Map?": TypeToken.ofMapN(),
    "object?": TypeToken.ofDynamicN(),
    "Object?": TypeToken.ofDynamicN(),
    "String?": TypeToken.ofStringN(),
    "dynamic?": TypeToken.ofDynamicN(),
    "dynamic": TypeToken.ofDynamic(),
  };

  static TypeToken? getTypeByString(String key) {
    return typeMap[key];
  }

  static RegExp typeReg = new RegExp(r"\[([\S]*)\]([\s\S]*)");

  /// 根据注释获取注释指定的类型
  static String getTypeString(String comment) {
    Iterable<Match> matches = typeReg.allMatches(comment);
    if (matches.isNotEmpty) {
      String match = matches.first.group(1)!;
      return match;
    }
    return "String";
  }

  /// 根据注释获取去除类型之后的注释
  static String getComment(String comment) {
    Iterable<Match> matches = typeReg.allMatches(comment);
    if (matches.isNotEmpty) {
      String match = matches.first.group(2)!;
      return match.trim();
    }
    return comment;
  }

  static String lowerFirstChar(String name) {
    return name[0].toLowerCase() + name.substring(1);
  }

  static String upperFirstChar(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }
}