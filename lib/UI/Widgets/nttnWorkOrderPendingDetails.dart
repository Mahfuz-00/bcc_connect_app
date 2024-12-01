import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../Data/Data Sources/API Service (Accept or Decline)/apiServiceRequestAcceptOrDecline.dart';
import '../../Data/Data Sources/API Service (Accept or Decline)/apiserviceWorkOrderAcceptOrDecline.dart';
import '../Bloc/auth_cubit.dart';
import '../Pages/NTTN Dashboard/nttnDashboard.dart';

/// A [StatelessWidget] that displays the details of a pending connection.
///
/// This page provides information such as the connection's [Name],
/// [PackageName], [PaymentMethod], [ConnectionType], [FRNumber],
/// [Location], [Status], [LinkCapacity], and [Remark]. Users can accept
/// or reject the connection request, triggering the appropriate API call.
///
/// [ispConnectionId] is derived from [FRNumber] for API operations.
///
/// The actions that can be performed are:
/// - Accepting the connection, which sets the [action] to 'accepted'.
/// - Rejecting the connection, which sets the [action] to 'rejected'.
class PendingWorkOrderDetails extends StatelessWidget {
  final String? WorkOrderNumber;
  final String FRNumber; // The unique ID of the application.
  final String Name; // The name associated with the connection.
  final String PackageName; // The organization name linked to the connection.
  final String Discount;
  final int? ContactDuration;
  final num? NetPayment;
  final String
      LinkCapacity; // The link capacity (e.g., bandwidth) of the connection.
  final String? SerivceType;
  final String
      PaymentMethod; // The mobile number associated with the connection.

  PendingWorkOrderDetails({
    Key? key,
    required this.Name,
    required this.PackageName,
    required this.PaymentMethod,
    required this.FRNumber,
    required this.LinkCapacity,
    required this.Discount,
    required this.SerivceType,
    required this.WorkOrderNumber,
    required this.ContactDuration,
    required this.NetPayment,
  }) :
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
          'Pending Work Order Details',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: const Center(
                  child: Text(
                    'Work Order Details',
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
              _buildRow('FR Number', FRNumber),
              _buildRow(
                  'Work Order Number', WorkOrderNumber.toString() ?? 'N/A'),
              _buildRow('Name', Name),
              _buildRow('Capacity', LinkCapacity ?? ''),
              _buildRow('Contact Duration',
                  '${ContactDuration.toString()} Months' ?? ''),
              _buildRow('Service Type', SerivceType ?? ''),
              _buildRow('Package Name', PackageName),
              _buildRow('Discount', Discount),
              _buildRow('Payment Method', PaymentMethod),
              _buildRow('Net Payment', '${NetPayment.toString()} TK' ?? ''),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.425,
                            MediaQuery.of(context).size.height * 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        action = 'active'; // Set action to 'accepted'.
                        handleAcceptOrReject(
                            action, context); // Handle accept action.
                        const snackBar = SnackBar(
                          content: Text(
                              'Processing...'), // Display processing message.
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NTTNDashboardUI(
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
                      child: Text('Approved',
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
                            MediaQuery.of(context).size.height * 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        action = 'decline'; // Set action to 'rejected'.
                        handleAcceptOrReject(
                            action, context); // Handle reject action.
                        const snackBar = SnackBar(
                          content: Text(
                              'Processing...'), // Display processing message.
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NTTNDashboardUI(
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
  Future<void> handleAcceptOrReject(String Action, BuildContext context) async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    final apiService = await WorkOrderAcceptRejectAPIService.create(token);

    print(Action);
    print(WorkOrderNumber);
    if (action.isNotEmpty) {
      await apiService.acceptOrRejectWorkOrder(
          type: Action, WorkOrderNumber: WorkOrderNumber.toString());
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
