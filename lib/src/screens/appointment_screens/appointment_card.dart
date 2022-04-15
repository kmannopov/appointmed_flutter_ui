import 'package:appointmed/config/palette.dart';
import 'package:appointmed/src/models/appointment.dart';
import 'package:appointmed/src/repositories/appointment_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentCard extends StatefulWidget {
  final Appointment appointment;
  final String role;
  const AppointmentCard(
      {Key? key, required this.appointment, required this.role})
      : super(key: key);

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  void _updateStatus(String status) async {
    try {
      var result = await AppointmentRepository().updateAppointmentStatus(
          appointmentId: widget.appointment.id, status: status);
      if (result) {
        setState(() {
          widget.appointment.status = status;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/doctor.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Clinic: " + widget.appointment.clinicName,
                      style: TextStyle(
                        color: Color(Palette.header01),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (widget.role == "Patient")
                          ? "Doctor: " + widget.appointment.doctorName
                          : "",
                      style: TextStyle(
                        color: Color(Palette.grey02),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            DateTimeCard(dateTime: widget.appointment.dateTime),
            const SizedBox(
              height: 15,
            ),
            if (widget.role == "Patient")
              (widget.appointment.status == "Scheduled")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            child: const Text('Cancel'),
                            onPressed:
                                (widget.appointment.status == "Scheduled")
                                    ? () {
                                        _showCancelDialog(context,
                                            () => _updateStatus("Cancelled"));
                                      }
                                    : null,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Check In'),
                            onPressed:
                                (widget.appointment.status == "Scheduled")
                                    ? () => {
                                          _showCheckInDialog(
                                            context,
                                            () => _updateStatus("Checked In"),
                                          )
                                        }
                                    : null,
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                        widget.appointment.status,
                        style: TextStyle(
                          color: Color(Palette.grey02),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            if (widget.role == "Doctor")
              (widget.appointment.status == "Checked In")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Expanded(
                        //   child: OutlinedButton(
                        //     child: const Text('Cancel'),
                        //     onPressed:
                        //         (widget.appointment.status == "Scheduled")
                        //             ? () {
                        //                 _showCancelDialog(context,
                        //                     () => _updateStatus("Cancelled"));
                        //               }
                        //             : null,
                        //   ),
                        // ),
                        // const SizedBox(
                        //   width: 20,
                        // ),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text('Complete'),
                            onPressed:
                                (widget.appointment.status == "Checked In")
                                    ? () => {
                                          _showCompleteDialog(
                                            context,
                                            () => _updateStatus("Complete"),
                                          )
                                        }
                                    : null,
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text(
                        widget.appointment.status,
                        style: TextStyle(
                          color: Color(Palette.grey02),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  final DateTime dateTime;
  const DateTimeCard({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(Palette.bg03),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Palette.primary,
                size: 15,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateFormat('dd MMM yyyy').format(dateTime),
                style: const TextStyle(
                  fontSize: 12,
                  color: Palette.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.access_alarm,
                color: Palette.primary,
                size: 17,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateFormat('HH:mm a').format(dateTime),
                style: const TextStyle(
                  color: Palette.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

_showCheckInDialog(BuildContext context, Function checkIn) {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      checkIn();
    },
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Check In"),
    content: const Text("Are you sure you want to check in?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_showCompleteDialog(BuildContext context, Function completeAppointment) {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continue"),
    onPressed: () {
      Navigator.of(context).pop();
      completeAppointment();
    },
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Check In"),
    content: const Text("Are you sure you want to complete this appointment?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_showCancelDialog(BuildContext context, Function cancelAppointment) {
  Widget cancelButton = TextButton(
    child: const Text("No, Go Back"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Yes, Cancel the Appointment"),
    onPressed: () {
      Navigator.of(context).pop();
      cancelAppointment();
    },
  );
  AlertDialog alert = AlertDialog(
    title: const Text("Cancel Appointment"),
    content: const Text("Are you sure you want to cancel your appointment?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
