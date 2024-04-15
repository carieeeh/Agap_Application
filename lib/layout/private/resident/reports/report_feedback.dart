import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ReportFeedback extends StatefulWidget {
  const ReportFeedback({
    super.key,
    required this.emergencyDocId,
    required this.userUid,
    required this.role,
  });

  final String emergencyDocId;
  final String userUid;
  final String role;

  @override
  State<ReportFeedback> createState() => _ReportFeedbackState();
}

class _ReportFeedbackState extends State<ReportFeedback> {
  final TextEditingController _comments = TextEditingController();
  final ReportController _reportController = Get.find<ReportController>();
  double emergencyRating = 0;
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      isLeadingBackBtn: true,
      title: "Feedback",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Image.asset(
                  'assets/images/red_no_bg_logo.png',
                  width: Get.width * .70,
                ),
              ),
            ),
            Text(
              widget.role == "rescuer"
                  ? "Thank you for responding!"
                  : "Thank you for reporting the incident!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 30,
              ),
              child: Text(
                "Let us know your feedback/ suggestions for the emergency.",
                textAlign: TextAlign.center,
              ),
            ),
            Visibility(
              visible: widget.role == "resident",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Rate: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  AnimatedRatingStars(
                    initialRating: 3.5,
                    minRating: 0.0,
                    maxRating: 5.0,
                    onChanged: (double rating) {
                      // Handle the rating change here
                      // print('Rating: $rating');
                      emergencyRating = rating;
                    },
                    displayRatingValue: true,
                    interactiveTooltips: true,
                    customFilledIcon: Icons.star,
                    customHalfFilledIcon: Icons.star_half,
                    customEmptyIcon: Icons.star_border,
                    animationDuration: const Duration(milliseconds: 300),
                    animationCurve: Curves.easeInOut,
                    readOnly: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _comments,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Suggestions/ Comments",
                  hintStyle: const TextStyle(color: gray),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Obx(
              () => RoundedCustomButton(
                onPressed: () {},
                isLoading: _reportController.isLoading.isTrue,
                label: "Submit",
                size: Size(Get.width * .75, 40),
                bgColor: primaryRed,
                radius: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
