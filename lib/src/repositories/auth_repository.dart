import 'dart:convert';
import 'package:appointmed/src/models/auth/register_request.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:appointmed/config/auth_config.dart';
import 'package:appointmed/src/models/auth/authentication_result.dart';
import 'package:appointmed/src/models/auth/login_request.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final storage = const FlutterSecureStorage();

  Future<bool> signIn(LoginRequest request) async {
    final response = await http.post(
        Uri.parse(AuthConfig.baseUrl + '/identity/login'),
        body: request.toJson());

    if (response.statusCode == 200) {
      _updateStorage(AuthenticationResult.fromJson(jsonDecode(response.body)));
      return true;
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  Future<bool> register(RegisterRequest request) async {
    final response = await http.post(
        Uri.parse(AuthConfig.baseUrl + '/identity/register'),
        body: request.toJson());

    if (response.statusCode == 200) {
      _updateStorage(AuthenticationResult.fromJson(jsonDecode(response.body)));
      return true;
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  Future<bool> refreshToken(String token, String refreshToken) async {
    final response = await http
        .post(Uri.parse(AuthConfig.baseUrl + '/identity/refresh'), body: {
      "token": token,
      "refreshToken": refreshToken,
    });

    if (response.statusCode == 200) {
      _updateStorage(AuthenticationResult.fromJson(jsonDecode(response.body)));
      return true;
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  void _updateStorage(AuthenticationResult result) async {
    await storage.write(key: 'token', value: result.token);
    await storage.write(key: 'refreshToken', value: result.refreshToken);
    await storage.write(key: 'userId', value: result.userId);
  }
}
