import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable()
class Appointment {
  String clinicId,
      clinicName,
      doctorId,
      doctorName,
      patientId,
      status,
      notes,
      id;
  DateTime createdDate, dateTime;

  Appointment(
      {required this.clinicId,
      required this.clinicName,
      required this.doctorId,
      required this.doctorName,
      required this.patientId,
      required this.status,
      required this.notes,
      required this.id,
      required this.createdDate,
      required this.dateTime});

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
