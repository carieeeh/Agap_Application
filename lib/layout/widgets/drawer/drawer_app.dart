import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/resident_controller.dart';
import 'package:agap_mobile_v01/global/controller/settings_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerApp extends StatelessWidget {
  DrawerApp({super.key});

  final AuthController _auth = Get.find<AuthController>();
  final SettingsController _settings = Get.find<SettingsController>();
  final ResidentController _residentController = Get.find<ResidentController>();

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
                            backgroundImage: NetworkImage(
                              _auth.userModel!.profile!,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 30,
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Image.network(
                                _residentController.selectedBadgeUrl.value,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _auth.userModel!.fullName ?? "",
                        style: const TextStyle(color: Colors.white),
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
                    Get.toNamed("/home");
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
                Visibility(
                  visible: _settings.hasReport.value,
                  child: ListTile(
                    leading: const Icon(
                      Icons.map_rounded,
                      color: Colors.white,
                    ),
                    title: const Text(
                      "Ongoing Report",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Get.offAllNamed('/rescuer_map_view');
                    },
                  ),
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
