import 'package:json_annotation/json_annotation.dart';

part 'authentication_result.g.dart';

@JsonSerializable()
class AuthenticationResult {
  final String token;
  final String refreshToken;
  final String userId;

  AuthenticationResult({
    required this.token,
    required this.refreshToken,
    required this.userId,
  });

  factory AuthenticationResult.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResultToJson(this);
}
