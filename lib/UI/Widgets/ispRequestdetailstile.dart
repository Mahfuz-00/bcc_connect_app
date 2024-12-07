import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The [ConnectionRequestInfoCard] class is a stateless widget that displays
/// detailed information about a connection request. It presents various
/// attributes related to the request in a visually structured format.
///
/// This card includes:
///
/// - [ConnectionType]: The type of connection requested.
/// - [NTTNProvider]: The NTTN (Nationwide Telecommunications Transmission Network)
///   provider involved in the request.
/// - [ApplicationID]: The unique identifier for the application associated with
///   the request.
/// - [MobileNo]: The mobile number linked to the request.
/// - [Location]: The geographical location where the connection is requested.
/// - [Time]: The timestamp indicating when the request was made.
/// - [Status]: The current status of the connection request.
///
/// The [build] method creates and returns a material design card that contains
/// the structured information, including rows for each attribute displayed
/// in a readable format. The time is formatted for better readability.
class ConnectionRequestInfoCard extends StatelessWidget {
  final String? ConnectionType; // The type of connection requested.
  final String?
      NTTNProvider; // The NTTN (Nationwide Telecommunications Transmission Network) provider involved.
  final String? FRNumber; // The unique identifier for the application.
  final String? MobileNo; // The mobile number associated with the request.
  final String? Location; // The location where the connection is requested.
  final String? Time; // The timestamp of when the request was made.
  final String? Status; // The current status of the connection request.
  final String? SerivceType;
  final String? Capacity;
  final String? WorkOrderNumber;
  final int? ContactDuration;
  final num? NetPayment;

  const ConnectionRequestInfoCard({
    Key? key,
    required this.ConnectionType,
    required this.NTTNProvider,
    required this.FRNumber,
    required this.MobileNo,
    required this.Location,
    required this.Time,
    required this.Status,
    this.SerivceType,
    this.Capacity,
    this.WorkOrderNumber,
    this.ContactDuration,
    this.NetPayment,
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
      // Adds elevation to the card for a subtle shadow effect.
      borderRadius: BorderRadius.circular(10),
      // Rounds the corners of the card.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // Padding inside the container.
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the card.
          borderRadius: const BorderRadius.all(
              Radius.circular(10)), // Ensures all corners are rounded.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Connection Type', ConnectionType ?? ''),
            _buildRow('FR Number', FRNumber ?? ''),
            if(ContactDuration != 0)...[
              _buildRow('Work Order Number', WorkOrderNumber?.toString() ?? ''),
            ],
            _buildRow('NTTN Provider', NTTNProvider ?? ''),
            _buildRow('Mobile No', MobileNo ?? ''),
            _buildRow('Location', Location ?? ''),
            _buildRow('Service Type', SerivceType ?? ''),
            _buildRow('Capacity', Capacity ?? ''),
            if(ContactDuration != 0)...[
              _buildRow('Contact Duration', '${ContactDuration?.toString()} Months' ?? ''),
              _buildRow('Net Payment', '${NetPayment?.toString()} TK'?? ''),
            ],
            _buildRowTime('Time', Time ?? ''),
            _buildRow('Work Order Status', Status ?? ''),

            if(ContactDuration == 0)...[
              SizedBox(height: 10,),
              Text('*Please contact $NTTNProvider for Work Order.*',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),)
            ],
          ],
        ),
      ),
    );
  }
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
                text: value ?? 'N/A',
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
