class TypeToken {
  late String _typeName;
  bool _nullable = false;
  List<TypeToken> _generics = [];

  ///[typeName] input typeName can with ? e.g. String?
  TypeToken.ofName(String typeName, [List<TypeToken> generics = const []]) {
    _nullable = isTypeNullable(typeName);
    if (_nullable) {
      _typeName = typeName.substring(0, typeName.length - 1);
    } else {
      _typeName = typeName;
    }
    _generics.addAll(generics);
  }

  /// nullable
  TypeToken.ofNameN(String typeName, [List<TypeToken> generics = const []]) {
    _nullable = true;
    _typeName = typeName;
    _generics.addAll(generics);
  }

  TypeToken.ofName2(String typeName, [List<Type> generics = const []])
      : this.ofName(typeName, generics.map((o) => TypeToken.of(o)).toList());

  factory TypeToken.ofFullName(String fullTypeName) {
    String typeName = resolveTypeName(fullTypeName);
    List<TypeToken> generics = resolveGenerics(fullTypeName).toList();
    return TypeToken.ofName(typeName, generics);
  }

  factory TypeToken.parse(Object obj) => TypeToken.of(obj.runtimeType);
  factory TypeToken.parseN(Object obj) => TypeToken.ofFullName(obj.runtimeType.toString() + "?");

  factory TypeToken.of(Type type) => TypeToken.ofFullName(type.toString());

  factory TypeToken.ofN(Type type) => TypeToken.ofFullName(type.toString() + "?");

  factory TypeToken.ofDynamic() => TypeToken.of(dynamic);

  factory TypeToken.ofDynamicN() => TypeToken.ofN(dynamic);

  factory TypeToken.ofInt() => TypeToken.of(int);

  factory TypeToken.ofIntN() => TypeToken.ofN(int);

  factory TypeToken.ofString() => TypeToken.of(String);

  factory TypeToken.ofStringN() => TypeToken.ofN(String);

  factory TypeToken.ofDouble() => TypeToken.of(double);

  factory TypeToken.ofDoubleN() => TypeToken.ofN(double);

  factory TypeToken.ofBool() => TypeToken.of(bool);

  factory TypeToken.ofBoolN() => TypeToken.ofN(bool);

  factory TypeToken.ofVoid() => TypeToken.ofName("void");

  static TypeToken ofListByToken(TypeToken componentType) {
    return TypeToken.ofName('List', [componentType]);
  }

  static TypeToken ofListByTokenN(TypeToken componentType) {
    return TypeToken.ofName('List?', [componentType]);
  }

  static TypeToken ofListByType(Type componentType) {
    return TypeToken.ofListByToken(TypeToken.of(componentType));
  }

  static TypeToken ofListByTypeN(Type componentType) {
    return TypeToken.ofListByToken(TypeToken.ofN(componentType));
  }

  static TypeToken ofMapByToken(TypeToken keyType, TypeToken valueType) {
    return TypeToken.ofName('Map', [keyType, valueType]);
  }

  static TypeToken ofMapByTokenN(TypeToken keyType, TypeToken valueType) {
    return TypeToken.ofName('Map?', [keyType, valueType]);
  }

  static TypeToken ofMapByType(Type keyType, Type valueType) {
    return TypeToken.ofMapByToken(TypeToken.of(keyType), TypeToken.of(valueType));
  }

  static TypeToken ofMapByTypeN1(Type keyType, Type valueType) {
    return TypeToken.ofMapByToken(TypeToken.ofN(keyType), TypeToken.of(valueType));
  }

  static TypeToken ofMapByTypeN2(Type keyType, Type valueType) {
    return TypeToken.ofMapByToken(TypeToken.of(keyType), TypeToken.ofN(valueType));
  }

  static TypeToken ofList<T>() {
    return ofListByToken(TypeToken.of(T));
  }

  static TypeToken ofListN<T>() {
    return ofListByTokenN(TypeToken.of(T));
  }

  static TypeToken ofListN1<T>() {
    return ofListByTokenN(TypeToken.ofN(T));
  }

  static TypeToken ofMap<K, V>() {
    return ofMapByToken(TypeToken.of(K), TypeToken.of(V));
  }

  static TypeToken ofMapN<K, V>() {
    return ofMapByTokenN(TypeToken.of(K), TypeToken.of(V));
  }

  static TypeToken ofMapN1<K, V>() {
    return ofMapByTokenN(TypeToken.ofN(K), TypeToken.of(V));
  }

  static TypeToken ofMapN2<K, V>() {
    return ofMapByTokenN(TypeToken.of(K), TypeToken.ofN(V));
  }

  String get typeName => _typeName;

  bool get isNullable => _nullable;

  String get fullTypeName => typeName
      + (generics.isNotEmpty ? "<${generics.join(", ")}>" : "")
      + (_nullable ? "?" : "");

  bool get isPrimitive => ['int', 'double', 'bool', 'String'].contains(typeName);

  bool get isNotPrimitive => !isPrimitive;

  bool get isInt => typeName == 'int';

  bool get isDouble => typeName == 'double';

  bool get isBool => typeName == 'bool';

  bool get isString => typeName == 'String';

  bool get isList => typeName == "List";

  bool get isMap => typeName == "Map";

  bool get isDynamic => typeName == "dynamic";

  bool get isVoid => typeName == "void";

  List<TypeToken> get generics => _generics;

  TypeToken get firstGeneric => generics.first;

  TypeToken get secondGeneric => generics[1];

  bool get hasGeneric => generics.isNotEmpty;

  bool get isNativeType {
    try {
      nativeType;
      return true;
    } catch (e) {
      return false;
    }
  }

  Type get nativeType {
    if (isInt) return int;
    if (isDouble) return double;
    if (isBool) return bool;
    if (isString) return String;
    if (isList) return List;
    if (isMap) return Map;
    throw "this TypeToken is not native type: $fullTypeName";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TypeToken && runtimeType == other.runtimeType && _typeName == other._typeName;

  @override
  int get hashCode => _typeName.hashCode;

  @override
  String toString() => fullTypeName;

  TypeToken operator [](int index) => generics[index];
}

bool isPrimitive(Type type) => TypeToken.of(type).isPrimitive;

bool isInt(Type type) => TypeToken.of(type).isInt;

bool isDouble(Type type) => TypeToken.of(type).isDouble;

bool isBool(Type type) => TypeToken.of(type).isBool;

bool isString(Type type) => TypeToken.of(type).isString;

bool isList(Type type) => TypeToken.of(type).isList;

bool isMap(Type type) => TypeToken.of(type).isMap;

bool isTypeNullable(String typeName) {
  return typeName.endsWith("?");
}

var _typeReg = RegExp("([a-zA-Z0-9\$_]+)(<((.+))>)?");
String resolveTypeName(String fullTypeName) {
  bool nullable = isTypeNullable(fullTypeName);
  String name = _typeReg.firstMatch(fullTypeName)!.group(1)!;
  if(nullable) {
    name += "?";
  }
  return name;
}

Iterable<TypeToken> resolveGenerics(String fullTypeName) sync* {
  String? fullGeneric = _getGenericsString(fullTypeName);
  List<String> genericStrings = _splitGenerics(fullGeneric).toList();
  for (var genericString in genericStrings) {
    String? childGenericString = _getGenericsString(genericString);
    if (childGenericString == null) {
      yield TypeToken.ofName(genericString);
    } else {
      yield TypeToken.ofName(resolveTypeName(genericString), resolveGenerics(genericString).toList());
    }
  }
}

var _genericReg = RegExp("[a-zA-Z0-9\$_]+<((.+))>");
String? _getGenericsString(String typeName) {
  if (_genericReg.hasMatch(typeName)) {
    return _genericReg.firstMatch(typeName)?.group(1);
  } else {
    return null;
  }
}

Iterable<String> _splitGenerics(String? genericsString) sync* {
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
