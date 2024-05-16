import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API Model and Service (ISP_Connection)/apiserviceispconnectiondetails.dart';
import '../API Service (Log Out)/apiServiceLogOut.dart';
import '../Connection Checker/internetconnectioncheck.dart';
import '../Connection Form (ISP)/connectionform.dart';
import '../ISP Request and Review List (Full)/ispRequestList.dart';
import '../ISP Request and Review List (Full)/ispReviewedList.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Template Models/ispRequestdetailstile.dart';
import 'templateerrorcontainer.dart';

class ISPDashboard extends StatefulWidget {
  final bool shouldRefresh;

  const ISPDashboard({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<ISPDashboard> createState() => _ISPDashboardState();
}

class _ISPDashboardState extends State<ISPDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //late List<ISPConnectionDetails> connectionRequests;
  // Declare variables to hold connection requests data
  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';

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

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await APIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardData();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 3));

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

      // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return ConnectionRequestInfoCard(
          ConnectionType: request['connection_type'],
          NTTNProvider: request['provider'],
          ApplicationID: request['application_id'].toString(),
          MobileNo: request['phone'],
          Location: request['location'],
          Time: request['created_at'],
          Status: request['status'],
        );
      }).toList();

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return ConnectionRequestInfoCard(
          ConnectionType: request['connection_type'],
          NTTNProvider: request['provider'],
          ApplicationID: request['application_id'].toString(),
          MobileNo: request['phone'],
          Location: request['location'],
          Time: request['created_at'],
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
      _isFetched = true;
      // Handle error as needed
    }
  }

  // Function to check if more than 10 items are available in the list
  bool shouldShowSeeAllButton(List list) {
    return list.length > 10;
  }

  // Build the button to navigate to the page showing all data
  Widget buildSeeAllButtonRequestList(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ISPRequestList()));
          },
          child: Text('See All Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
        ),
      ),
    );
  }

  // Build the button to navigate to the page showing all data
  Widget buildSeeAllButtonReviewedList(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ISPReviewedList()));
          },
          child: Text('See All Reviewed Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('initState called');
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        loadUserProfile();
        // Refresh logic here, e.g., fetch data again
        print('Page Loading Done!!');
        // connectionRequests = [];
        if (!_isFetched) {
          fetchConnectionRequests();
          //_isFetched = true; // Set _isFetched to true after the first call
        }
      }
      // After 5 seconds, set isLoading to false to stop showing the loading indicator
      setState(() {
        print('Page Loading');
        _pageLoading = false;
      });
    });
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
                backgroundColor: Colors.grey[100],
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
                    'Dashboard',
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
                            /*Container(
                        height: 60,
                        width: 60,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(photoUrl),
                          radius: 30,
                        ),
                      ),*/
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
                              /*  'Welcome',*/
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
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ISPDashboard())); // Close the drawer
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('New Connection Request',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConnectionForm()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Request List',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ISPRequestList()));
                        },
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Reviewed List',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ISPReviewedList()));
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
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileUI(
                                      shouldRefresh:
                                          true))); // Close the drawer
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 30),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Welcome, $userName',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
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
                            Divider(),
                            const SizedBox(height: 5),
                            Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height: 200, // Adjust height as needed
                                        width:
                                            screenWidth, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // Handle errors
                                      return buildNoRequestsWidget(screenWidth,
                                          'Error: ${snapshot.error}');
                                    } else if (_isFetched) {
                                      if (pendingConnectionRequests
                                          .isNotEmpty) {
                                        // If data is loaded successfully, display the ListView
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    pendingConnectionRequests
                                                                .length >
                                                            10
                                                        ? 10
                                                        : pendingConnectionRequests
                                                            .length,
                                                itemBuilder: (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return pendingConnectionRequests[
                                                      index];
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 10),
                                              ),
                                              if (shouldShowSeeAllButton(
                                                  pendingConnectionRequests))
                                                buildSeeAllButtonRequestList(
                                                    context),
                                            ],
                                          ),
                                        );
                                      } else if (pendingConnectionRequests
                                          .isEmpty) {
                                        // Handle the case when there are no pending connection requests
                                        return buildNoRequestsWidget(
                                            screenWidth,
                                            'You currently don\'t have any new requests pending.');
                                      }
                                    }
                                    // Return a default widget if none of the conditions above are met
                                    return SizedBox(); // You can return an empty SizedBox or any other default widget
                                  }),
                            ),
                            Divider(),
                            const SizedBox(height: 25),
                            Container(
                              child: const Text('Reviewed List',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  )),
                            ),
                            Divider(),
                            const SizedBox(height: 5),
                            Container(
                              //height: screenHeight*0.25,
                              child: FutureBuilder<void>(
                                  future: _isLoading
                                      ? null
                                      : fetchConnectionRequests(),
                                  builder: (context, snapshot) {
                                    if (!_isFetched) {
                                      // Return a loading indicator while waiting for data
                                      return Container(
                                        height: 200, // Adjust height as needed
                                        width:
                                            screenWidth, // Adjust width as needed
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      // Handle errors
                                      return buildNoRequestsWidget(screenWidth,
                                          'Error: ${snapshot.error}');
                                    } else if (_isFetched) {
                                      if (acceptedConnectionRequests.isEmpty) {
                                        // Handle the case when there are no pending connection requests
                                        return buildNoRequestsWidget(
                                            screenWidth,
                                            'No connection requests reviewed yet');
                                      } else if (acceptedConnectionRequests
                                          .isNotEmpty) {
                                        // If data is loaded successfully, display the ListView
                                        return Container(
                                          child: Column(
                                            children: [
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    acceptedConnectionRequests
                                                                .length >
                                                            10
                                                        ? 10
                                                        : acceptedConnectionRequests
                                                            .length,
                                                itemBuilder: (context, index) {
                                                  // Display each connection request using ConnectionRequestInfoCard
                                                  return acceptedConnectionRequests[
                                                      index];
                                                },
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(height: 10),
                                              ),
                                              if (shouldShowSeeAllButton(
                                                  acceptedConnectionRequests))
                                                buildSeeAllButtonReviewedList(
                                                    context),
                                            ],
                                          ),
                                        );
                                      }
                                    }
                                    return SizedBox();
                                  }),
                            ),
                            Divider(),
                            const SizedBox(height: 30),
                            Center(
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width * 0.8,
                                        MediaQuery.of(context).size.height *
                                            0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ConnectionForm()));
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ISPDashboard()));
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConnectionForm()));
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
}
