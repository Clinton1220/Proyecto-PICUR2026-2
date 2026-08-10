import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'title': 'Lluvia fuerte',
        'date': '05 ago 2026',
        'detail': 'Zona con alerta de lluvia intensa. Revisa drenajes.'
      },
      {
        'title': 'Aumento de inclinación',
        'date': '04 ago 2026',
        'detail': 'Se detectó inclinación mayor al 8% en el sector norte.'
      },
      {
        'title': 'Humedad alta',
        'date': '03 ago 2026',
        'detail': 'Humedad del suelo superior al 75% en la región central.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
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
                Text(alert['title']!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(alert['date']!,
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 12),
                Text(alert['detail']!, style: const TextStyle(height: 1.4)),
              ],
            ),
          );
        },
      ),
    );
  }
}
