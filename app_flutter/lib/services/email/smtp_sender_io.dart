import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'email_config.dart';
import 'email_types.dart';

/// Envío por SMTP para las plataformas con `dart:io`
/// (Android, iOS, Windows, macOS y Linux).
Future<EmailDeliveryResult> sendEmail(EmailMessage email) async {
  final server = SmtpServer(
    EmailConfig.host,
    port: EmailConfig.port,
    username: EmailConfig.username,
    password: EmailConfig.password,
    ssl: EmailConfig.useSsl,
  );

  final message = Message()
    ..from = const Address(EmailConfig.username, EmailConfig.fromName)
    ..recipients.add(email.to)
    ..subject = email.subject
    ..text = email.text
    ..html = email.html;

  try {
    await send(message, server, timeout: EmailConfig.timeout);
    return const EmailDeliveryResult.success();
  } on MailerException catch (e) {
    return EmailDeliveryResult(false, _describeMailerError(e));
  } on SocketException {
    return const EmailDeliveryResult(
      false,
      'Sin conexión con el servidor de correo. Revisa tu internet.',
    );
  } catch (e) {
    return EmailDeliveryResult(false, 'No se pudo enviar el correo: $e');
  }
}

/// Traduce los fallos SMTP más comunes a algo accionable.
String _describeMailerError(MailerException e) {
  final detail = e.message.toLowerCase();
  if (detail.contains('535') ||
      detail.contains('authentication') ||
      detail.contains('username and password')) {
    return 'El servidor rechazó las credenciales SMTP. '
        'En Gmail debes usar una contraseña de aplicación, no la de tu cuenta.';
  }
  if (detail.contains('timed out') || detail.contains('timeout')) {
    return 'El servidor de correo no respondió a tiempo. Inténtalo de nuevo.';
  }
  return 'No se pudo enviar el correo: ${e.message}';
}
