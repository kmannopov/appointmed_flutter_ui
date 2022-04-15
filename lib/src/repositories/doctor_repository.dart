import 'dart:convert';

import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/doctor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DoctorRepository {
  final trailingUrl = '/doctors';
  final storage = const FlutterSecureStorage();
  String? token;
  Map<String, String>? header;

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
    header = await _getToken();
    final response = await Dio().post(AuthConfig.baseUrl + trailingUrl,
        options: Options(headers: header), data: json.encode(doctor.toJson()));
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception(jsonDecode(response.data));
    } else {
      throw Exception(jsonDecode(response.data)['errors'][0]);
    }
  }

  Future<bool> updateDoctor(Doctor doctor) async {
    header = await _getToken();
    final response = await Dio().put(AuthConfig.baseUrl + trailingUrl,
        options: Options(headers: header), data: json.encode(doctor.toJson()));
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized');
    } else {
      var errorMessage = jsonDecode(response.data);
      throw Exception(errorMessage['errors'][0]);
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
