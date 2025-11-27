// lib/services/auth_service.dart
import 'package:dio/dio.dart';
import 'api_service.dart';
import 'api_endpoints.dart';

class AuthService {
  final ApiService api;

  AuthService(this.api);

  /// Login using identifier (phone/email) + password
  Future<Response> loginPassword({
    required String identifier,
    required String password,
  }) {
    return api.dio.post(
      ApiEndpoints.login,
      data: {'identifier': identifier, 'password': password},
    );
  }

  /// Send OTP for purpose: "login" or "signup"
  Future<Response> sendOtp({
    required String identifier,
    required String purpose,
  }) {
    return api.dio.post(
      ApiEndpoints.sendOtp,
      data: {'identifier': identifier, 'purpose': purpose},
    );
  }

  /// Verify OTP. Backend might return token on success for login.
  Future<Response> verifyOtp({
    required String identifier,
    required String otp,
    required String purpose,
  }) {
    return api.dio.post(
      ApiEndpoints.verifyOtp,
      data: {'identifier': identifier, 'otp': otp, 'purpose': purpose},
    );
  }

  /// Create account (final step with password)
  Future<Response> createAccount({
    required String identifier,
    required String name,
    required String password,
  }) {
    return api.dio.post(
      ApiEndpoints.createAccount,
      data: {'identifier': identifier, 'name': name, 'password': password},
    );
  }
}
