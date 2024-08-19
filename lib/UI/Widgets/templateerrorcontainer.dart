import 'package:flutter/material.dart';

/// A widget that displays a message when there are no requests.
/// This is used to inform users that there are no requests to show.
///
/// [screenWidth] is the width of the screen, used to set the width of the widget.
/// [message] is the message to be displayed when there are no requests.
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
