import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  final DateTime? dateOfBirth;
  final Function updateValue;

  const DatePicker({
    Key? key,
    required this.dateOfBirth,
    required this.updateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            child: const Text(
              "Date of Birth:",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.all(5),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(dateOfBirth == null
                      ? 'Please choose a date'
                      : DateFormat.yMMMd().format(dateOfBirth as DateTime)),
                ),
              ),
              TextButton(
                onPressed: () => _presentDatePicker(context),
                child: const Text(
                  'Choose Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _presentDatePicker(BuildContext context) async {
    var result = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 80)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      fieldHintText: "Date of Birth",
    );

    if (result == null) return;
    updateValue(result);
  }
}
