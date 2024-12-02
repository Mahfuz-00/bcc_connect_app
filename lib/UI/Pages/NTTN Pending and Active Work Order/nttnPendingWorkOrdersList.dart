import 'package:bcc_connect_app/UI/Widgets/nttnWorkOrderPendingDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (NTTN_Connection)/apiserviceconnectionnttn.dart';
import '../../../Data/Data Sources/API Service (NTTN_Connection)/apiserviceconnectionnttnfull.dart';
import '../../../Data/Data Sources/API Service (Work Order)/apiserviceWorkOrder.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/nttnConnectionMiniTiles.dart';
import '../../Widgets/nttnPendingConncetionDetails.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../NTTN Dashboard/nttnDashboard.dart';
import '../Profile UI/profileUI.dart';
import '../Search UI/searchUI.dart';
import 'nttnActiveWorkOrdersList.dart';

/// The [NTTNPendingWorkOrderListUI] widget displays a list of pending
/// connection requests for the user. It allows users to view, tap on,
/// and navigate to details about each connection request.
///
/// The widget is designed to be a StatefulWidget to manage its state,
/// particularly for loading and displaying pending connection requests
/// fetched from an API.
///
/// ### Parameters:
/// - `shouldRefresh` (bool): A flag to indicate whether the widget
///   should refresh its content upon initialization. Defaults to `false`.
///
/// ### State Management:
/// This widget utilizes the BLoC pattern to manage authentication state
/// through the [AuthCubit]. It fetches data from the API and handles
/// pagination for loading more connection requests when the user scrolls
/// to the bottom of the list.
///
/// ### Features:
/// - **Loading State**: Displays a loading indicator while fetching data.
/// - **Pagination**: Automatically fetches more connection requests when
///   the user scrolls to the bottom of the list, if more data is available.
/// - **Error Handling**: Prints error messages to the console when
///   API calls fail, allowing for debugging during development.
/// - **User Interface**: Contains a drawer for navigation to different
///   parts of the app, including a profile view and logout option.
///
/// ### Navigation:
/// - Each connection request is displayed as a tile, which can be tapped
///   to navigate to a detailed view of the selected connection request.
/// - The app bar includes options for navigation and updates the UI
///   based on user interactions.
class NTTNPendingWorkOrderListUI extends StatefulWidget {
  final bool shouldRefresh;

  const NTTNPendingWorkOrderListUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<NTTNPendingWorkOrderListUI> createState() =>
      _NTTNPendingWorkOrderListUIState();
}

class _NTTNPendingWorkOrderListUIState
    extends State<NTTNPendingWorkOrderListUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool _pageLoading = true;
  List<Widget> pendingConnectionRequests = [];
  bool _isFetched = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  ScrollController _scrollController = ScrollController();
  late Pagination pendingPagination;
  bool canFetchMorePending = false;
  late String url = '';

  Future<void> fetchConnectionApplications() async {
    if (_isFetched) return;
    try {
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;
      final apiService = await WorkOrderAPIService.create(token);

      final Map<String, dynamic> dashboardData =
      await apiService.fetchWorkOrders();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      print(dashboardData);

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        /* setState(() {
          _isFetched = true;
        });*/
        return;
      }

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination['pending']);
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
      print('Pending: $pendingRequestsData');

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return ConnectionsTile(
          Name: request['client_name'],
          LinkCapacity: request['link_capacity'],
          OrganizationName: request['organization'],
          onPressed: () {
            print('Pending tapped');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PendingWorkOrderDetails(
                  Name: request['client_name'],
                  FRNumber: request['fr_number'].toString(),
                  LinkCapacity: request['link_capacity'],
                  SerivceType: request['service_type'],
                  WorkOrderNumber: request['work_order_number'],
                  ContactDuration: request['contract_duration'],
                  NetPayment: request['net_payment'],
                  PackageName: request['package_name'],
                  PaymentMethod: request['payment_mode'],
                  Discount: request['discount'],
                ),
              ),
            );
          },
        );
      }).toList();

      setState(() {
        pendingConnectionRequests = pendingWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
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
        final apiService = await NTTNFullConnectionAPIService.create(token);
        final Map<String, dynamic> dashboardData =
        await apiService.fetchFullConnections(url);

        if (dashboardData == null || dashboardData.isEmpty) {
          print(
              'No data available or error occurred while fetching dashboard data');
          return;
        }

        final Map<String, dynamic> records = dashboardData['records'];
        if (records == null || records.isEmpty) {
          print('No records available');
          setState(() {
            _isFetched = true;
          });
          return;
        }

        final Map<String, dynamic> pagination = records['pagination'] ?? {};
        print(pagination);

        pendingPagination = Pagination.fromJson(pagination['pending']);

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
            SnackBar(content: Text('All Work Orders loaded')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        print('Current count: $currentCount');

        final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
          return ConnectionsTile(
            Name: request['client_name'],
            LinkCapacity: request['link_capacity'],
            OrganizationName: request['organization'],
            onPressed: () {
              print('Pending tapped');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingWorkOrderDetails(
                    Name: request['client_name'],
                    FRNumber: request['fr_number'].toString(),
                    LinkCapacity: request['link_capacity'],
                    SerivceType: request['service_type'],
                    WorkOrderNumber: request['work_order_number'],
                    ContactDuration: request['contract_duration'],
                    NetPayment: request['net_payment'],
                    PackageName: request['package_name'],
                    PaymentMethod: request['payment_mode'],
                    Discount: request['discount'],
                  ),
                ),
              );
            },
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
    if (!_isFetched) {
      fetchConnectionApplications();
    }
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh) {
        print('Page Loading Done!!');
      }
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

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userProfile = state.userProfile;
          return InternetConnectionChecker(
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
                  'Pending Work Orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
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
                          SizedBox(height: 10),
                          Text(
                            userProfile.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                          SizedBox(height: 5),
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
                      title: Text('Active Work Orders',
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
                                    NTTNActiveWorkOrderListUI(
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
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        final authCubit = context.read<AuthCubit>();
                        final token =
                            (authCubit.state as AuthAuthenticated).token;
                        var logoutApiService =
                        await LogOutApiService.create(token);

                        logoutApiService.authToken;

                        if (await logoutApiService.signOut()) {
                          const snackBar = SnackBar(
                            content: Text('Logged out'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          context.read<AuthCubit>().logout();
                          final emailCubit = EmailCubit();
                          emailCubit.clearEmail();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginUI())); // Close the drawer
                        }
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
              body: _pageLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                      child: Container(
                        color: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Welcome, ${userProfile.name}',
                                textAlign: TextAlign.left,
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
                                'All Pending Work Orders',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                    pendingConnectionRequests.isNotEmpty
                        ? NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (!scrollInfo.metrics.outOfRange &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo
                                    .metrics.maxScrollExtent &&
                            !_isLoading &&
                            canFetchMorePending) {
                          fetchMoreConnectionRequests();
                        }
                        return true;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: ListView.separated(
                          addAutomaticKeepAlives: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          // Prevent internal scrolling
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
                      ),
                    )
                        : !_isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : buildNoRequestsWidget(screenWidth,
                        'You currently don\'t have any new requests pending.'),
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
                        Future.delayed(Duration(seconds: 0), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NTTNDashboardUI(shouldRefresh: true)));
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
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
