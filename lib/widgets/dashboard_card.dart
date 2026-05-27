import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: color,

          borderRadius:
              BorderRadius.circular(15),
        ),

        child: Column(
          children: [
            Text(
              title,

              style: const TextStyle(
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value.toString(),

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}