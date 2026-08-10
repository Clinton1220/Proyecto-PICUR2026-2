import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../utils/validators.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String? _codeError;
  String? _statusMessage;
  bool _loading = false;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _pulseController.dispose();
    super.dispose();
  }

  String get _code => _codeControllers.map((c) => c.text).join();

  void _updateError() {
    setState(() => _codeError = validateCode(_code));
  }

  void _onDigitChanged(int index, String value) {
    if (value.isEmpty) {
      _codeControllers[index].text = '';
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length == 1) {
      final digit = value.characters.last;
      _codeControllers[index].text = digit;
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      final onlyDigits = value.replaceAll(RegExp(r'\D'), '');
      if (onlyDigits.isEmpty) return;
      final digits = onlyDigits.split('');
      for (var i = 0; i < digits.length && index + i < 6; i++) {
        _codeControllers[index + i].text = digits[i];
      }
      final nextIndex = index + digits.length;
      if (nextIndex < _focusNodes.length) {
        _focusNodes[nextIndex].requestFocus();
      } else {
        _focusNodes.last.unfocus();
      }
    }
    _updateError();
    setState(() {});
  }

  Future<void> _verify() async {
    _updateError();
    if (_codeError != null) return;

    setState(() {
      _loading = true;
      _statusMessage = null;
    });
    final result =
        await AuthService.instance.verifyRegistrationCode(widget.email, _code);
    setState(() => _loading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
    if (!result.ok) return;
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Future<void> _resendCode() async {
    setState(() {
      _loading = true;
      _statusMessage = null;
    });
    final result =
        await AuthService.instance.resendVerificationCode(widget.email);
    setState(() {
      _loading = false;
      _statusMessage = result.ok ? 'Código reenviado' : result.message;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result.message)));
  }

  Widget _buildDigitField(int index) {
    final hasValue = _codeControllers[index].text.isNotEmpty;
    return ScaleTransition(
      scale: Tween<double>(begin: 1.0, end: 1.02).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 50,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: hasValue ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focusNodes[index].hasFocus
                ? const Color(0xFF2A7F35)
                : Colors.grey.shade400,
            width: _focusNodes[index].hasFocus ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: TextField(
            controller: _codeControllers[index],
            focusNode: _focusNodes[index],
            autofocus: index == 0,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 1,
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: (value) => _onDigitChanged(index, value),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _code.length == 6 && !_loading;
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar correo')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Verificación de cuenta',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ingresa el código de 6 dígitos que enviamos a tu correo para activar tu cuenta.',
                style:
                    TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined,
                          size: 28, color: Color(0xFF2A7F35)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.email,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _codeError != null
                        ? Colors.red.shade300
                        : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, _buildDigitField),
                    ),
                    if (_codeError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _codeError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: canSubmit ? _verify : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Verificar'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _loading ? null : _resendCode,
                icon: const Icon(Icons.refresh),
                label: const Text('Reenviar código'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_statusMessage != null) ...[
                const SizedBox(height: 18),
                Text(
                  _statusMessage!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 18),
              const Text(
                'Si no recibes el código en unos segundos, revisa spam o pulsa reenviar código.',
                style:
                    TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
