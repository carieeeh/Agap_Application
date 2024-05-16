import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Text(
            "Vision",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Making Manila City safer and stronger with innovative technology, ensuring quick emergency response and reducing disaster risks effectively.",
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          const Text(
            "Mission",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Creating AGAP, an easy-to-use Emergency Response App, giving Manila City residents instant access to emergency help. With AGAP, ensuring fast and effective responses to both natural disasters and man-made hazards. Using simple, smart technology to improve communication, preparedness, and response, saving lives and protecting property and the environment.",
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
