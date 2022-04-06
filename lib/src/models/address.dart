import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String region;
  String city;
  String district;
  String street;
  double latitude;
  double longitude;

  Address({
    required this.city,
    required this.district,
    required this.region,
    required this.street,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
