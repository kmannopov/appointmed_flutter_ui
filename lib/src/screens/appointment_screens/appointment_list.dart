import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/models/appointment.dart';
import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:appointmed/src/screens/appointment_screens/appointment_card.dart';
import 'package:flutter/material.dart';

class AppointmentList extends StatefulWidget {
  final String role;
  const AppointmentList({Key? key, required this.role}) : super(key: key);

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  final _appointmentRepository = AppointmentRepository();
  List<Appointment> appointments = [];

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  void getAppointments() async {
    try {
      var result;
      if (widget.role == "Patient") {
        result = await _appointmentRepository.getPatientAppointments();
      } else if (widget.role == "Doctor") {
        result = await _appointmentRepository.getDoctorAppointments();
      }
      setState(() {
        appointments = result;
      });
    } catch (error) {
      ErrorDialog.show(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 40),
        child: (appointments.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                const Text(
                  "Your appointments: ",
                  style: TextStyle(
                    color: Palette.mainColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: ListView(
                    children: [
                      for (var appointment in appointments)
                        AppointmentCard(
                            appointment: appointment, role: widget.role),
                    ],
                  ),
                ),
              ]),
      ),
    );
  }
}
