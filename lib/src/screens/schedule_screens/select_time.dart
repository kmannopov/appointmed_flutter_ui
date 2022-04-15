import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:appointmed/src/screens/patient_screens/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class SelectTime extends StatefulWidget {
  final String doctorId;
  const SelectTime({Key? key, required this.doctorId}) : super(key: key);

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  DateTime? appointmentTime;
  final _appointmentRepository = AppointmentRepository();
  List<DateTime>? availableTimes;
  final _formKey = GlobalKey<FormState>();

  void _getAvailableTimes() async {
    await _appointmentRepository
        .getAvailableTimes(widget.doctorId)
        .then((value) {
      setState(() {
        availableTimes = value;
      });
    });
  }

  void _scheduleAppointment() async {
    var result = await _appointmentRepository.scheduleAppointment(
      doctorId: widget.doctorId,
      patientId: (await const FlutterSecureStorage().read(key: 'userId'))!,
      appointmentTime: appointmentTime!,
    );

    if (result) {
      Navigator.push(
          context,
          PageTransition(
              child: const PatientHome(),
              type: PageTransitionType.rightToLeftWithFade));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (availableTimes == null) {
      _getAvailableTimes();
    }
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: (availableTimes != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Form(
                      key: _formKey,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          label: const Text("Choose a Time*"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'Field must not be empty' : null,
                        isExpanded: true,
                        items: availableTimes!
                            .map<DropdownMenuItem<String>>((DateTime value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(
                                DateFormat('E, dd MMM, hh:mma').format(value)),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            appointmentTime = DateTime.parse(value!);
                          });
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _scheduleAppointment();
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      )),
                      minimumSize: MaterialStateProperty.all<Size>(
                          Size(MediaQuery.of(context).size.width * 0.9, 65)),
                    ),
                    child: const Text('Book Appointment'),
                  )
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
