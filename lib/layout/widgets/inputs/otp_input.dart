import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPInput extends StatefulWidget {
  final TextEditingController pinController;
  final String label;
  final Function(String?) validation;
  final bool? hasShadow;
  final String? errorText;
  final bool? obscureText;
  final bool? readOnly;
  final Function(String)? onChanged;
  const OTPInput(
      {super.key,
      required this.pinController,
      required this.label,
      required this.validation,
      this.hasShadow,
      this.errorText,
      this.obscureText,
      this.readOnly,
      this.onChanged});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: darkGray,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: lightGray),
        boxShadow: [
          widget.hasShadow ?? false
              ? const BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 3),
                  blurRadius: 2,
                  spreadRadius: 0,
                )
              : const BoxShadow(),
        ],
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(color: gray),
            ),
            const SizedBox(height: 5),
            Directionality(
              // Specify direction if desired
              textDirection: TextDirection.ltr,
              child: Pinput(
                readOnly: widget.readOnly ?? false,
                length: 6,
                obscureText: widget.obscureText ?? false,
                controller: widget.pinController,
                forceErrorState: widget.errorText != null,
                errorText: widget.errorText,
                errorTextStyle:
                    const TextStyle(fontSize: 12, color: colorError),
                focusNode: focusNode,
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                validator: (value) {
                  return widget.validation(value);
                },
                // onClipboardFound: (value) {
                //   debugPrint('onClipboardFound: $value');
                //   pinController.setText(value);
                // },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: widget.onChanged,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: bgPrimaryBlue,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: bgPrimaryBlue),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: bgPrimaryBlue),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
