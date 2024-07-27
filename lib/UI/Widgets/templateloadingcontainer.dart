import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  final double screenWidth;

  LoadingContainer({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 200, // Adjust height as needed
        width: screenWidth, // Adjust width as needed
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
