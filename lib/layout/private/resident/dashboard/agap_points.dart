import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/badge_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AGAPPoints extends StatefulWidget {
  const AGAPPoints({super.key});

  @override
  State<AGAPPoints> createState() => _AGAPPointsState();
}

class _AGAPPointsState extends State<AGAPPoints> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Color of the shadow
                  spreadRadius: 2, // Spread radius
                  blurRadius: 2, // Blur radius
                  offset: const Offset(4, 4), // Offset (x, y)
                )
              ],
            ),
            child: const Column(
              children: [
                Text(
                  "AGAP Points",
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  "35 points",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: lightGray,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Color of the shadow
                  spreadRadius: 2, // Spread radius
                  blurRadius: 2, // Blur radius
                  offset: const Offset(4, 4), // Offset (x, y)
                )
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What is AGAP Points?",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  "AGAP points are use to buy badges listed below. You will earn 1 AGAP point for each emergency you report is completed.",
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 30.0),
            child: Text(
              "Unlock AGAP Badges using points:",
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: Get.height * .41,
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 3,
              children: [
                BadgeButton(
                  points: "3",
                  description:
                      "Guardian Angel Badge - Avid reporter and assists in emergency incidents. Consistently helps in emergency incidents. Acting as a guardian angel for the community.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2Fwith_bg%2FGuardian%20Angel%20Badge.png?alt=media&token=59d4134d-ea24-41e9-bb3f-0d6c7e7e913d",
                  badge: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2FGuardian%20Angel%20Badge.png?alt=media&token=90b506ae-7c47-4f02-86f7-8b4d17c5b59d",
                  ),
                ),
                BadgeButton(
                  points: "3",
                  description:
                      "Swift Reporter Badge - Reports emergency incident quickly. Rapidly reports an emergency situation.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2Fwith_bg%2FSwift%20Responder%20Badge.png?alt=media&token=33fede4a-d36c-42f6-8984-6b2b53c2f72b",
                  badge: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2FSwift%20Responder%20Badge.png?alt=media&token=3f545bc1-a91d-424d-ad11-a62cdfb9619a",
                  ),
                ),
                BadgeButton(
                  points: "5",
                  description:
                      "Life Saver Badge - Users who has a significant impact by actively participating in emergency situations that directly contribute to saving lives, demonstrating a high level of commitment.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2Fwith_bg%2FLife%20Saver%20Badge.png?alt=media&token=2c6a8b96-319f-4c02-aedd-deaa7bbfea97",
                  badge: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2FLife%20Saver%20Badge.png?alt=media&token=ec1a0601-f663-47c2-b039-f30fee5945be",
                  ),
                ),
                BadgeButton(
                  points: "5",
                  description:
                      "Night Owl Badge - Actively reports night time emergency situations. Dedicated to ensure the safety of the community when little to no one is around.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2Fwith_bg%2FNight%20Owl%20Badge.png?alt=media&token=6b4d9225-986f-4a13-931e-ff5c3f94fd67",
                  badge: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2FNight%20Owl%20Badge.png?alt=media&token=9a58a8f7-66cc-4907-87f1-37c33b5f5745",
                  ),
                ),
                BadgeButton(
                  points: "10",
                  description:
                      "Crisis Communicator Badge - Provides clear and concise emergency report. Excels in providing accurate information of an emergency report, contributes to the information and calmness of the community during an emergency crisis.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2Fwith_bg%2FCrisis%20Communicator%20Badge.png?alt=media&token=f3bc9884-9f7c-4dea-b939-e0c896726b70",
                  badge: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2FCrisis%20Communicator%20Badge.png?alt=media&token=69fb1b1b-7c78-4544-b20c-51cd3cdc1eaa",
                  ),
                ),
                BadgeButton(
                  points: "15",
                  description:
                      "Hero Badge - Active participation in emergency crisis and collaborates with the community. Displays great leadership and coordination.",
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2Fwith_bg%2FCommunity%20Hero%20Badge.png?alt=media&token=83a1b0e1-3f04-48b7-ba08-b08f9f261f26",
                  badge: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/agap-f4c32.appspot.com/o/badges%2FCommunity%20Hero%20Badge.png?alt=media&token=dc8be817-6db5-49e9-bcde-da07013c307b",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
