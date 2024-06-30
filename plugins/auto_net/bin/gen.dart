import 'dart:io';

import 'ProtoJsonDetector.dart';
import 'parser/ProtoJsonParser.dart';
import 'utils/Contracts.dart';
import 'utils/Log.dart';
import 'writer/BeanWriter.dart';
import 'writer/ProtoJsonApiWriter.dart';
import 'writer/ProtoJsonWriter.dart';

/// 协议生成入口
void main() {
  Log.log("apply autoNet plugin");

  //解析根目录
  ProtoJsonDetector detector = ProtoJsonDetector();
  ProtoJsonParser rootParser = ProtoJsonParser();
  ProtoJsonWriter rootWriter =
      ProtoJsonWriter(Contracts.getOutputDir(Contracts.getRoot()));
  ProtoJsonApiWriter rootApiWriter =
      ProtoJsonApiWriter(Contracts.getOutputDir(Contracts.getRoot()));

  detector.isExist().then((value) {
    if (value) {
      rootParser.parseDir(detector.getRootProtoJsonDir());
    } else {
      Log.log("Can't find protoJson defined in root project!!!\n" +
              " You can run genHelp command to see how to Define!!!");
    }
  }).then((value) {
    rootParser.getFileList().forEach((itemFile) {
      //生成bean
      rootWriter.doWrite(itemFile);
    });
    rootApiWriter.doWrite(rootParser.getFileList());
  }).then((value) {
    //生成BeanJson中的bean
    rootParser.getBeanFileList().forEach((itemFile) {
      Directory outDir =
          Contracts.getBeanDir(Contracts.getOutputDir(Contracts.getRoot()));
      BeanWriter(itemFile.fileName, itemFile.info, outDir,
              "bean文件夹下${itemFile.fileName}.json中定义的bean类\n${itemFile.info["description"]}",
      import: (itemFile.info["import"] as Map<String, String>?) ?? {})
          .doWrite();
    });
  });

  //解析插件
}
