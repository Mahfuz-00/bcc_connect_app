import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API Model and Service (ISP_Connection)/apiserviceispconnectiondetails.dart';
import '../Connection Checker/connectionchecker.dart';
import '../Connection Checker/internetconnectioncheck.dart';
import '../Connection Form (ISP)/connectionform.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
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
  final ScrollController scrollController = ScrollController();
  final GlobalKey requestTextKey = GlobalKey();
  final GlobalKey acceptedTextKey = GlobalKey();

  //late List<ISPConnectionDetails> connectionRequests;
  // Declare variables to hold connection requests data
  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;

  late final String userName;
  late final String organizationName;
  late final String photoUrl;

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isLoading = true;
      });
    }
  }

/*  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      organizationName = prefs.getString('organizationName') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
    });
  }*/

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
      });
      _isFetched = true;
    } catch (e) {
      print('Error fetching connection requests: $e');
      // Handle error as needed
    }
  }

  Future<bool> _fetchData() async {
    await fetchConnectionRequests(); // Call your method to fetch data
    return true; // Return true once data is fetched
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    print('initState called');
    //loadUserProfile();


    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh) {
        // Refresh logic here, e.g., fetch data again
        print('Page Loading Done!!');
        // connectionRequests = [];
        if (!_isFetched) {
          fetchConnectionRequests();
          _isFetched = true; // Set _isFetched to true after the first call
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

    return Scaffold(
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
                  CircleAvatar(
                   // backgroundImage: NetworkImage(photoUrl),
                    radius: 30,
                  ),
                  Text(
                   'Welcome', /*userName,*/
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '',/*organizationName,*/
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnectionForm()));
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
                scrollToRequestText();
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
              title: Text('Logout',
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
                        builder: (context) => Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: _pageLoading
          ? Center(
              // Show circular loading indicator while waiting
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: scrollController,
              child: SafeArea(
                child: Container(
                  color: Colors.grey[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Welcome ', /*$userName*/
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
                        Divider(),
                        const SizedBox(height: 5),
                        Container(
                          //height: screenHeight*0.25,
                          child: FutureBuilder<void>(
                              future: _fetchData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Return a loading indicator while waiting for data
                                  return Container(
                                    height: 200, // Adjust height as needed
                                    width:
                                        screenWidth, // Adjust width as needed
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
                                  return buildNoRequestsWidget(
                                      screenWidth, 'Error: ${snapshot.error}');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (pendingConnectionRequests.isNotEmpty) {
                                    // If data is loaded successfully, display the ListView
                                    return Container(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
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
                          key: acceptedTextKey,
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
                              future: fetchConnectionRequests(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Return a loading indicator while waiting for data
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // Handle errors
                                  return buildNoRequestsWidget(
                                      screenWidth, 'Error: ${snapshot.error}');
                                } else if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (acceptedConnectionRequests.isEmpty) {
                                    // Handle the case when there are no pending connection requests
                                    return buildNoRequestsWidget(screenWidth,
                                        'No connection requests reviewed yet');
                                  } else {
                                    // If data is loaded successfully, display the ListView
                                    return Container(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: /* acceptedConnectionRequests.length > 10
                                    ? 10
                                    :*/
                                            acceptedConnectionRequests.length,
                                        itemBuilder: (context, index) {
                                          // Display each connection request using ConnectionRequestInfoCard
                                          return acceptedConnectionRequests[
                                              index];
                                        },
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(height: 10),
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
                                    MediaQuery.of(context).size.height * 0.1),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ISPDashboard()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnectionForm()));
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
    );
  }

  bool _isScrolling = false;
  double? _initialPositionRequest;
  double? _initialPositionAccepted;

  void scrollToRequestText() {
    if (_isScrolling) return;
    // Find the RenderObject for the text widget
    final RenderBox? renderBox =
        requestTextKey.currentContext!.findRenderObject() as RenderBox?;
    // Check if the RenderObject is valid
    if (renderBox != null) {
      _isScrolling = true;
      // Get the position of the RenderObject in the global coordinate system
      final position = renderBox.localToGlobal(Offset.zero).dy;

      // Store the initial position
      if (_initialPositionAccepted == null) {
        _initialPositionRequest = position;
        print('Request: $_initialPositionRequest');
      }
      // Scroll to the position of the text widget
      scrollController
          .animateTo(
        (_initialPositionRequest! - 55) - renderBox.size.height,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      )
          .then((_) {
        // Use then() to handle completion
        _initialPositionRequest = null;
        print('Request Done: $_initialPositionRequest');
        Future.delayed(Duration(milliseconds: 100), () {
          print('Double Check: $_initialPositionRequest'); // Should be null
        });
        _isScrolling = false; // Reset flag after animation finishes
      });
    }
  }

  void scrollToAcceptedText() {
    if (_isScrolling) return;
    // Find the RenderObject for the text widget
    final RenderBox? renderBox =
        acceptedTextKey.currentContext!.findRenderObject() as RenderBox?;

    // Check if the RenderObject is valid
    if (renderBox != null) {
      _isScrolling = true;
      // Get the position of the RenderObject in the global coordinate system
      final position = renderBox.localToGlobal(Offset.zero).dy;
      // Store the initial position
      if (_initialPositionRequest == null) {
        _initialPositionAccepted = position;
        print('accepted: $_initialPositionAccepted');
      }
      // Scroll to the position of the text widget
      scrollController
          .animateTo(
        (_initialPositionAccepted! - 55) - renderBox.size.height,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      )
          .then((_) {
        // Use then() to handle completion
        _isScrolling = false; // Reset flag after animation finishes
        _initialPositionAccepted = null;
        print('accepted Done: $_initialPositionAccepted');
      });
    }
  }
}
