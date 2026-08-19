import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 10)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Estado del terreno',
              style: TextStyle(color: Colors.black54, fontSize: 14)),
          SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.shield, color: Color(0xFF35AD56), size: 34),
              SizedBox(width: 14),
              Text('SEGURO',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Text('Todo normal por ahora',
              style: TextStyle(color: Colors.black54)),
          SizedBox(height: 18),
          Text('Última actualización: 10:30 a. m.',
              style: TextStyle(color: Colors.black38)),
        ],
      ),
    );
  }
}
