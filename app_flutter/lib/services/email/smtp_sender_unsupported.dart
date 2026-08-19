import 'email_types.dart';

/// Fallback para Flutter Web: el navegador no permite abrir sockets SMTP,
/// así que el envío directo no es posible. En web hay que pasar por un
/// backend propio o por una API HTTP de correo.
Future<EmailDeliveryResult> sendEmail(EmailMessage email) async {
  return const EmailDeliveryResult(
    false,
    'El envío de correo por SMTP no está disponible en la versión web. '
    'Ejecuta la app en Windows o Android.',
  );
}
