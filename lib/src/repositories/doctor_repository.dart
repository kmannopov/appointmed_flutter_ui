import 'dart:convert';

import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DoctorRepository {
  final trailingUrl = '/doctors';
  final storage = const FlutterSecureStorage();
  String? token;
  var header;

  DoctorRepository() {
    _getToken();
  }

  Future<Doctor> getDoctorById(String userId) async {
    final response = await http.get(
        Uri.parse(AuthConfig.baseUrl + trailingUrl + '/$userId'),
        headers: header);
    if (response.statusCode == 404) {
      throw Exception('Doctor not found');
    } else if (response.statusCode == 200) {
      return Doctor.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  Future<bool> registerDoctor(Doctor doctor) async {
    _getToken();
    final response = await http.post(
        Uri.parse(AuthConfig.baseUrl + trailingUrl),
        headers: header,
        body: json.encode(doctor.toJson()));
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.body));
    } else {
      throw Exception(jsonDecode(response.body)['errors'][0]);
    }
  }

  Future<bool> updateDoctor(Doctor doctor) async {
    final response = await http.put(Uri.parse(AuthConfig.baseUrl + trailingUrl),
        headers: header, body: json.encode(doctor.toJson()));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  void _getToken() async {
    token = await storage.read(key: 'token');
    header = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8',
      'Authorization': 'Bearer $token',
    };
  }
}
