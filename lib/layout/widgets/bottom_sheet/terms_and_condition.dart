import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        children: [
          Center(
            child: Container(
              height: 6,
              width: 80,
              decoration: BoxDecoration(
                color: gray,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: Get.height * .45,
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "*Terms and Conditions*",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "1. *Purpose of the Application:* This Emergency Rescue Application is intended to provide assistance during emergencies and critical situations, in accordance with the provisions of the Philippine Constitution and By-Laws.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "2. *Accurate Use:* Users of this application are expected to provide accurate information when reporting emergencies. False reporting or misuse of the application for non-emergency purposes is strictly prohibited.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "3. *Legal Compliance:* Users are required to comply with all applicable laws and regulations of the Philippines when using this application. Any violation of the law, including but not limited to false reporting, abuse of emergency services, or infringement of privacy rights, will result in legal action.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "4. *Protection of Privacy:* The application respects the privacy rights of individuals. Users are prohibited from sharing personal information of others without consent, and any misuse of personal data will be subject to legal consequences.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "5. *Penalties for Abuse:* Any user found to be abusing the application, including false reporting, misuse of emergency services, or violation of privacy rights, will face penalties as prescribed by Philippine laws and regulations.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "6. *User Responsibility:* Users are solely responsible for their actions and conduct while using the application. They must exercise caution and diligence to ensure the accurate and appropriate use of emergency services.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "7. *Disclaimer:* The developers and administrators of this application shall not be held liable for any damages, losses, or consequences arising from the misuse or abuse of the application by users. Users agree to indemnify and hold harmless the developers and administrators from any claims or liabilities resulting from their actions.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "8. *Modification of Terms:* These terms and conditions may be modified or updated by the developers and administrators of the application at any time. Users are advised to review the terms periodically for any changes.",
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "By using this Emergency Rescue Application, users acknowledge that they have read, understood, and agreed to abide by these terms and conditions, as well as the applicable laws and regulations of the Philippines.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
