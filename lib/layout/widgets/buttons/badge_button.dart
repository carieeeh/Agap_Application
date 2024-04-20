import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/resident_controller.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BadgeButton extends StatefulWidget {
  const BadgeButton({
    super.key,
    required this.badge,
    required this.imageUrl,
    required this.description,
    required this.points,
  });

  final String badge;
  final String imageUrl;
  final String description;
  final int points;

  @override
  State<BadgeButton> createState() => _BadgeButtonState();
}

class _BadgeButtonState extends State<BadgeButton> {
  final ResidentController _residentController = Get.find<ResidentController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.dialog(
          Dialog(
            child: SizedBox(
              height: Get.height * .645,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: Get.height * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Image.network(widget.imageUrl),
                    ),
                    Text("AGAP points needed: ${widget.points.toString()}"),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    RoundedCustomButton(
                      onPressed: () {
                        _residentController.buyBadges(
                          widget.badge,
                          widget.points,
                        );
                      },
                      isLoading: _residentController.isLoading.value,
                      label: "Unlock",
                      size: Size(Get.width * .7, 30),
                      bgColor: primaryRed,
                    ),
                    RoundedCustomButton(
                      onPressed: () {
                        Get.back();
                      },
                      label: "Close",
                      size: Size(Get.width * .7, 30),
                      bgColor: gray,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Positioned(
              top: 0,
              right: 0,
              child: Icon(Icons.lock_outline, color: Colors.black),
            ),
            Image.network(widget.badge),
          ],
        ),
      ),
    );
  }
}
