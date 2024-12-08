import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The [BCCConnectionsInfoCard] class is a stateless widget that
/// displays detailed information about a BCC connection, including
/// the [Name], [OrganizationName], [MobileNo], [ConnectionType],
/// [Provider], [FRNumber], and [Status].
///
/// This widget is styled as a card with rounded corners and a shadow
/// effect for visual elevation. It organizes the information into
/// rows, each showing a label and its corresponding value, making
/// it easy to read and understand the connection details.
///
/// All fields are required and must be provided when instantiating
/// the widget. The card is designed for use in BCC-related
/// applications where displaying connection information is necessary.
class BCCConnectionsInfoCard extends StatelessWidget {
  final String? Name;
  final String? OrganizationName;
  final String? OrgAddress;
  final String? MobileNo;
  final String? ConnectionType;
  final String? Provider;
  final String? FRNumber;
  final String? Status;
  final String? SerivceType;
  final String? Capacity;
  final String? WorkOrderNumber;
  final dynamic? ContactDuration;
  final num? NetPayment;

  /// Constructor for the `BCCConnectionsInfoCard` widget.
  ///
  /// All fields are required and must be passed to the widget when it is instantiated.
  const BCCConnectionsInfoCard({
    Key? key,
    required this.Name,
    required this.OrganizationName,
    required this.MobileNo,
    required this.ConnectionType,
    required this.Provider,
    required this.FRNumber,
    required this.Status,
    required this.OrgAddress,
    this.SerivceType,
    this.Capacity,
    this.WorkOrderNumber,
    this.ContactDuration,
    this.NetPayment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      // Adds a shadow to the card to give a raised effect.
      borderRadius: BorderRadius.circular(10),
      // Rounds the corners of the card.
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Name', Name),
            _buildRow('Organization Name', OrganizationName),
            _buildRow('Organization Address', OrgAddress),
            _buildRow('Mobile No', MobileNo),
            _buildRow('Provider', Provider),
            _buildRow('Connection Type', ConnectionType),
            _buildRow('FR Number', FRNumber),
            _buildRow('Service Type', SerivceType!),
            _buildRow('Capacity', Capacity!),
            if (ContactDuration != 0) ...[
              if (WorkOrderNumber != null)
                _buildRow('Work Order Number', WorkOrderNumber!),
              if (ContactDuration != null)
                _buildRow('Contact Duration',
                    '${ContactDuration.toString()} Months'!),
              if (NetPayment != null)
                _buildRow('Net Payment', '${NetPayment.toString()} TK'!),
            ],
            _buildRow('Status', Status),
          ],
        ),
      ),
    );
  }
}

/// Builds a row displaying a label and its corresponding value.
/// This method is used for string values.
///
/// - Parameters:
///   - label: The label text to be displayed.
///   - value: The value text to be displayed next to the label.
Widget _buildRow(String label, String? value) {
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
                text: value == 'none' ? 'N/A' : value,
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

/// Builds a row displaying a label and its corresponding integer value.
/// This method is specifically used for displaying Application ID.
///
/// - Parameters:
///   - label: The label text to be displayed.
///   - value: The integer value to be displayed next to the label.
Widget _buildRowApplicationID(String label, int? value) {
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
                text: value.toString() ?? 'N/A',
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

/// Builds a row displaying a label and a date/time value formatted as 'Month Day, Year, Time'.
///
/// - Parameters:
///   - label: The label text to be displayed.
///   - value: The date/time string value in ISO 8601 format to be parsed and displayed next to the label.
Widget _buildRowTime(String label, String value) {
  DateTime date = DateTime.parse(value);
  DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  DateFormat timeFormat = DateFormat.jm();
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
