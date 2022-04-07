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
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8'
        },
        body: jsonEncode(request.toJson()));

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
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8'
        },
        body: json.encode(request.toJson()));

    if (response.statusCode == 200) {
      _updateStorage(AuthenticationResult.fromJson(jsonDecode(response.body)));
      return true;
    } else {
      var errorMessage = jsonDecode(response.body);
      throw Exception(errorMessage['errors'][0]);
    }
  }

  Future<bool> refreshToken() async {
    var token = await storage.read(key: 'token');
    var refreshToken = await storage.read(key: 'refreshToken');

    final response = await http.post(
        Uri.parse(AuthConfig.baseUrl + '/identity/refresh'),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8'
        },
        body: json.encode({
          "token": token,
          "refreshToken": refreshToken,
        }));

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
    var role = json.decode(_decodeUserData(result.token))['role'];
    await storage.write(key: 'role', value: role);
  }

  String _decodeUserData(String token) {
    String normalizedSource = base64Url.normalize(token.split(".")[1]);
    return utf8.decode(base64Url.decode(normalizedSource));
  }
}
