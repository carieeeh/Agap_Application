import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/bottom_sheet/about_us.dart';
import 'package:agap_mobile_v01/layout/widgets/bottom_sheet/terms_and_condition.dart';
import 'package:agap_mobile_v01/layout/widgets/contact_us.dart';
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
              Get.toNamed('/rescuer_profile');
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
            onTap: () {
              Get.to(() => const ContactUs());
            },
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
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const AboutUs(),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.format_line_spacing_rounded),
            title: const Text("Terms and Condition"),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const TermsAndCondition(),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
