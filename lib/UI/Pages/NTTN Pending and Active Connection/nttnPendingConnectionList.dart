import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (ISP_Connection)/apiserviceispconnectionfulldetails.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (NTTN_Connection)/apiserviceconnectionnttn.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/nttnConnectionMiniTiles.dart';
import '../../Widgets/nttnPendingConncetionDetails.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../../Widgets/templateloadingcontainer.dart';
import '../Information/information.dart';
import '../Login UI/loginUI.dart';
import '../NTTN Dashboard/nttnDashboard.dart';
import '../Profile UI/profileUI.dart';
import '../Search UI/searchUI.dart';
import 'nttnActiveConnectionList.dart';

class NTTNPendingConnectionList extends StatefulWidget {
  final bool shouldRefresh;

  const NTTNPendingConnectionList({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<NTTNPendingConnectionList> createState() =>
      _NTTNPendingConnectionListState();
}

class _NTTNPendingConnectionListState extends State<NTTNPendingConnectionList> {
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

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
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

      setState(() {
        pendingConnectionRequests = pendingWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      // Handle error as needed
    }
  }

  Future<void> fetchMoreConnectionRequests() async {
    setState(() {
      _isLoading = true;
    });
    print(url);

    try {
      if (url != '' && url.isNotEmpty) {
        final apiService = await APIServiceISPConnectionFull.create();
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

  @override
  void initState() {
    // TODO: implement initState
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
      //_isFetched = true; // Set _isFetched to true after the first call
    }
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh) {
        loadUserProfile();
        // Refresh logic here, e.g., fetch data again
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

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userProfile = state.userProfile;
          return InternetChecker(
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
                  'Pending Connections',
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
                            width: 60, // Adjust width as needed
                            height: 60, // Adjust height as needed
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
                            /*userName,*/
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
                            /*organizationName,*/
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
                                builder: (context) => NTTNDashboard(
                                      shouldRefresh: true,
                                    ))); // Close the drawer
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
                                builder: (context) => NTTNActiveConnectionList(
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
                                builder: (context) => ProfileUI(
                                      shouldRefresh: true,
                                    ))); // Close the drawer
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
                        /*   // Clear user data from SharedPreferences
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('userName');
                              await prefs.remove('organizationName');
                              await prefs.remove('photoUrl');*/
                        // Create an instance of LogOutApiService
                        var logoutApiService = await LogOutApiService.create();

                        // Wait for authToken to be initialized
                        logoutApiService.authToken;

                        // Call the signOut method on the instance
                        if (await logoutApiService.signOut()) {
                          const snackBar = SnackBar(
                            content: Text('Logged out'),
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
              body: _pageLoading
                  ? Center(
                      // Show circular loading indicator while waiting
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
                                  horizontal: 10, vertical: 20),
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
                                      'All Pending Applications',
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
