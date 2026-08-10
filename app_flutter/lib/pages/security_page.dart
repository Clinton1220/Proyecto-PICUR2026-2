import 'package:flutter/material.dart';
import '../utils/validators.dart';
import '../widgets/password_strength.dart';
import '../services/auth_service.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _currentPass = TextEditingController();
  final _newPass = TextEditingController();
  bool _loading = false;
  String? _currentError;
  String? _newError;
  bool _newVisible = false;
  PasswordValidationResult _passResult = validatePasswordSecurity('');

  @override
  void dispose() {
    _currentPass.dispose();
    _newPass.dispose();
    super.dispose();
  }

  void _onNewPass(String value) {
    final result = validatePasswordSecurity(value);
    setState(() {
      _passResult = result;
      _newError = validatePassword(value);
    });
  }

  Future<void> _changePassword() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    final current = _currentPass.text;
    final next = _newPass.text;
    setState(() {
      _currentError = current.isEmpty ? 'Ingresa tu contraseña actual' : null;
      _newError = validatePassword(next);
    });
    if (_currentError != null || _newError != null) return;

    setState(() => _loading = true);
    final res =
        await AuthService.instance.changePassword(user.email, current, next);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.message)));
    if (res.ok) {
      _currentPass.clear();
      _newPass.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguridad'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _currentPass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña actual',
                errorText: _currentError,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPass,
              obscureText: !_newVisible,
              onChanged: _onNewPass,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                errorText: _newError,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                suffixIcon: IconButton(
                  icon: Icon(_newVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _newVisible = !_newVisible),
                ),
              ),
            ),
            const SizedBox(height: 12),
            PasswordStrengthIndicator(result: _passResult),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _changePassword,
              child: _loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Actualizar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
