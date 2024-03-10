import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerApp extends StatefulWidget {
  const DrawerApp({super.key});

  @override
  State<DrawerApp> createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
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
                      Stack(
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
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.health_and_safety_rounded,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
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
                    Get.toNamed('/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.white),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Colors.white),
                  title: const Text(
                    "Dashboard",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/dashboard');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.white),
                  title: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.toNamed('/settings');
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
                    Get.offAllNamed('/reports');
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
                cancel: RoundedCustomButton(
                  onPressed: () {
                    _auth.logOut();
                  },
                  label: "Yes",
                  size: Size(Get.width * .5, 40),
                  bgColor: primaryRed,
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
