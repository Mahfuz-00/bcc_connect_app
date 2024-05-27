import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../API Model and Service (Accept or Decline)/apiServiceAcceptOrDecline.dart';
import '../NTTN Dashboard/nttnDashboard.dart';

class PendingConnectionDetailsPage extends StatelessWidget {
  final String Name;
  final String OrganizationName;
  final String MobileNo;
  final String ConnectionType;
  final String ApplicationID;
  final String Location;
  final String Status;
  final String LinkCapacity;
  final String Remark;
  final int ispConnectionId; // Declare ispConnectionId as a class member

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
  })   : ispConnectionId = int.tryParse(ApplicationID) ?? 0, // Initialize ispConnectionId in the constructor initializer list
        super(key: key);

  late String action; // Enter 'accepted' or 'rejected' here

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leadingWidth: 40,
        titleSpacing: 10,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white,)
        ),
        title: const Text(
          'Connection Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
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
                    'Welcome, NTTN Admin Name',
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
                      action = 'accepted';
                      handleAcceptOrReject(action);
                      const snackBar = SnackBar(
                        content: Text('Processing...'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NTTNDashboard(shouldRefresh: true)),
                      );
                      const snackBar = SnackBar(
                        content: Text('Request Accepted!'),
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
                  SizedBox(width: 10,),
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
                      action = 'rejected';
                      handleAcceptOrReject(action);
                      const snackBar = SnackBar(
                        content: Text('Processing...'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              NTTNDashboard(shouldRefresh: true)),
                        );
                        const snackBar = SnackBar(
                          content: Text('Request Declined!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });// Validation complete, hide circular progress indicator
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

  // Function to handle accept or reject action
  Future<void> handleAcceptOrReject(String Action) async {
    final apiService = await ConnectionAcceptRejectAPIService.create();

    print(Action);
    print(ApplicationID);
    print(ispConnectionId);
    if (action.isNotEmpty && ispConnectionId > 0) {
      await apiService.acceptOrRejectConnection(type: Action, ispConnectionId: ispConnectionId);
    } else {
      print('Action or ISP connection ID is missing');
    }
  }

  Widget _buildRowTime(String label, String value) {
    //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM

    // Option 2: Using separate methods for date and time
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
