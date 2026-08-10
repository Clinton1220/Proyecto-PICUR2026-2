import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class AuthResult {
  final bool ok;
  final String message;
  AuthResult(this.ok, this.message);
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const String _storageKey = 'geo_guardian_users';

  final Map<String, UserProfile> _users = {}; // email -> profile
  final Map<String, String> _codes = {}; // email -> code
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_storageKey);
    if (value == null) return;

    final decoded = jsonDecode(value) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      final userMap = entry.value as Map<String, dynamic>;
      _users[entry.key] = UserProfile.fromMap(userMap);
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _users.map((key, user) => MapEntry(key, user.toMap())),
    );
    await prefs.setString(_storageKey, encoded);
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return emailRegex.hasMatch(email);
  }

  String _generateCode() {
    final rnd = Random();
    return (100000 + rnd.nextInt(900000)).toString();
  }

  Future<AuthResult> register(
      String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_isEmailValid(email)) {
      return AuthResult(false, 'Correo inválido');
    }
    final existing = _users[email];
    if (existing != null && existing.verified) {
      return AuthResult(false, 'El usuario ya existe');
    }

    final user = UserProfile(
      name: name,
      email: email,
      password: password,
      verified: false,
    );
    _users[email] = user;
    await _saveUsers();
    await _sendVerificationCode(email);
    return AuthResult(true, 'Se ha enviado un código de verificación');
  }

  Future<void> _sendVerificationCode(String email) async {
    final code = _generateCode();
    _codes[email] = code;
    // En un entorno real se enviaría por correo. Aquí lo dejamos en consola para desarrollo.
    // ignore: avoid_print
    print('Verification code for $email: $code');
  }

  Future<AuthResult> verifyRegistrationCode(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final stored = _codes[email];
    if (stored == null || stored != code) {
      return AuthResult(false, 'Código inválido');
    }
    final user = _users[email];
    if (user == null) {
      return AuthResult(false, 'Usuario no encontrado');
    }
    user.verified = true;
    _codes.remove(email);
    await _saveUsers();
    _currentUser = user;
    return AuthResult(true, 'Correo verificado correctamente');
  }

  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final user = _users[email];
    if (user == null) return AuthResult(false, 'Usuario no encontrado');
    if (!user.verified) {
      await _sendVerificationCode(email);
      return AuthResult(
          false, 'Cuenta no verificada. Se ha enviado un código al correo');
    }
    if (user.password != password) {
      return AuthResult(false, 'Contraseña incorrecta');
    }
    _currentUser = user;
    return AuthResult(true, 'Login correcto');
  }

  Future<AuthResult> resendVerificationCode(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final user = _users[email];
    if (user == null) return AuthResult(false, 'Usuario no encontrado');
    if (user.verified) return AuthResult(false, 'La cuenta ya está verificada');
    await _sendVerificationCode(email);
    return AuthResult(true, 'Se ha reenviado el código de verificación');
  }

  Future<bool> sendRecoveryCode(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = _users[email];
    if (user == null || !user.verified) return false;
    final code = _generateCode();
    _codes[email] = code;
    // ignore: avoid_print
    print('Recovery code for $email: $code');
    return true;
  }

  Future<bool> verifyCode(String email, String code) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final stored = _codes[email];
    return stored != null && stored == code;
  }

  Future<AuthResult> resetPassword(
      String email, String code, String newPassword) async {
    final ok = await verifyCode(email, code);
    if (!ok) return AuthResult(false, 'Código inválido');
    final current = _users[email];
    if (current == null) return AuthResult(false, 'Usuario no encontrado');
    current.password = newPassword;
    _codes.remove(email);
    await _saveUsers();
    if (_currentUser?.email == email) {
      _currentUser = current;
    }
    return AuthResult(true, 'Contraseña actualizada');
  }

  Future<AuthResult> updateProfile(String email, String name) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final current = _users[email];
    if (current == null) return AuthResult(false, 'Usuario no encontrado');
    current.name = name;
    await _saveUsers();
    if (_currentUser?.email == email) {
      _currentUser = current;
    }
    return AuthResult(true, 'Perfil actualizado');
  }

  Future<AuthResult> changePassword(
      String email, String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final current = _users[email];
    if (current == null) return AuthResult(false, 'Usuario no encontrado');
    if (current.password != oldPassword) {
      return AuthResult(false, 'Contraseña actual incorrecta');
    }
    current.password = newPassword;
    await _saveUsers();
    if (_currentUser?.email == email) {
      _currentUser = current;
    }
    return AuthResult(true, 'Contraseña actualizada');
  }

  void logout() {
    _currentUser = null;
  }
}
