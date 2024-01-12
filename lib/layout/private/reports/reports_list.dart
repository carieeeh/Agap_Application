import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsList extends StatefulWidget {
  const ReportsList({super.key});

  @override
  State<ReportsList> createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Status",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
          );
        }),
        backgroundColor: primaryRed,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Date", style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Report", style: TextStyle(fontWeight: FontWeight.w600)),
                Text("Status", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: Get.height * .80,
            child: ListView.builder(
              itemCount: 20,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    TextButton(
                      onPressed: () {},
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
                            "Fire",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
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
