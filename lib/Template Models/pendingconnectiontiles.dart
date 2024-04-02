import 'package:flutter/material.dart';

import 'userinfo.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback onPressed;

  const UserListTile({
    Key? key,
    required this.user,
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
              title: Text(user.name,
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: 'default',
              ),),
              subtitle: Text(user.orgName,
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
