import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerSettingsPage extends StatefulWidget {
  const RescuerSettingsPage({super.key});

  @override
  State<RescuerSettingsPage> createState() => _RescuerSettingsPageState();
}

class _RescuerSettingsPageState extends State<RescuerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Settings",
      body: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text("Account"),
            onTap: () {
              Get.toNamed('/profile');
            },
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.visibility_outlined),
          //   title: const Text("Appearance"),
          //   onTap: () {},
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text("Contact"),
            onTap: () {},
          ),
          const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.notifications),
          //   title: const Text("Notification"),
          //   onTap: () {},
          // ),
          // const Divider(),
          ListTile(
            leading: const Icon(Icons.question_mark_outlined),
            title: const Text("About us"),
            onTap: () {},
          ),
          const Divider(),
        ],
      ),
    );
  }
}
