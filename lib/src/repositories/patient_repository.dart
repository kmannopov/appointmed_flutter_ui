import 'dart:convert';
import 'dart:io';

import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/patient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PatientRepository {
  final trailingUrl = '/patients';
  final storage = const FlutterSecureStorage();
  late String? token;

  PatientRepository() {
    _getToken();
  }

  Future<bool> registerPatient(Patient patient) async {
    final response =
        await http.post(Uri.parse(AuthConfig.baseUrl + trailingUrl),
            headers: {
              HttpHeaders.authorizationHeader: token!,
            },
            body: patient.toJson());
    if (response.statusCode == 201) {
      return true;
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  Future<bool> updatePatient(Patient patient) async {
    final response = await http.put(Uri.parse(AuthConfig.baseUrl + trailingUrl),
        body: patient.toJson());
    if (response.statusCode == 200) {
      return true;
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  void _getToken() async {
    token = await storage.read(key: 'token');
  }
}
