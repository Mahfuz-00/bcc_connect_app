import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../API Model and Service(NTTN_Connection)/apiserviceconnectionnttn.dart';
import '../BCC Dashboard/report.dart';
import '../Connection Checker/connectionchecker.dart';
import '../Connection Checker/internetconnectioncheck.dart';
import '../ISP Dashboard/templateerrorcontainer.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Search UI/searchUI.dart';
import '../Template Models/nttnActiveConnectionDetails.dart';
import '../Template Models/nttnConnectionMiniTiles.dart';
import '../Template Models/nttnPendingConncetionDetails.dart';

class NTTNDashboard extends StatefulWidget {
  final bool shouldRefresh;

  const NTTNDashboard({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<NTTNDashboard> createState() => _NTTNDashboardState();
}

class _NTTNDashboardState extends State<NTTNDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  final GlobalKey requestTextKey = GlobalKey();
  final GlobalKey acceptedTextKey = GlobalKey();
  bool _isLoading = false;
  bool _pageLoading = true;
  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  int? CountPending;
  int? CountActive;

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  Future<void> fetchConnectionApplications() async {
    if (_isFetched) return;
    try {
      final apiService = await NTTNConnectionAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic> dashboardData =
          await apiService.fetchConnections();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      print(dashboardData);

      final Map<String, dynamic>? counts = dashboardData['records']['total'];
      print(counts);
      setState(() {
        CountActive = counts?['active'];
        CountPending = counts?['inactive'];
        print('SBL Active: $CountActive');
        print('SBL Pending: $CountPending');
      });

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      print('Pending: $pendingRequestsData');
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      print('Accepted: $acceptedRequestsData');

      // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return ConnectionsTile(
          Name: request['name'],
          OrganizationName: request['organization'],
          MobileNo: request['mobile'],
          ConnectionType: request['connection_type'],
          ApplicationID: request['application_id'].toString(),
          Location: request['location'],
          Status: request['status'],
          LinkCapacity: request['link'],
          Remark: request['remark'],
          onPressed: () {
            print('Pending tapped');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingConnectionDetailsPage(
                  Name: request['name'],
                  OrganizationName: request['organization'],
                  MobileNo: request['mobile'],
                  ConnectionType: request['connection_type'],
                  ApplicationID: request['application_id'].toString(),
                  Location: request['location'],
                  Status: request['status'],
                  LinkCapacity: request['link'],
                  Remark: request['remark'],
                ),
              ),
            );
          },
        );
      }).toList();

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return ConnectionsTile(
          Name: request['name'],
          OrganizationName: request['organization'],
          MobileNo: request['mobile'],
          ConnectionType: request['connection_type'],
          ApplicationID: request['application_id'].toString(),
          Location: request['location'],
          Status: request['status'],
          LinkCapacity: request['link'],
          Remark: request['remark'],
          onPressed: () {
            print('Active tapped');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActiveConnectionDetailsPage(
                  Name: request['name'],
                  OrganizationName: request['organization'],
                  MobileNo: request['mobile'],
                  ConnectionType: request['connection_type'],
                  ApplicationID: request['application_id'].toString(),
                  Location: request['location'],
                  Status: request['status'],
                  LinkCapacity: request['link'],
                  Remark: request['remark'],
                ),
              ),
            );
          },
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

  int _expandedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnection();
    if (widget.shouldRefresh) {
      // Refresh logic here, e.g., fetch data again
      Future.delayed(Duration(seconds: 3), () {
        // After 5 seconds, set isLoading to false to stop showing the loading indicator
        setState(() {
          _pageLoading = false;
        });
      });
      if (!_isFetched) {
        fetchConnectionApplications();
        _isFetched = true; // Set _isFetched to true after the first call
      }
    }
  }

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
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
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
            icon: const Icon(
              Icons.notifications_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
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
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '',
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
                            NTTNDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Pending Application',
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
              title: Text('Connections',
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
              title: Text('Report',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BCCReport()));
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Welcome',
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.deepPurple,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(CountActive.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('Total Active Connection',
                                        textAlign: TextAlign.center,
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.greenAccent,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(CountPending.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('New Pending Connection',
                                        textAlign: TextAlign.center,
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
                        )),
                        SizedBox(
                          height: 20,
                        ),
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
                        Divider(),
                        const SizedBox(height: 5),
                        Container(
                          //height: screenHeight*0.25,
                          child: FutureBuilder<void>(
                              future: fetchConnectionApplications(),
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
                                        itemCount: pendingConnectionRequests
                                                    .length >
                                                10
                                            ? 10
                                            : pendingConnectionRequests.length,
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
                        Divider(),
                        const SizedBox(height: 5),
                        Container(
                          key: acceptedTextKey,
                          child: const Text('Active Connections',
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
                              future: fetchConnectionApplications(),
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
                                    return buildNoRequestsWidget(
                                        screenWidth, 'No Active connection.');
                                  } else {
                                    // If data is loaded successfully, display the ListView
                                    return Container(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: acceptedConnectionRequests
                                                    .length >
                                                10
                                            ? 10
                                            : acceptedConnectionRequests.length,
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
                Future.delayed(Duration(seconds: 0), () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NTTNDashboard(shouldRefresh: true)));
                });
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
