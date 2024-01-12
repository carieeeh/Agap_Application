import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/drawer/drawer_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainContainer extends StatefulWidget {
  final String title;
  final Widget body;
  final bool? isLeadingBackBtn;

  const MainContainer({
    super.key,
    required this.title,
    required this.body,
    this.isLeadingBackBtn,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: widget.isLeadingBackBtn ?? false
            ? BackButton(
                onPressed: () {
                  Get.back();
                },
                color: Colors.white,
              )
            : Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu_rounded, color: Colors.white),
                );
              }),
        backgroundColor: primaryRed,
      ),
      drawer: const DrawerApp(),
      body: widget.body,
    );
  }
}
