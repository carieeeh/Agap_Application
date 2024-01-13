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
    return Column(
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
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Lorem ipsum dolor sit amet. Aut velit dolorem et magni suscipit est accusamus inventore non repellat quia.",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            "Unlock AGAP Badges using points:",
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: Get.height * .4,
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 3,
            children: const [
              BadgeButton(
                badge: Text(
                  "Badge 1",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              BadgeButton(
                badge: Text(
                  "Badge 2",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              BadgeButton(
                badge: Text(
                  "Badge 3",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              BadgeButton(
                badge: Text(
                  "Badge 4",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              BadgeButton(
                badge: Text(
                  "Badge 5",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              BadgeButton(
                badge: Text(
                  "Badge 6",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
