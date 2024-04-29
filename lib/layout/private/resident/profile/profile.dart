import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthController _authController = Get.find<AuthController>();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Profile",
      actionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
      body: SizedBox(
        height: Get.height,
        child: Stack(
          children: [
            Container(
              height: Get.height * .2,
              decoration: const BoxDecoration(
                color: primaryRed,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(100)),
              ),
            ),
            Positioned(
              top: 80,
              left: 50,
              child: Container(
                height: Get.height * .15,
                width: Get.width * .7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: gray),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                    child: Text(
                  _authController.userModel!.fullName(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )),
              ),
            ),
            Positioned(
              top: 40,
              left: Get.width * .38,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/person.png',
                  fit: BoxFit.cover,
                  height: 45,
                ),
              ),
            ),
            Positioned(
              top: Get.height * .3,
              width: Get.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        "About Me",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                        child: Text(
                            "Lorem ipsum dolor sit amet. Aut velit dolorem et magni suscipit est accusamus"),
                      ),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        "Allergies",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                        child: Text(
                            "Lorem ipsum dolor sit amet. Aut velit dolorem et magni suscipit est accusamus"),
                      ),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        "Blood type",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                        child: Text(
                            "Lorem ipsum dolor sit amet. Aut velit dolorem et magni suscipit est accusamus"),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> takeImage() async {
    final photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (photo != null) {
      // photoList.add(photo);
    } else {
      Get.snackbar(
        "Warning: No image taken",
        "You did not take any image with your camera!",
        backgroundColor: yellow,
      );
    }
  }
}
