import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Search)/apiservicefilter.dart';
import '../../../Data/Data Sources/API Service (Search)/apiservicesearchregion.dart';
import '../../../Data/Models/connectionSearchModel.dart';
import '../../../Data/Models/searchmodel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/dropdownfieldConnectionForm.dart';
import '../../Widgets/searchResultTile.dart';
import '../../Widgets/templateerrorcontainer.dart';

/// `SearchUser` is a StatefulWidget that provides a user interface for searching ISP connections
/// based on various filters such as Division, District, Upazila, and Union.
///
/// The widget interacts with the `APIServiceSearchRegion` to fetch location data and `SearchFilterAPIService`
/// to filter ISP connections based on selected criteria. The user can select options from dropdowns to filter
/// the search results, and the results are displayed in a list below the search button.
///
/// Key functionalities:
/// - Fetch and display divisions, districts, upazilas, and unions from the API service.
/// - Allow the user to select a division, district, upazila, and union from dropdown menus.
/// - Fetch and display NTTN provider information based on the selected filters.
/// - Display the search results or an appropriate message if no results are found or an error occurs.
class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLinkCapacity;
  late String? _divisionID = '';
  late String? _districtID = '';
  late String? _upazilaID = '';
  late String? _unionID = '';
  late String _NTTNID;
  late String _NTTNPhoneNumber;
  Widget? _providerInfo;

  late APIServiceSearchRegion apiService;

  Future<APIServiceSearchRegion> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await APIServiceSearchRegion.create(token);
    return apiService;
  }

  List<DivisionSearch> divisions = [];
  List<DistrictSearch> districts = [];
  List<UpazilaSearch> upazilas = [];
  List<UnionSearch> unions = [];
  List<NTTNProviderResult> nttnProviders = [];
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUnion;
  String? selectedNTTNProvider;
  bool _isLoading = false;
  bool _isInternetAvailable = false;
  bool isLoadingDivision = false;
  bool isLoadingDistrict = false;
  bool isLoadingUpzila = false;
  bool isLoadingUnion = false;
  bool isLoadingNTTNProvider = false;

  //late Connections connection;

  List<Connections> filteredConnections = [];

  @override
  void initState() {
    super.initState();
    fetchDivisions();
  }

  /// Fetches the list of divisions from the API and updates the state.
  Future<void> fetchDivisions() async {
    setState(() {
      isLoadingDivision = true;
      _isLoading = true;
    });
    try {
      await initializeApiService();
      final List<DivisionSearch> fetchedDivisions =
          await apiService.fetchDivisions();
      setState(() {
        _isLoading = false;
        divisions = fetchedDivisions;
        for (DivisionSearch division in fetchedDivisions) {
          print('Division Name: ${division.name}');
          print('Division Name: ${division.id}');
        }
        isLoadingDivision = false;
      });
    } catch (e) {
      print('Error fetching divisions: $e');
    }
  }

  /// Fetches the list of districts for the selected division from the API and updates the state.
  Future<void> fetchDistricts(String divisionId) async {
    setState(() {
      isLoadingDistrict = true;
      _isLoading = true;
    });
    try {
      final List<DistrictSearch> fetchedDistricts =
          await apiService.fetchDistricts(divisionId);
      setState(() {
        _isLoading = false;
        districts = fetchedDistricts;
        for (DistrictSearch district in fetchedDistricts) {
          print('District Name: ${district.name}');
        }
        isLoadingDistrict = false;
      });
    } catch (e) {
      print('Error fetching districts: $e');
    }
  }

  /// Fetches the list of upazilas for the selected district from the API and updates the state.
  Future<void> fetchUpazilas(String districtId) async {
    setState(() {
      isLoadingUpzila = true;
      _isLoading = true;
    });
    try {
      final List<UpazilaSearch> fetchedUpazilas =
          await apiService.fetchUpazilas(districtId);
      setState(() {
        _isLoading = false;
        upazilas = fetchedUpazilas;
        for (UpazilaSearch upazila in fetchedUpazilas) {
          print('Upzila Name: ${upazila.name}');
        }
        isLoadingUpzila = false;
      });
    } catch (e) {
      print('Error fetching upazilas: $e');
    }
  }

  /// Fetches the list of unions for the selected upazila from the API and updates the state.
  Future<void> fetchUnions(String upazilaId) async {
    setState(() {
      isLoadingUnion = true;
      _isLoading = true;
    });
    try {
      final List<UnionSearch> fetchedUnions =
          await apiService.fetchUnions(upazilaId);
      setState(() {
        _isLoading = false;
        unions = fetchedUnions;
        for (UnionSearch union in fetchedUnions) {
          print('Union Name: ${union.name}');
        }
        isLoadingUnion = false;
      });
    } catch (e) {
      print('Error fetching unions: $e');
    }
  }

  /// Fetches the list of NTTN providers for the selected union from the API and updates the state.
  Future<void> fetchNTTNProviders(String unionId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<NTTNProviderResult> fetchedNTTNProviders =
          await apiService.fetchNTTNProviders(unionId);
      setState(() {
        _isLoading = false;
        nttnProviders = fetchedNTTNProviders;
        int counter = 0;
        for (NTTNProviderResult NTTN in fetchedNTTNProviders) {
          print('NTTN Provider Details$counter: ${NTTN.toString()}');
          counter++;
        }
        isLoadingNTTNProvider = false;
      });
    } catch (e) {
      print('Error fetching NTTN providers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InternetChecker(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Advance Search',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'default',
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[100],
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Search ISP Connection(s)',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default')),
                    SizedBox(height: 5),
                    Text(
                        'Select an Optimal filter to search ISP Connections(s)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'default',
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    // Division Dropdown
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.075,
                          padding: EdgeInsets.only(left: 10, top: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Division',
                                dropdownItems: divisions
                                    .map((division) => division.name)
                                    .toList(),
                                initialValue: selectedDivision,
                                onChanged: (newValue) {
                                  setState(() {
                                    //It Takes Name String
                                    selectedDistrict = null;
                                    selectedUpazila = null;
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    print(
                                        'Selected District: ${selectedDistrict}');
                                    selectedDivision = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    DivisionSearch selectedDivisionObject =
                                        divisions.firstWhere(
                                      (division) => division.name == newValue,
                                    );
                                    if (selectedDivisionObject != null) {
                                      _divisionID = selectedDivisionObject.id;
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchDistricts(selectedDivisionObject.id);
                                    }
                                  }
                                },
                              ),
                              if (isLoadingDivision)
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // District Dropdown
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.075,
                          padding: EdgeInsets.only(left: 10, top: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'District',
                                dropdownItems: districts
                                    .map((district) => district.name)
                                    .toList(),
                                initialValue: selectedDistrict,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUpazila = null;
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    selectedDistrict = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    DistrictSearch selectedDistrictObject =
                                        districts.firstWhere(
                                      (district) => district.name == newValue,
                                    );
                                    if (selectedDistrictObject != null) {
                                      _districtID = selectedDistrictObject.id;
                                      fetchUpazilas(selectedDistrictObject.id);
                                    }
                                  }
                                },
                              ),
                              if (isLoadingDistrict)
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Upazila Dropdown
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.075,
                          padding: EdgeInsets.only(left: 10, top: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Upazila',
                                dropdownItems: upazilas
                                    .map((upazila) => upazila.name)
                                    .toList(),
                                initialValue: selectedUpazila,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    selectedUpazila = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    UpazilaSearch selectedUpazilaObject =
                                        upazilas.firstWhere(
                                      (upazila) => upazila.name == newValue,
                                    );
                                    if (selectedUpazilaObject != null) {
                                      _upazilaID = selectedUpazilaObject.id;
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchUnions(selectedUpazilaObject.id);
                                    }
                                  }
                                },
                              ),
                              if (isLoadingUpzila)
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Union Dropdown
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.075,
                          padding: EdgeInsets.only(left: 10, top: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Union',
                                dropdownItems:
                                    unions.map((union) => union.name).toList(),
                                initialValue: selectedUnion,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedNTTNProvider = null;
                                    selectedUnion = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    UnionSearch selectedUnionObject =
                                        unions.firstWhere(
                                      (union) => union.name == newValue,
                                    );
                                    if (selectedUnionObject != null) {
                                      _unionID = selectedUnionObject.id;
                                    }
                                  }
                                },
                              ),
                              if (isLoadingUnion)
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    // Search Button
                    Center(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(25, 192, 122, 1),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.9,
                                MediaQuery.of(context).size.height * 0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: selectedDivision != null
                              ? () {
                                  setState(() {
                                    print('Tapped');
                                    filterNTTNConnections();
                                    _providerInfo = Column(
                                      children: [
                                        Text(
                                          'Provider Information',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'default',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          //height: screenHeight*0.25,
                                          child: FutureBuilder<void>(
                                              future: filterNTTNConnections(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Container(
                                                    height: 200,
                                                    width: screenWidth,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  if (searchresults
                                                      .isNotEmpty) {
                                                    return Container(
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: searchresults
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return searchresults[
                                                              index];
                                                        },
                                                        separatorBuilder:
                                                            (context, index) =>
                                                                const SizedBox(
                                                                    height: 10),
                                                      ),
                                                    );
                                                  } else {
                                                    return buildNoRequestsWidget(
                                                        screenWidth,
                                                        'No Connection Found!');
                                                  }
                                                }
                                                return SizedBox();
                                              }),
                                        ),
                                      ],
                                    );
                                  });
                                }
                              : null,
                          child: const Text('Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_providerInfo != null) _providerInfo!,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> searchresults = [];

  /// `filterNTTNConnections` filters NTTN connections based on selected criteria (Division, District, Upazila, and Union)
  /// and updates the state with the search results.
  ///
  /// This method:
  /// - Creates an instance of `SearchFilterAPIService` to interact with the API.
  /// - Constructs a request data map with available filter criteria.
  /// - Sends the request to the API service to filter NTTN connections.
  /// - Processes the response and extracts connection details.
  /// - Maps the connection data to a list of `SearchConnectionsInfoCard` widgets.
  /// - Updates the `searchresults` list with the generated widgets to display the search results.
  ///
  /// Errors during the API call are caught and logged for debugging purposes.
  Future<void> filterNTTNConnections() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    final apiService = await SearchFilterAPIService.create(token);
    print(_divisionID);
    print(_districtID);
    print(_upazilaID);
    print(_unionID);

    final Map<String, dynamic> requestData = {};

    if (_divisionID != null) {
      requestData['division_id'] = _divisionID;
    }

    if (_districtID != null) {
      requestData['district_id'] = _districtID;
    }

    if (_upazilaID != null) {
      requestData['upazila_id'] = _upazilaID;
    }

    if (_unionID != null) {
      requestData['union_id'] = _unionID;
    }

    print(requestData);

    try {
      print('Request:: $requestData');
      final Map<String, dynamic> filteredData =
          await apiService.filterNTTNConnection(requestData);
      print('Filtered NTTN connections: $filteredData');

      if (filteredData.containsKey('records')) {
        List<dynamic> connections = filteredData['records'];
        print('Connections:: $connections');
        final List<Widget> searchWidgets = connections.map((request) {
          return SearchConnectionsInfoCard(
            Name: request['name'],
            OrganizationName: request['organization'],
            MobileNo: request['mobile'],
            ConnectionType: request['connection_type'],
            Provider: request['provider'],
            Status: request['status'],
          );
        }).toList();
        setState(() {
          searchresults = searchWidgets;
        });
      }
    } catch (e) {
      print('Error filtering NTTN connections: $e');
    }
  }
}
