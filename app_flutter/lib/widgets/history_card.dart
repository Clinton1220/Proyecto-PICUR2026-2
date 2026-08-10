import 'package:flutter/material.dart';
import '../models/history_event.dart';

class HistoryCard extends StatelessWidget {
  final HistoryEvent event;

  const HistoryCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(event.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(event.time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          Text(event.subtext, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 14,
            children: [
              _DetailChip(
                  label: 'Humedad: ${event.humidity}',
                  color: Colors.blue.shade50),
              _DetailChip(
                  label: 'Inclinación: ${event.inclination}',
                  color: Colors.green.shade50),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final Color color;

  const _DetailChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}
