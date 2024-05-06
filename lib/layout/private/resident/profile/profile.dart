import 'dart:io';

import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/controller/auth_controller.dart';
import 'package:agap_mobile_v01/global/controller/profile_controller.dart';
import 'package:agap_mobile_v01/layout/private/main_container.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/date_input.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/dropdown_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isReadOnly = true;
  XFile? photo;

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
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _emergencyContactName = TextEditingController();

  @override
  void initState() {
    setInputValues();
    super.initState();
  }

  void setInputValues() {
    _nameController.text = _authController.userModel!.fullName ?? "";
    _email.text = _authController.userModel!.email ?? "";
    _bdayController.text = _authController.userModel!.birthday ?? "";
    _addressController.text = _authController.userModel!.address ?? "";
    _contactNumber.text = _authController.userModel!.contactNumber ?? "";
    _emergencyContactNumber.text =
        _authController.userModel!.emeContactNumber ?? "";
    _emergencyContactName.text =
        _authController.userModel!.emeContactName ?? "";
    _allergiesController.text = _authController.userModel!.allergies ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: "Profile",
      actionButton: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Obx(
          () => _profileController.isLoading.isTrue
              ? const CircularProgressIndicator()
              : IconButton(
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
                        "gender": _gender.text,
                        "eme_contact_number": _emergencyContactNumber.text,
                        "eme_contact_name": _emergencyContactName.text,
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
      ),
      body: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: Get.height * .28,
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
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: Get.width * .38,
                      child: InkWell(
                        onTap: () {
                          if (!isReadOnly) {
                            takeImage();
                          }
                        },
                        child: photo != null
                            ? CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: FileImage(File(photo!.path)),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(
                                  _authController.userModel!.profile!,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              profileTile(_email, "Email"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: DropdownInput(
                  list: _profileController.gender,
                  width: Get.width * .92,
                  label: "Gender",
                  initialSelection: _authController.userModel!.gender,
                  enabled: !isReadOnly,
                  onSelected: (value) {
                    _gender.text = value;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: CustomDateInput(
                  readOnly: isReadOnly,
                  onDateTimeChanged: (value) {
                    _bdayController.text = value[0].toString().split(" ")[0];
                  },
                  type: "single",
                  context: context,
                  controller: _bdayController,
                  child: Container(),
                ),
              ),
              profileTile(_addressController, "Address"),
              contactNumberField(_contactNumber, "Contact Number", isReadOnly),
              profileTile(
                _emergencyContactName,
                "Emergency Contact Person Name",
              ),
              contactNumberField(_emergencyContactNumber,
                  "Emergency Contact Number", isReadOnly),
              profileTile(_allergiesController, "Allergies"),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: DropdownInput(
                  list: _profileController.bloodTypes,
                  width: Get.width * .92,
                  label: "Blood type",
                  enabled: !isReadOnly,
                  initialSelection: _authController.userModel!.bloodType,
                  onSelected: (value) {
                    _bloodType.text = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> takeImage() async {
    photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (photo != null) {
      _profileController.updateUserProfile({}, image: photo);
      setState(() {});
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

  Widget contactNumberField(
      TextEditingController controller, String label, bool isReadOnly) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        keyboardType: TextInputType.number,
        inputFormatters: [LengthLimitingTextInputFormatter(10)],
        decoration: InputDecoration(
          prefixText: "+63 ",
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
