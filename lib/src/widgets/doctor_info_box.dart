import 'package:appointmed/config/palette.dart';
import 'package:flutter/material.dart';

class DoctorInfoBox extends StatelessWidget {
  DoctorInfoBox({
    Key? key,
    required this.value,
    required this.info,
    this.icon = Icons.info,
    this.color = Palette.primary,
  }) : super(key: key);
  IconData icon;
  Color color;
  String value;
  String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 40,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            info,
            style: const TextStyle(
                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
