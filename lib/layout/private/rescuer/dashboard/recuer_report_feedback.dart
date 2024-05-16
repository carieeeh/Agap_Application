import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/report_controller.dart';
import 'package:agap_mobile_v01/global/date_time_utils.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerReportFeedback extends StatefulWidget {
  const RescuerReportFeedback({super.key});

  @override
  State<RescuerReportFeedback> createState() => _RescuerReportFeedbackState();
}

class _RescuerReportFeedbackState extends State<RescuerReportFeedback> {
  final ReportController _reportController = Get.find<ReportController>();
  final DateTimeUtils _dateUtils = DateTimeUtils();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Feedbacks", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Overall Rating: ",
                style: TextStyle(fontSize: 16),
              ),
              AnimatedRatingStars(
                initialRating: _reportController.averageRating.value,
                minRating: 0.0,
                maxRating: 5.0,
                onChanged: (double rating) {
                  // Handle the rating change here
                  // print('Rating: $rating');
                },
                displayRatingValue: true,
                interactiveTooltips: true,
                customFilledIcon: Icons.star,
                customHalfFilledIcon: Icons.star_half,
                customEmptyIcon: Icons.star_border,
                animationDuration: const Duration(milliseconds: 300),
                animationCurve: Curves.easeInOut,
                readOnly: true,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: Container(
          //     margin: const EdgeInsets.only(left: 15),
          //     width: 100,
          //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          //     decoration: BoxDecoration(
          //       color: lightGray,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: const Row(
          //       children: [
          //         Icon(Icons.filter_alt),
          //         Text("Filter"),
          //       ],
          //     ),
          //   ),
          // ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Date",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Rating",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 85,
                  child: Text(
                    "Comments",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            height: Get.height * .5,
            child: ListView.builder(
              itemCount: _reportController.emergenciesFeedback.length,
              padding: const EdgeInsets.only(bottom: 50),
              itemBuilder: (context, index) {
                final Map<String, dynamic> feedback =
                    _reportController.emergenciesFeedback[index].data();

                return Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _dateUtils.formatDate(
                                dateTime:
                                    DateTime.parse(feedback["created_at"])),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            feedback["rating"].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Text(
                              feedback["comment"],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
