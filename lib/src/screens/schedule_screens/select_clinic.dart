import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/models/address.dart';
import 'package:appointmed/src/models/clinic.dart';
import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:appointmed/src/screens/clinic_screens/clinic_detail.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SelectClinicScreen extends StatefulWidget {
  final String category;
  const SelectClinicScreen({Key? key, required this.category})
      : super(key: key);

  @override
  State<SelectClinicScreen> createState() => _SelectClinicScreenState();
}

class _SelectClinicScreenState extends State<SelectClinicScreen> {
  final _appointmentRepository = AppointmentRepository();
  List<Clinic> clinics = [];

  @override
  void initState() {
    getClinics();
    super.initState();
  }

  void getClinics() async {
    try {
      var result =
          await _appointmentRepository.getClinicsByDept(widget.category);
      setState(() {
        clinics = result;
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
        child: (clinics.isEmpty)
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                const Text(
                  "Please select a clinic: ",
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
                      for (var clinic in clinics)
                        ClinicCard(
                          clinicName: clinic.name,
                          address: clinic.address,
                          departmentId: clinic.departments
                              .where(
                                  (element) => element.name == widget.category)
                              .first
                              .id,
                        )
                    ],
                  ),
                ),
              ]),
      ),
    );
  }
}

class ClinicCard extends StatelessWidget {
  final String img = 'assets/icons/clinic_icon.png';
  final String clinicName;
  final Address address;
  final String departmentId;

  const ClinicCard({
    Key? key,
    required this.clinicName,
    required this.address,
    required this.departmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Card(
        margin: const EdgeInsets.only(bottom: 20),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: ClinicDetail(
                        clinicName: clinicName,
                        clinicAddress: address,
                        departmentId: departmentId),
                    type: PageTransitionType.rightToLeftWithFade));
          },
          child: Row(
            children: [
              Container(
                color: Color(Palette.grey01),
                child: Image(
                  width: 100,
                  image: AssetImage(img),
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
                      clinicName,
                      style: TextStyle(
                        color: Color(Palette.header01),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${address.city}, ${address.district}, ${address.street}",
                      style: TextStyle(
                        color: Color(Palette.grey02),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Color(Palette.yellow02),
                          size: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '4.0 - 50 Reviews',
                          style: TextStyle(color: Color(Palette.grey02)),
                        )
                      ],
                    )
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
