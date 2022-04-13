import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:flutter/material.dart';

class SelectDoctorScreen extends StatefulWidget {
  final String departmentId;
  const SelectDoctorScreen({Key? key, required this.departmentId})
      : super(key: key);

  @override
  State<SelectDoctorScreen> createState() => _SelectDoctorScreenState();
}

class _SelectDoctorScreenState extends State<SelectDoctorScreen> {
  final _appointmentRepository = AppointmentRepository();
  List<Doctor> doctors = [];

  void getDoctors() async {
    try {
      // var result =
      //     await _appointmentRepository.getDoctorsByDept(widget.departmentId);
      // setState(() {
      //   doctors = result;
      // });
    } catch (error) {
      ErrorDialog.show(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
