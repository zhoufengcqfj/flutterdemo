import 'package:dartpoet/dartpoet.dart';

class DocSpec implements Spec {
  String content;

  DocSpec.text(this.content);

  @override
  String code({Map<String, dynamic> args = const {}}) {
    return getComment(content);
  }

  String getComment(String a) {
    var result = '';
    a.split('\n').forEach((element) {
      result += '///' + element;
      result += '\n';
    });
    return result.substring(0, result.length - 1);
  }
}

String collectWithDoc(DocSpec? doc, String raw) {
  if (doc == null) return raw;
  return '${doc.code()}\n$raw';
}
