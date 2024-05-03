import 'package:agap_mobile_v01/global/constant.dart';
import 'package:agap_mobile_v01/global/date_time_utils.dart';
import 'package:agap_mobile_v01/layout/widgets/inputs/custom_date_bottomsheet.dart';
import 'package:flutter/material.dart';

class CustomDateInput extends StatefulWidget {
  const CustomDateInput({
    super.key,
    required this.onDateTimeChanged,
    required this.child,
    required this.type,
    required this.context,
    required this.controller,
    this.readOnly = true,
  });

  final ValueChanged<List<DateTime?>> onDateTimeChanged;
  final String type; // range or single
  final Widget child;
  final BuildContext context;
  final TextEditingController controller;
  final bool readOnly;

  @override
  State<CustomDateInput> createState() => _CustomDateInputState();
}

class _CustomDateInputState extends State<CustomDateInput> {
  final DateTimeUtils _dateTimeUtils = DateTimeUtils();
  List<DateTime?> _dates = [];

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () async {
        if (!widget.readOnly) {
          _dates = await showModalBottomSheet(
            context: context,
            builder: (context) => CustomDateBottomsheet(type: widget.type),
          );
          widget.onDateTimeChanged(_dates);
          setState(() {});
        }
      },
      controller: widget.controller,
      decoration: const InputDecoration(
        labelText: "Birth date",
        isDense: true,
        hintText: "yyyy-mm-dd",
        contentPadding: EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorSuccess),
        ),
        focusColor: colorSuccess,
      ),
    );
  }

  List<Widget> range() {
    return [
      const Text("From date"),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[0]),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray,
              size: 20,
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      const Text("End date"),
      const SizedBox(height: 5),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: gray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _dates.isEmpty
                  ? "mm/dd/yyyy"
                  : _dateTimeUtils.formatDate(dateTime: _dates[1]),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: gray,
              size: 20,
            ),
          ],
        ),
      ),
      widget.child,
    ];
  }
}
