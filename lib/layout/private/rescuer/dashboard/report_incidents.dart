import 'dart:convert';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/global/model/emergency.dart';
import 'package:agap_mobile_v01/global/web_view.dart';
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
  DateTime? _selectedDate;
  final SettingsController _settingsController = Get.find<SettingsController>();
  final ReportController _reportController = Get.find<ReportController>();
  List<Emergency> emergencyList = [];
  List<Map<String, dynamic>> result = [];

  @override
  void initState() {
    emergencyList = (_reportController.emergencies)
        .map((emergencyJson) => Emergency.fromJson(emergencyJson.data()))
        .toList();
    result = _reportController.getTotalEmergenciesByTypeAndMonth(
        emergencyList, 2024);
    super.initState();
  }

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
            InkWell(
              onTap: () {
                _selectYear(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: primaryRed,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Year ${_selectedDate?.year ?? "2024"}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            InkWell(
              onTap: () {
                downloadExcel();
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
        ReportChart(result: result),
      ],
    );
  }

  void downloadExcel() {
    List toExcel = result.map((e) {
      return {
        "month": "${indexToMonth(e["month"])} ${_selectedDate?.year ?? "2024"}",
        "fire": e["fire"],
        "police": e["police"],
        "medical": e["medical"],
        "earthquake": e["earthquake"],
        "flood": e["flood"],
      };
    }).toList();

    String jsonString = jsonEncode(toExcel);
    String jsonStringWithoutSpaces = jsonString.replaceAll(RegExp(r'\s'), '');
    String urlEncodedString = Uri.encodeFull(jsonStringWithoutSpaces);

    print(urlEncodedString);
    webViewLauncher(
      url: 'https://agap-f4c32.web.app/export?data=$urlEncodedString',
      context: context,
    );
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String indexToMonth(int index) {
    String text = "";
    switch (index) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
    }
    return text;
  }
}
