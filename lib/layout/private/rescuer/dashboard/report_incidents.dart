import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/chart/chart_legend.dart';
import 'package:agap_mobile_v01/layout/widgets/chart/report_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerReportIncidents extends StatefulWidget {
  const RescuerReportIncidents({super.key});

  @override
  State<RescuerReportIncidents> createState() => _RescuerReportIncidentsState();
}

class _RescuerReportIncidentsState extends State<RescuerReportIncidents> {
  final SettingsController _settingsController = Get.find<SettingsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("Reported Incidents", style: TextStyle(fontSize: 24)),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.filter_alt),
                  Text("Filter"),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Year 2024",
                style: TextStyle(color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                _settingsController.callFunction("", {});
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: lightGray,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.download),
                    Text("Download"),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChartLegend(color: primaryRed, title: "Fire"),
            ChartLegend(color: colorSuccess, title: "Medicine"),
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
