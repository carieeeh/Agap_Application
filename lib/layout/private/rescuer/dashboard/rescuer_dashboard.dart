import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/dashboard/recuer_report_feedback.dart';
import 'package:agap_mobile_v01/layout/private/rescuer/dashboard/report_incidents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerDashboard extends StatefulWidget {
  const RescuerDashboard({super.key});

  @override
  State<RescuerDashboard> createState() => _RescuerDashboardState();
}

class _RescuerDashboardState extends State<RescuerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _tabs = [
    const Tab(
      child: Text(
        'Reported Inidents',
        style: TextStyle(color: Colors.black),
      ),
    ),
    const Tab(
      child: Text(
        'Feedback',
        style: TextStyle(color: Colors.black),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Dashboard",
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: _tabs,
            indicatorColor: primaryRed,
          ),
          SizedBox(
            height: Get.height * .8,
            child: TabBarView(
              controller: _tabController,
              children: const [
                RescuerReportIncidents(),
                RescuerReportFeedback(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
