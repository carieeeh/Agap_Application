import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerReportsList extends StatefulWidget {
  const RescuerReportsList({super.key});

  @override
  State<RescuerReportsList> createState() => _RescuerReportsListState();
}

class _RescuerReportsListState extends State<RescuerReportsList> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Report Status",
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Date", style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Location", style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(
                  width: 80,
                  child: Text(
                    "Supporting Document",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: Get.height * .75,
            child: ListView.builder(
              itemCount: 5,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Get.toNamed('/rescuer_reports/rescuer_feedback');
                        Get.defaultDialog(
                          title: "Supporting Document",
                          content: Container(
                            height: Get.height * .3,
                            color: Colors.amber,
                            child: const Center(
                              child: Text(
                                "Supporting Document File Goes Here!",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          confirm: RoundedCustomButton(
                            onPressed: () {
                              Get.back();
                            },
                            label: "Close",
                            size: Size(Get.width * .5, 40),
                            bgColor: primaryRed,
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "12/10/2024",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "ABC St.",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              "View",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: primaryRed,
                              ),
                            ),
                          ),
                          Text(
                            "In Progress",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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
        ],
      ),
    );
  }
}
