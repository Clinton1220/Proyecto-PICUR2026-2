import 'package:flutter/material.dart';
import '../utils/validators.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordValidationResult result;

  const PasswordStrengthIndicator({super.key, required this.result});

  Widget _buildRow(bool good, String label) {
    return Row(
      children: [
        Icon(
          good ? Icons.check_circle : Icons.cancel,
          color: good ? Colors.green : Colors.red,
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label,
              style: TextStyle(
                color: good ? Colors.green[700] : Colors.red[700],
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              result.isSecure ? Icons.lock_open : Icons.lock_outline,
              color: result.isSecure ? Colors.green : Colors.orange,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              result.isSecure ? 'Contraseña segura' : 'Contraseña débil',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: result.isSecure ? Colors.green : Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildRow(result.hasMinLength, 'Al menos 8 caracteres'),
        const SizedBox(height: 4),
        _buildRow(result.hasUppercase, 'Una mayúscula'),
        const SizedBox(height: 4),
        _buildRow(result.hasLowercase, 'Una minúscula'),
        const SizedBox(height: 4),
        _buildRow(result.hasNumber, 'Un número'),
        const SizedBox(height: 4),
        _buildRow(result.hasSpecial, 'Un símbolo'),
      ],
    );
  }
}
