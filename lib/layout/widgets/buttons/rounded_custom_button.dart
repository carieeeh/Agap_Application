import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoundedCustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final Color? bgColor;
  final Color? textColor;
  final double? radius;
  final Size size;
  final Color? loaderColor;
  final bool? isLoading;

  const RoundedCustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.bgColor,
    this.textColor,
    this.radius,
    required this.size,
    this.isLoading,
    this.loaderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: isLoading ?? false ? null : onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: size,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 50))),
          backgroundColor: bgColor ?? primaryBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: isLoading ?? false,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: loaderColor ?? Colors.white,
                      strokeWidth: 3,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
