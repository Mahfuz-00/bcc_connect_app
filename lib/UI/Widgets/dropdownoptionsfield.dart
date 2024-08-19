import 'package:flutter/material.dart';

/// A builder class that constructs a customizable dropdown form field widget.
/// This widget allows users to select from a list of options that are dynamically determined
/// based on the selected value of another dropdown or any other condition.
class DropdownFormFieldBuilder {
  final Map<String, List<String>>
      options; // A map of options where each key has an associated list of items.
  final String labelText; // The label text displayed above the dropdown.
  final String? selectedValue; // The currently selected value in the dropdown.
  final ValueChanged<String?>?
      onChanged; // Callback function to handle changes in selection.

  /// Constructor for the `DropdownFormFieldBuilder` class.
  ///
  /// The [options] and [labelText] parameters are required.
  /// The [selectedValue] and [onChanged] parameters are optional.
  DropdownFormFieldBuilder({
    required this.options,
    required this.labelText,
    required this.selectedValue,
    required this.onChanged,
  });

  /// Builds the dropdown form field widget.
  ///
  /// This method returns a `Widget` that contains the dropdown form field,
  /// customized with the given parameters. It uses the selected value to
  /// determine which list of items to display in the dropdown menu.
  Widget build(BuildContext context) {
    // Retrieves the list of items based on the selected value. If no value is selected,
    // an empty list is used.
    final List<String> items =
        selectedValue != null ? options[selectedValue!]! : [];

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        // Set the width to 90% of the screen width.
        height: MediaQuery.of(context).size.height * 0.085,
        // Set the height to 8.5% of the screen height.
        padding: EdgeInsets.only(left: 10),
        // Adds padding to the left side of the container.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          // Adds rounded corners to the container.
          border: Border.all(
              color: Colors.grey), // Adds a grey border around the container.
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          // Sets the currently selected value in the dropdown.
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value, // The value of the dropdown item.
              child: Text(
                value, // The display text of the dropdown item.
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
          // Calls the provided onChanged callback when a new value is selected.
          decoration: InputDecoration(
            labelText: labelText, // Sets the label text for the dropdown.
            border:
                InputBorder.none, // Removes the border of the input decoration.
          ),
        ),
      ),
    );
  }
}
