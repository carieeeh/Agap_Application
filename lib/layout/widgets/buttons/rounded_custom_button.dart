import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';

class RoundedCustomButton extends StatefulWidget {
  final void Function() onPressed;
  final String label;
  final Color? bgColor;
  final Color? textColor;
  final double? radius;
  final Size size;
  const RoundedCustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.bgColor,
    this.textColor,
    this.radius,
    required this.size,
  });

  @override
  State<RoundedCustomButton> createState() => _RoundedCustomButtonState();
}

class _RoundedCustomButtonState extends State<RoundedCustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: widget.size,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(widget.radius ?? 50))),
          backgroundColor: widget.bgColor ?? primaryBlue,
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.textColor ?? Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
