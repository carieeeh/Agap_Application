import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/private/resident/dashboard/agap_points.dart';
import 'package:agap_mobile_v01/layout/private/resident/dashboard/report_incidents.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
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
        'AGAP Points',
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
                ReportIncidents(),
                AGAPPoints(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
