import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/home/report_row_detail.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportDetails extends StatefulWidget {
  const ReportDetails({super.key});

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      isLeadingBackBtn: true,
      title: 'Report Details',
      body: SizedBox(
        height: Get.height * .8,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Label Assitance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: Get.height * .3,
                width: Get.width * .75,
                color: lightGray,
                child: const Center(
                  child: Text("Supporting Image/Video Here!"),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.0),
                child: Column(
                  children: [
                    ReportRowDetail(label: 'Date', information: '01/13/2024'),
                    ReportRowDetail(
                        label: 'Location',
                        information: 'TUP San Marcelino St. Manila City'),
                    ReportRowDetail(label: 'Status', information: 'Pending'),
                    ReportRowDetail(
                        label: 'Active Onsite Responders', information: '5'),
                    ReportRowDetail(
                        label: 'Needed Emergency Unit', information: '7'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              RoundedCustomButton(
                onPressed: () {},
                label: "RESPOND!",
                size: Size(Get.width * .85, 40),
                radius: 10,
                bgColor: primaryRed,
              )
            ],
          ),
        ),
      ),
    );
  }
}
