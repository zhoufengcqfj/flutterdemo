import 'dart:io';

import 'package:dartpoet/dartpoet.dart';

import '../parser/NetFile.dart';
import '../utils/Contracts.dart';
import '../utils/Log.dart';

/// api文件生成器
class ProtoJsonApiWriter {
  Directory mOutDir;

  List<DependencySpec> mDependencies = List.of(
      [DependencySpec.import("package:dh_net/Request.dart")],
      growable: true);

  /// outDir 指定输出目录
  ProtoJsonApiWriter(this.mOutDir);

  /// 生成API类
  void doWrite(List<NetFile> netFileList) {
    String className = "Api";
    FileSpec fileSpec = FileSpec.build(
      dependencies: mDependencies,
      // define methods in this file
      methods: [],
      classes: [
        ClassSpec.build(
          className,
          methods: getMethodList(netFileList),
          doc: DocSpec.text("根据ProtoJson文件的定义自动生成的请求文件"),
        )
      ],
    );

    // define a dart file
    DartFile dartFile = DartFile.fromFileSpec(fileSpec);
    // output file content
    //print(dartFile.outputContent());

    dartFile
        .outputSync(mOutDir.path + "/$className${Contracts.genDartExtension}");
  }

  /// Api中的每个请求方法
  List<MethodSpec> getMethodList(List<NetFile> netFileList) {
    List<MethodSpec> methodList = List.empty(growable: true);
    netFileList.forEach((item) {
      bool hasPathParam = item.api.hasPathParam();
      bool hasParam = item.api.request != null && item.api.request!.isNotEmpty;
      //请求参数是否是List
      bool isParamList = false;
      if (hasParam) {
        isParamList = item.api.request is List;
      }
      bool hasUrlParam =
          item.api.urlParam != null && item.api.urlParam!.isNotEmpty;
      bool hasResp = item.api.response != null && item.api.response.isNotEmpty;
      bool hasHeader = item.api.headers != null;
      String className = Contracts.getClassNameByFileName(item.fileName);
      String respClassName = className + Contracts.suffixResp;
      String methodName = Contracts.lowerFirstChar(className);

      if (item.api.request != null) {
        if (item.api.request is String) {
          String typeString = Contracts.getTypeString(item.api.request);
          TypeToken? type = Contracts.getTypeByString(typeString + "?");
          if (type == null) {
            var import = item.api.import;
            //判断import中是否有包含，如果没有包含，提示用户没有该类型
            if (import != null && import[typeString] != null) {
              //导入外部依赖
              _addDependence(DependencySpec.import(import[typeString]!));
            } else {
              Log.err("$import");
              Log.err("没有找到定义类型：$typeString, 请检查，可以在import属性中申明外部依赖哦~");
            }
          }
        } else if ((item.api.request is Map || item.api.request is List) &&
            item.api.request.isNotEmpty) {
          _addDependence(DependencySpec.import(
              "bean/${item.paramClassName}" + Contracts.genDartExtension));
        }
      }
      if (item.api.response is String) {
        String typeString = Contracts.getTypeString(item.api.response);
        TypeToken? type = Contracts.getTypeByString(typeString + "?");
        if (type == null) {
          var import = item.api.import;
          //判断import中是否有包含，如果没有包含，提示用户没有该类型
          if (import != null && import[typeString] != null) {
            //导入外部依赖
            _addDependence(DependencySpec.import(import[typeString]!));
            respClassName = typeString;
          }
        }
      } else if (item.api.response is Map && item.api.response.isNotEmpty) {
        _addDependence(DependencySpec.import(
            "bean/${item.respClassName}" + Contracts.genDartExtension));
      }
      if (hasUrlParam) {
        _addDependence(DependencySpec.import(
            "bean/${item.pathParamClassName}" + Contracts.genDartExtension));
      }
      List<ParameterSpec> paramList = List.empty(growable: true);
      String pathParam = "";
      if (hasPathParam) {
        item.api.urlPathParam!.forEach((key, value) {
          pathParam += key + ",";
          paramList.add(ParameterSpec.build(key, type: TypeToken.ofString()));
        });
      }
      if (hasUrlParam) {
        paramList.add(ParameterSpec.build("param",
            type: TypeToken.ofName(item.pathParamClassName)));
      }
      String method = item.api.method.toLowerCase();
      if (hasParam) {
        var type = TypeToken.ofName(item.paramClassName);
        if (item.api.request is String) {
          String typeString = Contracts.getTypeString(item.api.request);
          type = TypeToken.ofName(typeString);
        }
        if (isParamList) {
          type = TypeToken.ofListByTokenN(type);
        }
        paramList.add(ParameterSpec.build("data", type: type));
      }
      String codeString = 'Request.$method(';
      if (hasPathParam) {
        codeString +=
            "Request.getUrl(\"${item.api.url}\", <String>[${pathParam.substring(0, pathParam.length - 1)}])";
        if (hasParam) {
          codeString += ", data: data";
        }
        if (hasUrlParam) {
          codeString += ", params: param.toJson()";
        }
        if (hasHeader) {
          List<String> headerStringList = [];
          item.api.headers!.forEach((key, value) {
            headerStringList.add("\"" + key + "\": \"" + value.toString() + "\"");
          });
          String headerString = "{" + headerStringList.join(",") + "}";
          codeString += ", headers: $headerString";
        }
        codeString += ")";
      } else {
        codeString += "\"${item.api.url}\"";
        if (hasParam) {
          codeString += ", data: data";
        }
        if (hasUrlParam) {
          codeString += ", params: param.toJson()";
        }
        if (hasHeader) {
          List<String> headerStringList = [];
          item.api.headers!.forEach((key, value) {
            headerStringList.add("\"" + key + "\": \"" + value.toString() + "\"");
          });
          String headerString = "{" + headerStringList.join(",") + "}";
          codeString += ", headers: $headerString";
        }
        codeString += ")";
      }
      TypeToken returnType;
      if (hasResp) {
        if (item.api.response is String) {
          codeString += "\n.then((value) => $respClassName.fromJson(value));";
          codeString = "return " + codeString;
          String typeString = Contracts.getTypeString(item.api.response);
          if (typeString != null) {
            returnType = TypeToken.ofName(
                "Future", [TypeToken.ofNameN(typeString)]);
          } else {
            returnType = TypeToken.ofName(
                "Future", [TypeToken.ofStringN()]);
          }
        } else {
          codeString += "\n.then((value) => $respClassName.fromJson(value));";
          codeString = "return " + codeString;
          returnType = TypeToken.ofName(
              "Future", [TypeToken.ofName("$className${Contracts.suffixResp}")]);
        }
      } else {
        codeString += ";";
        returnType = TypeToken.ofName("Future");
      }

      MethodSpec methodItem = MethodSpec.build(methodName,
          doc: DocSpec.text(item.api.description),
          isStatic: true,
          parameters: paramList,
          returnType: returnType,
          codeBlock: CodeBlockSpec.lines([codeString]),
          asynchronousMode: AsynchronousMode.asyncFuture);
      methodList.add(methodItem);
    });
    return methodList;
  }

  void _addDependence(DependencySpec item) {
    if (!mDependencies.contains(item)) {
      mDependencies.add(item);
    } else {
      // Log.log("include dependence");
    }
  }
}
