import 'dart:async';
import 'dart:math';

class AiService {
  AiService._();
  static final AiService instance = AiService._();

  final _rnd = Random();

  Future<String> analyzeImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final score = 0.65 + _rnd.nextDouble() * 0.25;
    final level = score > 0.8
        ? 'ALTO'
        : score > 0.7
            ? 'MEDIO'
            : 'BAJO';
    return 'Análisis IA completo: nivel de riesgo $level. Recomendación: revisa el drenaje, aplica refuerzo en puntos críticos y monitorea la humedad cada hora.';
  }

  Future<String> assistantReply(String prompt) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final lower = prompt.toLowerCase();
    if (lower.contains('riesgo') || lower.contains('derrumbre')) {
      return 'Según los datos actuales, el terreno muestra señales de inestabilidad. Te recomiendo verificar la inclinación y la lluvia acumulada en las últimas 12 horas.';
    }
    if (lower.contains('lluvia') || lower.contains('humedad')) {
      return 'El nivel de humedad es un factor importante. Si supera el 70%, el riesgo de deslizamiento aumenta. Mantén el suelo ventilado y controla fugas de agua.';
    }
    if (lower.contains('camera') ||
        lower.contains('foto') ||
        lower.contains('imagen')) {
      return 'Ya tienes una función de análisis de imagen en la Cámara IA. Toma una foto y presiona "Analizar con IA" para obtener una evaluación rápida.';
    }
    if (lower.contains('hola') || lower.contains('buenos')) {
      return 'Hola, soy tu asistente IA de GeoGuardian. Puedo ayudarte a analizar riesgos, interpretar sensores y recomendar acciones de seguridad.';
    }
    return 'Puedo ayudarte con análisis de riesgos, sensores, alertas y recomendaciones de seguridad. Pregúntame algo específico sobre el terreno o las condiciones.';
  }
}
