import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final Function(String?)? onChanged;
  final int? maxLength;
  final String? errorText;
  final Function() submit;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.onChanged,
    this.maxLength,
    required this.submit,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border.all(color: gray),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              SizedBox(
                width: Get.width * .7,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText ?? '9928372321',
                    hintStyle: hintStyle ?? const TextStyle(color: gray),
                  ),
                  controller: controller,
                  onChanged: onChanged,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(maxLength ?? 10)
                  ],
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: submit,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: primaryRed,
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: errorText != null,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              errorText ?? 'err',
              style: const TextStyle(fontSize: 12, color: colorError),
            ),
          ),
        ),
      ],
    );
  }
}
