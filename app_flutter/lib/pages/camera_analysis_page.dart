import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/rounded_button.dart';

class CameraAnalysisPage extends StatefulWidget {
  const CameraAnalysisPage({super.key});

  @override
  State<CameraAnalysisPage> createState() => _CameraAnalysisPageState();
}

class _CameraAnalysisPageState extends State<CameraAnalysisPage> {
  bool _loading = false;
  String _result =
      'Toma una foto o selecciona una imagen para analizar con IA.';

  Future<void> _analyzeImage() async {
    setState(() {
      _loading = true;
      _result = 'Analizando...';
    });
    final response = await AiService.instance.analyzeImage(
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80');
    setState(() {
      _loading = false;
      _result = response;
    });
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
                    onPressed: _analyzeImage,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Tomar foto'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _analyzeImage,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 10)),
                ],
              ),
              child: Text(_result,
                  style: const TextStyle(fontSize: 16, height: 1.5)),
            ),
            const SizedBox(height: 18),
            RoundedButton(
              onPressed: _analyzeImage,
              child: _loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Analizar con IA'),
            ),
          ],
        ),
      ),
    );
  }
}
