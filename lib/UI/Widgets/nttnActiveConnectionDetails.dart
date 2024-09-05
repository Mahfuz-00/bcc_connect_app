import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A [StatelessWidget] that displays the details of an active connection.
///
/// This page includes the following details:
/// - [Name]: The name of the individual associated with the connection.
/// - [OrganizationName]: The organization name linked to the connection.
/// - [MobileNo]: The mobile number associated with the connection.
/// - [ConnectionType]: The type of connection (e.g., New, Upgrade).
/// - [ApplicationID]: The unique ID of the application.
/// - [Location]: The location of the connection.
/// - [Status]: The current status of the connection (e.g., Pending, Accepted).
/// - [LinkCapacity]: The link capacity (e.g., bandwidth) of the connection.
/// - [Remark]: Any additional remarks about the connection.
class ActiveConnectionDetails extends StatelessWidget {
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

  const ActiveConnectionDetails({
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        // Background color of the app bar.
        leadingWidth: 40,
        titleSpacing: 10,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); // Navigates back to the previous screen.
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ) // Back arrow icon.
            ),
        title: const Text(
          'Active Connection Details', // Title of the app bar.
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        centerTitle: true, // Centers the title in the app bar.
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          // Padding around the entire content.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const Center(
                  child: Text(
                    'Connection Details',
                    // Title for the connection details section.
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40, // Adds spacing between the title and avatar.
              ),
              _buildRow('Name', Name),
              Divider(),
              // Divider line between rows.
              _buildRow('Organiztion Name', OrganizationName),
              Divider(),
              _buildRow('Mobile No', MobileNo),
              Divider(),
              _buildRow('Connection Type', ConnectionType),
              Divider(),
              _buildRow('Application ID', ApplicationID),
              Divider(),
              _buildRow('Location', Location),
              Divider(),
              _buildRow('Status', Status),
              Divider(),
              _buildRow('Link Capacity', LinkCapacity),
              Divider(),
              _buildRow('Remark', Remark),
              Divider(),
              SizedBox(height: 40),
              // Adds spacing before the button.
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                  // Button color.
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                      MediaQuery.of(context).size.height * 0.1),
                  // Button size.
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Button corner radius.
                  ),
                ),
                onPressed: () {
                  Navigator.pop(
                      context); // Navigates back to the previous screen when the button is pressed.
                },
                child: Text('Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    )),
              ),
            ],
          ),
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

  /// A helper function that formats and displays the date and time in a readable format.
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
}
