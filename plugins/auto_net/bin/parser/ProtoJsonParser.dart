import 'dart:convert';
import 'dart:io';
import '../utils/Contracts.dart';
import '../utils/Log.dart';
import '../parser/NetFile.dart';
import '../parser/NetApi.dart';
import 'package:path/path.dart' as path;

import 'BeanFile.dart';

/// 协议文件解析器
class ProtoJsonParser {
  List<NetFile> mNetFileList = new List.empty(growable: true);
  List<BeanFile> mBeanFileList = new List.empty(growable: true);

  //解析某个文件夹下的json
  void parseDir(Directory jsonDir) {
    workDir(jsonDir, mNetFileList);
  }

  /// 解析协议数据
  void workDir(Directory current, List<NetFile> outList) {
    List<FileSystemEntity> fileList = current.listSync();
    fileList.forEach((itemFile) {
      FileSystemEntityType type = FileSystemEntity.typeSync(itemFile.path);
      switch (type) {
        case FileSystemEntityType.directory:
          Log.log("find protoJson directory");
          if (!itemFile.path.endsWith("bean")) {
            //非bean目录下的json统一生成为bean
            workDir(Directory.fromUri(itemFile.uri), outList);
          } else {
            workBeanDir(Directory.fromUri(itemFile.uri), mBeanFileList);
          }
          break;
        case FileSystemEntityType.file:
          String fileName = itemFile.path.split(path.separator).last;
          String fileContent = File(itemFile.path).readAsStringSync();
          NetApi api = NetApi.fromJson(json.decode(fileContent));
          String? className = api.name;
          if (className == null || className.isEmpty) {
            className = Contracts.getClassNameByFileName(fileName);
          }
          outList.add(NetFile(
              fileName,
              api,
              className + Contracts.suffixParam,
              className + Contracts.suffixPathParam,
              className + Contracts.suffixResp,
              fileName));
          break;
        case FileSystemEntityType.link:
          Log.log(
              "Directory of ProtoJson contains Link file, please check it carefully: \n ${itemFile.path}");
          break;
      }
    });
  }

  /// 解析bean数据
  void workBeanDir(Directory current, List<BeanFile> outList) {
    Log.log("find bean directory");
    List<FileSystemEntity> fileList = current.listSync();
    fileList.forEach((itemFile) {
      FileSystemEntityType type = FileSystemEntity.typeSync(itemFile.path);
      switch (type) {
        case FileSystemEntityType.directory:
          Log.log("bean directory can't contain directory");
          break;
        case FileSystemEntityType.file:
          String className = itemFile.path.split(path.separator).last.split(".")[0];
          String fileContent = File(itemFile.path).readAsStringSync();
          Map<String, dynamic> info = json.decode(fileContent);
          BeanFile item = new BeanFile(className, info);
          outList.add(item);
          break;
        case FileSystemEntityType.link:
          Log.log(
              "Directory of ProtoJson contains Link file, please check it carefully: \n ${itemFile.path}");
          break;
      }
    });
  }

  ///获取解析好的NetFile
  List<NetFile> getFileList() {
    return mNetFileList;
  }

  ///获取解析好的NetFile
  List<BeanFile> getBeanFileList() {
    return mBeanFileList;
  }
}
