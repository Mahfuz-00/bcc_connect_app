import 'package:flutter/material.dart';

/// Creates a widget that displays a message indicating there are no requests.
///
/// This function takes the following parameters:
/// - [screenWidth]: The width of the screen, used to set the width of the widget.
/// - [message]: The message to display in the widget, typically indicating that there are no requests.
Widget buildNoRequestsWidget(double screenWidth, String message) {
  return Material(
    elevation: 5,
    // Adds a shadow effect to give a material design feel.
    borderRadius: BorderRadius.circular(10),
    // Rounds the corners of the widget.
    child: Container(
      height: 200,
      // Height of the container.
      width: screenWidth,
      // Width of the container based on screen width.
      padding: EdgeInsets.all(20),
      // Padding inside the container.
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the container.
        borderRadius:
            BorderRadius.circular(10), // Rounds the corners of the container.
      ),
      child: Center(
        child: Text(
          message, // Message to be displayed.
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'default',
          ),
        ),
      ),
    ),
  );
}
