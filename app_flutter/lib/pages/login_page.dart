import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import 'verify_email_page.dart';
import '../widgets/input_field.dart';
import '../utils/validators.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  String? _emailError;
  String? _passError;
  bool _loading = false;
  bool _passVisible = false;

  Widget _socialButton({
    required String label,
    required Widget logo,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide(color: borderColor.withOpacity(0.3)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _onEmailChanged(String v) {
    setState(() => _emailError = validateEmail(v));
  }

  void _onPassChanged(String v) {
    setState(() => _passError = validatePassword(v));
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final res = await AuthService.instance.login(email, pass);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res.message)));
    if (res.ok) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage()));
      return;
    }

    if (res.message.contains('Cuenta no verificada')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => VerifyEmailPage(email: email)),
      );
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _emailError == null &&
        _passError == null &&
        _emailCtrl.text.isNotEmpty &&
        _passCtrl.text.isNotEmpty &&
        !_loading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              const Text('Bienvenido',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Inicia sesión para continuar',
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
              const SizedBox(height: 42),
              InputField(
                  label: 'Correo electrónico',
                  icon: Icons.mail_outline,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: _onEmailChanged),
              const SizedBox(height: 16),
              InputField(
                  label: 'Contraseña',
                  icon: Icons.lock_outline,
                  obscureText: !_passVisible,
                  controller: _passCtrl,
                  errorText: _passError,
                  onChanged: _onPassChanged,
                  suffixIcon: IconButton(
                    icon: Icon(_passVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () =>
                        setState(() => _passVisible = !_passVisible),
                  )),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage())),
                  child: const Text('¿Olvidaste tu contraseña?'),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: canSubmit ? _submit : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _loading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                  child: Text('o continúa con',
                      style: TextStyle(color: Colors.black54))),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _socialButton(
                      label: 'Google',
                      borderColor: Colors.grey,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Inicio con Google no disponible en la demo.'),
                          ),
                        );
                      },
                      logo: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        alignment: Alignment.center,
                        child: const Text('G',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _socialButton(
                      label: 'Facebook',
                      borderColor: const Color(0xFF1877F2),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Inicio con Facebook no disponible en la demo.'),
                          ),
                        );
                      },
                      logo: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1877F2),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.facebook,
                            color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
