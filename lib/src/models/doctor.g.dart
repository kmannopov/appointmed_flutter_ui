// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Doctor _$DoctorFromJson(Map<String, dynamic> json) => Doctor(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      userId: json['userId'] as String?,
      clinicId: json['clinicId'] as String?,
      departmentId: json['departmentId'] as String?,
    );

Map<String, dynamic> _$DoctorToJson(Doctor instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'clinicId': instance.clinicId,
      'departmentId': instance.departmentId,
      'userId': instance.userId,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
    };
