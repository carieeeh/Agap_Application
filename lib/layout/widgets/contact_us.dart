import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/buttons/rounded_custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final AuthController _auth = Get.find<AuthController>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();

  @override
  void initState() {
    _name.text = _auth.userModel?.fullName ?? "";
    _email.text = _auth.userModel?.email ?? "";
    super.initState();
  }

  Future sendEmail() async {
    FlutterEmailSender.send(Email(
      body: _message.text,
      subject: "AGAP Customer Service",
      recipients: ["agap.tupm@gmail.com"],
      isHTML: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Contact Us",
      isLeadingBackBtn: true,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Full name",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _name,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Email",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  hintText: "Enter your email",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Message",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _message,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Enter your message",
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              RoundedCustomButton(
                onPressed: () {
                  sendEmail();
                },
                label: "Submit",
                bgColor: primaryRed,
                size: Size(Get.width * .9, 40),
              )
            ],
          ),
        ),
      ),
    );
  }
}
