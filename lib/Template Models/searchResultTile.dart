import 'package:flutter/material.dart';

class SearchConnectionsInfoCard extends StatelessWidget {
  final String Name;
  final String OrganizationName;
  final String MobileNo;
  final String ConnectionType;
  final String Provider;
  final String Status;

  const SearchConnectionsInfoCard({
    Key? key,
    required this.Name,
    required this.OrganizationName,
    required this.MobileNo,
    required this.ConnectionType,
    required this.Provider,
    required this.Status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        //width: screenWidth*0.9,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildProviderRow('Name', Name),
            const SizedBox(height: 5), // Space between rows
            buildProviderRow('Organization', OrganizationName),
            const SizedBox(height: 5), // Space between rows
            buildProviderRow('Mobile No', MobileNo),
            const SizedBox(height: 5),
            buildProviderRow('Connection Type', ConnectionType),
            const SizedBox(height: 5),
            buildProviderRow('Provider', Provider),
            const SizedBox(height: 5),
            buildProviderRow('Status', Status),
          ],
        ),
      ),
    );
  }
}

Widget buildProviderRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
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
              fontFamily: 'default'
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
          value,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'default'
          ),
        ),
      ),
    ],
  );
}