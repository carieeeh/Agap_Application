import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerDrawerApp extends StatelessWidget {
  RescuerDrawerApp({super.key});

  final AuthController _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          SizedBox(
            height: Get.height * .9,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: Get.height * .2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/person.png',
                          fit: BoxFit.cover,
                          height: 45,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Juan Dela Cruz",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.white),
                  title: const Text(
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/rescuer_profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.white),
                  title: const Text(
                    "Interactive Map",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/interactive_map');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Colors.white),
                  title: const Text(
                    "Dashboard",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/rescuer_dashboard');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/rescuer_settings');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.health_and_safety,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Emergency Reports",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/rescuer_reports');
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Get.defaultDialog(
                title: "Are you sure you want to log out?",
                content: Container(),
                cancel: Obx(
                  () => RoundedCustomButton(
                    onPressed: () {
                      _auth.logOut();
                    },
                    isLoading: _auth.isLoading.isTrue,
                    label: "Yes",
                    size: Size(Get.width * .5, 40),
                    bgColor: primaryRed,
                  ),
                ),
                confirm: RoundedCustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  label: "No",
                  size: Size(Get.width * .5, 40),
                  bgColor: gray,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
