import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (ISP_Connection)/apiserviceispconnectiondetails.dart';
import '../../../Data/Data Sources/API Service (ISP_Connection)/apiserviceispconnectionfulldetails.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/ispRequestdetailstile.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../Connection Form (ISP)/connectionform.dart';
import '../ISP Dashboard/ispDashboard.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import 'ispRequestList.dart';

/// The [ISPReviewedListUI] widget displays a list of active
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
class ISPReviewedListUI extends StatefulWidget {
  final bool shouldRefresh;

  const ISPReviewedListUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<ISPReviewedListUI> createState() => _ISPReviewedListUIState();
}

class _ISPReviewedListUIState extends State<ISPReviewedListUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  ScrollController _scrollController = ScrollController();
  late Pagination acceptedPagination;
  bool canFetchMoreAccepted = false;
  late String url = '';

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;
      final apiService = await ISPConnectionAPIService.create(token);

      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardData();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

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

      acceptedPagination = Pagination.fromJson(pagination['accepted']);
      if (acceptedPagination.nextPage != 'None' &&
          acceptedPagination.nextPage!.isNotEmpty) {
        url = acceptedPagination.nextPage as String;
        print(acceptedPagination.nextPage);
        canFetchMoreAccepted = acceptedPagination.canFetchNext;
      } else {
        url = '';
        canFetchMoreAccepted = false;
      }

      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

      if (acceptedRequestsData == null || acceptedRequestsData.isEmpty) {
        print('No pending records available');
        setState(() {
          acceptedRequestsData.isEmpty;
          print(_isLoading);
          _isFetched = true;
          _isLoading = !_isLoading;
          print(_isLoading);
        });
        return;
      }

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return ConnectionRequestInfoCard(
          ConnectionType: request['connection_type'],
          NTTNProvider: request['provider'],
          FRNumber: request['fr_number'].toString(),
          MobileNo: request['phone'],
          Location: request['location'],
          Time: request['created_at'],
          Status: request['status'],
          SerivceType: request['service_type'],
          Capacity: request['capacity'],
          WorkOrderNumber: request['work_order_number'],
          ContactDuration: request['contract_duration'],
          NetPayment: request['net_payment'],
        );
      }).toList();

      setState(() {
        acceptedConnectionRequests = acceptedWidgets;
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
        final apiService = await ISPConnectionFullAPIService.create(token);
        final Map<String, dynamic> dashboardData =
            await apiService.fetchFullData(url);

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

        acceptedPagination = Pagination.fromJson(pagination['accepted']);
        if (acceptedPagination.nextPage != 'None' &&
            acceptedPagination.nextPage!.isNotEmpty) {
          url = acceptedPagination.nextPage as String;
          print(acceptedPagination.nextPage);
          canFetchMoreAccepted = acceptedPagination.canFetchNext;
        } else {
          url = '';
          canFetchMoreAccepted = false;
        }

        final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
        for (var index = 0; index < acceptedRequestsData.length; index++) {
          print(
              'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
        }

        final List<Widget> acceptedWidgets =
            acceptedRequestsData.map((request) {
          return ConnectionRequestInfoCard(
            ConnectionType: request['connection_type'],
            NTTNProvider: request['provider'],
            FRNumber: request['fr_number'].toString(),
            MobileNo: request['phone'],
            Location: request['location'],
            Time: request['created_at'],
            Status: request['status'],
            SerivceType: request['service_type'],
            Capacity: request['capacity'],
            WorkOrderNumber: request['work_order_number'],
            ContactDuration: request['contract_duration'],
            NetPayment: request['net_payment'],
          );
        }).toList();

        setState(() {
          acceptedConnectionRequests.addAll(acceptedWidgets);
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
    print('initState called');
    Future.delayed(Duration(seconds: 1), () {
      if (!_isFetched) {
        fetchConnectionRequests();
      }
    });
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh && !_isFetched) {
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
                  'Reviewed List',
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
                                builder: (context) => ISPDashboardUI(
                                      shouldRefresh: true,
                                    ))); // Close the drawer
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectionFormUI()));
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
                                  builder: (context) => LoginUI()));
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
                                    child: const Text(
                                      'All Reviewed Requests',
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
                          acceptedConnectionRequests.isNotEmpty
                              ? NotificationListener<ScrollNotification>(
                                  onNotification: (scrollInfo) {
                                    if (!scrollInfo.metrics.outOfRange &&
                                        scrollInfo.metrics.pixels ==
                                            scrollInfo
                                                .metrics.maxScrollExtent &&
                                        !_isLoading &&
                                        canFetchMoreAccepted) {
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
                                      itemCount:
                                          acceptedConnectionRequests.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            acceptedConnectionRequests.length) {
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
                                        return acceptedConnectionRequests[
                                            index];
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
                                      'No connection requests reviewed yet.'),
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
                                builder: (context) => ISPDashboardUI(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectionFormUI()));
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
