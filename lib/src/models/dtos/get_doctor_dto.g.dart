// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_doctor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDoctorDto _$GetDoctorDtoFromJson(Map<String, dynamic> json) => GetDoctorDto(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      clinicId: json['clinicId'] as String?,
      departmentId: json['departmentId'] as String?,
    );

Map<String, dynamic> _$GetDoctorDtoToJson(GetDoctorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'clinicId': instance.clinicId,
      'departmentId': instance.departmentId,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
    };
