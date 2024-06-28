// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountInfoEntity _$AccountInfoEntityFromJson(Map<String, dynamic> json) =>
    AccountInfoEntity(
      admin: json['admin'] as bool?,
      email: json['email'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountInfoEntityToJson(AccountInfoEntity instance) =>
    <String, dynamic>{
      'admin': instance.admin,
      'email': instance.email,
      'address': instance.address,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      street: json['street'] as String,
      city: json['city'] as String,
      zipCode: json['zipCode'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'zipCode': instance.zipCode,
    };
