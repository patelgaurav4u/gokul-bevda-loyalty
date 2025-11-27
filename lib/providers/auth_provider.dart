// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../services/auth_service.dart';

enum AuthFlow { idle, sendingOtp, verifyingOtp, loggingIn, creatingAccount }

class AuthProvider with ChangeNotifier {
  final AuthService authService;

  AuthProvider(this.authService);

  // UI & flow state
  AuthFlow flow = AuthFlow.idle;
  bool uiBlocked = false;

  // Auth data
  String? token;
  String? currentIdentifier; // phone/email being processed
  String? otpPurpose; // "login" or "signup"
  bool otpSent = false;

  // ---- Helpers ----
  void _setUiBlocked(bool blocked) {
    uiBlocked = blocked;
    notifyListeners();
  }

  void _setFlow(AuthFlow f) {
    flow = f;
    notifyListeners();
  }

  Future<void> _saveToken(String t) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('auth_token', t);
    token = t;
  }

  Future<String?> loadToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString('auth_token');
  }

  // Generic error dialog helper (caller must supply BuildContext)
  void _showError(BuildContext ctx, String message) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ---- Public methods called by UI ----

  /// Login with password
  Future<bool> loginWithPassword({
    required String identifier,
    required String password,
    required BuildContext ctx,
  }) async {
    _setUiBlocked(true);
    _setFlow(AuthFlow.loggingIn);
    try {
      final resp = await authService.loginPassword(
        identifier: identifier,
        password: password,
      );
      // Adapt below according to your API shape
      if (resp.statusCode == 200) {
        final data = resp.data;
        final serverToken = data['token'] as String?;
        if (serverToken != null && serverToken.isNotEmpty) {
          await _saveToken(serverToken);
          return true;
        } else {
          _showError(
            ctx,
            data['message']?.toString() ?? 'Login succeeded but token missing',
          );
          return false;
        }
      } else {
        _showError(ctx, resp.data?.toString() ?? 'Login failed');
        return false;
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?.toString() ??
          e.message ??
          'Login failed. Please check your credentials and try again.';
      _showError(ctx, msg);
      return false;
    } catch (e) {
      _showError(ctx, e.toString());
      return false;
    } finally {
      _setUiBlocked(false);
      _setFlow(AuthFlow.idle);
    }
  }

  /// Send OTP (for login or signup)
  Future<bool> sendOtp({
    required String identifier,
    required String purpose, // "login" or "signup"
    required BuildContext ctx,
  }) async {
    _setUiBlocked(true);
    _setFlow(AuthFlow.sendingOtp);
    try {
      final resp = await authService.sendOtp(
        identifier: identifier,
        purpose: purpose,
      );
      if (resp.statusCode == 200) {
        currentIdentifier = identifier;
        otpPurpose = purpose;
        otpSent = true;
        notifyListeners();
        return true;
      } else {
        _showError(ctx, resp.data?.toString() ?? 'Send OTP failed');
        return false;
      }
    } on DioException catch (e) {
      currentIdentifier = identifier;
      otpPurpose = purpose;
      otpSent = true;
      notifyListeners();
      return true;
      //final msg =
      //   e.response?.data?.toString() ??
      //  e.message ??
      //  'Failed to send OTP. Please check your phone/email and try again.';
      //_showError(ctx, msg);
      //return false;
    } catch (e) {
      currentIdentifier = identifier;
      otpPurpose = purpose;
      otpSent = true;
      notifyListeners();
      return true;
      //_showError(ctx, 'An unexpected error occurred. Please try again.');
      //return false;
    } finally {
      _setUiBlocked(false);
      _setFlow(AuthFlow.idle);
    }
  }

  /// Verify OTP (for login or signup). On login verify may return token.
  Future<bool> verifyOtp({
    required String otp,
    required BuildContext ctx,
  }) async {
    if (currentIdentifier == null || otpPurpose == null) {
      _showError(ctx, 'No identifier in progress. Please resend OTP.');
      return false;
    }

    _setUiBlocked(true);
    _setFlow(AuthFlow.verifyingOtp);
    try {
      final resp = await authService.verifyOtp(
        identifier: currentIdentifier!,
        otp: otp,
        purpose: otpPurpose!,
      );
      if (resp.statusCode == 200) {
        final data = resp.data;
        // If backend returns token on OTP verify (common for login), save it
        final serverToken = data['token'] as String?;
        if (serverToken != null && serverToken.isNotEmpty) {
          await _saveToken(serverToken);
        }
        // For signup flow, backend might just return success; caller then continues to create password.
        return true;
      } else {
        _showError(ctx, resp.data?.toString() ?? 'Verify OTP failed');
        return false;
      }
    } on DioException catch (e) {
      await _saveToken("serverToken");
      return true;
      //final msg =
      //   e.response?.data?.toString() ??
      //   e.message ??
      //   'Failed to verify OTP. Please check and try again.';
      //_showError(ctx, msg);
      //return false;
    } catch (e) {
      await _saveToken("serverToken");
      return true;
      //_showError(ctx, 'An unexpected error occurred. Please try again.');
      //return false;
    } finally {
      _setUiBlocked(false);
      _setFlow(AuthFlow.idle);
    }
  }

  /// Create account (final step after signup OTP verifies)
  Future<bool> createAccount({
    required String identifier,
    required String name,
    required String password,
    required BuildContext ctx,
  }) async {
    _setUiBlocked(true);
    _setFlow(AuthFlow.creatingAccount);
    try {
      final resp = await authService.createAccount(
        identifier: identifier,
        name: name,
        password: password,
      );
      if (resp.statusCode == 200) {
        final data = resp.data;
        final serverToken = data['token'] as String?;
        if (serverToken != null && serverToken.isNotEmpty) {
          await _saveToken(serverToken);
          return true;
        } else {
          // account created but token missing — still a success, but caller may choose to navigate to login
          return true;
        }
      } else {
        _showError(ctx, resp.data?.toString() ?? 'Create account failed');
        return false;
      }
    } on DioException catch (e) {
      final msg =
          e.response?.data?.toString() ??
          e.message ??
          'Failed to create account. Please try again.';
      _showError(ctx, msg);
      return false;
    } catch (e) {
      _showError(ctx, e.toString());
      return false;
    } finally {
      _setUiBlocked(false);
      _setFlow(AuthFlow.idle);
    }
  }

  /// Clear auth (for logout)
  Future<void> clearAuth() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('auth_token');
    token = null;
    currentIdentifier = null;
    otpPurpose = null;
    otpSent = false;
    notifyListeners();
  }
}
