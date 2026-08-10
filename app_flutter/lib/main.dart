import 'package:flutter/material.dart';
import 'pages/splash_page.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  runApp(const GeoGuardianApp());
}

class GeoGuardianApp extends StatelessWidget {
  const GeoGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoGuardian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A7F35)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

class HistoryEvent {
  final String title;
  final String subtext;
  final String time;
  final String humidity;
  final String inclination;

  const HistoryEvent(
      {required this.title,
      required this.subtext,
      required this.time,
      required this.humidity,
      required this.inclination});
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
