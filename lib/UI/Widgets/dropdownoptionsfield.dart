import 'package:flutter/material.dart';

class DropdownFormFieldBuilder {
  final Map<String, List<String>> options;
  final String labelText;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;

  DropdownFormFieldBuilder({
    required this.options,
    required this.labelText,
    required this.selectedValue,
    required this.onChanged,
  });

  Widget build(BuildContext context) {
    final List<String> items = selectedValue != null ? options[selectedValue!]! : [];

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.085,
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
