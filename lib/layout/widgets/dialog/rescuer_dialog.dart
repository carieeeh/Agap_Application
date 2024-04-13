import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RescuerDialog extends StatefulWidget {
  const RescuerDialog({
    super.key,
    required this.imageUrls,
    required this.type,
    required this.location,
    required this.totalUnits,
    required this.description,
  });

  final List<String> imageUrls;
  final String type;
  final String location;
  final String totalUnits;
  final String description;

  @override
  State<RescuerDialog> createState() => _RescuerDialogState();
}

class _RescuerDialogState extends State<RescuerDialog>
    with TickerProviderStateMixin {
  final TextStyle labelStyle = const TextStyle(fontSize: 14);
  final TextStyle detailsStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Container(
          height: Get.height * .75,
          width: Get.width,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "EMERGENCY!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: Get.height * .3,
                  width: Get.width,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageViewController,
                        itemCount: widget.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Image.network(
                              widget.imageUrls[index],
                              height: 280,
                              width: 280,
                              fit: BoxFit.fitWidth,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * .25,
                      child: Text("Type :", style: labelStyle),
                    ),
                    Expanded(child: Text(widget.type, style: detailsStyle)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * .25,
                      child: Text("Location :", style: labelStyle),
                    ),
                    Expanded(
                      child: Text(widget.location, style: detailsStyle),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * .25,
                      child: Text("Total units :", style: labelStyle),
                    ),
                    Expanded(
                        child: Text(
                      widget.totalUnits,
                      style: detailsStyle,
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * .25,
                      child: Text("Description :", style: labelStyle),
                    ),
                    Expanded(
                        child: Text(
                      widget.description,
                      style: detailsStyle,
                    )),
                  ],
                ),
                const SizedBox(height: 10),
                RoundedCustomButton(
                  onPressed: () {},
                  label: "Accept",
                  bgColor: colorSuccess,
                  size: Size(
                    Get.width * .8,
                    30,
                  ),
                ),
                RoundedCustomButton(
                  onPressed: () {},
                  label: "Decline",
                  bgColor: gray,
                  size: Size(
                    Get.width * .8,
                    30,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
