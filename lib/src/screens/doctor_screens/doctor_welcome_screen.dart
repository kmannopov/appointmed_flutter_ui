import 'package:appointmed/src/models/clinic.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:appointmed/src/repositories/doctor_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DoctorWorkplacePage extends StatefulWidget {
  const DoctorWorkplacePage({Key? key}) : super(key: key);

  @override
  State<DoctorWorkplacePage> createState() => _DoctorWorkplacePageState();
}

class _DoctorWorkplacePageState extends State<DoctorWorkplacePage> {
  final storage = const FlutterSecureStorage();
  final _doctorRepository = DoctorRepository();
  final _appointmentRepository = AppointmentRepository();
  Doctor? doctor;
  Clinic? clinic;
  String? name;

  _DoctorWorkplacePageState() {
    getDoctorInfo();
  }

  void getDoctorInfo() async {
    var userId = await storage.read(key: 'userId');
    try {
      doctor = await _doctorRepository.getDoctorById(userId!);
      clinic = await _appointmentRepository.getClinicById(doctor!.clinicId!);
      setState(() {
        name = doctor!.firstName + ' ' + doctor!.lastName;
      });
    } catch (error) {
      //ErrorDialog.show(context: context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            UserIntro(
              name: name,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Current Workplace: "),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class UserIntro extends StatelessWidget {
  final String? name;

  const UserIntro({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                (name ?? ''),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/doctor-male.png'),
        )
      ],
    );
  }
}
