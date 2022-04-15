import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/extensions/error_dialog.dart';
import 'package:appointmed/src/models/patient.dart';
import 'package:appointmed/src/repositories/patient_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

List<Map> doctors = [
  {
    'img': 'assets/icons/clinic_icon.png',
    'clinicName': 'Tashkent Cardiology Center',
    'Specialization': 'Cardiology'
  },
  {
    'img': 'assets/icons/clinic_icon.png',
    'clinicName': 'Tashkent International Clinic',
    'Specialization': 'General'
  },
  {
    'img': 'assets/icons/clinic_icon.png',
    'clinicName': 'Shox Med Clinic',
    'Specialization': 'General'
  },
  {
    'img': 'assets/icons/clinic_icon.png',
    'clinicName': 'Tashkent Endocrinology Center',
    'Specialization': 'Endocrinology'
  }
];

class PatientWelcomePage extends StatefulWidget {
  const PatientWelcomePage({Key? key}) : super(key: key);

  @override
  State<PatientWelcomePage> createState() => _PatientWelcomePageState();
}

class _PatientWelcomePageState extends State<PatientWelcomePage> {
  final storage = const FlutterSecureStorage();
  final _patientRepository = PatientRepository();
  Patient? patient;
  String? name;

  _PatientWelcomePageState() {
    getPatientInfo();
  }

  void getPatientInfo() async {
    var userId = await storage.read(key: 'userId');
    try {
      patient = await _patientRepository.getPatientById(userId!);
      setState(() {
        name = patient!.firstName + ' ' + patient!.lastName;
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
              height: 10,
            ),
            const SearchInput(),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Top Rated Clinics',
              style: TextStyle(
                color: Color(Palette.header01),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            for (var doctor in doctors)
              TopClinicCard(
                img: doctor['img'],
                clinicName: doctor['clinicName'],
                clinicSpecialization: doctor['Specialization'],
              )
          ],
        ),
      ),
    );
  }
}

class TopClinicCard extends StatelessWidget {
  String img;
  String clinicName;
  String clinicSpecialization;

  TopClinicCard({
    Key? key,
    required this.img,
    required this.clinicName,
    required this.clinicSpecialization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {},
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
            Column(
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
                  clinicSpecialization,
                  style: TextStyle(
                    color: Color(Palette.grey02),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
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
            )
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(Palette.bg),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(Palette.purple02),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for a clinic',
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(Palette.purple01),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
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
