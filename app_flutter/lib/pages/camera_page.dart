import 'package:flutter/material.dart';
import '../widgets/risk_meter.dart';
import 'camera_analysis_page.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  void _navigateToAnalysis(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraAnalysisPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara IA'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToAnalysis(context),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Tomar foto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToAnalysis(context),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const RiskMeter(
                value: 0.85, label: 'Probabilidad de derrumbe', status: 'ALTA'),
          ],
        ),
      ),
    );
  }
}
