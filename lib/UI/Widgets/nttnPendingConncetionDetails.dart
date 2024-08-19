import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Data/Data Sources/API Service (Accept or Decline)/apiServiceAcceptOrDecline.dart';
import '../Pages/NTTN Dashboard/nttnDashboard.dart';

/// A stateless widget that displays the details of a pending connection request.
/// It includes options to accept or reject the request, and handles the navigation and API calls accordingly.
class PendingConnectionDetailsPage extends StatelessWidget {
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
  final int
      ispConnectionId; // The connection ID parsed from ApplicationID for API operations.

  PendingConnectionDetailsPage({
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
  })  : ispConnectionId = int.tryParse(ApplicationID) ?? 0,
        // Parses ApplicationID to integer for API operations.
        // Initialize ispConnectionId in the constructor initializer list
        super(key: key);

  late String action; // Action to be performed ('accepted' or 'rejected').

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
        // AppBar background color.
        leadingWidth: 40,
        titleSpacing: 10,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); // Navigates back to the previous screen.
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            )),
        title: const Text(
          'Pending Connection Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const Center(
                  child: Text(
                    'Connection Details',
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
                height: 40,
              ),
              Center(
                child: CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 65,
                  ),
                  radius: 50,
                ),
              ),
              SizedBox(height: 20),
              _buildRow('Name', Name),
              Divider(),
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
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.425,
                          MediaQuery.of(context).size.height * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      action = 'accepted'; // Set action to 'accepted'.
                      handleAcceptOrReject(action); // Handle accept action.
                      const snackBar = SnackBar(
                        content: Text(
                            'Processing...'), // Display processing message.
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NTTNDashboard(
                                  shouldRefresh:
                                      true)), // Navigate to NTTN Dashboard.
                        );
                        const snackBar = SnackBar(
                          content: Text(
                              'Request Accepted!'), // Display acceptance message.
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: Text('Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.425,
                          MediaQuery.of(context).size.height * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      action = 'rejected'; // Set action to 'rejected'.
                      handleAcceptOrReject(action); // Handle reject action.
                      const snackBar = SnackBar(
                        content: Text(
                            'Processing...'), // Display processing message.
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NTTNDashboard(
                                  shouldRefresh:
                                      true)), // Navigate to NTTN Dashboard.
                        );
                        const snackBar = SnackBar(
                          content: Text(
                              'Request Declined!'), // Display rejection message.
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }); // Validation complete, hide circular progress indicator
                    },
                    child: Text('Decline',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a row displaying a label and value.
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

  /// Handles the accept or reject action by calling the API service.
  Future<void> handleAcceptOrReject(String Action) async {
    final apiService = await ConnectionAcceptRejectAPIService.create();

    print(Action);
    print(ApplicationID);
    print(ispConnectionId);
    if (action.isNotEmpty && ispConnectionId > 0) {
      await apiService.acceptOrRejectConnection(
          type: Action, ispConnectionId: ispConnectionId);
    } else {
      print('Action or ISP connection ID is missing');
    }
  }

  /// Builds a row displaying a label and a formatted date-time value.
  Widget _buildRowTime(String label, String value) {
    //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM

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
}
