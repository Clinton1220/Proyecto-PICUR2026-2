String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'Ingrese un correo';
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
  if (!emailRegex.hasMatch(value)) return 'Correo inválido';
  return null;
}

class PasswordValidationResult {
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecial;
  final bool hasMinLength;

  PasswordValidationResult({
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecial,
    required this.hasMinLength,
  });

  bool get isSecure =>
      hasUppercase && hasLowercase && hasNumber && hasSpecial && hasMinLength;
}

PasswordValidationResult validatePasswordSecurity(String value) {
  return PasswordValidationResult(
    hasUppercase: value.contains(RegExp(r'[A-Z]')),
    hasLowercase: value.contains(RegExp(r'[a-z]')),
    hasNumber: value.contains(RegExp(r'\d')),
    hasSpecial:
        value.contains(RegExp(r'[!@#\$%\^&*(),.?":{}|<>~`\[\]\\/\-_+=;]')),
    hasMinLength: value.length >= 8,
  );
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Ingrese una contraseña';
  if (value.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
  final result = validatePasswordSecurity(value);
  if (!result.isSecure) {
    return 'Debe tener mayúscula, minúscula, número y símbolo';
  }
  return null;
}

String? validateNotEmpty(String? value, String fieldName) {
  if (value == null || value.isEmpty) return 'Ingrese $fieldName';
  return null;
}

String? validateCode(String? value) {
  if (value == null || value.isEmpty) return 'Ingrese el código';
  if (value.length != 6) return 'El código debe tener 6 dígitos';
  return null;
}
