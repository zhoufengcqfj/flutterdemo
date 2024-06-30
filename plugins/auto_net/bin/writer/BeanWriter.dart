import 'dart:io';
import '../utils/Contracts.dart';
import 'package:dartpoet/dartpoet.dart';

import '../utils/Log.dart';

/// 输出Bean
class BeanWriter {
  /// 生成的bean的名称
  String mClassName;

  /// 生成的bean的名称
  List<DependencySpec> mDependencies = <DependencySpec>[];

  /// 输出bean的目录
  Directory mOutDir;

  /// 字段信息
  Map<String, dynamic> mInfo;

  /// 类描述信息
  String mDesc;

  /// 模块
  String module;

  /// 外部依赖
  Map<String, dynamic> import;

  /// 继承信息
  Map<String, dynamic>? ex;

  List<ClassSpec> mClassList = List.empty(growable: true);

  BeanWriter(this.mClassName, this.mInfo, this.mOutDir, this.mDesc,
      {this.module = "", this.import = const {}, this.ex}) {
    mClassList.add(getClass(this.mClassName, this.mInfo, this.mDesc));
  }

  ClassSpec getClass(
      String className, Map<String, dynamic> mapData, String comment) {
    return ClassSpec.build(
      className,
      superClass: getSuperClass(this.ex),
      constructorBuilder: (owner) sync* {
        yield ConstructorSpec.normal(
          owner,
          parameters: getConstructPropertyByMap(mapData),
        );
      },
      properties: getClassPropertyByMap(className, mapData),
      methods: getBeanMethods(className, mapData),
      doc: DocSpec.text(comment),
    );
  }

  /// 获取父类
  TypeToken? getSuperClass(Map<String, dynamic>? ex) {
    if (ex != null && ex.isNotEmpty) {
      String name = ex["name"];
      String importFrom = ex["import"];
      mDependencies.add(DependencySpec.import(importFrom));
      return TypeToken.ofName(name);
    }
    return null;
  }


  void doWrite() async {
    FileSpec fileSpec = FileSpec.build(
      dependencies: mDependencies,
      // define methods in this file
      methods: [],
      classes: getClasses(),
    );

    // define a dart file
    DartFile dartFile = DartFile.fromFileSpec(fileSpec);
    // output file content
    //print(dartFile.outputContent());

    String outPath;
    if (module.isNotEmpty) {
      outPath =
          mOutDir.path + "/$module/$mClassName${Contracts.genDartExtension}";
      await Directory(mOutDir.path + "/$module").create();
    } else {
      outPath = mOutDir.path + "/$mClassName${Contracts.genDartExtension}";
    }

    dartFile.outputSync(outPath);
  }

  List<ClassSpec> getClasses() {
    return mClassList;
  }

  static bool hasListString = false;
  static bool hasListBean = false;

  List<PropertySpec> getClassPropertyByMap(
      String currentClassName, Map<String, dynamic> mapData) {
    List<PropertySpec> propertyList = List.empty(growable: true);
    mapData.forEach((key, value) {
      if (value is List) {
        dynamic itemData = value[0];
        TypeToken itemType = TypeToken.ofName('error');
        if (itemData is String) {
          hasListString = true;
          String typeString = Contracts.getTypeString(itemData);
          TypeToken? type = Contracts.getTypeByString(typeString);
          if (type == null) {
            if (import[typeString] != null) {
              //添加import中定义的bean
              _addDependence(DependencySpec.import(import[typeString]!));
            } else {
              //添加bean中定义的bean
              _addDependence(DependencySpec.import(
                  "$typeString${Contracts.genDartExtension}"));
            }
          }
          itemType = TypeToken.ofListByTokenN(
              type ?? TypeToken.ofFullName(typeString));
        } else if (itemData is Map) {
          hasListBean = true;
          String upKey = Contracts.upperFirstChar(key);
          String name = currentClassName + upKey;
          mClassList.add(getClass(
              name, value[0], currentClassName + "的List数据子类：" + upKey));
          itemType = TypeToken.ofListByTokenN(TypeToken.ofName(name));
        } else {
          Log.err("包含未支持类型，请联系开发。。。");
        }
        PropertySpec item = PropertySpec.of(key, type: itemType);
        item.doc = DocSpec.text("List数据");
        propertyList.add(item);
      } else if (value is Map<String, dynamic>) {
        String upKey = Contracts.upperFirstChar(key);
        String name = currentClassName + upKey;
        mClassList
            .add(getClass(name, value, currentClassName + "的子类：" + upKey));
        PropertySpec item =
            PropertySpec.of(key, type: TypeToken.ofName(name + "?"));
        item.doc = DocSpec.text("子类数据");
        propertyList.add(item);
      } else {
        String typeString = Contracts.getTypeString(value);
        TypeToken? type = Contracts.getTypeByString(typeString + "?");
        if (type != null) {
          PropertySpec item = PropertySpec.of(key, type: type);
          item.doc = DocSpec.text(Contracts.getComment(value));
          propertyList.add(item);
        } else {
          //判断import中是否有包含，如果没有包含，提示用户没有该类型
          if (import[typeString] != null) {
            //导入外部依赖
            _addDependence(DependencySpec.import(import[typeString]!));
            PropertySpec item =
                PropertySpec.of(key, type: TypeToken.ofNameN(typeString));
            propertyList.add(item);
          } else {
            Log.err("$import");
            Log.err("没有找到定义类型：$typeString, 请检查，可以在import属性中申明外部依赖哦~");
          }
        }
      }
    });
    return propertyList;
  }

  void _addDependence(DependencySpec item) {
    if (!mDependencies.contains(item)) {
      mDependencies.add(item);
    } else {
      // Log.log("include dependence");
    }
  }

  List<ParameterSpec> getConstructPropertyByMap(Map<String, dynamic> mapData) {
    List<ParameterSpec> propertyList = List.empty(growable: true);
    mapData.forEach((key, value) {
      if (value is List) {
        TypeToken type = TypeToken.ofList();
        ParameterSpec item =
            ParameterSpec.named(key, isSelfParameter: true, type: type);
        propertyList.add(item);
      } else if (value is Map) {
      } else {
        String typeString = Contracts.getTypeString(value);
        TypeToken? type = Contracts.getTypeByString(typeString);
        if (type != null) {
          ParameterSpec item =
              ParameterSpec.named(key, isSelfParameter: true, type: type);
          propertyList.add(item);
        } else {
          //判断import中是否有包含，如果没有包含，提示用户没有该类型
          if (import[typeString] != null) {
            //导入外部依赖
            _addDependence(DependencySpec.import(import[typeString]!));
            ParameterSpec item = ParameterSpec.named(key,
                isSelfParameter: true, type: TypeToken.ofNameN(typeString));
            propertyList.add(item);
          } else {
            Log.err("import: $import");
            Log.err("没有找到定义类型：$typeString, 请检查，可以在import属性中申明外部依赖哦~");
          }
        }
      }
    });
    return propertyList;
  }

  /// 添加toJson fromJson toString方法
  List<MethodSpec> getBeanMethods(
      String className, Map<String, dynamic> mapData) {
    if (mapData.isNotEmpty) {
      TypeToken mapStringDynamic =
          TypeToken.ofMapByToken(TypeToken.of(String), TypeToken.ofDynamic());
      TypeToken mapDynamicDynamic =
          TypeToken.ofMapByToken(TypeToken.ofDynamic(), TypeToken.ofDynamic());

      List<MethodSpec> methodList = List.empty(growable: true);
      List<String> toLines = List.empty(growable: true);
      toLines
          .add("final Map<String, dynamic> data = new Map<String, dynamic>();");
      mapData.forEach((key, value) => toLines.add("data['$key'] = this.$key;"));
      toLines.add("return data;");
      MethodSpec toJson = MethodSpec.build("toJson",
          returnType: mapStringDynamic,
          codeBlock: CodeBlockSpec.lines(toLines));
      methodList.add(toJson);

      List<String> fromLines = List.empty(growable: true);
      mapData.forEach((key, value) {
        if (value is List) {
          var itemData = value[0];
          if (itemData is String) {
            String typeString = Contracts.getTypeString(itemData);
            TypeToken? type = Contracts.getTypeByString(typeString);
            if (type != null) {
              fromLines.add(
                  "if (json['$key'] != null && json['$key'].isNotEmpty) {\n");
              fromLines.add("$key = json['$key'].cast<${type.typeName}>();");
              fromLines.add("}");
            } else {
              //dynamic
              fromLines.add(
                  "if (json['$key'] != null && json['$key'].isNotEmpty) {\n");
              fromLines.add(
                  "$key = (json['$key'] as List).map<$typeString>((info) => $typeString.fromJson(info)).toList(growable: true);");
              fromLines.add("}");
            }
          } else {
            //dynamic
            String subClassName = className + Contracts.upperFirstChar(key);
            fromLines.add(
                "if (json['$key'] != null && json['$key'].isNotEmpty) {\n");
            fromLines.add(
                "$key = (json['$key'] as List).map<$subClassName>((info) => $subClassName.fromJson(info)).toList(growable: true);");
            fromLines.add("}");
          }
        } else if (value is Map) {
          //dynamic
          String subClassName = className + Contracts.upperFirstChar(key);
          fromLines
              .add("if (json['$key'] != null && json['$key'].isNotEmpty) {\n");
          fromLines.add("$key = $subClassName.fromJson(json['$key']);");
          fromLines.add("}");
        } else {
          String typeString = Contracts.getTypeString(value);
          TypeToken? type = Contracts.getTypeByString(typeString);
          if (type != null) {
            typeString = type.toString();
          }
          if (typeString == TypeToken.ofString().toString()) {
            fromLines.add("$key = json['$key'] is $typeString? json['$key']: json['$key']?.toString();");
          }else if(type == null){
            fromLines.add("$key = json['$key'] is Map ? $typeString.fromJson(json['$key']): null;");
          } else {
            fromLines.add("$key = json['$key'] is $typeString? json['$key']: null;");
          }
        }
      });
      MethodSpec fromJson = MethodSpec.build("$className.fromJson",
          parameters:
              List.of([ParameterSpec.build("json", type: mapDynamicDynamic)]),
          codeBlock: CodeBlockSpec.lines(fromLines),
          withLambda: false);
      methodList.add(fromJson);

      String toStringCodeLine = 'return \"{';
      mapData.forEach((key, value) {
        if (value is List) {
          toStringCodeLine += '\\\"$key\\\": [\${$key?.join(",")??\"\"}], ';
        } else if (value is Map) {
          toStringCodeLine += "\\\"$key\\\": \${$key?.toString()??\"\"}, ";
        } else {
          toStringCodeLine += "\\\"$key\\\": \\\"\${$key?? \"\"}\\\", ";
        }
      });
      toStringCodeLine =
          toStringCodeLine.substring(0, toStringCodeLine.length - 2);
      toStringCodeLine += "}\";";
      MethodSpec toString = MethodSpec.build("toString",
          metas: [MetaSpec.ofInstance("override")],
          codeBlock: CodeBlockSpec.line(toStringCodeLine),
          returnType: TypeToken.ofString(),
          withLambda: false);
      methodList.add(toString);
      return methodList;
    } else {
      return List.empty();
    }
  }

  a(List<dynamic> data) {
    return data.map((e) => e.toString());
  }
/*
  class info {
    String realm;
    String randomKey;
    String encryptType;
    String method;

    info({this.realm, this.randomKey, this.encryptType, this.method});

    info.fromJson(Map<String, dynamic> json) {
      realm = json['realm'];
      randomKey = json['randomKey'];
      encryptType = json['encryptType'];
      method = json['method'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['realm'] = this.realm;
      data['randomKey'] = this.randomKey;
      data['encryptType'] = this.encryptType;
      data['method'] = this.method;
      return data;
    }
  }
*/

}
