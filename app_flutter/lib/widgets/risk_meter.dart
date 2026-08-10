import 'package:flutter/material.dart';

class RiskMeter extends StatelessWidget {
  final double value;
  final String label;
  final String status;

  const RiskMeter({
    super.key,
    required this.value,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(status,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(
              value: value,
              color: Colors.red,
              backgroundColor: Colors.red.shade100,
              minHeight: 10),
          const SizedBox(height: 14),
          Text('${(value * 100).round()}% Probabilidad de derrumbe',
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
