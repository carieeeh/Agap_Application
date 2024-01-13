import 'package:flutter/material.dart';

class ReportRowDetail extends StatelessWidget {
  const ReportRowDetail(
      {super.key, required this.label, required this.information});
  final String label;
  final String information;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(information)),
        ],
      ),
    );
  }
}
