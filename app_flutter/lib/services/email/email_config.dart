/// Configuración del servidor SMTP usado para enviar los códigos de
/// verificación y de recuperación de contraseña.
///
/// Los valores se inyectan en tiempo de compilación con `--dart-define` o,
/// más cómodo, con `--dart-define-from-file=dart_define.json`. De esta forma
/// las credenciales nunca quedan escritas en el código fuente.
///
/// Ejemplo:
/// ```
/// flutter run --dart-define-from-file=dart_define.json
/// ```
///
/// Ver `dart_define.example.json` y `CONFIGURAR_EMAIL.md`.
class EmailConfig {
  const EmailConfig._();

  /// Servidor SMTP. Gmail: smtp.gmail.com · Outlook: smtp-mail.outlook.com
  static const String host =
      String.fromEnvironment('SMTP_HOST', defaultValue: 'smtp.gmail.com');

  /// 587 para STARTTLS (recomendado) o 465 para SSL directo.
  static const int port = int.fromEnvironment('SMTP_PORT', defaultValue: 587);

  /// Cuenta desde la que se envían los correos.
  static const String username = String.fromEnvironment('SMTP_USERNAME');

  /// En Gmail NO es la contraseña de la cuenta, es una "contraseña de
  /// aplicación" de 16 caracteres.
  static const String password = String.fromEnvironment('SMTP_PASSWORD');

  /// Nombre que verá el destinatario como remitente.
  static const String fromName = String.fromEnvironment(
    'SMTP_FROM_NAME',
    defaultValue: 'GeoGuardian AI',
  );

  /// `true` solo si usas el puerto 465 (SSL implícito).
  static const bool useSsl = bool.fromEnvironment('SMTP_SSL');

  /// Cuánto tiempo esperamos al servidor antes de abortar el envío.
  static const Duration timeout = Duration(seconds: 25);

  /// Si no hay credenciales, el envío se desactiva y el código se muestra en
  /// consola (modo desarrollo).
  static bool get isConfigured => username.isNotEmpty && password.isNotEmpty;
}
