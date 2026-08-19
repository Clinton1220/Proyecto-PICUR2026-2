import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'email_service.dart';

class AuthResult {
  final bool ok;
  final String message;
  AuthResult(this.ok, this.message);
}

/// Código de un solo uso emitido para un correo concreto.
class _PendingCode {
  final String code;
  final CodePurpose purpose;
  final DateTime expiresAt;
  int attempts;

  _PendingCode({
    required this.code,
    required this.purpose,
    required this.expiresAt,
    this.attempts = 0,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toMap() => {
        'code': code,
        'purpose': purpose.storageKey,
        'expiresAt': expiresAt.toIso8601String(),
        'attempts': attempts,
      };

  static _PendingCode? fromMap(Map<String, dynamic> map) {
    final expiresAt = DateTime.tryParse(map['expiresAt'] as String? ?? '');
    final purposeName = map['purpose'] as String?;
    final code = map['code'] as String?;
    if (expiresAt == null || purposeName == null || code == null) return null;

    final matches =
        CodePurpose.values.where((value) => value.storageKey == purposeName);
    if (matches.isEmpty) return null;

    return _PendingCode(
      code: code,
      purpose: matches.first,
      expiresAt: expiresAt,
      attempts: map['attempts'] as int? ?? 0,
    );
  }
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const String _storageKey = 'geo_guardian_users';
  static const String _codesKey = 'geo_guardian_codes';

  /// Vigencia de un código enviado por correo.
  static const Duration codeTtl = Duration(minutes: 10);

  /// Intentos fallidos permitidos antes de invalidar el código.
  static const int maxCodeAttempts = 5;

  final Map<String, UserProfile> _users = {}; // email -> profile
  final Map<String, _PendingCode> _codes = {}; // email -> código pendiente
  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final value = prefs.getString(_storageKey);
    if (value != null) {
      final decoded = jsonDecode(value) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        final userMap = entry.value as Map<String, dynamic>;
        _users[entry.key] = UserProfile.fromMap(userMap);
      }
    }

    final rawCodes = prefs.getString(_codesKey);
    if (rawCodes != null) {
      final decoded = jsonDecode(rawCodes) as Map<String, dynamic>;
      for (final entry in decoded.entries) {
        final pending =
            _PendingCode.fromMap(entry.value as Map<String, dynamic>);
        // Los códigos vencidos no se recuperan.
        if (pending != null && !pending.isExpired) {
          _codes[entry.key] = pending;
        }
      }
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _users.map((key, user) => MapEntry(key, user.toMap())),
    );
    await prefs.setString(_storageKey, encoded);
  }

  /// Persiste los códigos para que sobrevivan a un reinicio de la app.
  Future<void> _saveCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _codes.map((email, pending) => MapEntry(email, pending.toMap())),
    );
    await prefs.setString(_codesKey, encoded);
  }

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return emailRegex.hasMatch(email);
  }

  /// Código de 6 dígitos con un generador criptográficamente seguro.
  String _generateCode() {
    final rnd = Random.secure();
    return (100000 + rnd.nextInt(900000)).toString();
  }

  /// Genera un código nuevo, lo guarda y lo envía por correo.
  ///
  /// Un correo solo puede tener un código vigente: emitir uno invalida el
  /// anterior, sin importar para qué se pidió.
  Future<AuthResult> _issueCode(String email, CodePurpose purpose) async {
    final code = _generateCode();
    _codes[email] = _PendingCode(
      code: code,
      purpose: purpose,
      expiresAt: DateTime.now().add(codeTtl),
    );
    await _saveCodes();

    final delivery = await EmailService.instance.sendCode(
      to: email,
      code: code,
      purpose: purpose,
      validFor: codeTtl,
    );

    if (!delivery.ok) {
      // Sin correo entregado el código es inservible: lo descartamos para que
      // el usuario pueda reintentar con uno nuevo.
      _codes.remove(email);
      await _saveCodes();
      return AuthResult(false, delivery.message);
    }

    return AuthResult(
      true,
      'Enviamos un código de 6 dígitos a $email. '
      'Vence en ${codeTtl.inMinutes} minutos.',
    );
  }

  /// Valida un código y lo consume. Devuelve `null` si todo está bien o el
  /// mensaje de error correspondiente.
  Future<String?> _consumeCode(
    String email,
    String code,
    CodePurpose purpose,
  ) async {
    final pending = _codes[email];
    if (pending == null) {
      return 'No hay ningún código pendiente. Solicita uno nuevo.';
    }

    if (pending.isExpired) {
      _codes.remove(email);
      await _saveCodes();
      return 'El código venció. Solicita uno nuevo.';
    }

    if (pending.purpose != purpose) {
      return 'Ese código no corresponde a esta operación.';
    }

    if (pending.code != code) {
      pending.attempts++;
      final restantes = maxCodeAttempts - pending.attempts;
      if (restantes <= 0) {
        _codes.remove(email);
        await _saveCodes();
        return 'Demasiados intentos fallidos. Solicita un código nuevo.';
      }
      await _saveCodes();
      return 'Código inválido. Te quedan $restantes intentos.';
    }

    _codes.remove(email);
    await _saveCodes();
    return null;
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

    final delivery = await _issueCode(email, CodePurpose.registration);
    if (!delivery.ok) {
      // La cuenta queda creada pero sin verificar: el usuario puede reintentar
      // desde la pantalla de verificación o volviendo a iniciar sesión.
      return AuthResult(
        false,
        'Cuenta creada, pero no pudimos enviar el código: ${delivery.message}',
      );
    }
    return delivery;
  }

  Future<AuthResult> verifyRegistrationCode(String email, String code) async {
    final user = _users[email];
    if (user == null) {
      return AuthResult(false, 'Usuario no encontrado');
    }

    final error = await _consumeCode(email, code, CodePurpose.registration);
    if (error != null) return AuthResult(false, error);

    user.verified = true;
    await _saveUsers();
    _currentUser = user;
    return AuthResult(true, 'Correo verificado correctamente');
  }

  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final user = _users[email];
    if (user == null) return AuthResult(false, 'Usuario no encontrado');
    if (!user.verified) {
      final delivery = await _issueCode(email, CodePurpose.registration);
      return AuthResult(
        false,
        'Cuenta no verificada. ${delivery.message}',
      );
    }
    if (user.password != password) {
      return AuthResult(false, 'Contraseña incorrecta');
    }
    _currentUser = user;
    return AuthResult(true, 'Login correcto');
  }

  Future<AuthResult> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) {
        return AuthResult(false, 'Inicio con Google cancelado');
      }

      return _loginWithSocialProfile(
        name: googleUser.displayName ?? googleUser.email.split('@').first,
        email: googleUser.email,
        provider: 'google',
      );
    } catch (_) {
      return AuthResult(
        false,
        'No se pudo iniciar sesiÃ³n con Google. Revisa la configuraciÃ³n OAuth.',
      );
    }
  }

  Future<AuthResult> loginWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        return AuthResult(false, 'Inicio con Facebook cancelado');
      }

      if (result.status != LoginStatus.success) {
        return AuthResult(
          false,
          result.message ?? 'No se pudo iniciar sesiÃ³n con Facebook',
        );
      }

      final data = await FacebookAuth.instance.getUserData(
        fields: 'name,email',
      );
      final email = data['email'] as String?;
      if (email == null || !_isEmailValid(email)) {
        return AuthResult(
          false,
          'Facebook no devolviÃ³ un correo vÃ¡lido para esta cuenta',
        );
      }

      return _loginWithSocialProfile(
        name: data['name'] as String? ?? email.split('@').first,
        email: email,
        provider: 'facebook',
      );
    } catch (_) {
      return AuthResult(
        false,
        'No se pudo iniciar sesiÃ³n con Facebook. Revisa App ID y Client Token.',
      );
    }
  }

  Future<AuthResult> _loginWithSocialProfile({
    required String name,
    required String email,
    required String provider,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_isEmailValid(email)) {
      return AuthResult(false, 'Correo invÃ¡lido');
    }

    final existing = _users[email];
    if (existing == null) {
      final user = UserProfile(
        name: name,
        email: email,
        password: 'social:$provider',
        verified: true,
      );
      _users[email] = user;
      await _saveUsers();
      _currentUser = user;
      return AuthResult(true, 'Login con $provider correcto');
    }

    existing.name = existing.name.isNotEmpty ? existing.name : name;
    existing.verified = true;
    await _saveUsers();
    _currentUser = existing;
    return AuthResult(true, 'Login con $provider correcto');
  }

  Future<AuthResult> resendVerificationCode(String email) async {
    final user = _users[email];
    if (user == null) return AuthResult(false, 'Usuario no encontrado');
    if (user.verified) return AuthResult(false, 'La cuenta ya está verificada');
    return _issueCode(email, CodePurpose.registration);
  }

  /// Envía el código para restablecer la contraseña.
  Future<AuthResult> sendRecoveryCode(String email) async {
    final user = _users[email];
    if (user == null || !user.verified) {
      return AuthResult(false, 'Correo no registrado o no verificado');
    }
    return _issueCode(email, CodePurpose.recovery);
  }

  Future<AuthResult> resetPassword(
      String email, String code, String newPassword) async {
    final current = _users[email];
    if (current == null) return AuthResult(false, 'Usuario no encontrado');

    final error = await _consumeCode(email, code, CodePurpose.recovery);
    if (error != null) return AuthResult(false, error);

    current.password = newPassword;
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
