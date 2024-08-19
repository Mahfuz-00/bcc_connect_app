import 'package:flutter/material.dart';

/// A custom dropdown form field widget that provides a list of selectable items.
/// It allows users to choose from a list of strings and can be initialized with a value.
class DropdownFormField extends StatefulWidget {
  final String hintText; // The placeholder text when no value is selected.
  final List<String>
      dropdownItems; // List of items that will populate the dropdown menu.
  final String?
      initialValue; // The initial value selected when the widget is created.
  final ValueChanged<String?>?
      onChanged; // Callback to handle changes in selection.

  /// Constructor for the `DropdownFormField` widget.
  ///
  /// The [hintText] and [dropdownItems] parameters are required.
  /// The [initialValue] and [onChanged] parameters are optional.
  DropdownFormField({
    required this.hintText,
    required this.dropdownItems,
    this.initialValue,
    this.onChanged,
  });

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? _selectedValue; // Holds the currently selected value in the dropdown.

  @override
  void initState() {
    super.initState();
    _selectedValue = widget
        .initialValue; // Set the initial value from the widget's parameter.
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: InputBorder.none, // No border for the dropdown field.
        hintText: widget.hintText, // Placeholder text when no item is selected.
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: 12), // Padding for the dropdown field.
      ),
      value: _selectedValue, // The currently selected value in the dropdown.
      items: widget.dropdownItems.map((item) {
        return DropdownMenuItem(
          value: item, // The value associated with this dropdown item.
          child: Text(
            item, // Display text for the dropdown item.
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue =
              value; // Update the selected value when the user changes the selection.
        });
        // Call the onChanged callback provided by the parent widget
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
    );
  }
}
