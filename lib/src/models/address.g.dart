// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      city: json['city'] as String,
      district: json['district'] as String,
      region: json['region'] as String,
      street: json['street'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'region': instance.region,
      'city': instance.city,
      'district': instance.district,
      'street': instance.street,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
