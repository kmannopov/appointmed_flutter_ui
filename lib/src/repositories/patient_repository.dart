import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/patient.dart';
import 'package:appointmed/src/repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PatientRepository {
  final trailingUrl = '/patients';
  final storage = const FlutterSecureStorage();
  final _authRepository = AuthRepository();
  String? token;
  Map<String, String>? header;

  PatientRepository() {
    _getToken();
  }

  Future<Patient> getPatientById(String userId) async {
    final response = await http.get(
        Uri.parse(AuthConfig.baseUrl + trailingUrl + '/$userId'),
        headers: header);
    if (response.statusCode == 404) {
      throw Exception('Patient not found');
    } else if (response.statusCode == 200) {
      return Patient.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      _authRepository.refreshToken();
      throw Exception('Unauthorized: ${jsonDecode(response.body).toString()}');
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors']);
    }
  }

  Future<bool> registerPatient(Patient patient) async {
    header = await _getToken();
    final response = await Dio().post(
      AuthConfig.baseUrl + trailingUrl,
      data: json.encode(patient.toJson()),
      options: Options(headers: header),
    );
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      var errorMessage = jsonDecode(response.data);
      throw Exception(errorMessage['errors'][0].toString());
    } else {
      var errorMessage = jsonDecode(response.data);
      throw Exception(errorMessage.toString());
    }
  }

  Future<bool> updatePatient(Patient patient) async {
    header = await _getToken();
    final response = await Dio().put(AuthConfig.baseUrl + trailingUrl,
        data: json.encode(patient.toJson()), options: Options(headers: header));
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
