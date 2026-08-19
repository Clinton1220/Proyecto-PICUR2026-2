/// Resultado de un intento de envío de correo.
class EmailDeliveryResult {
  final bool ok;

  /// Mensaje apto para mostrarle al usuario.
  final String message;

  const EmailDeliveryResult(this.ok, this.message);

  const EmailDeliveryResult.success()
      : ok = true,
        message = 'Correo enviado';
}

/// Correo listo para enviar, en versión HTML y texto plano.
class EmailMessage {
  final String to;
  final String subject;
  final String html;
  final String text;

  const EmailMessage({
    required this.to,
    required this.subject,
    required this.html,
    required this.text,
  });
}
