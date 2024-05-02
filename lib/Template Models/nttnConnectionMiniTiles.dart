import 'package:flutter/material.dart';


class ConnectionsTile extends StatelessWidget {
  final String Name;
  final String OrganizationName;
  final String MobileNo;
  final String ConnectionType;
  final String ApplicationID;
  final String Location;
  final String Status;
  final String LinkCapacity;
  final String Remark;
  final VoidCallback onPressed;

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: screenWidth,
            height: screenHeight*0.1,
            decoration: BoxDecoration(
              color: Color.fromRGBO(25, 192, 122, 1),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(Name,
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'default',
              ),),
              subtitle: Text(OrganizationName,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'default',
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              onTap: onPressed,
            ),
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
