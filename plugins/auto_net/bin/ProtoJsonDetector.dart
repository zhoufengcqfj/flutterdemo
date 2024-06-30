import 'dart:io';

import 'utils/Contracts.dart';

///协议检测器，检测根目录下的Contracts.protoJsonDir定义的目录
class ProtoJsonDetector {

  Directory rootDir = Contracts.getRoot();

  Future<bool> isExist() {
    return getProtoJsonDir(rootDir).exists();
  }

  Future<bool> isBeanExist() {
    return getBeanJsonDir(rootDir).exists();
  }

  Future<bool> isExistSubProject(Directory subProject) {
    return getProtoJsonDir(subProject).exists();
  }

  //定义通过工具生成协议的目录地址
  Directory getProtoJsonDir(Directory subProject) {
    return Directory("${subProject.path}${Contracts.protoJsonDir}");
  }

  //定义通过工具生成bean的目录地址
  Directory getBeanJsonDir(Directory subProject) {
    return Directory("${subProject.path}${Contracts.beanJsonDir}");
  }

  Directory getRootBeanJsonDir() {
    return getBeanJsonDir(rootDir);
  }

  Directory getRootProtoJsonDir() {
    return getProtoJsonDir(rootDir);
  }

}