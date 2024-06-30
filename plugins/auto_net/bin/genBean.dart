import 'dart:io';

import 'ProtoJsonDetector.dart';
import 'parser/BeanJsonParser.dart';
import 'utils/Contracts.dart';
import 'utils/Log.dart';
import 'writer/BeanWriter.dart';

/// Bean生成入口
void main() {
  Log.log("apply autoNet plugin");

  //解析根目录
  ProtoJsonDetector detector = ProtoJsonDetector();
  BeanJsonParser rootParser = BeanJsonParser();

  detector.isBeanExist().then((value) {
    if (value) {
      Log.log("find beanJson directory");
      rootParser.parseDir(detector.getRootBeanJsonDir());
    } else {
      Log.log("Can't find beanJson defined in root project!!!\n" +
          " You can run genHelp command to see how to Define!!!");
    }
    return value;
  }).then((value) {
    if (!value) {
      return;
    }
    Directory outDir = Directory(detector.rootDir.path + "/lib");
    //生成Bean
    rootParser.getBeanFileList().forEach((itemFile) async {
      BeanWriter(itemFile.fileName.split(".").first, itemFile.info[Contracts.beanKey],
              outDir, "bean文件夹下${itemFile.fileName}.json中定义的bean类",
              module: itemFile.module,
              import: (itemFile.info["import"] as Map<String, String>?) ?? {},
              ex: (itemFile.info[Contracts.extendsKey] as Map<String, dynamic>?) ?? {})
          .doWrite();
    });
  }).onError((error, stackTrace) {
    print(stackTrace);
  });

  //解析插件
}
