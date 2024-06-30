import 'package:flutter_test/flutter_test.dart';

import 'package:auto_net/auto_net.dart';
import '../bin/utils/Contracts.dart';

void main() {

  Map<String, String> typeCheck = {
    "[int] int": "int",
    "[Integer] int": "Integer",
    "[double] int": "double",
    "[Double] int": "Double",
    "[boolean] int": "boolean",
    "[Boolean] int": "Boolean",
    "[bool] int": "bool",
    "[Bool] int": "Bool",
    "[object] int": "object",
    "[Object] int": "Object",
    "[map] int": "map",
    "[Map] int": "Map",
    "[<T>] int": "<T>",
    "[empty] int": "empty",
  };

  test('get comment type', () {
    typeCheck.forEach((key, value) {
      expect(Contracts.getTypeString(key), value);
    });
  });

  Map<String, String> commentCheck = {
    "[Object] dynamic": "dynamic",
    "[Map] mapData": "mapData",
    "[<T>] info": "info",
    "[empty]": "",
  };

  test('get comment data', () {
    commentCheck.forEach((key, value) {
      expect(Contracts.getComment(key), value);
    });
  });

  test('get url', () {
    RegExp typeReg = new RegExp(r"{([\S].*?)}");
    List<String> data =  <String>["t", "n"];
    int count = 0;
    String result = "{type}/{name}".replaceAllMapped(typeReg, (match) {
      print(match.input);
      print(match.start);
      print(match.groupCount);
      print(match.group(1));
      return data[count++];
    } );
    print(result);

  });
}
