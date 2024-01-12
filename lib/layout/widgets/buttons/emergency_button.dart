import 'package:flutter/material.dart';

class EmergencyButton extends StatefulWidget {
  final String title;
  final String imagePath;
  final Function() onPressed;

  const EmergencyButton(
      {super.key,
      required this.title,
      required this.imagePath,
      required this.onPressed});

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: widget.onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(150, 150),
        side: const BorderSide(width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          Image.asset(widget.imagePath),
        ],
      ),
    );
  }
}
