import 'package:flutter/material.dart';
import '../widgets/input_field.dart';
import '../widgets/password_strength.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  String? _emailError;
  bool _loading = false;

  void _onEmail(String v) => setState(() => _emailError = validateEmail(v));

  Future<void> _sendCode() async {
    final email = _email.text.trim();
    final err = validateEmail(email);
    setState(() => _emailError = err);
    if (err != null) return;
    setState(() => _loading = true);
    final ok = await AuthService.instance.sendRecoveryCode(email);
    setState(() => _loading = false);
    if (!ok) {
      setState(() {
        _emailError = 'Correo no registrado o no verificado';
      });
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código de recuperación enviado')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResetPasswordPage(email: email)),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = _emailError == null && _email.text.isNotEmpty && !_loading;
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          InputField(
              label: 'Correo electrónico',
              icon: Icons.mail_outline,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              onChanged: _onEmail,
              errorText: _emailError),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: can ? _sendCode : null,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Enviar código'))
        ]),
      ),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _code = TextEditingController();
  final _newPass = TextEditingController();
  String? _codeError;
  String? _passError;
  bool _loading = false;
  bool _passVisible = false;
  PasswordValidationResult _passResult = validatePasswordSecurity('');

  void _onCode(String v) => setState(() => _codeError = validateCode(v));

  void _onPass(String v) {
    final result = validatePasswordSecurity(v);
    setState(() {
      _passError = validatePassword(v);
      _passResult = result;
    });
  }

  Future<void> _reset() async {
    final code = _code.text.trim();
    final pass = _newPass.text;
    setState(() {
      _codeError = validateCode(code);
      _passError = validatePassword(pass);
    });
    if (_codeError != null || _passError != null) return;
    setState(() => _loading = true);
    final res =
        await AuthService.instance.resetPassword(widget.email, code, pass);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.message)));
    if (res.ok) Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void dispose() {
    _code.dispose();
    _newPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = _codeError == null &&
        _passError == null &&
        _code.text.isNotEmpty &&
        _newPass.text.isNotEmpty &&
        !_loading;
    return Scaffold(
      appBar: AppBar(title: const Text('Restablecer contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Text('Enviamos un código a ${widget.email}'),
          const SizedBox(height: 12),
          InputField(
              label: 'Código',
              icon: Icons.confirmation_number,
              controller: _code,
              keyboardType: TextInputType.number,
              onChanged: _onCode,
              errorText: _codeError),
          const SizedBox(height: 12),
          InputField(
              label: 'Nueva contraseña',
              icon: Icons.lock_outline,
              obscureText: !_passVisible,
              controller: _newPass,
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
              onPressed: can ? _reset : null,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Restablecer'))
        ]),
      ),
    );
  }
}
