import 'package:flutter/material.dart';

/// A custom dropdown form field widget that allows users to select a value from a list of options.
/// The widget includes styling and validation, and it provides the selected value to a callback function.
class DropdownFormField extends StatefulWidget {
  late final String
      hintText; // Placeholder text displayed when no value is selected.
  late final List<DropdownMenuItem<String>>
      dropdownItems; // List of dropdown items.
  final Function(String?)
      onChanged; // Callback function to handle changes in selection.

  /// Constructor for the `DropdownFormField` widget.
  ///
  /// All fields are required and must be passed when the widget is instantiated.
  DropdownFormField({
    required this.hintText,
    required this.dropdownItems,
    required this.onChanged,
  });

  @override
  _DropdownFormFieldState createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField> {
  String? selectedValue; // Holds the currently selected value.
  final _dropdownFormKey =
      GlobalKey<FormState>(); // Key to manage the form's state.

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      borderRadius: BorderRadius.circular(10),
      // Rounded corners for the container.
      child: Container(
        width: screenWidth * 0.9, // Width adjusted relative to screen size.
        height: 60, // Fixed height for the dropdown field.
        child: Form(
          key: _dropdownFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  // Background color is applied to the field.
                  fillColor: Colors.white,
                  // White background color.
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        5), // Rounded corners for the border.
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        5), // Rounded corners for the border.
                  ),
                  contentPadding: EdgeInsets.all(17),
                  // Padding inside the field.
                  hintText: widget.hintText,
                  // Placeholder text when no value is selected.
                  hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'default',
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                value: selectedValue, // The currently selected value.
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!; // Update the selected value.
                  });
                  widget.onChanged(newValue); // Call the onChanged callback.
                },
                items:
                    widget.dropdownItems.map((DropdownMenuItem<String> item) {
                  return DropdownMenuItem<String>(
                    value: item.value,
                    child: ButtonTheme(
                      alignedDropdown: true,
                      // Align the dropdown items correctly.
                      child: Text(
                        item.value!,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'default',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ), // Use provided dropdown items
            ],
          ),
        ),
      ),
    );
  }

  /// Resets the selected value to null, effectively clearing the dropdown selection.
  void resetSelectedValue() {
    setState(() {
      selectedValue = null;
    });
  }
}
