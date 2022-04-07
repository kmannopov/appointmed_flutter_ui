import 'package:json_annotation/json_annotation.dart';

part 'doctor.g.dart';

@JsonSerializable(explicitToJson: true)
class Doctor {
  final String firstName, lastName, gender, email, phoneNumber;
  final String? clinicId, departmentId;
  final DateTime dateOfBirth;

  Doctor(
      {required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.email,
      this.clinicId,
      this.departmentId});

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
