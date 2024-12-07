import 'package:bcc_connect_app/UI/Pages/NTTN%20Work%20Order/nttnWorkOrder.dart';
import 'package:bcc_connect_app/UI/Pages/Work%20Order/workOrder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (NTTN_Connection)/apiserviceconnectionnttn.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/nttnActiveConnectionDetails.dart';
import '../../Widgets/nttnConnectionMiniTiles.dart';
import '../../Widgets/nttnPendingConncetionDetails.dart';
import '../../Widgets/requestWidget.dart';
import '../NTTN Pending and Active Connection/nttnActiveConnectionList.dart';
import '../NTTN Pending and Active Connection/nttnPendingConnectionList.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Search UI/searchUI.dart';

/// This class represents the user interface for the NTTN Dashboard.
/// It handles the display of user information, connection status,
/// and notifications. It uses a [SingleChildScrollView] for scrollable content
/// and a [Container] to manage padding and background color.
/// The main elements include:
///
/// - [userProfile]: An object that holds user information, particularly the user's name.
/// - [CountActive]: An integer representing the total number of active connections.
/// - [CountPending]: An integer representing the total number of new pending connections.
/// - [screenWidth]: A double representing the width of the device screen, used for responsive design.
/// - [screenHeight]: A double representing the height of the device screen, used for responsive design.
/// - [_isLoading]: A boolean indicating whether data is currently being loaded.
/// - [_isFetched]: A boolean indicating whether data has been successfully fetched.
/// - [pendingConnectionRequests]: A list of requests for pending connections.
/// - [acceptedConnectionRequests]: A list of requests for active connections.
/// - [canFetchMorePending]: A boolean indicating whether more pending requests can be fetched.
/// - [canFetchMoreAccepted]: A boolean indicating whether more accepted requests can be fetched.
/// - [fetchConnectionApplications]: A method that fetches connection application data.
/// - [NTTNPendingConnectionListUI]: A widget representing the UI for pending connections.
/// - [NTTNActiveConnectionListUI]: A widget representing the UI for active connections.
/// - [notifications]: A list of notification messages displayed in the overlay.
/// - [_showNotificationsOverlay]: A method that displays a notification overlay.
///
/// The UI includes:
/// - A welcome message displaying the user's name.
/// - A section showing connection status with counts for active and pending connections.
/// - Two [RequestsWidget] components displaying pending and active connection requests.
/// - A bottom navigation bar with options to navigate to Home, Search, and Information screens.
class NTTNDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const NTTNDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<NTTNDashboardUI> createState() => _NTTNDashboardUIState();
}

class _NTTNDashboardUIState extends State<NTTNDashboardUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _pageLoading = true;
  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _errorOccurred = false;
  int? CountPending = 0;
  int? CountActive = 0;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<String> notifications = [];
  late Pagination pendingPagination;
  late Pagination acceptedPagination;

  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;

  Future<void> fetchConnectionApplications() async {
    if (_isFetched) return;
    try {
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;
      final apiService = await NTTNConnectionAPIService.create(token);
      final Map<String, dynamic> dashboardData =
          await apiService.fetchConnections();
      if (dashboardData == null || dashboardData.isEmpty) {
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
        print('No records available');
        /*   setState(() {
          _isFetched = true;
        });*/
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

      notifications = List<String>.from(records['notifications'] ?? []);

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      print('Pending: $pendingRequestsData');
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      print('Accepted: $acceptedRequestsData');
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${acceptedRequestsData[index]}\n');
      }

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
                builder: (context) => PendingConnectionDetails(
                  Name: request['name'],
                  OrganizationName: request['organization'],
                  MobileNo: request['mobile'],
                  ConnectionType: request['connection_type'],
                  FRNumber: request['fr_number'].toString(),
                  Location: request['location'],
                  Status: request['status'],
                  LinkCapacity: request['link'],
                  Remark: request['remark'],
                  SerivceType: request['service_type'],
                  Capacity: request['capacity'],
                  WorkOrderNumber: request['work_order_number'],
                  ContactDuration: request['contract_duration'],
                  NetPayment: request['net_payment'],
                  OrgAddress: request['client_address'],
                ),
              ),
            );
          },
        );
      }).toList();

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
                builder: (context) => ActiveConnectionDetails(
                  Name: request['name'],
                  OrganizationName: request['organization'],
                  MobileNo: request['mobile'],
                  ConnectionType: request['connection_type'],
                  FRNumber: request['fr_number'].toString(),
                  Location: request['location'],
                  Status: request['status'],
                  LinkCapacity: request['link'],
                  Remark: request['remark'],
                  SerivceType: request['service_type'],
                  Capacity: request['capacity'],
                  WorkOrderNumber: request['work_order_number'],
                  ContactDuration: request['contract_duration'],
                  NetPayment: request['net_payment'],
                  OrgAddress: request['client_address'],
                ),
              ),
            );
          },
        );
      }).toList();

      setState(() {
        pendingConnectionRequests = pendingWidgets;
        acceptedConnectionRequests = acceptedWidgets;
        print(acceptedConnectionRequests);
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.shouldRefresh) {
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _pageLoading = false;
        });
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      if (!_isFetched) {
        fetchConnectionApplications();
      }
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
                    /*  canPop: false,*/
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
                          'NTTN Dashboard',
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
                                  final token =
                                      (authCubit.state as AuthAuthenticated)
                                          .token;
                                  var notificationApiService =
                                      await NotificationReadApiService.create(
                                          token);
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
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle, // For a circular image
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1, // 1:1 ratio for a square or circular image
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: 'https://bcc.touchandsolve.com${userProfile.photo}',
                                          fit: BoxFit.cover, // Ensures the image covers the available space
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.person, size: 40),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    userProfile.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                  SizedBox(height: 10),
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
                                        builder: (context) => NTTNDashboardUI(
                                              shouldRefresh: true,
                                            )));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NTTNPendingConnectionListUI(
                                              shouldRefresh: true,
                                            )));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NTTNActiveConnectionListUI(
                                              shouldRefresh: true,
                                            )));
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text('Work Order',
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
                                    return NTTNWorkOrderUI(shouldRefresh: true,);
                                  },
                                ));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfileUI(
                                              shouldRefresh: true,
                                            )));
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
                                final token =
                                    (authCubit.state as AuthAuthenticated)
                                        .token;
                                var logoutApiService =
                                    await LogOutApiService.create(token);
                                logoutApiService.authToken;
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
                                          builder: (context) => LoginUI()));
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                                    height: 20,
                                  ),
                                  Container(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Material(
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: screenWidth * 0.43,
                                          height: screenHeight * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: Colors.deepPurple,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              Text('Active Connections',
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
                                          width: screenWidth * 0.43,
                                          height: screenHeight * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                            color: Colors.greenAccent,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              Text('Pending Connections',
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
                                  RequestsWidget(
                                      loading: _isLoading,
                                      fetch: _isFetched,
                                      errorText:
                                          'There is no new connection request at this moment.',
                                      listWidget: pendingConnectionRequests,
                                      fetchData: fetchConnectionApplications(),
                                      showSeeAllButton: canFetchMorePending,
                                      seeAllButtonText: 'See All Request',
                                      nextPage: NTTNPendingConnectionListUI(
                                        shouldRefresh: true,
                                      )),
                                  Divider(),
                                  const SizedBox(height: 5),
                                  Container(
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
                                  RequestsWidget(
                                      loading: _isLoading,
                                      fetch: _isFetched,
                                      errorText: 'No Active connection.',
                                      listWidget: acceptedConnectionRequests,
                                      fetchData: fetchConnectionApplications(),
                                      showSeeAllButton: canFetchMoreAccepted,
                                      seeAllButtonText:
                                          'See All Reviewed Request',
                                      nextPage: NTTNActiveConnectionListUI(
                                        shouldRefresh: true,
                                      )),
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
                                          builder: (context) => NTTNDashboardUI(
                                              shouldRefresh: true)));
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
                                    return SearchUI();
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
                                    return InformationUI();
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
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
