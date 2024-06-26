import 'dart:convert';

import 'package:dartpoet/dartpoet.dart';

class PropertySpec implements Spec {
  DocSpec? doc;
  TypeToken? type;
  String name;
  dynamic defaultValue;
  List<MetaSpec>? metas = [];

  PropertySpec.of(
    this.name, {
    this.doc,
    this.type,
    this.defaultValue,
    this.metas,
  }) {
    metas ??= [];
  }

  PropertySpec.ofDynamic(
    String name, {
    DocSpec? doc,
    dynamic defaultValue,
    List<MetaSpec>? metas,
  }) : this.of(
          name,
          doc: doc,
          type: TypeToken.ofDynamic(),
          defaultValue: defaultValue,
          metas: metas,
        );

  PropertySpec.ofString(
    String name, {
    DocSpec? doc,
    String? defaultValue,
    List<MetaSpec>? metas,
  }) : this.of(
          name,
          doc: doc,
          type: TypeToken.ofString(),
          defaultValue: defaultValue,
          metas: metas,
        );

  PropertySpec.ofInt(
    String name, {
    DocSpec? doc,
    int? defaultValue,
    List<MetaSpec>? metas,
  }) : this.of(
          name,
          doc: doc,
          type: TypeToken.ofInt(),
          defaultValue: defaultValue,
          metas: metas,
        );

  PropertySpec.ofDouble(
    String name, {
    DocSpec? doc,
    double? defaultValue,
    List<MetaSpec>? metas,
  }) : this.of(
          name,
          doc: doc,
          type: TypeToken.ofDouble(),
          defaultValue: defaultValue,
          metas: metas,
        );

  PropertySpec.ofBool(
    String name, {
    DocSpec? doc,
    bool? defaultValue,
    List<MetaSpec>? metas,
  }) : this.of(
          name,
          doc: doc,
          type: TypeToken.ofBool(),
          defaultValue: defaultValue,
          metas: metas,
        );

  static PropertySpec ofListByToken(
    String name, {
    TypeToken? componentType,
    DocSpec? doc,
    List? defaultValue,
    List<MetaSpec>? metas,
  }) {
    return PropertySpec.of(name,
        type: TypeToken.ofListByToken(componentType ?? TypeToken.ofDynamic()),
        metas: metas,
        doc: doc,
        defaultValue: defaultValue);
  }

  static PropertySpec ofList<T>(
    String name, {
    DocSpec? doc,
    List? defaultValue,
    List<MetaSpec>? metas,
  }) {
    return ofListByToken(name, doc: doc, defaultValue: defaultValue, metas: metas, componentType: TypeToken.of(T));
  }

  static PropertySpec ofMapByToken(
    String name,
    TypeToken keyType,
    TypeToken valueType, {
    DocSpec? doc,
    Map? defaultValue,
    List<MetaSpec>? metas,
  }) {
    return PropertySpec.of(name,
        type: TypeToken.ofMapByToken(keyType, valueType), metas: metas, doc: doc, defaultValue: defaultValue);
  }

  static PropertySpec ofMap<K, V>(
    String name, {
    DocSpec? doc,
    Map? defaultValue,
    List<MetaSpec>? metas,
  }) {
    return ofMapByToken(name, TypeToken.of(K), TypeToken.of(V), metas: metas, doc: doc, defaultValue: defaultValue);
  }

  String _getType() {
    return type == null ? 'dynamic' : type!.fullTypeName;
  }

  String _formatValue(dynamic val) {
    if (val == null) {
      return 'null';
    }
    if (isPrimitive(val!.runtimeType)) return val.toString();
    if (val is List || val is Map) return jsonEncode(val);
    return val.toString();
  }

  @override
  String code({Map<String, dynamic> args = const {}}) {
    bool withDefValue = args[KEY_WITH_DEF_VALUE] ?? false;
    var raw = '${_getType()} $name';
    if (withDefValue && defaultValue != null) raw += '=${_formatValue(defaultValue)}';
    raw += ';';
    raw = collectWithMeta(metas, raw);
    raw = collectWithDoc(doc, raw);
    return raw;
  }
}

String collectProperties(List<PropertySpec> properties) {
  return properties.map((o) => o.code(args: {KEY_WITH_DEF_VALUE: true})).join('\n');
}
