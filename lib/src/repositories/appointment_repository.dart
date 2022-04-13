import 'dart:convert';

import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/clinic.dart';
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

  void _getToken() async {
    token = await storage.read(key: 'token');
    header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
  }
}
