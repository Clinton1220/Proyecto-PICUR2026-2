import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/status_card.dart';
import '../widgets/sensor_card.dart';
import 'alerts_page.dart';
import 'sensor_detail_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Hola, ${AuthService.instance.currentUser?.name ?? 'Usuario'}'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AlertsPage()),
            ),
            icon: const Icon(Icons.notifications_none),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StatusCard(),
            const SizedBox(height: 22),
            const _SensorGrid(),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SensorDetailPage()),
              ),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Ver detalle de sensores'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SensorGrid extends StatelessWidget {
  const _SensorGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.3,
      children: const [
        SensorCard(
            label: 'Humedad del suelo',
            value: '65%',
            status: 'Normal',
            icon: Icons.water_drop),
        SensorCard(
            label: 'Lluvia acumulada',
            value: '0 mm',
            status: 'Sin lluvia',
            icon: Icons.umbrella),
        SensorCard(
            label: 'Inclinación',
            value: '5°',
            status: 'Estable',
            icon: Icons.terrain),
        SensorCard(
            label: 'Temperatura',
            value: '27°C',
            status: 'Normal',
            icon: Icons.thermostat),
      ],
    );
  }
}
