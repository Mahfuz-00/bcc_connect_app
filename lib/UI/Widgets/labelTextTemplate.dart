import 'package:flutter/material.dart';

/// A widget that displays a text label with a red asterisk indicating a required field.
///
/// This widget is useful for form labels where certain fields are mandatory.
/// The red asterisk visually indicates to the user that the associated field is required.
///
/// **Parameters:**
/// - [text]: A String representing the label text to be displayed.
class LabeledTextWithoutAsterisk extends StatelessWidget {
  final String text;

  const LabeledTextWithoutAsterisk({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Color.fromRGBO(143, 150, 158, 1),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'default',
        ),
      ),
    );
  }
}