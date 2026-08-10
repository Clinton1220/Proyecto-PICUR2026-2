import 'package:flutter/material.dart';

class ReportZonePage extends StatefulWidget {
  const ReportZonePage({super.key});

  @override
  State<ReportZonePage> createState() => _ReportZonePageState();
}

class _ReportZonePageState extends State<ReportZonePage> {
  final _descriptionCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_descriptionCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte enviado con éxito.')),
    );
    _descriptionCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar zona'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Describe la situación de la zona',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionCtrl,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Escribe aquí el problema o condición observada...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _loading ? null : _submitReport,
              child: _loading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar reporte'),
            ),
          ],
        ),
      ),
    );
  }
}
