// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
      clinicId: json['clinicId'] as String,
      clinicName: json['clinicName'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String,
      id: json['id'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'clinicId': instance.clinicId,
      'clinicName': instance.clinicName,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'status': instance.status,
      'notes': instance.notes,
      'id': instance.id,
      'createdDate': instance.createdDate.toIso8601String(),
      'dateTime': instance.dateTime.toIso8601String(),
    };
