import 'package:flutter/foundation.dart';

import 'email/email_config.dart';
import 'email/email_types.dart';
import 'email/smtp_sender_unsupported.dart'
    if (dart.library.io) 'email/smtp_sender_io.dart' as sender;

/// Para qué se emitió un código.
enum CodePurpose {
  /// Activación de una cuenta recién creada.
  registration,

  /// Restablecimiento de contraseña olvidada.
  recovery,
}

extension CodePurposeLabel on CodePurpose {
  String get storageKey => name;

  String get subject => switch (this) {
        CodePurpose.registration => 'Verifica tu cuenta de GeoGuardian AI',
        CodePurpose.recovery => 'Código para recuperar tu contraseña',
      };

  String get headline => switch (this) {
        CodePurpose.registration => 'Confirma tu correo',
        CodePurpose.recovery => 'Recupera tu contraseña',
      };

  String get intro => switch (this) {
        CodePurpose.registration =>
          'Gracias por registrarte en GeoGuardian AI. Usa este código para activar tu cuenta:',
        CodePurpose.recovery =>
          'Recibimos una solicitud para restablecer tu contraseña. Usa este código para continuar:',
      };

  String get footer => switch (this) {
        CodePurpose.registration =>
          'Si no creaste esta cuenta, puedes ignorar este mensaje.',
        CodePurpose.recovery =>
          'Si no solicitaste el cambio, ignora este correo: tu contraseña actual seguirá siendo válida.',
      };
}

/// Envía los correos transaccionales de la app.
class EmailService {
  EmailService._();
  static final EmailService instance = EmailService._();

  bool get isConfigured => EmailConfig.isConfigured;

  /// Envía un código de 6 dígitos al correo indicado.
  ///
  /// Si no hay credenciales SMTP configuradas, en modo debug el código se
  /// imprime en consola para poder seguir probando la app sin servidor.
  Future<EmailDeliveryResult> sendCode({
    required String to,
    required String code,
    required CodePurpose purpose,
    required Duration validFor,
  }) async {
    if (!isConfigured) {
      if (kDebugMode) {
        debugPrint('[GeoGuardian] Código ${purpose.name} para $to: $code');
        return const EmailDeliveryResult(
          true,
          'SMTP no configurado: el código se imprimió en la consola de debug',
        );
      }
      return const EmailDeliveryResult(
        false,
        'El envío de correos no está configurado en esta compilación.',
      );
    }

    return sender.sendEmail(
      EmailMessage(
        to: to,
        subject: purpose.subject,
        html: _buildHtml(code, purpose, validFor),
        text: _buildText(code, purpose, validFor),
      ),
    );
  }

  String _buildText(String code, CodePurpose purpose, Duration validFor) {
    return '''
${purpose.headline}

${purpose.intro}

$code

El código vence en ${validFor.inMinutes} minutos.

${purpose.footer}

GeoGuardian AI - Monitoreo de riesgo de deslizamientos
''';
  }

  String _buildHtml(String code, CodePurpose purpose, Duration validFor) {
    final spacedCode = code.split('').join('&nbsp;');
    return '''
<!DOCTYPE html>
<html lang="es">
<body style="margin:0;padding:24px;background:#f4f7f6;font-family:Segoe UI,Roboto,Helvetica,Arial,sans-serif;">
  <table role="presentation" width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <td align="center">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0"
               style="max-width:520px;background:#ffffff;border-radius:18px;overflow:hidden;box-shadow:0 6px 24px rgba(0,0,0,0.06);">
          <tr>
            <td style="background:#2A7F35;padding:22px 28px;color:#ffffff;font-size:20px;font-weight:700;">
              GeoGuardian AI
            </td>
          </tr>
          <tr>
            <td style="padding:28px;">
              <h1 style="margin:0 0 12px;font-size:22px;color:#1b1b1b;">${purpose.headline}</h1>
              <p style="margin:0 0 22px;font-size:15px;line-height:1.6;color:#444444;">${purpose.intro}</p>
              <div style="margin:0 0 18px;padding:18px;text-align:center;background:#f0f7f1;
                          border:1px dashed #2A7F35;border-radius:14px;">
                <span style="font-size:32px;font-weight:700;letter-spacing:6px;color:#2A7F35;">$spacedCode</span>
              </div>
              <p style="margin:0 0 22px;font-size:14px;color:#666666;">
                El código vence en <strong>${validFor.inMinutes} minutos</strong>.
              </p>
              <p style="margin:0;font-size:13px;line-height:1.6;color:#888888;">${purpose.footer}</p>
            </td>
          </tr>
          <tr>
            <td style="padding:16px 28px;background:#fafafa;font-size:12px;color:#999999;">
              GeoGuardian AI &middot; Monitoreo de riesgo de deslizamientos
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
''';
  }
}
