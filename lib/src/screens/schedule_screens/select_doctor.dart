import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:appointmed/src/screens/schedule_screens/select_time.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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

  @override
  void initState() {
    getDoctors();
    super.initState();
  }

  void getDoctors() async {
    try {
      var result =
          await _appointmentRepository.getDoctorsByDept(widget.departmentId);
      setState(() {
        doctors = result;
      });
    } catch (error) {
      //ErrorDialog.show(context: widget.context, message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 40),
          child: (doctors.isEmpty)
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  const Text(
                    "Please select a doctor: ",
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
                        for (var doctor in doctors) DoctorCard(doctor: doctor)
                      ],
                    ),
                  ),
                ])),
    );
  }
}

class DoctorCard extends StatefulWidget {
  String img = 'assets/images/doctor-male.png';
  final Doctor doctor;

  DoctorCard({
    Key? key,
    required this.doctor,
  }) : super(key: key) {
    img = (doctor.gender == "Male")
        ? 'assets/images/doctor-male.png'
        : 'assets/images/doctor.png';
  }

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return GestureDetector(
                    onTap: () {},
                    child: SelectTime(doctorId: widget.doctor.userId!),
                    behavior: HitTestBehavior.opaque,
                  );
                });
          },
          child: Row(
            children: [
              Container(
                color: Color(Palette.grey01),
                child: Image(
                  width: 100,
                  image: AssetImage(widget.img),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.firstName + " " + widget.doctor.lastName,
                      style: TextStyle(
                        color: Color(Palette.header01),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "8 years of experience",
                      style: TextStyle(
                        color: Color(Palette.grey02),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
