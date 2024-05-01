import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/profile_controller.dart';
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
  bool isReadOnly = true;

  final AuthController _authController = Get.find<AuthController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _bdayController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _emergencyContactNumber = TextEditingController();
  final TextEditingController _bloodType = TextEditingController();
  final TextEditingController _emergencyContactName = TextEditingController();

  @override
  void initState() {
    setInputValues();
    super.initState();
  }

  void setInputValues() {
    _nameController.text = _authController.userModel!.fullName();
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Profile",
      actionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: IconButton(
          onPressed: () {
            setState(() {
              isReadOnly = !isReadOnly;
            });
            if (isReadOnly) {
              _profileController.updateUserProfile({
                "full_name": _nameController.text,
                "email": _email.text,
                "birthday": _bdayController.text,
                "address": _addressController.text,
                "contact_number": _contactNumber.text,
                "emergency_contact_number": _emergencyContactNumber.text,
                "emergency_contact_name": _emergencyContactName.text,
                "allergies": _allergiesController.text,
                "blood_type": _bloodType.text,
              });
            }
          },
          icon: Icon(
            isReadOnly ? Icons.edit : Icons.save,
            color: Colors.white,
          ),
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
                    child: TextField(
                  readOnly: isReadOnly,
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsetsDirectional.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    labelText: "",
                    focusColor: colorSuccess,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
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
              child: SizedBox(
                height: Get.height * .53,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      profileTile(_email, "Email"),
                      profileTile(_bdayController, "Birthday"),
                      profileTile(_addressController, "Address"),
                      profileTile(_contactNumber, "Contact Number"),
                      profileTile(
                        _emergencyContactName,
                        "Emergency Contact Person Name",
                      ),
                      profileTile(
                          _emergencyContactNumber, "Emergency Contact Number"),
                      profileTile(_allergiesController, "Allergies"),
                      profileTile(_bloodType, "Blood type"),
                    ],
                  ),
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

  Widget profileTile(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          contentPadding: const EdgeInsetsDirectional.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          labelText: label,
          focusColor: colorSuccess,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: gray),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: colorSuccess),
          ),
        ),
      ),
    );
  }
}
