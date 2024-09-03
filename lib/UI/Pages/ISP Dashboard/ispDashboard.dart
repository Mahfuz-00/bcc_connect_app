import 'package:bcc_connect_app/UI/Widgets/requestWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (ISP_Connection)/apiserviceispconnectiondetails.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/ispRequestdetailstile.dart';
import '../Connection Form (ISP)/connectionform.dart';
import '../ISP Request and Review List (Full)/ispRequestList.dart';
import '../ISP Request and Review List (Full)/ispReviewedList.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Upgrade UI/upgradeUI.dart';

/// A dashboard widget that displays active and pending ISP connections.
///
/// This widget shows the number of active and pending connections, along
/// with buttons that allow users to navigate to the full lists of each type.
class ISPDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const ISPDashboardUI({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<ISPDashboardUI> createState() => _ISPDashboardUIState();
}

class _ISPDashboardUIState extends State<ISPDashboardUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  late String UserName = '';
  late String OrganizationName = '';
  late String Photo = '';
  late String ID = '';
  late String Token = '';
  List<String> notifications = [];
  late Pagination pendingPagination;
  late Pagination acceptedPagination;

  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;
      final apiService = await ISPConnectionAPIService.create(token);

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
        setState(() {
          _isFetched= true;
        });
        return;
      }

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination['pending']);
      acceptedPagination = Pagination.fromJson(pagination['accepted']);
      print(pendingPagination.nextPage);
      print(acceptedPagination.nextPage);

      canFetchMorePending = pendingPagination.canFetchNext;
      canFetchMoreAccepted = acceptedPagination.canFetchNext;

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Extract notifications
      notifications = List<String>.from(records['notifications'] ?? []);

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 1));

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

  @override
  void initState() {
    super.initState();
    print('initState called');
    Future.delayed(Duration(seconds: 2), () {
      if (!_isFetched) {
        fetchConnectionRequests();
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      if (widget.shouldRefresh && !_isFetched) {
        print('Page Loading Done!!');
        // connectionRequests = [];
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
              child: CircularProgressIndicator(),
            ),
          )
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                return InternetConnectionChecker(
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
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  _showNotificationsOverlay(context);
                                  final authCubit = context.read<AuthCubit>();
                                  final token = (authCubit.state as AuthAuthenticated).token;
                                  var notificationApiService =
                                      await NotificationReadApiService.create(token);
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
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            'https://bcc.touchandsolve.com${userProfile.photo}'),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    userProfile.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    userProfile.organization,
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
                                        builder: (context) => ISPDashboardUI(
                                            shouldRefresh:
                                                true))); // Close the drawer
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
                                        builder: (context) =>
                                            ConnectionFormUI()));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Upgrade Connection',
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
                                        builder: (context) =>
                                            UpgradeUI(shouldRefresh: true)));
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
                                        builder: (context) => ISPRequestListUI(
                                            shouldRefresh: true)));
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
                                        builder: (context) => ISPReviewedListUI(
                                            shouldRefresh: true)));
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
                                    return InformationUI();
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
                                                true)));
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
                                  content: Text('Logging out'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                final authCubit = context.read<AuthCubit>();
                                final token = (authCubit.state as AuthAuthenticated).token;
                                var logoutApiService =
                                    await LogOutApiService.create(token);

                                // Wait for authToken to be initialized
                                logoutApiService.authToken;

                                // Call the signOut method on the instance
                                if (await logoutApiService.signOut()) {
                                  const snackBar = SnackBar(
                                    content: Text('Logged out'),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  context.read<AuthCubit>().logout();
                                  final emailCubit = EmailCubit();
                                  emailCubit.clearEmail();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LoginUI()));
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
                                      'Welcome, ${userProfile.name}',
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
                                  RequestsWidget(
                                      loading: _isLoading,
                                      fetch: _isFetched,
                                      errorText:
                                          'You currently don\'t have any new requests pending.',
                                      listWidget: pendingConnectionRequests,
                                      fetchData: fetchConnectionRequests(),
                                      showSeeAllButton: canFetchMorePending,
                                      seeAllButtonText: 'See All Request',
                                      nextPage:
                                          ISPRequestListUI(shouldRefresh: true)),
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
                                  RequestsWidget(
                                      loading: _isLoading,
                                      fetch: _isFetched,
                                      errorText:
                                          'No connection requests reviewed yet',
                                      listWidget: acceptedConnectionRequests,
                                      fetchData: fetchConnectionRequests(),
                                      showSeeAllButton: canFetchMoreAccepted,
                                      seeAllButtonText:
                                          'See All Reviewed Request',
                                      nextPage:
                                          ISPReviewedListUI(shouldRefresh: true)),
                                  Divider(),
                                  const SizedBox(height: 30),
                                  Center(
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              25, 192, 122, 1),
                                          fixedSize: Size(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConnectionFormUI()));
                                        },
                                        child:
                                            const Text('New Connection Request',
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
                                        builder: (context) =>
                                            ISPDashboardUI(shouldRefresh: true)));
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
                                        builder: (context) =>
                                            ConnectionFormUI()));
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
                                    return UpgradeUI(shouldRefresh: true);
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
                                      Icons.upgrade,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Wrap(
                                      children: [
                                        Text(
                                          'Upgrade',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      ],
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
