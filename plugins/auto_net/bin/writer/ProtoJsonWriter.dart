import 'dart:io';

import 'package:dartpoet/dartpoet.dart';

import '../parser/NetFile.dart';
import '../utils/Contracts.dart';
import '../utils/Log.dart';
import 'BeanWriter.dart';

///解析输出器，用于将解析到的协议输出相关文件到指定位置
class ProtoJsonWriter {
  Directory mOutDir;

  /// outDir 指定输出目录
  ProtoJsonWriter(this.mOutDir);

  void doWrite(NetFile netFile) {
    Directory outDir = Contracts.getBeanDir(mOutDir);
    if (!outDir.existsSync()) {
      outDir.createSync(recursive: true);
    }
    if (netFile.api.request != null && netFile.api.request!.isNotEmpty) {
      var requestInfo = netFile.api.request!;
      if (netFile.api.request is List) {
        requestInfo = netFile.api.request[0];
      }
      if (!(netFile.api.request is String)) {
        BeanWriter(netFile.paramClassName, requestInfo, outDir,
                "${netFile.api.description}的请求类\n参见${netFile.fileName}定义的${netFile.api.url}接口",
                import: netFile.api.import ?? {})
            .doWrite();
      }
    }
    if (netFile.api.urlParam != null &&
        netFile.api.urlParam!.isNotEmpty) {
      BeanWriter(netFile.pathParamClassName, netFile.api.urlParam!, outDir,
              "${netFile.api.description}的请求类\n参见${netFile.fileName}定义的${netFile.api.url}接口",
              import: netFile.api.import ?? {})
          .doWrite();
    }
    if (netFile.api.response is Map && netFile.api.response.isNotEmpty) {
      BeanWriter(netFile.respClassName, netFile.api.response, outDir,
              "${netFile.api.description}的请求类\n参见${netFile.fileName}定义的${netFile.api.url}接口",
              import: netFile.api.import ?? {})
          .doWrite();
    }
  }
}
