import 'package:bcc_connect_app/Data/Data%20Sources/API%20Service%20(BCC_Connections)/apiserviceconnectionfullbcc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (BCC_Connections)/apiserviceconnectionbcc.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/bccConnectionsPendingdetailtile.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../Information/information.dart';
import '../Search UI/searchUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// The [BCCDashboardUI] class represents the dashboard interface for the BCC Admin application.
/// It manages the display of user connection requests, including pending and accepted requests,
/// and handles data fetching and loading states. The UI is built using Flutter widgets and is
/// integrated with Bloc for state management.
///
/// **Main Variables:**
/// - [shouldRefresh]: A boolean indicating if the dashboard should refresh.
/// - [scaffoldKey]: A GlobalKey for the scaffold, used to control the drawer.
/// - [tabController]: A TabController for managing tabs in the dashboard.
/// - [isLoading]: A boolean indicating if data is currently being loaded.
/// - [userName]: A string holding the user's name.
/// - [organizationName]: A string holding the user's organization name.
/// - [photoUrl]: A string holding the user's photo URL.
/// - [pendingConnectionRequests]: A list of widgets representing pending connection requests.
/// - [acceptedConnectionRequests]: A list of widgets representing accepted connection requests.
/// - [isFetched]: A boolean indicating if the data has been fetched.
/// - [pageLoading]: A boolean indicating if the page is loading.
/// - [adslCountPending]: An integer holding the count of pending ADSL requests.
/// - [adslCountActive]: An integer holding the count of active ADSL requests.
/// - [sblCountPending]: An integer holding the count of pending SBL requests.
/// - [sblCountActive]: An integer holding the count of active SBL requests.
/// - [notifications]: A list of strings holding notification messages.
/// - [scrollController]: A ScrollController for managing scroll events.
/// - [tabScrollController]: A ScrollController for managing tab scroll events.
/// - [pendingPagination]: A Pagination object for handling pagination of requests.
/// - [canFetchMorePending]: A boolean indicating if more pending requests can be fetched.
/// - [url]: A string holding the URL for fetching more connection requests.
///
/// **Key Methods:**
/// - [fetchConnections]: Fetches connection requests from the API.
/// - [fetchMoreConnectionRequests]: Fetches additional connection requests when scrolling to the bottom.
/// - [buildSegmentedButton] creates a segmented control with two options
///   ([SecureNetBangladeshLimited] and [AdvancedDigitalSolutionLimited]). Parameters:
///   - [selectedIndex]: The index of the currently selected segment.
///   - [onValueChanged]: Callback function triggered when the segment changes.
///
/// - [buildContentForSecureNetBangladeshLimited] displays the total active and
///   pending connections for 'SecureNet Bangladesh Limited'. Parameters:
///   - [sblCountActive]: The count of active connections (can be null).
///   - [sblCountPending]: The count of pending connections (can be null).
///
/// - [buildContentForAdvancedDigitalSolutionLimited] displays the total active
///   and pending connections for 'Advanced Digital Solution Limited'. Parameters:
///   - [adslCountActive]: The count of active connections (can be null).
///   - [adslCountPending]: The count of pending connections (can be null).
class BCCDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const BCCDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<BCCDashboardUI> createState() => _BCCDashboardUIState();
}

class _BCCDashboardUIState extends State<BCCDashboardUI>
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
  int? adslCountPending = 0;
  int? adslCountActive = 0;
  int? sblCountPending = 0;
  int? sblCountActive = 0;
  List<String> notifications = [];
  ScrollController _scrollController = ScrollController();
  ScrollController _tabScrollController = ScrollController();
  late Pagination pendingPagination;
  bool canFetchMorePending = false;
  late String url = '';

  Future<void> fetchConnections() async {
    if (_isFetched) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;
      final apiService = await BCCConnectionAPIService.create(token);

      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
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
        print('No records available');
        /*  setState(() {
          _isFetched= true;
        });*/
        return;
      }

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination);
      print('Pagination: $pendingPagination');
      if (pendingPagination.nextPage != 'None' &&
          pendingPagination.nextPage!.isNotEmpty) {
        url = pendingPagination.nextPage as String;
        print(pendingPagination.nextPage);
        canFetchMorePending = pendingPagination.canFetchNext;
      } else {
        url = '';
        canFetchMorePending = false;
      }

      notifications = List<String>.from(records['notifications'] ?? []);

      print(records);

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      print('Pending: $pendingRequestsData');
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      print('Accepted: $acceptedRequestsData');

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return BCCConnectionsInfoCard(
          Name: request['name'],
          OrganizationName: request['organization'],
          MobileNo: request['mobile'],
          ConnectionType: request['connection_type'],
          Provider: request['provider'],
          FRNumber: request['fr_number'],
          Status: request['status'],
          SerivceType: request['service_type'],
          Capacity: request['capacity'],
          WorkOrderNumber: request['work_order_number'],
          ContactDuration: request['contract_duration'],
          NetPayment: request['net_payment'],
          OrgAddress: request['client_address'],
        );
      }).toList();

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return BCCConnectionsInfoCard(
          Name: request['name'],
          OrganizationName: request['organization'],
          MobileNo: request['mobile'],
          ConnectionType: request['connection_type'],
          Provider: request['provider'],
          FRNumber: request['fr_number'],
          Status: request['status'],
          SerivceType: request['service_type'],
          Capacity: request['capacity'],
          WorkOrderNumber: request['work_order_number'],
          ContactDuration: request['contract_duration'],
          NetPayment: request['net_payment'],
          OrgAddress: request['client_address'],
        );
      }).toList();

      setState(() {
        pendingConnectionRequests = pendingWidgets;
        acceptedConnectionRequests = acceptedWidgets;
        _isFetched = true;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
      _isLoading = false;
    }
  }

  Future<void> fetchMoreConnectionRequests() async {
    setState(() {
      _isLoading = true;
    });
    print(url);

    try {
      if (url != '' && url.isNotEmpty) {
        final authCubit = context.read<AuthCubit>();
        final token = (authCubit.state as AuthAuthenticated).token;
        final apiService = await BCCFullConnectionAPIService.create(token);
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

        if (pendingPagination.nextPage != 'None' &&
            pendingPagination.nextPage!.isNotEmpty) {
          url = pendingPagination.nextPage as String;
          print(pendingPagination.nextPage);
          canFetchMorePending = pendingPagination.canFetchNext;
        } else {
          url = '';
          canFetchMorePending = false;
        }

        final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
        final int currentCount = pendingConnectionRequests.length;

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

        final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
          return BCCConnectionsInfoCard(
            Name: request['name'],
            OrganizationName: request['organization'],
            MobileNo: request['mobile'],
            ConnectionType: request['connection_type'],
            Provider: request['provider'],
            FRNumber: request['fr_number'],
            Status: request['status'],
            SerivceType: request['service_type'],
            Capacity: request['capacity'],
            WorkOrderNumber: request['work_order_number'],
            ContactDuration: request['contract_duration'],
            NetPayment: request['net_payment'],
            OrgAddress: request['client_address'],
          );
        }).toList();

        setState(() {
          pendingConnectionRequests.addAll(pendingWidgets);
          _isLoading = false;
        });
      } else {
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
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh) {
        setState(() {
          _pageLoading = false;
        });
      }
    });
    Future.delayed(Duration(seconds: 2), () {
      if (!_isFetched) {
        fetchConnections();
      }
    });
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
                                      fontSize: 20,
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
                                        builder: (context) => BCCDashboardUI(
                                              shouldRefresh: true,
                                            )));
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
                        controller: _scrollController,
                        child: Column(
                          children: [
                            SafeArea(
                              child: Container(
                                color: Colors.grey[100],
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
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
                                  buildContentForSecureNetBangladeshLimited(
                                      sblCountActive, sblCountPending),
                                  buildContentForAdvancedDigitalSolutionLimited(
                                      adslCountActive, adslCountPending),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'All Pending Requests',
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          pendingConnectionRequests.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            pendingConnectionRequests.length) {
                                          return Center(
                                            child: _isLoading
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : SizedBox.shrink(),
                                          );
                                        }
                                        return pendingConnectionRequests[index];
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                    ),
                                  )
                                : _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : buildNoRequestsWidget(screenWidth,
                                        'There is no new connection request at this moment.'),
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
                                        builder: (context) => BCCDashboardUI(
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
            width: screenWidth * 0.43,
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
                Text('Active Connections',
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
            width: screenWidth * 0.43,
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
                Text('Pending Connections',
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
