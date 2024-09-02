import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays information about a connection in a card format.
///
/// This card contains details such as [Name], [OrganizationName], [MobileNo],
/// [ConnectionType], [ApplicationID], [Location], [Status], [LinkCapacity],
/// and [Remark] related to the connection.
///
/// The card is styled with a shadow and rounded corners for visual appeal.
/// It consists of several rows, each displaying a label and its corresponding value.
///
/// [Name] - The name of the individual associated with the connection.
/// [OrganizationName] - The organization name linked to the connection.
/// [MobileNo] - The mobile number associated with the connection.
/// [ConnectionType] - The type of connection (e.g., New, Upgrade).
/// [ApplicationID] - The unique ID of the application.
/// [Location] - The location of the connection.
/// [Status] - The current status of the connection (e.g., Pending, Accepted).
/// [LinkCapacity] - The link capacity (e.g., bandwidth) of the connection.
/// [Remark] - Any additional remarks about the connection.
class BCCConnectionsInfoCard extends StatelessWidget {
  final String
      Name; // The name of the individual associated with the connection.
  final String
      OrganizationName; // The organization name linked to the connection.
  final String MobileNo; // The mobile number associated with the connection.
  final String ConnectionType; // The type of connection (e.g., New, Upgrade).
  final String ApplicationID; // The unique ID of the application.
  final String Location; // The location of the connection.
  final String
      Status; // The current status of the connection (e.g., Pending, Accepted).
  final String
      LinkCapacity; // The link capacity (e.g., bandwidth) of the connection.
  final String Remark; // Any additional remarks about the connection.

  const BCCConnectionsInfoCard({
    Key? key,
    required this.Name,
    required this.OrganizationName,
    required this.MobileNo,
    required this.ConnectionType,
    required this.ApplicationID,
    required this.Location,
    required this.Status,
    required this.LinkCapacity,
    required this.Remark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context)
        .size
        .width; // Fetches the width of the device screen.
    final screenHeight = MediaQuery.of(context)
        .size
        .height; // Fetches the height of the device screen.
    return Material(
      elevation: 5,
      // Adds shadow to the card to give it a raised effect.
      borderRadius: BorderRadius.circular(10),
      // Rounds the corners of the card.
      child: Container(
        //width: screenWidth*0.9,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // Padding inside the card.
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the card.
          borderRadius: const BorderRadius.all(
              Radius.circular(10)), // Rounds the corners of the card.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Name', Name),
            _buildRow('Organiztion Name', OrganizationName),
            _buildRow('Mobile No', MobileNo),
            _buildRow('Connection Type', ConnectionType),
            _buildRow('Application ID', ApplicationID),
            _buildRow('Location', Location),
            _buildRow('Status', Status),
            _buildRow('Link Capacity', LinkCapacity),
            _buildRow('Remark', Remark),
          ],
        ),
      ),
    );
  }
}

/// A helper function that builds a row to display a label and its corresponding value.
/// It is used within the `BCCConnectionsInfoCard` to create each piece of information in the card.
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

/// A helper function that formats and displays the date and time in a readable format.
/// This function is not used in the current implementation but can be used for displaying
/// date and time information if needed.
Widget _buildRowTime(String label, String value) {
  //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM

  // Parses the string value into a DateTime object.
  DateTime date = DateTime.parse(value);
  // Formats the date as "Month Day, Year".
  DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  // Formats the time in AM/PM format.
  DateFormat timeFormat = DateFormat.jm();
  // Combines the formatted date and time into a single string.
  String formattedDate = dateFormat.format(date);
  String formattedTime = timeFormat.format(date);
  String formattedDateTime = '$formattedDate, $formattedTime';
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
      Expanded(
        child: Text(
          formattedDateTime, // Format date as DD/MM/YYYY
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.6,
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
            fontFamily: 'default',
          ),
        ),
      ),
    ],
  );
}
