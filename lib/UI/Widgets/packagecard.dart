import 'package:flutter/material.dart';

class PackageCard extends StatelessWidget {
  final String id;
  final String name;
  final String packageName;
  final String packageDescription;
  final double charge;

  const PackageCard({
    Key? key,
    required this.id,
    required this.name,
    required this.packageName,
    required this.packageDescription,
    required this.charge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                packageName,
                style: TextStyle(
                  color: Color.fromRGBO(25, 192, 122, 1),
                  fontSize: 24,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ),
            SizedBox(height: 8.0),
            _buildRow('Service Name', name),
            SizedBox(height: 5.0),
            _buildRow('Package Name', packageName),
            SizedBox(height: 5.0),
            _buildRow('Package Description', packageDescription),
            SizedBox(height: 5.0),
            _buildRow('Package Price', '${charge.toString()} TK'),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }

  /// A helper function that builds a row to display a label and its corresponding value.
  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
