import 'package:json_annotation/json_annotation.dart';


part 'account_info_entity.g.dart';

@JsonSerializable()
class AccountInfoEntity {

	final bool? admin;

	final String? email;

	final Address? address;


	AccountInfoEntity({required this.admin,required this.email,required this.address});
  factory AccountInfoEntity.fromJson(Map<String, dynamic> json) => _$AccountInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoEntityToJson(this);

}

@JsonSerializable()
class Address {
	final String street;
	final String city;
	final String zipCode;

	Address({required this.street, required this.city, required this.zipCode});

	/// 从JSON映射转换为Address对象的工厂方法
	factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

	/// 将Address对象转换为JSON映射的方法
	Map<String, dynamic> toJson() => _$AddressToJson(this);
}