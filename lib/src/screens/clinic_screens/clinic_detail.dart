import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/models/address.dart';
import 'package:appointmed/src/screens/schedule_screens/select_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart" as lat_long;
import 'package:page_transition/page_transition.dart';

class ClinicDetail extends StatelessWidget {
  const ClinicDetail(
      {Key? key,
      required this.clinicName,
      required this.clinicAddress,
      required this.departmentId})
      : super(key: key);

  final String clinicName;
  final Address clinicAddress;
  final String departmentId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(clinicName),
            backgroundColor: Palette.primary,
            expandedHeight: 200,
            flexibleSpace: const FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/images/hospital.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(
              clinicAddress: clinicAddress,
              clinicName: clinicName,
              departmentId: departmentId,
            ),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final String clinicName;
  final Address clinicAddress;
  final String departmentId;
  const DetailBody({
    Key? key,
    required this.clinicName,
    required this.clinicAddress,
    required this.departmentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailClinicCard(clinicName: clinicName, address: clinicAddress),
          const SizedBox(
            height: 15,
          ),
          const ClinicInfo(),
          const SizedBox(
            height: 30,
          ),
          Text(
            'About',
            style: Palette.kTitleStyle,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Having been in service for over 15 years, this clinic is one of the best in the country. It is a family owned and operated hospital with a reputation for quality healthcare and excellent patient care.',
            style: TextStyle(
              color: Color(Palette.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Location',
            style: Palette.kTitleStyle,
          ),
          const SizedBox(
            height: 25,
          ),
          ClinicLocation(clinicAddress: clinicAddress),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              )),
              minimumSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * 0.9, 65)),
            ),
            child: const Text('Book Appointment'),
            onPressed: () => {
              Navigator.push(
                  context,
                  PageTransition(
                      child: SelectDoctorScreen(departmentId: departmentId),
                      type: PageTransitionType.rightToLeftWithFade))
            },
          )
        ],
      ),
    );
  }
}

class ClinicLocation extends StatelessWidget {
  final Address clinicAddress;
  const ClinicLocation({
    Key? key,
    required this.clinicAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            center: lat_long.LatLng(
                clinicAddress.latitude, clinicAddress.longitude),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: lat_long.LatLng(
                      clinicAddress.latitude, clinicAddress.longitude),
                  builder: (ctx) => const Icon(Icons.pin_drop_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClinicInfo extends StatelessWidget {
  const ClinicInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        NumberCard(
          label: 'Patients',
          value: '1000+',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Open Since',
          value: '2007',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Rating',
          value: '4.0',
        ),
      ],
    );
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(Palette.bg03),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(Palette.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(Palette.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailClinicCard extends StatelessWidget {
  final String clinicName;
  final Address address;
  const DetailClinicCard({
    Key? key,
    required this.clinicName,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicName,
                    style: TextStyle(
                        color: Color(Palette.header01),
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${address.region}, ${address.city}, ${address.district}, ${address.street}",
                    style: TextStyle(
                      color: Color(Palette.grey02),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
