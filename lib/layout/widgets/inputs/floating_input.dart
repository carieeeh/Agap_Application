import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';

class FloatingInput extends StatefulWidget {
  final String label;
  final bool isPassword;
  final IconData icon;
  final TextEditingController textController;

  const FloatingInput({
    super.key,
    required this.label,
    required this.isPassword,
    required this.textController,
    required this.icon,
  });

  @override
  State<FloatingInput> createState() => _FloatingInputState();
}

class _FloatingInputState extends State<FloatingInput> {
  bool _isObscure = true;

  _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: lightGray,
            blurRadius: 3,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        obscureText: widget.isPassword ? _isObscure : false,
        controller: widget.textController,
        style: const TextStyle(color: darkGray, fontSize: 15),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
          labelStyle: const TextStyle(color: darkGray),
          suffixIcon: !widget.isPassword
              ? Icon(widget.icon, color: darkGray)
              : InkWell(
                  onTap: _togglePasswordView,
                  child: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: darkGray,
                  ),
                ),
          floatingLabelStyle:
              MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : Colors.black;
            return TextStyle(color: color, letterSpacing: 1.3, fontSize: 14);
          }),
        ),
        validator: (String? value) {
          if (value == null || value == '') {
            return '';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.disabled,
      ),
    );
  }
}
