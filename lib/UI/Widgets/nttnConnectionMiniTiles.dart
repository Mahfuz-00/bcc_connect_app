import 'package:flutter/material.dart';

/// A widget that represents a connection tile, displaying key information
/// related to a specific connection.
///
/// This tile includes details such as [Name], [OrganizationName], [MobileNo],
/// [ConnectionType], [ApplicationID], [Location], [Status], [LinkCapacity],
/// and [Remark]. It also features a tap callback to handle user interactions.
///
/// [Name] - The name associated with the connection.
/// [OrganizationName] - The organization name linked to the connection.
/// [MobileNo] - The mobile number associated with the connection.
/// [ConnectionType] - The type of connection (e.g., New, Upgrade).
/// [ApplicationID] - The unique ID of the application.
/// [Location] - The location of the connection.
/// [Status] - The current status of the connection (e.g., Pending, Accepted).
/// [LinkCapacity] - The link capacity (e.g., bandwidth) of the connection.
/// [Remark] - Any additional remarks about the connection.
/// [onPressed] - Callback function to be executed when the tile is tapped.
///
/// The tile is visually styled with a background color, elevation, and rounded corners.
/// It includes a [ListTile] to display the [Name] and [OrganizationName], along
/// with a trailing arrow icon indicating it is clickable.
class ConnectionsTile extends StatelessWidget {
  final String Name; // The name associated with the connection.
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
  final VoidCallback
      onPressed; // Callback function to be executed when the tile is tapped.

  const ConnectionsTile({
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
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context)
        .size
        .width; // Fetches the width of the device screen.
    final screenHeight = MediaQuery.of(context)
        .size
        .height; // Fetches the height of the device screen.
    return Column(
      children: [
        Material(
          elevation: 5,
          // Adds shadow to the tile to give it a raised effect.
          borderRadius: BorderRadius.circular(10),
          // Rounds the corners of the tile.
          child: Container(
            width: screenWidth,
            // Sets the width of the tile to the screen width.
            height: screenHeight * 0.1,
            // Sets the height of the tile to 10% of the screen height.
            decoration: BoxDecoration(
              color: Color.fromRGBO(25, 192, 122, 1),
              // Background color of the tile.
              border: Border.all(
                color: Colors.grey, // Border color.
                width: 1.0, // Border width.
              ),
              borderRadius:
                  BorderRadius.circular(10), // Rounds the corners of the tile.
            ),
            child: ListTile(
              title: Text(
                Name, // Displays the name of the connection.
                style: TextStyle(
                  color: Colors.white, // Text color.
                  fontWeight: FontWeight.bold, // Text weight.
                  fontSize: 18, // Text size.
                  fontFamily: 'default', // Text font.
                ),
              ),
              subtitle: Text(
                OrganizationName, // Displays the organization name.
                style: TextStyle(
                  color: Colors.white70, // Text color.
                  fontWeight: FontWeight.bold, // Text weight.
                  fontSize: 16, // Text size.
                  fontFamily: 'default', // Text font.
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              // Icon to indicate that the tile is clickable.
              onTap:
                  onPressed, // Callback to be executed when the tile is tapped.
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ) // Adds space below the tile.
      ],
    );
  }
}
