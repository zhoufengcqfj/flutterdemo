import 'dart:convert';
import 'dart:io';
import '../utils/Contracts.dart';
import '../utils/Log.dart';
import '../parser/NetFile.dart';
import '../parser/NetApi.dart';
import 'package:path/path.dart' as path;

import 'BeanFile.dart';

/// 协议文件解析器
class BeanJsonParser {
  List<BeanFile> mBeanFileList = new List.empty(growable: true);

  //解析某个文件夹下的json
  void parseDir(Directory jsonDir) {
    workBeanDir(jsonDir, mBeanFileList, "");
  }

  /// 解析协议数据
  void workBeanDir(Directory current, List<BeanFile> outList, String moduleName) {
    List<FileSystemEntity> fileList = current.listSync();
    fileList.forEach((itemFile) {
      FileSystemEntityType type = FileSystemEntity.typeSync(itemFile.path);
      switch (type) {
        case FileSystemEntityType.directory:
          String fileName = itemFile.path.split(path.separator).last;
          workBeanDir(Directory.fromUri(itemFile.uri), outList, fileName);
          break;
        case FileSystemEntityType.file:
          String fileName = itemFile.path.split(path.separator).last;
          String fileContent = File(itemFile.path).readAsStringSync();
          var beanInfo = json.decode(fileContent);
          outList.add(BeanFile(
              fileName,
              beanInfo,module: moduleName));
          break;
        case FileSystemEntityType.link:
          Log.log(
              "Directory of ProtoJson contains Link file, please check it carefully: \n ${itemFile.path}");
          break;
      }
    });
  }

  ///获取解析好的NetFile
  List<BeanFile> getBeanFileList() {
    return mBeanFileList;
  }
}
