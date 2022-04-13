import 'package:appointmed/src/models/address.dart';
import 'package:appointmed/src/models/department.dart';

import 'package:json_annotation/json_annotation.dart';

part 'clinic.g.dart';

@JsonSerializable(explicitToJson: true)
class Clinic {
  final String id;
  final String name;
  final Address address;
  final List<Department> departments;

  Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.departments,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicToJson(this);
}
