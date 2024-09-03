import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';

/// The [InformationUI] class represents the main UI screen that provides a comprehensive
/// overview of the mobile application's functionalities, specifically designed for
/// three types of users: ISPs, BCC administrators, and NTTN providers.
///
/// The UI includes the following components:
///
/// - [GlobalKey] _scaffoldKey: A key to uniquely identify the scaffold and allow for
///   controlling the state of the scaffold widget.
/// - [SingleTickerProviderStateMixin] is used for providing a single ticker for
///   animations within this widget.
/// - [MediaQuery] is used to retrieve the size of the screen, including
///   [screenWidth] and [screenHeight].
/// - [InternetConnectionChecker] wraps the entire scaffold to check and manage
///   the internet connection status.
/// - [AppBar] is set with a back button ([IconButton]) and a title 'Information'.
/// - [SingleChildScrollView] ensures that the content is scrollable if the text
///   exceeds the screen height.
/// - [SafeArea] ensures that the content is displayed within the safe area, avoiding
///   any overlap with system UI elements.
/// - The UI content is structured using [Column], [Text], and [SizedBox] widgets,
///   detailing the various functionalities for ISPs, BCC admins, and NTTN providers.
/// - Each section provides detailed information regarding the operations available
///   to each user type.
class InformationUI extends StatefulWidget {
  const InformationUI({super.key});

  @override
  State<InformationUI> createState() => _InformationUIState();
}

class _InformationUIState extends State<InformationUI> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
          titleSpacing: 5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Information',
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
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile App Overview',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Our mobile application serves as a comprehensive platform facilitating interactions among three key user types: Internet Service Providers (ISPs), Broadband Connectivity Center (BCC) administrators, and National Telecommunication Transmission Network (NTTN) providers. Below is a breakdown of the functionalities available to each user type:\n',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),),
                  SizedBox(height: 10),
                  Text(
                    'ISP User:',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('ISP users can submit requests for new connections via the application. These requests are then processed by NTTN providers, who have the authority to accept or decline them. Additionally, ISP users have access to two essential lists:\n\n'
                    'Recent Request List:\n' 'Displays the most recent connection requests made by the ISP user.\n\n'
                    'Accepted List:\n' 'Presents a comprehensive view of all connection requests accepted by NTTN providers.\n',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),),
                  SizedBox(height: 10),
                  Text(
                    'BCC Admin User:',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('BCC administrators oversee the project\'s progress and monitor various aspects of connection provisioning. Key functionalities available to BCC admin users include:\n\n'
                  'NTTN Provider Number of Connection Overview:\n' 'Provides insights into the number of active connections managed by each NTTN provider (e.g., SecureNet Bangladesh Limited and Advanced Digital Solution Limited), as well as the count of pending connection requests.\n\n'
                  'Latest Request Display:\n' 'Offers visibility into the most recent connection requests submitted by ISPs.\n',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),),
                  SizedBox(height: 10),
                  Text(
                    'NTTN Provider User:',
                    style: TextStyle(
                      color: const Color.fromRGBO(25, 192, 122, 1),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('NTTN provider users, representing entities such as SecureNet Bangladesh Limited or Advanced Digital Solution Limited, enjoy specialized features tailored to their operational needs. These include:\n\n'
                    'Connection Management:\n' 'Enables NTTN providers to track the total number of connections serviced, as well as pending connection requests awaiting approval.\n\n'
                    'Pending Request List:\n' 'Presents a detailed overview of pending connection requests, allowing NTTN providers to review request specifics and make informed decisions regarding acceptance or declination.\n\n'
                    'Connection List:\n' 'Offers comprehensive insights into existing connections, including detailed connection information and status updates.\n\n'
                    'Our mobile application streamlines the connectivity provisioning process, fostering seamless collaboration among ISPs, BCC administrators, and NTTN providers while ensuring efficient service delivery and user satisfaction.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
