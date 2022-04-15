import 'dart:convert';

import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/appointment.dart';
import 'package:appointmed/src/models/clinic.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AppointmentRepository {
  String? token;
  Map<String, String>? header;
  final storage = const FlutterSecureStorage();

  AppointmentRepository() {
    _getToken();
  }

  Future<Clinic> getClinicById(String clinicId) async {
    _getToken();
    final response = await http.get(
        Uri.parse(AuthConfig.baseUrl + '/clinics/$clinicId'),
        headers: header);
    if (response.statusCode == 200) {
      return Clinic.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  Future<List<Clinic>> getClinicsByDept(String departmentName) async {
    _getToken();
    final response = await http.get(
      Uri.parse(AuthConfig.baseUrl + "/clinics/dept/$departmentName"),
      headers: header,
    );
    if (response.statusCode == 200) {
      return List<Clinic>.from(
          json.decode(response.body).map((x) => Clinic.fromJson(x)));
    } else if (response.statusCode == 401) {
      throw Exception(json.decode(response.body)["errors"][0].toString());
    } else {
      throw Exception(json.decode(response.body).toString());
    }
  }

  Future<List<DateTime>> getAvailableTimes(String doctorId) async {
    header = await _getToken();
    final response = await Dio().get(
      AuthConfig.baseUrl + "/appointments/times/$doctorId",
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      List jsonResponse = response.data;
      return List<DateTime>.from(
          jsonResponse.map((x) => DateTime.parse(x).toLocal()).toList());
    } else if (response.statusCode == 401) {
      throw Exception(json.decode(response.data)["errors"][0].toString());
    } else {
      throw Exception(json.decode(response.data).toString());
    }
  }

  Future<List<Doctor>> getDoctorsByDept(String departmentId) async {
    _getToken();
    final response = await http.get(
      Uri.parse(AuthConfig.baseUrl + "/doctors/dept/$departmentId"),
      headers: header,
    );
    if (response.statusCode == 200) {
      return List<Doctor>.from(
          json.decode(response.body).map((x) => Doctor.fromJson(x)));
    } else if (response.statusCode == 401) {
      throw Exception(json.decode(response.body)["errors"][0].toString());
    } else {
      throw Exception(json.decode(response.body).toString());
    }
  }

  Future<bool> scheduleAppointment(
      {required String doctorId,
      required String patientId,
      required DateTime appointmentTime}) async {
    header = await _getToken();
    var encodedTime = appointmentTime.toIso8601String();
    final response = await Dio().post(AuthConfig.baseUrl + "/appointments",
        options: Options(headers: header),
        data: {
          "doctorId": doctorId,
          "patientId": patientId,
          "dateTime": encodedTime,
          "notes": "None"
        });

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(json.decode(response.data).toString());
    }
  }

  Future<List<Appointment>> getPatientAppointments() async {
    header = await _getToken();
    var userId = await storage.read(key: "userId");
    final response = await Dio().get(
      AuthConfig.baseUrl + "/appointments/patient/$userId",
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      return List<Appointment>.from(
          response.data.map((x) => Appointment.fromJson(x)));
    } else if (response.statusCode == 401) {
      throw Exception(response.data["errors"][0].toString());
    } else {
      throw Exception(response.data.toString());
    }
  }

  Future<List<Appointment>> getDoctorAppointments() async {
    header = await _getToken();
    var userId = await storage.read(key: "userId");
    final response = await Dio().get(
      AuthConfig.baseUrl + "/appointments/doctor/$userId",
      options: Options(headers: header),
    );
    if (response.statusCode == 200) {
      return List<Appointment>.from(
          response.data.map((x) => Appointment.fromJson(x)));
    } else if (response.statusCode == 401) {
      throw Exception(response.data["errors"][0].toString());
    } else {
      throw Exception(response.data.toString());
    }
  }

  Future<bool> updateAppointmentStatus(
      {required String appointmentId, required String status}) async {
    header = await _getToken();
    final response = await Dio().put(
      AuthConfig.baseUrl + "/appointments/$appointmentId",
      options: Options(headers: header),
      data: json.encode(status),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(response.data.toString());
    }
  }

  Future<Map<String, String>?> _getToken() async {
    token = await storage.read(key: 'token');
    var result = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    header = result;
    return result;
  }
}
