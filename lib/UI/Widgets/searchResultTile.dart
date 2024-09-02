import 'package:flutter/material.dart';

/// A widget that displays connection information for a person or entity.
///
/// This widget shows details such as the name, organization name, mobile number,
/// connection type, provider, and status in a structured format.
///
/// **Variables:**
/// - [Name]: The name of the person or entity.
/// - [OrganizationName]: The name of the organization.
/// - [MobileNo]: The mobile number associated with the connection.
/// - [ConnectionType]: The type of connection (e.g., Pending, Accepted).
/// - [Provider]: The service provider for the connection.
/// - [Status]: The current status of the connection.
class SearchConnectionsInfoCard extends StatelessWidget {
  final String Name; // The name of the person or entity.
  final String OrganizationName; // The name of the organization.
  final String MobileNo; // The mobile number associated with the connection.
  final String
      ConnectionType; // The type of connection (e.g., Pending, Accepted).
  final String Provider; // The service provider for the connection.
  final String Status; // The current status of the connection.

  const SearchConnectionsInfoCard({
    Key? key,
    required this.Name, // Required for displaying the name.
    required this.OrganizationName, // Required for displaying the organization name.
    required this.MobileNo, // Required for displaying the mobile number.
    required this.ConnectionType, // Required for displaying the connection type.
    required this.Provider, // Required for displaying the provider.
    required this.Status, // Required for displaying the status.
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5, // Shadow effect to give a material design feel.
      borderRadius: BorderRadius.circular(10), // Rounded corners.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // Padding inside the card.
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the card.
          borderRadius: const BorderRadius.all(
              Radius.circular(10)), // Rounded corners for the card.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align children to the start (left) of the card.
          children: [
            buildProviderRow('Name', Name),
            // Display name.
            const SizedBox(height: 5),
            // Space between rows
            buildProviderRow('Organization', OrganizationName),
            // Display organization name.
            const SizedBox(height: 5),
            // Space between rows
            buildProviderRow('Mobile No', MobileNo),
            // Display mobile number.
            const SizedBox(height: 5),
            buildProviderRow('Connection Type', ConnectionType),
            // Display connection type.
            const SizedBox(height: 5),
            buildProviderRow('Provider', Provider),
            // Display provider.
            const SizedBox(height: 5),
            buildProviderRow('Status', Status),
            // Display status.
          ],
        ),
      ),
    );
  }
}

/// A helper function that creates a row with a label and a value.
/// This function is used to format and display information in the card.
///
/// [label] is the text label for the information field.
/// [value] is the value to be displayed next to the label.
Widget buildProviderRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    // Align children to the start (top) of the row.
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'default'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        // Space between label and value.
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
        child: Text(
          value,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'default'),
        ),
      ),
    ],
  );
}
