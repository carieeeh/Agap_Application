import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/chart/chart_legend.dart';
import 'package:agap_mobile_v01/layout/widgets/chart/report_chart.dart';
import 'package:flutter/material.dart';

class ReportIncidents extends StatefulWidget {
  const ReportIncidents({super.key});

  @override
  State<ReportIncidents> createState() => _ReportIncidentsState();
}

class _ReportIncidentsState extends State<ReportIncidents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Reported Incidents", style: TextStyle(fontSize: 24)),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: primaryRed,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Year 2024",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChartLegend(color: primaryRed, title: "Fire"),
            ChartLegend(color: colorSuccess, title: "Health care"),
            ChartLegend(color: primaryBlue, title: "Police"),
            ChartLegend(color: yellow, title: "Earthquake"),
            ChartLegend(color: skyBlue, title: "Flood"),
          ],
        ),
        const SizedBox(height: 20),
        const ReportChart(),
      ],
    );
  }
}
