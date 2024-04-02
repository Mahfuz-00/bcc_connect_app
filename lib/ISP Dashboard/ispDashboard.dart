import 'package:flutter/material.dart';

import '../Connection Form (ISP)/connectionform.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../UserType Dashboard(Demo)/DemoAppDashboard.dart';

class ISPDashboard extends StatefulWidget {
  const ISPDashboard({super.key});

  @override
  State<ISPDashboard> createState() => _ISPDashboardState();
}

class _ISPDashboardState extends State<ISPDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final GlobalKey requestTextKey = GlobalKey();
  final GlobalKey acceptedTextKey = GlobalKey();

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
          'ISP Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
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
                        builder: (context) => const ISPDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('New Connection Request',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectionForm()));
              },
            ),
            Divider(),
            ListTile(
              title: Text('Request List',
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
              title: Text('Accepted List',
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
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Welcome, ISP User Name',
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
                    height: 25,
                  ),
                  Container(
                    key: requestTextKey,
                    child: const Text('Request List',
                        //key: requestTextKey,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                  const SizedBox(height: 5),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 200,
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Connection Type:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'NTTN Provider:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Application ID:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mobile No:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Location:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          ),
                          Container(
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'New\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Summit\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Agh012rf89\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '01112223330\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Dhaka 1206\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Connection Type:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'NTTN Provider:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Application ID:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mobile No:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Location:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          ),
                          Container(
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Upgrade\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Summit\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '98ghh66fd0\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '01234598760\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mirpur-10\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Connection Type:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'NTTN Provider:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Application ID:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mobile No:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Location:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          ),
                          Container(
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Others\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Fiber@Home\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'ABHYT67IHGR\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '0190099001\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mirpur-1\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    key: acceptedTextKey,
                    child: const Text('Accepted List',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                  const SizedBox(height: 5),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 200,
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Connection Type:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'NTTN Provider:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Application ID:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mobile No:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Location:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          ),
                          Container(
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'New\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Fiber@Home\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '0ijse2456dsf\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '01456622333\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Dhanmondi\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 200,
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'Connection Type:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'NTTN Provider:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Application ID:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Mobile No:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Location:\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          ),
                          Container(
                            height: 120,
                            child: RichText(
                                text: const TextSpan(children: [
                                  TextSpan(
                                      text: 'New\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Fiber@Home\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '77345jnkjn234\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: '01761123467\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                  TextSpan(
                                      text: 'Ashulia\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        height: 1.6,
                                        letterSpacing: 1.3,
                                        fontFamily: 'default',
                                      )),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                          fixedSize: Size(MediaQuery.of(context).size.width* 0.8, MediaQuery.of(context).size.height * 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ConnectionForm()));
                        },
                        child: const Text('New Connection Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                      ),
                    ),
                  )
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
                padding: EdgeInsets.all(5),
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
                      height: 5,
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
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConnectionForm()));
              },
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
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add_circle_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'New Connection',
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
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
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
