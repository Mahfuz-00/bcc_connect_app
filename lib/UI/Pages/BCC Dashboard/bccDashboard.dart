import 'package:bcc_connect_app/Data/Data%20Sources/API%20Service%20(BCC_Connections)/apiserviceconnectionfullbcc.dart';
import 'package:bcc_connect_app/UI/Widgets/requestWidget.dart';
import 'package:bcc_connect_app/UI/Widgets/requestWidgetShowAll.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (BCC_Connections)/apiserviceconnectionbcc.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/bccConnectionsPendingdetailtile.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../Information/information.dart';
import '../Search UI/searchUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

class BCCDashboard extends StatefulWidget {
  final bool shouldRefresh;

  const BCCDashboard({Key? key, this.shouldRefresh = false}) : super(key: key);

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
  List<String> notifications = [];
  ScrollController _scrollController = ScrollController();
  ScrollController _tabScrollController = ScrollController();
  late Pagination pendingPagination;
  bool canFetchMorePending = false;
  late String url = '';

/*  Future<void> loadUserProfile() async {
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
  }*/

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

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination);
      print('Pagination: $pendingPagination');
      if(pendingPagination.nextPage != 'None' && pendingPagination.nextPage!.isNotEmpty){
        url = pendingPagination.nextPage as String;
        print(pendingPagination.nextPage);
        canFetchMorePending = pendingPagination.canFetchNext;
      } else{
        url = '';
        canFetchMorePending = false;
      }

      // Extract notifications
      notifications = List<String>.from(records['notifications'] ?? []);

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

  Future<void> fetchMoreConnectionRequests() async {
    setState(() {
      _isLoading = true;
    });
    print(url);

    try {
      if (url != '' && url.isNotEmpty) {
        final apiService = await BCCFullConnectionAPIService.create();
        final Map<String, dynamic> dashboardData =
        await apiService.fetchFullDashboardItems(url);

        if (dashboardData == null || dashboardData.isEmpty) {
          print(
              'No data available or error occurred while fetching dashboard data');
          return;
        }

        final Map<String, dynamic> records = dashboardData['records'];
        if (records == null || records.isEmpty) {
          print('No records available');
          return;
        }

        final Map<String, dynamic> pagination = records['pagination'] ?? {};
        print(pagination);

        pendingPagination = Pagination.fromJson(pagination);

        if(pendingPagination.nextPage != 'None' && pendingPagination.nextPage!.isNotEmpty){
          url = pendingPagination.nextPage as String;
          print(pendingPagination.nextPage);
          canFetchMorePending = pendingPagination.canFetchNext;
        } else{
          url = '';
          canFetchMorePending = false;
        }

        final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
        final int currentCount = pendingConnectionRequests.length;
        /*final int additionalLoadCount =
            pendingRequestsData.length > currentCount + _itemsToLoad
                ? _itemsToLoad
                : pendingRequestsData.length - currentCount;
        for (var index = 0; index < pendingRequestsData.length; index++) {
          print(
              'Pending Request at index $index: ${pendingRequestsData[index]}\n');
        }*/

        if (pendingRequestsData.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('All requests loaded')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        print('Current count: $currentCount');
        // print('Additional load count: $additionalLoadCount');

        /*  if (additionalLoadCount == 0) {
          // If no additional requests are loaded
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('All requests loaded')),
          );
        }*/

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

        setState(() {
          pendingConnectionRequests.addAll(pendingWidgets);
          _isLoading = false;
        });
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All requests loaded')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      print('Error fetching more connection requests: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        print('Invoking Scrolling!!');
        fetchMoreConnectionRequests();
      }
    });
    _tabController = TabController(length: 2, vsync: this);
    //loadUserProfile();
    Future.delayed(Duration(seconds: 5), () {
      //loadUserProfile();
      if (widget.shouldRefresh) {
        setState(() {
          _pageLoading = false;
        });
      }
    });
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
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                return InternetChecker(
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
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  _showNotificationsOverlay(context);
                                  var notificationApiService =
                                      await NotificationReadApiService.create();
                                  notificationApiService.readNotification();
                                },
                              ),
                              if (notifications.isNotEmpty)
                                Positioned(
                                  right: 11,
                                  top: 11,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '${notifications.length}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
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
                                        image: CachedNetworkImageProvider('https://bcc.touchandsolve.com${userProfile.photo}'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Text(
                                    userProfile.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                  /*  SizedBox(height: 10),
                            Text(
                              organizationName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),*/
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
                                            BCCDashboard(shouldRefresh: true,))); // Close the drawer
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
                                            ProfileUI(shouldRefresh: true,))); // Close the drawer
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
                                Navigator.pop(context);
                                const snackBar = SnackBar(
                                  content: Text(
                                      'Logging out'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                /*   // Clear user data from SharedPreferences
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('userName');
                                await prefs.remove('organizationName');
                                await prefs.remove('photoUrl');*/
                                // Create an instance of LogOutApiService
                                var logoutApiService =
                                await LogOutApiService.create();

                                // Wait for authToken to be initialized
                                logoutApiService.authToken;

                                // Call the signOut method on the instance
                                if (await logoutApiService.signOut()) {
                                  const snackBar = SnackBar(
                                    content: Text(
                                        'Logged out'),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  // Call logout method in AuthCubit/AuthBloc
                                  context.read<AuthCubit>().logout();
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
                        controller: _scrollController,
                        child: Column(
                          children: [
                            SafeArea(
                              child: Container(
                                color: Colors.grey[100],
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Welcome, ${userProfile.name}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                                    const SizedBox(height: 20),
                                    TabBar(
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
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.25,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  buildContentForSecureNetBangladeshLimited(sblCountActive, sblCountPending),
                                  buildContentForAdvancedDigitalSolutionLimited(adslCountActive, adslCountPending),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Pending Authentication',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                            Divider(),
                            pendingConnectionRequests.isNotEmpty
                                ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.separated(
                                                                physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside ListView
                                                                shrinkWrap: true, // Allow ListView to take only necessary height
                                                                itemCount: pendingConnectionRequests.length + 1,
                                                                itemBuilder: (context, index) {
                                  if (index == pendingConnectionRequests.length) {
                                    return Center(
                                      child: _isLoading
                                          ? Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: CircularProgressIndicator(),
                                      )
                                          : SizedBox.shrink(),
                                    );
                                  }
                                  return pendingConnectionRequests[index];
                                                                },
                                                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                                              ),
                                )
                                : buildNoRequestsWidget(screenWidth, 'There is no new connection request at this moment.'),
                          ],
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
                                        builder: (context) => BCCDashboard(
                                              shouldRefresh: true,
                                            )));
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
              } else {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
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

  void _showNotificationsOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight + 10.0,
        right: 10.0,
        width: 250,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: notifications.isEmpty
                ? Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'No new notifications',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text(notifications[index]),
                            onTap: () {
                              // Handle notification tap if necessary
                              overlayEntry.remove();
                            },
                          ),
                          if (index < notifications.length - 1) Divider()
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // Remove the overlay when tapping outside
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
