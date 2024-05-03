import 'package:agap_mobile_v01/global/constant.dart';
import 'package:flutter/material.dart';

class DropdownInput extends StatelessWidget {
  const DropdownInput({
    super.key,
    required this.list,
    required this.onSelected,
    required this.label,
    this.width,
    this.height,
    this.initialSelection,
    this.enabled = true,
  });

  final String label;
  final List list;
  final ValueChanged onSelected;
  final double? width;
  final double? height;
  final bool enabled;
  final String? initialSelection;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      initialSelection: initialSelection,
      width: width,
      enabled: enabled,
      label: Text(label),
      trailingIcon: const Icon(
        Icons.arrow_drop_down_rounded,
        size: 25,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: darkGray),
        disabledBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: gray)),
        constraints: BoxConstraints(maxHeight: height ?? 45),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: gray),
        ),
      ),
      onSelected: (value) {
        onSelected(value);
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry>((value) {
        return DropdownMenuEntry(
          value: value,
          label: value,
        );
      }).toList(),
    );
  }
}
