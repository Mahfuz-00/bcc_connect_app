import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Data Sources/API Service (Upgrade Connection)/apiServiceUpgradeConnection.dart';
import '../Bloc/auth_cubit.dart';

/// A widget that displays detailed information about a connection upgrade request.
///
/// This widget is used to show detailed information related to a connection upgrade request
/// and allows users to submit an upgrade request through a dialog.
///
/// [UserID] is the ID of the user requesting the upgrade.
/// [ConnectionType] is the type of connection being upgraded.
/// [NTTNProvider] is the name of the NTTN provider.
/// [ApplicationID] is the unique ID of the application.
/// [Division] is the division where the connection is located.
/// [District] is the district where the connection is located.
/// [Upazila] is the Upazila where the connection is located.
/// [Union] is the union where the connection is located.
class UpgradeConnectionInfoCard extends StatefulWidget {
  final String UserID;
  final String ConnectionType;
  final String NTTNProvider;
  final String ApplicationID;
  final String Division;
  final String District;
  final String Upazila;
  final String Union;

  const UpgradeConnectionInfoCard({
    Key? key,
    required this.UserID,
    required this.ConnectionType,
    required this.NTTNProvider,
    required this.ApplicationID,
    required this.Division,
    required this.District,
    required this.Upazila,
    required this.Union,
  }) : super(key: key);

  @override
  _UpgradeConnectionInfoCardState createState() =>
      _UpgradeConnectionInfoCardState();
}

class _UpgradeConnectionInfoCardState extends State<UpgradeConnectionInfoCard> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCapacity;
  bool showCustomCapacityField = false;
  final TextEditingController customCapacityController =
      TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Connection Type', widget.ConnectionType),
            _buildRow('Application ID', widget.ApplicationID),
            _buildRow('NTTN Provider', widget.NTTNProvider),
            _buildRow('District', widget.District),
            _buildRow('Division', widget.Division),
            _buildRow('Upazila', widget.Upazila),
            _buildRow('Union', widget.Union),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.5,
                      MediaQuery.of(context).size.height * 0.075,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _showUpgradeDialog(context);
                  },
                  child: const Text('Upgrade',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a dialog allowing the user to submit an upgrade request.
  ///
  /// The dialog contains form fields for entering link capacity and remarks,
  /// and handles form submission by interacting with the API service.
  void _showUpgradeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upgrade Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(),
                  TextFormField(
                    controller: customCapacityController,
                    decoration: InputDecoration(
                        labelText: 'Enter Link Capacity',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter link capacity';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: remarkController,
                    decoration: InputDecoration(
                        labelText: 'Remark',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      const snackBar = SnackBar(
                        content: Text('Processing'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      String linkCapacity = customCapacityController.text;
                      String remark = remarkController.text;

                      print('Upgrade Type: $linkCapacity');
                      print('Remark: $remark');

                      try {
                        final authCubit = context.read<AuthCubit>();
                        final token =
                            (authCubit.state as AuthAuthenticated).token;
                        UpgradeConnectionAPIService apiService =
                            await UpgradeConnectionAPIService.create(token);
                        var response = await apiService.updateConnection(
                          id: widget.ApplicationID,
                          requestType: 'Upgrade',
                          linkCapacity: linkCapacity,
                          remark: remark,
                        );
                        print('Response: $response');
                        const snackBar = SnackBar(
                          content:
                              Text('Successfully Submitted Upgrade Request'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      } catch (e) {
                        const snackBar = SnackBar(
                          content: Text('Upgrade Request is not Submitted'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        print('Error: $e');
                      }
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(
                        color: Color.fromRGBO(25, 192, 122, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  /// Builds a row displaying a label and its corresponding value.
  ///
  /// [label] is the text label to display.
  /// [value] is the value associated with the label.
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
}
