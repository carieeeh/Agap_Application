import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/model/emergency.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportsList extends StatefulWidget {
  const ReportsList({super.key});

  @override
  State<ReportsList> createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  final ReportController _report = Get.find<ReportController>();
  List filteredEmergencies = [];
  DateTime? _startDate, _endDate;

  @override
  void initState() {
    filteredEmergencies = _report.emergencies;
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2022),
        lastDate: DateTime(DateTime.now().year + 1),
        initialDateRange:
            DateTimeRange(start: DateTime.now(), end: DateTime.now()));
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        filteredEmergencies = _report.emergencies.where((emergency) {
          final item = Emergency.fromJson(emergency.data());
          final date = item.createdAt.toDate();
          return date.isAfter(_startDate!) && date.isBefore(_endDate!);
        }).toList();
      });
      print(filteredEmergencies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Report Status",
      actionButton: IconButton(
        onPressed: () {
          _selectDate(context);
        },
        icon: const Icon(
          Icons.calendar_month,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
          () => Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Date", style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("Report",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    Text("Status",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Divider(),
              Visibility(
                visible: _report.isLoading.isTrue,
                child: SizedBox(
                  height: Get.height * .8,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Visibility(
                visible: _report.isLoading.isFalse,
                child: SizedBox(
                  height: Get.height * .80,
                  child: ListView.builder(
                    itemCount: filteredEmergencies.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final emergency =
                          Emergency.fromJson(filteredEmergencies[index].data());
                      final String emergencyId = filteredEmergencies[index].id;
                      String formattedDate = DateFormat('MM/dd/yyyy').format(
                          emergency.createdAt.toDate()); // Format the date
                      return Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Get.to(
                              //   ReportFeedback(
                              //     emergencyDocId: emergencyId,
                              //     userUid: emergency.residentUid ?? "",
                              //     role: "resident",
                              //     readOnly: true,
                              //   ),
                              // );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 40),
                                SizedBox(
                                  width: 115,
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Text(
                                    "${emergency.type}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: emergency.status == "finished"
                                        ? colorSuccess
                                        : emergency.status == "rejected"
                                            ? colorError
                                            : emergency.status == "pending"
                                                ? orange
                                                : emergency.status == "accepted"
                                                    ? yellow
                                                    : brown,
                                  ),
                                  child: Text(
                                    "${emergency.status}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
