import 'package:flutter/material.dart';

class UserProfileCard extends StatelessWidget {

  final String name;
  final String orgName;
  final String mobileNo;
  final String nttnprovider;
  final String connectionType;
  final String applicationId;
  final String address;

  const UserProfileCard({
    Key? key,
    required this.name,
    required this.orgName,
    required this.mobileNo,
    required this.nttnprovider,
    required this.connectionType,
    required this.applicationId,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.21,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 90,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: Container(
                height: 190,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.6,
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                    children: [
                      TextSpan(
                        text: 'Name: $name\n',
                      ),
                      TextSpan(
                        text: 'Organization Name: $orgName\n',
                      ),
                      TextSpan(
                        text: 'Mobile No: $mobileNo\n',
                      ),
                      TextSpan(
                        text: 'NTTN Provider: $nttnprovider\n',
                      ),
                      TextSpan(
                        text: 'Connection Type: $connectionType\n',
                      ),
                      TextSpan(
                        text: 'Application ID: $applicationId\n',
                      ),
                      TextSpan(
                        text: 'Address: $address\n',
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
