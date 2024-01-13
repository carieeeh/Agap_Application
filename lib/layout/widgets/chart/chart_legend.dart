import 'package:flutter/material.dart';

class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.color, required this.title});
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
