import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom text form field designed for single-digit numeric input.
/// It is styled with a specific width, height, and border color, and ensures only digits are inputted.
class CustomTextFormField extends StatelessWidget {
  final TextEditingController
      textController; // Controller to manage the text input.

  const CustomTextFormField({
    Key? key,
    required this.textController, // Required parameter for managing text.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.2, // Set width to 20% of screen width.
      height: 70, // Fixed height of 70 pixels.
      alignment: Alignment.center,
      child: TextFormField(
        textAlign: TextAlign.center,
        // Center the text inside the field.
        controller: textController,
        // Use provided TextEditingController.
        keyboardType: TextInputType.number,
        // Numeric keyboard for input.
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          // Restrict input to digits only.
          LengthLimitingTextInputFormatter(1),
          // Limit input length to 1 character.
        ],
        style: const TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 35,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 20),
          // Padding at the bottom of the field.
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(
                  25, 192, 122, 1), // Border color when the field is enabled.
              width: 2.0, // Border width.
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(
                  25, 192, 122, 1), // Border color when the field is focused.
              width: 2.0, // Border width.
            ),
          ),
          labelText: '', // No label text displayed.
        ),
      ),
    );
  }
}
