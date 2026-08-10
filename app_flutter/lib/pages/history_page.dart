import 'package:flutter/material.dart';
import '../models/history_event.dart';
import '../widgets/history_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView.separated(
          itemCount: historyEvents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) =>
              HistoryCard(event: historyEvents[index]),
        ),
      ),
    );
  }
}

const historyEvents = [
  HistoryEvent(
      title: 'Seguro',
      subtext: 'Humedad: 60% · Inclinación: 5°',
      time: '10 jul 2024 · 10:30 a.m.',
      humidity: '60%',
      inclination: '5°'),
  HistoryEvent(
      title: 'Precaución',
      subtext: 'Humedad: 75% · Inclinación: 8°',
      time: '09 jul 2024 · 02:15 p.m.',
      humidity: '75%',
      inclination: '8°'),
  HistoryEvent(
      title: 'Riesgo Alto',
      subtext: 'Humedad: 90% · Inclinación: 12°',
      time: '08 jul 2024 · 11:45 a.m.',
      humidity: '90%',
      inclination: '12°'),
  HistoryEvent(
      title: 'Precaución',
      subtext: 'Humedad: 70% · Inclinación: 7°',
      time: '07 jul 2024 · 09:20 a.m.',
      humidity: '70%',
      inclination: '7°'),
  HistoryEvent(
      title: 'Seguro',
      subtext: 'Humedad: 55% · Inclinación: 4°',
      time: '06 jul 2024 · 08:10 a.m.',
      humidity: '55%',
      inclination: '4°'),
];
