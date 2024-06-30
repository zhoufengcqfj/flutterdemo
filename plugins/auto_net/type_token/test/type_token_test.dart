
void main() {

  var name = resolveTypeName("String?");
  print(name);
  var name1 = resolveTypeName("List<String>?");
  print(name1);
  var name2 = _getGenericsString("List<String>?");
  print(name2);
  var name3 = _getGenericsString("List<String?>?");
  print(name3);
  var name4 = _splitGenerics("List<String?, int?>");
  print(name4);
}

String? resolveTypeName(String fullTypeName) {
  RegExp regex = RegExp("([a-zA-Z0-9\$_]+)(<((.+))>)?");
  return regex.firstMatch(fullTypeName)?.group(1);
}

String? _getGenericsString(String typeName) {
  var regex = RegExp("[a-zA-Z0-9\$_]+<((.+))>");
  if (regex.hasMatch(typeName)) {
    return regex.firstMatch(typeName)?.group(1);
  } else {
    return null;
  }
}

Iterable<String> _splitGenerics(String genericsString) sync* {
  if (genericsString == null) {
    yield* [];
  } else {
    genericsString = genericsString.replaceAll(" ", "");
    String tmp = "";
    bool output = true;
    for (var idx = 0; idx < genericsString.length; idx++) {
      String s = genericsString[idx];
      if (s == ",") {
        if (output) {
          yield tmp;
          tmp = "";
        } else {
          tmp += s;
        }
      } else if (s == "<") {
        output = false;
        tmp += s;
      } else if (s == ">") {
        output = true;
        tmp += s;
      } else {
        tmp += s;
      }
    }
    yield tmp;
  }
}