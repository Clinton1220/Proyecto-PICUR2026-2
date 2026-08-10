import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _controller = TextEditingController();
  String _response = 'Pregunta algo sobre el terreno, sensores o riesgos.';
  bool _loading = false;

  Future<void> _send() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _loading = true;
      _response = 'Procesando...';
    });

    final result = await AiService.instance.assistantReply(prompt);
    setState(() {
      _loading = false;
      _response = result;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente IA'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Text(_response,
                    style: const TextStyle(fontSize: 16, height: 1.5)),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Escribe tu pregunta aquí...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              minLines: 1,
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: _loading ? null : _send,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Consultar IA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
