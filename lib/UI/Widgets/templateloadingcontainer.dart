import 'package:flutter/material.dart';

/// A widget that displays a loading indicator inside a styled container.
///
/// [screenWidth] is the width of the screen, used to set the width of the container.
class LoadingContainer extends StatelessWidget {
  final double screenWidth;

  LoadingContainer({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      // Adds a shadow effect to give a material design feel.
      borderRadius: BorderRadius.circular(10),
      // Rounds the corners of the widget.
      child: Container(
        height: 200,
        // Height of the container; adjust as needed.
        width: screenWidth,
        // Width of the container based on screen width.
        padding: EdgeInsets.all(20),
        // Padding inside the container for spacing.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child:
              CircularProgressIndicator(), // Displays a circular progress indicator.
        ),
      ),
    );
  }
}
