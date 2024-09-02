import 'package:flutter/material.dart';

/// The [DropdownFormField] class is a stateful widget that represents
/// a dropdown selection field within a form. It allows users to select
/// an item from a predefined list of options.
///
/// The widget consists of a hint text displayed when no value is selected,
/// a list of dropdown items, and a callback function that is triggered
/// when the selection changes. This component is useful in forms
/// where user selection is required, such as in settings or input forms.
///
/// The widget features a rounded container with a fixed height and an
/// outlined border, providing a clean and intuitive interface for users.
///
/// All fields are required and must be provided when instantiating
/// the widget.
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
