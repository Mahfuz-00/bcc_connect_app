import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Fetch Connections)/apiServiceFetchconnectionlist.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/email_cubit.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../../Widgets/upgradeConnectionDetails.dart';
import '../Connection Form (ISP)/connectionform.dart';
import '../ISP Dashboard/ispDashboard.dart';
import '../ISP Request and Review List (Full)/ispRequestList.dart';
import '../ISP Request and Review List (Full)/ispReviewedList.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// `UpgradeUI` is a StatefulWidget that displays a list of connections, handles user profile, and manages navigation.
///
/// The widget shows a loading indicator while fetching data and provides options for navigation through the app's drawer.
///
/// **Constructor Arguments:**
/// - `shouldRefresh` (bool): Determines whether the page should refresh its content.
class UpgradeUI extends StatefulWidget {
  final bool shouldRefresh;

  const UpgradeUI({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<UpgradeUI> createState() => _ISPDashboardState();
}

class _ISPDashboardState extends State<UpgradeUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lists to hold the pending and accepted connection request widgets
  List<Widget> pendingConnectionRequests = [];
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  late String Id;

  /// Fetches the connection requests from the API and updates the state with the fetched data.
  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;
      final apiService = await FetchedConnectionListAPIService.create(token);

      final authState = context.read<AuthCubit>().state;
      int userId = 0;
      if (authState is AuthAuthenticated) {
        userId = authState.userProfile.Id; // Access the user ID from the Cubit
        print('User ID: $userId');
      } else {
        print('User is not authenticated');
      }
      // Fetch dashboard data from API
      final Map<String, dynamic> dashboardData =
          await apiService.fetchConnectionData(userId);
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }

      final List<dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        setState(() {
          _isFetched = true;
        });
        return;
      }

      for (var index = 0; index < records.length; index++) {
        print('Connection at index $index: ${records[index]}\n');
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Simulate fetching data for 1 seconds
      await Future.delayed(Duration(seconds: 1));

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = records.map((request) {
        return UpgradeConnectionInfoCard(
          UserID: request['user_id'].toString(),
          ConnectionType: request['request_type'],
          NTTNProvider: request['nttn_provider'],
          ApplicationID: request['id'].toString(),
          Division: request['division'],
          District: request['district'],
          Upazila: request['upazila'],
          Union: request['union'],
        );
      }).toList();

      setState(() {
        acceptedConnectionRequests = acceptedWidgets;
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
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        print('Page Loading Done!!');
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
                return InternetChecker(
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
                        'Connection List',
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
                                // Display user profile picture
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
                                      builder: (context) =>
                                          ISPDashboard(shouldRefresh: true)));
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
                                          ConnectionForm())); // Navigate to ConnectionForm
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
                                      builder: (context) =>
                                          ISPRequestList(shouldRefresh: true)));
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
                                      builder: (context) => ISPReviewedList(
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
                                      builder: (context) =>
                                          ProfileUI(shouldRefresh: true)));
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                context.read<AuthCubit>().logout();
                                final emailCubit = EmailCubit();
                                emailCubit.clearEmail();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              }
                            },
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    // Building the body of the UpgradeUI screen
                    // This section includes a SingleChildScrollView to handle scrolling of the content
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
                                // Title for the existing connection list
                                Center(
                                  child: Text(
                                    'Your Existing Connection List',
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
                                  child: const Text('Connection List',
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
                                // FutureBuilder to handle fetching and displaying connection requests
                                Container(
                                  child: FutureBuilder<void>(
                                      future: _isLoading
                                          ? null
                                          : fetchConnectionRequests(),
                                      builder: (context, snapshot) {
                                        if (!_isFetched) {
                                          return Container(
                                            height: 200,
                                            width: screenWidth,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return buildNoRequestsWidget(
                                              screenWidth,
                                              'Error: ${snapshot.error}');
                                        } else if (_isFetched) {
                                          if (acceptedConnectionRequests
                                              .isEmpty) {
                                            return buildNoRequestsWidget(
                                                screenWidth,
                                                'You don\'t have any Approved Connection, please create a new connection.');
                                          } else if (acceptedConnectionRequests
                                              .isNotEmpty) {
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
                                                    itemBuilder:
                                                        (context, index) {
                                                      return acceptedConnectionRequests[
                                                          index];
                                                    },
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            const SizedBox(
                                                                height: 10),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
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
                                          ISPDashboard(shouldRefresh: true)));
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
                                    Icons.refresh,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Refresh',
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
