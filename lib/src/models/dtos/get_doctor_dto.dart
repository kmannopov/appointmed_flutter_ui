import 'package:json_annotation/json_annotation.dart';

part 'get_doctor_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class GetDoctorDto {
  final String id, firstName, lastName, gender, email, phoneNumber;
  final String? clinicId, departmentId;
  final DateTime dateOfBirth;

  GetDoctorDto(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.email,
      this.clinicId,
      this.departmentId});

  factory GetDoctorDto.fromJson(Map<String, dynamic> json) =>
      _$GetDoctorDtoFromJson(json);
  Map<String, dynamic> toJson() => _$GetDoctorDtoToJson(this);
}
