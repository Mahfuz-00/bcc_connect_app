import 'package:flutter/material.dart';

/// A widget that displays connection information for a person or entity.
///
/// This widget shows details such as the name, organization name, mobile number,
/// connection type, provider, and status in a structured format.
///
/// **Variables:**
/// - [Provider]: The service provider for the connection.
/// - [ContactName]: The contact name associated with the provider.
/// - [ContactMobileNo]: The contact mobile number associated with the provider.
/// - [ContactEmail]: The contact email associated with the provider.
/// - [Connections]: A list of maps, where each map contains details about a specific connection.
class SearchConnectionsInfoCard extends StatelessWidget {
  final String? Provider; // The service provider for the connection.
  final String? ContactName; // The contact name associated with the provider.
  final String? ContactMobileNo; // The contact mobile number associated with the provider.
  final String? ContactEmail; // The contact email associated with the provider.
  final List<Map<String, String>>? Connections; // A list of maps, each containing connection details.

  const SearchConnectionsInfoCard({
    Key? key,
    required this.Provider,
    required this.ContactName,
    required this.ContactMobileNo,
    required this.ContactEmail,
    required this.Connections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Center(
              child: Text(
                'NTTN Provider Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(25, 192, 122, 1),
                    fontSize: 24,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default'),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                child: Divider()),
            buildProviderRow('Provider', Provider!),
            if (ContactName != null && ContactName != 'none') ...[
              buildProviderRow('Contact Name', ContactName!),
            ],
            if (ContactMobileNo != null && ContactMobileNo != 'none') ...[
              buildProviderRow('Contact Mobile No', ContactMobileNo!),
            ],
            if (ContactEmail != null && ContactEmail != 'none') ...[
              buildProviderRow('Contact Email', ContactEmail!),
            ],
            Divider(),
            const SizedBox(height: 10),
            Center(
              child: Text(
                'ISP Connection Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromRGBO(25, 192, 122, 1),
                    fontSize: 24,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default'),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 40),
                child: Divider()),
            if (Connections != null && Connections!.isNotEmpty) ...[
              for (var connection in Connections!) ...[
                if (connection.isNotEmpty) ...[
                  buildProviderRow('Connection Type', connection['connection_type']!),
                  buildProviderRow('Name', connection['name']!),
                  buildProviderRow('Organization', connection['organization']!),
                  buildProviderRow('Mobile', connection['mobile']!),
                  buildProviderRow('Status', connection['status']!),
                  const SizedBox(height: 10),
                ],
              ],
            ] else ...[
              Center(
                child: Text(
                  'No ISP Connection in this location',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 24,
                      height: 1.6,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default'),
                ),
              ),
              const SizedBox(height: 5),
            ],
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
