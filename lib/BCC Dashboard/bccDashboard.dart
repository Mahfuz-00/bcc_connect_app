import 'package:bcc_connect_app/Information/information.dart';
import 'package:bcc_connect_app/Search%20UI/searchUI.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API Model And Service (BCC_Connections)/apiserviceconnectionbcc.dart';
import '../API Service (Log Out)/apiServiceLogOut.dart';
import '../Connection Checker/internetconnectioncheck.dart';
import '../ISP Dashboard/templateerrorcontainer.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Template Models/bccConnectionsPendingdetailtile.dart';

class BCCDashboard extends StatefulWidget {
  const BCCDashboard({super.key});

  @override
  State<BCCDashboard> createState() => _BCCDashboardState();
}

class _BCCDashboardState extends State<BCCDashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isLoading = false;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _pageLoading = true;
  int? adslCountPending;
  int? adslCountActive;
  int? sblCountPending;
  int? sblCountActive;

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      organizationName = prefs.getString('organizationName') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      photoUrl = 'https://bcc.touchandsolve.com' + photoUrl;
      print('User Name: $userName');
      print('Organization Name: $organizationName');
      print('Photo URL: $photoUrl');
      print('User profile got it!!!!');
    });
  }

  Future<void> fetchConnections() async {
    if (_isFetched) return;
    try {
      final apiService = await BCCConnectionAPIService.create();

      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      print(dashboardData);

      final Map<String, dynamic>? counts = dashboardData['records']['total'];
      print(counts);
      final dynamic sblcount = counts?['sbl'];
      print('SBL: $sblcount');
      final dynamic adslcount = counts?['adsl'];
      print('ADSL: $adslcount');
      setState(() {
        sblCountActive = sblcount['active'];
        sblCountPending = sblcount['inactive'];
        print('SBL Active: $sblCountActive');
        print('SBL Pending: $sblCountPending');
        adslCountActive = adslcount['active'];
        adslCountPending = adslcount['inactive'];
        print('ADSL Active: $adslCountActive');
        print('ADSL Pending: $adslCountPending');
      });

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      print(records);

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      print('Pending: $pendingRequestsData');
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      print('Accepted: $acceptedRequestsData');

      // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return BCCConnectionsInfoCard(
          Name: request['name'],
          OrganizationName: request['organization'],
          MobileNo: request['mobile'],
          ConnectionType: request['connection_type'],
          Provider: request['provider'],
          ApplicationID: request['application_id'],
          Status: request['status'],
        );
      }).toList();

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return BCCConnectionsInfoCard(
          Name: request['name'],
          OrganizationName: request['organization'],
          MobileNo: request['mobile'],
          ConnectionType: request['connection_type'],
          Provider: request['provider'],
          ApplicationID: request['application_id'],
          Status: request['status'],
        );
      }).toList();

      setState(() {
        pendingConnectionRequests = pendingWidgets;
        acceptedConnectionRequests = acceptedWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = false;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      loadUserProfile();
      // After 5 seconds, set isLoading to false to stop showing the loading indicator
      setState(() {
        _pageLoading = false;
      });
    });
    _tabController = TabController(length: 2, vsync: this);
    //loadUserProfile();
    if (!_isFetched) {
      fetchConnections();
      // _isFetched = true; // Set _isFetched to true after the first call
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _pageLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              // Show circular loading indicator while waiting
              child: CircularProgressIndicator(),
            ),
          )
        : InternetChecker(
            child: PopScope(
              canPop: false,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                  titleSpacing: 5,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  title: const Text(
                    'BCC Admin Dashboard',
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
                      icon: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                      ),
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
                            Container(
                              width: 60, // Adjust width as needed
                              height: 60, // Adjust height as needed
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(photoUrl),
                                ),
                              ),
                            ),
                            Text(
                              userName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              organizationName,
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
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BCCDashboard())); // Close the drawer
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Information',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Information();
                            },
                          ));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Profile',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileUI())); // Close the drawer
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Logout',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () async {
                          // Clear user data from SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('userName');
                          await prefs.remove('organizationName');
                          await prefs.remove('photoUrl');
                          // Create an instance of LogOutApiService
                          var logoutApiService =
                              await LogOutApiService.create();

                          // Wait for authToken to be initialized
                          logoutApiService.authToken;

                          // Call the signOut method on the instance
                          if (await logoutApiService.signOut()) {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Login())); // Close the drawer
                          }
                        },
                      ),
                      Divider(),
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                    child: SafeArea(
                  child: Container(
                    color: Colors.grey[100],
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Connection Status',
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
                            height: 30,
                          ),
                          Container(
                            child: TabBar(
                              padding: EdgeInsets.zero,
                              controller: _tabController,
                              tabs: [
                                Tab(
                                  child: Text(
                                    'SecureNet Bangladesh Limited',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Advanced Digital Solution Limited',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: screenHeight * 0.25,
                            width: screenWidth,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                // Widget for SecureNet Bangladesh Limited Tab
                                buildContentForSecureNetBangladeshLimited(
                                    sblCountActive, sblCountPending),
                                // Widget for Advanced Digital Solution Limited Tab
                                buildContentForAdvancedDigitalSolutionLimited(
                                    adslCountActive, adslCountPending),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Pending Authentication',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            //height: screenHeight*0.25,
                            child: FutureBuilder<void>(
                                future: fetchConnections(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Return a loading indicator while waiting for data
                                    return Container(
                                      height: 200,
                                      // Adjust height as needed
                                      width: screenWidth,
                                      // Adjust width as needed
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    // Handle errors
                                    return buildNoRequestsWidget(screenWidth,
                                        'Error: ${snapshot.error}');
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (pendingConnectionRequests.isNotEmpty) {
                                      // If data is loaded successfully, display the ListView
                                      return Container(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: /*pendingConnectionRequests.length > 10
                                          ? 10
                                          :*/
                                              pendingConnectionRequests.length,
                                          itemBuilder: (context, index) {
                                            // Display each connection request using ConnectionRequestInfoCard
                                            return pendingConnectionRequests[
                                                index];
                                          },
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 10),
                                        ),
                                      );
                                    } else {
                                      // Handle the case when there are no pending connection requests
                                      return buildNoRequestsWidget(screenWidth,
                                          'There is no new connection request at this moment.');
                                    }
                                  }
                                  // Return a default widget if none of the conditions above are met
                                  return SizedBox(); // You can return an empty SizedBox or any other default widget
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                bottomNavigationBar: Container(
                  height: screenHeight * 0.08,
                  color: const Color.fromRGBO(25, 192, 122, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BCCDashboard()));
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
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return SearchUser();
                            },
                          ));
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
                                Icons.search,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
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
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Information();
                            },
                          ));
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
              ),
            ),
          );
  }

  Widget buildSegmentedButton(
      int selectedIndex, void Function(int) onValueChanged) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: CupertinoSegmentedControl<int>(
          children: {
            0: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'SecureNet Bangladesh Limited',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            1: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Advanced Digital Solution Limited',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          },
          groupValue: selectedIndex,
          onValueChanged: onValueChanged,
          unselectedColor: Colors.grey[200],
          selectedColor: const Color.fromRGBO(25, 192, 122, 1),
          borderColor: const Color.fromRGBO(25, 192, 122, 1),
        ),
      ),
    );
  }

  Widget buildContentForSecureNetBangladeshLimited(
      int? sblCountActive, int? sblCountPending) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
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
                Text(sblCountActive.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    )),
                SizedBox(
                  height: 10,
                ),
                Text('Total Active Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'default',
                    ))
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(20),
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
                Text(sblCountPending.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    )),
                SizedBox(
                  height: 10,
                ),
                Text('New Pending Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'default',
                    ))
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget buildContentForAdvancedDigitalSolutionLimited(
      int? adslCountActive, int? adslCountPending) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
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
                Text(adslCountActive.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    )),
                SizedBox(
                  height: 10,
                ),
                Text('Total Active Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'default',
                    ))
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
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
                Text(adslCountPending.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    )),
                SizedBox(
                  height: 10,
                ),
                Text('New Pending Connection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'default',
                    ))
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
