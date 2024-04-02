import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BCC Dashboard/report.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/activeconncetiondetails.dart';
import '../Template Models/activeconnectiontiles.dart';
import '../Template Models/pendingconncetiondetails.dart';
import '../Template Models/pendingconnectiontiles.dart';
import '../Template Models/userinfo.dart';
import '../Template Models/userinfocard.dart';
import '../UserType Dashboard(Demo)/DemoAppDashboard.dart';

class NTTNDashboard extends StatefulWidget {
  const NTTNDashboard({super.key});

  @override
  State<NTTNDashboard> createState() => _NTTNDashboardState();
}

class _NTTNDashboardState extends State<NTTNDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final GlobalKey requestTextKey = GlobalKey();
  final GlobalKey acceptedTextKey = GlobalKey();

  List<User> _people = [
    User(
      name: 'Md. Sajjad Hasan',
      orgName: 'Touch and Solve',
      mobileNo: 01234567890,
      connectionType: 'New',
      applicationId: 'BHWRT12345',
      address: 'Mirpur, Dhaka-1206', requestDetails: '',
    ),
    User(
      name: 'Md. Samiul Islam Khan',
      orgName: 'Google',
      mobileNo: 01234567890,
      connectionType: 'Others',
      applicationId: 'BHWRT12346',
      address: 'Mirpur-11, Dhaka-1206', requestDetails: '',
    ),
    User(
      name: 'Md. Nafiul Islam Khan',
      orgName: 'Facebook',
      mobileNo: 01234567890,
      connectionType: 'Upgrade',
      applicationId: 'BHWRT12348',
      address: 'Mirpur-12, Dhaka-1206', requestDetails: '',
    ),
  ];

  User USER1 = User(
    name: 'Md Hakim',
    orgName: 'Kajol Enterprise',
    mobileNo: 01234567800,
    connectionType: 'New',
    applicationId: 'BBGSIJI774',
    address: 'Banani, Dhaka',
    requestDetails: 'I want a new connection.',
  );

  User USER2 = User(
    name: 'Md Saddam Hussain',
    orgName: 'Sagor Enterprise',
    mobileNo: 01234567630,
    connectionType: 'Others',
    applicationId: 'BBGSIJI775',
    address: 'Baridhara, Dhaka',
    requestDetails: 'My connection is not stable.',
  );

  User USER3 = User(
    name: 'Md Iqbal Hasan',
    orgName: 'Iqbal Enterprise',
    mobileNo: 01753456780,
    connectionType: 'Upgrade',
    applicationId: 'BBGSIJI776',
    address: 'Dhanmondi, Dhaka',
    requestDetails: 'I want to upgrade my connection.',
  );

  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        titleSpacing: 5,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'NTTN Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(25, 192, 122, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 35,
                    ),
                    radius: 30,
                  ),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Organization Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Home',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NTTNDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Pending Application',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.pop(context);
                scrollToRequestText();
              },
            ),
            Divider(),
            ListTile(
              title: Text('Connections',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.pop(context);
                scrollToAcceptedText();
              },
            ),
            Divider(),
            ListTile(
              title: Text('Report',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BCCReport()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: SafeArea(
          child: Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
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
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.45,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Colors.deepPurple,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('250',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: 15,),
                                  Text('Total Active Connection',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.45,
                              height: screenHeight * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: Colors.greenAccent,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('140',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  SizedBox(height: 15,),
                                  Text('New Pending Connection',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 20,),
                  Container(
                    key: requestTextKey,
                    child: const Text('Pending Application',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                  const SizedBox(height: 5),
                  UserListTile(
                    user: USER3,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PendingUserDetailsPage(user: USER3),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  UserListTile(
                    user: USER1,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PendingUserDetailsPage(user: USER1),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  UserListTile(
                    user: USER2,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PendingUserDetailsPage(user: USER2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    key: acceptedTextKey,
                    child: const Text('Connections',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                  SizedBox(height:20),
                  Column(
                    children: [
                      ActiveUserListTile(
                        user: User(
                          name: 'Salahuddin',
                          orgName: 'Salahuddin Software',
                          mobileNo: 012017678,
                          connectionType: 'New',
                          applicationId: 'BBGSIJI789',
                          address: 'Shamoli, Dhaka', requestDetails: '',
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActiveUserDetailsPage(user: User(
                                name: 'Salahuddin',
                                orgName: 'Salahuddin Software',
                                mobileNo: 012017678,
                                connectionType: 'New',
                                applicationId: 'BBGSIJI789',
                                address: 'Shamoli, Dhaka', requestDetails: '',
                              ),),
                            ),
                          );
                        },
                      ),
                      ActiveUserListTile(
                        user: USER1,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActiveUserDetailsPage(user: USER1),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        color: const Color.fromRGBO(25, 192, 122, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BCCMainDashboard()));
              },
              child: Container(
                width: screenWidth / 3,
                padding: EdgeInsets.all(7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 2.5,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){},
              behavior: HitTestBehavior.translucent,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 2.5,
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    )),
                width: screenWidth / 3,
                padding: EdgeInsets.all(7.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 2.5,
                    ),
                    Text(
                      'Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'default',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _people[index].isExpanded = isExpanded;
        });
      },
      children: _people.map<ExpansionPanel>((User user) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: isExpanded ? 16 : 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    if (!isExpanded) ...[
                      Expanded(
                        child: Text(
                          user.orgName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                    ],
                    Divider(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          },
          body: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.3,
                        height:
                        MediaQuery.of(context).size.height *
                            0.15,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.all(
                              Radius.circular(20)),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 100,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${user.name}'),
                      Text('Organization: ${user.orgName}'),
                      Text('Mobile No: ${user.mobileNo}'),
                      Text('Connection Type: ${user.connectionType}'),
                      Text('Application ID: ${user.applicationId}'),
                      Text('Address: ${user.address}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          isExpanded: user.isExpanded,
        );
      }).toList(),
    );
  }


  void scrollToRequestText() {
    // Find the RenderObject for the text widget
    final RenderBox? renderBox =
    requestTextKey.currentContext?.findRenderObject() as RenderBox?;

    // Check if the RenderObject is valid
    if (renderBox != null) {
      // Get the position of the RenderObject in the global coordinate system
      final position = renderBox.localToGlobal(Offset.zero);

      // Scroll to the position of the text widget
      scrollController.animateTo(
        position.dy - (MediaQuery.of(_scaffoldKey.currentContext!).padding.top),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToAcceptedText() {
    // Find the RenderObject for the text widget
    final RenderBox? renderBox =
    acceptedTextKey.currentContext?.findRenderObject() as RenderBox?;

    // Check if the RenderObject is valid
    if (renderBox != null) {
      // Get the position of the RenderObject in the global coordinate system
      final position = renderBox.localToGlobal(Offset.zero);

      // Scroll to the position of the text widget
      scrollController.animateTo(
        position.dy - (MediaQuery.of(_scaffoldKey.currentContext!).padding.top),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
