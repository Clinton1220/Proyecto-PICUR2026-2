import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/password_strength.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';
import 'verify_email_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String? _nameError;
  String? _emailError;
  String? _passError;
  bool _loading = false;
  bool _passVisible = false;
  PasswordValidationResult _passResult = validatePasswordSecurity('');

  void _onName(String v) => setState(
      () => _nameError = v.trim().isEmpty ? 'Ingresa un nombre' : null);
  void _onEmail(String v) => setState(() => _emailError = validateEmail(v));

  void _onPass(String v) {
    final result = validatePasswordSecurity(v);
    setState(() {
      _passError = validatePassword(v);
      _passResult = result;
    });
  }

  Future<void> _register() async {
    final email = _email.text.trim();
    setState(() => _loading = true);
    final res = await AuthService.instance
        .register(_name.text.trim(), email, _pass.text);
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.message)));
    if (res.ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => VerifyEmailPage(email: email)),
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = _nameError == null &&
        _emailError == null &&
        _passError == null &&
        _name.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _pass.text.isNotEmpty &&
        !_loading;
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          InputField(
              label: 'Nombre completo',
              icon: Icons.person_outline,
              controller: _name,
              onChanged: _onName,
              errorText: _nameError),
          const SizedBox(height: 12),
          InputField(
              label: 'Correo electrónico',
              icon: Icons.mail_outline,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              onChanged: _onEmail,
              errorText: _emailError),
          const SizedBox(height: 12),
          InputField(
              label: 'Contraseña',
              icon: Icons.lock_outline,
              obscureText: !_passVisible,
              controller: _pass,
              onChanged: _onPass,
              errorText: _passError,
              suffixIcon: IconButton(
                icon: Icon(_passVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _passVisible = !_passVisible),
              )),
          const SizedBox(height: 12),
          PasswordStrengthIndicator(result: _passResult),
          const SizedBox(height: 18),
          FilledButton(
              onPressed: can ? _register : null,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Crear cuenta'))
        ]),
      ),
    );
  }
}
