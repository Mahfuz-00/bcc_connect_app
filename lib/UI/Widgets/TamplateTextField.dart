import 'package:flutter/material.dart';

/// A customizable text input field widget for forms.
///
/// This widget encapsulates a [TextFormField] with customizable properties.
/// It supports various input types, validation, and styling.
///
/// **Variables:**
/// - [controller]: A [TextEditingController] for managing the text input.
/// - [label]: The label text displayed for the input field.
/// - [validator]: An optional function for validating the input.
/// - [keyboardType]: Specifies the type of keyboard to be displayed (default is [TextInputType.text]).
/// - [obscureText]: A boolean that determines if the text should be obscured (for passwords).
class CustomTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextInput({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 70,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'default',
          ),
        ),
      ),
    );
  }
}
