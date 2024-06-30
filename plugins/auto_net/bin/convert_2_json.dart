import 'dart:io';

import 'utils/Contracts.dart';

var tags = {
  "request": "request",
  "head": "headers",
  "response": "response",
  "description": "description",
  "httpmethod": "method",
  "urlpathparam": "urlPathParam",
  "urlparam": "urlParam",
  "uri":"url"
};

RegExp protoJsonRex(String name) {
  return RegExp("=== $name\\s.*?(([\\s\\S]*?)?\\s.*?)===");
}

String _convertTag(String content, String tag, {bool required = true}) {
  var requestExp = protoJsonRex(tag);
  var match = requestExp.firstMatch(content);
  if (match != null) {
    var result = content.substring(match.start, match.end);

    if (tag == 'httpmethod') {
      result =
          '"${tags[tag]}": "${result.substring(result.indexOf(tag) + tag.length, result.lastIndexOf('===')).trim()}"';
    } else {
      result = result.replaceAll('===', '');
      result = result.replaceFirst(tag, '"${tags[tag]}":');
    }

    if (match.end != content.length) {
      result = result + ',';
    }
    return content.replaceRange(match.start, match.end, result);
  }else if(required){
    throw Exception('$tag is required');
  }
  return content;
}

_convertDesc(String content, {bool required = true}) {
  var tag = 'description';
  var requestExp = protoJsonRex(tag);
  var match = requestExp.firstMatch(content);
  if (match != null) {
    var result = content.substring(match.start, match.end).replaceAll(RegExp(r"\s+\b|\b\s"), '');
    var desc = '接口注释：';
    var uriInfo = 'URI信息：';
    var divider = '===';

    var url = result
        .substring(result.indexOf(uriInfo) + uriInfo.length,
            result.lastIndexOf(divider))
        .trim();
    url = url.replaceFirst('uri', 'url');
    // url = url.replaceFirst('：', ":");

    var descJson =
        '"${tags[tag]}":"${result.substring(result.indexOf(desc) + desc.length, result.indexOf(uriInfo)).trim()}",';

    descJson = descJson + '\n';
    descJson = '$descJson$url';


    if (match.end != content.length) {
      descJson = descJson + ',';
    }
    return content.replaceRange(match.start, match.end, descJson);
  }else if(required){
    throw Exception('$tag is required');
  }
  return content;
}

_convertFile(String path){
  try {
    var file = File(path);
    if (file.existsSync() && !file.path.endsWith('.json')) {
      var content = file.readAsStringSync();
      content = _convertTag(content, "request");
      content = _convertTag(content, "head");
      content = _convertTag(content, "response");
      content = _convertTag(content, "urlpathparam");
      content = _convertTag(content, "urlparam");
      content = _convertTag(content, "httpmethod");
      content = _convertDesc(content);

      file.writeAsStringSync("{$content}");

      var name = file.path.substring(file.parent.path.length);
      name = name.replaceAll(".", '');
      name = name + '.json';
      file = file.renameSync(file.parent.path + "\\" + name);
    }
  } catch (e) {
    print('$path');
    print('convert failed  ${e.toString()}');
  }
}

_convertInDir(Directory dir){
  if (dir.existsSync()) {
    dir.listSync().forEach((element) {
      if(FileSystemEntity.isDirectorySync(element.path)){
        _convertInDir(Directory(element.path));
      }else{
        _convertFile(element.path);
      }
    });
  }
}

void main() {
  _convertInDir(Directory(Contracts.getRoot().path + Contracts.protoJsonDir));
}
