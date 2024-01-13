import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';

class BadgeButton extends StatefulWidget {
  final Widget badge;
  const BadgeButton({
    super.key,
    required this.badge,
  });

  @override
  State<BadgeButton> createState() => _BadgeButtonState();
}

class _BadgeButtonState extends State<BadgeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Color of the shadow
            spreadRadius: 2, // Spread radius
            blurRadius: 2, // Blur radius
            offset: const Offset(4, 4), // Offset (x, y)
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.lock_outline, color: Colors.black),
          ),
          widget.badge,
        ],
      ),
    );
  }
}
