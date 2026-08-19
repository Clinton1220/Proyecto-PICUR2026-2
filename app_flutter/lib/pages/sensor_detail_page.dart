import 'package:flutter/material.dart';

class SensorDetailPage extends StatelessWidget {
  const SensorDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de sensores'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen de sensores',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _SensorInfoTile(
              label: 'Humedad del suelo',
              value: '65%',
              detail: 'Nivel correcto, sin riego adicional requerido',
            ),
            SizedBox(height: 12),
            _SensorInfoTile(
              label: 'Lluvia acumulada',
              value: '0 mm',
              detail: 'No se detectó lluvia registrada en las últimas 6 horas',
            ),
            SizedBox(height: 12),
            _SensorInfoTile(
              label: 'Inclinación',
              value: '5°',
              detail: 'Lectura estable. Mantener monitoreo semanal',
            ),
            SizedBox(height: 12),
            _SensorInfoTile(
              label: 'Temperatura',
              value: '27°C',
              detail: 'Condición normal para la zona',
            ),
          ],
        ),
      ),
    );
  }
}

class _SensorInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String detail;

  const _SensorInfoTile({
    required this.label,
    required this.value,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(detail, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
