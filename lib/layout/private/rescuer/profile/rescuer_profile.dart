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

class RescuerProfile extends StatefulWidget {
  const RescuerProfile({super.key});

  @override
  State<RescuerProfile> createState() => _RescuerProfileState();
}

class _RescuerProfileState extends State<RescuerProfile> {
  bool isReadOnly = true;
  XFile? photo;
  final ImagePicker _imagePicker = ImagePicker();

  final AuthController _auth = Get.find<AuthController>();
  final ProfileController _profileController = Get.find<ProfileController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _department = TextEditingController();
  final TextEditingController _category = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();

  @override
  void initState() {
    setInputValues();
    super.initState();
  }

  void setInputValues() {
    _nameController.text = _auth.userModel!.userFullName();
    _birthday.text = _auth.userModel?.birthday ?? "";
    _email.text = _auth.userModel?.email ?? "";
    _contactNumber.text = _auth.userModel?.contactNumber ?? "";
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
                        "gender": _gender.text,
                        "birthday": _birthday.text,
                        "contact_number": _contactNumber.text,
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
                                  _auth.userModel!.profile!,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              profileTile(_department, "Station Name", true),
              profileTile(_category, "Station Type", true),
              profileTile(_email, "Email", isReadOnly),
              contactNumberField(_contactNumber, "Contact Number", isReadOnly),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: DropdownInput(
                  list: _profileController.gender,
                  width: Get.width * .92,
                  label: "Gender",
                  initialSelection: _auth.userModel!.gender,
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
                    _birthday.text = value[0].toString().split(" ")[0];
                  },
                  type: "single",
                  context: context,
                  controller: _birthday,
                  child: Container(),
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

  Widget profileTile(
      TextEditingController controller, String label, bool isReadOnly) {
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
