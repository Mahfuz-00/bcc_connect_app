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

/// The [SearchUI] class provides a user interface for advanced searching
/// of ISP connections based on geographic criteria. It allows users
/// to select various filters such as divisions, districts, upazilas,
/// and unions to refine their search.
///
/// It includes methods for fetching data from the API for each filter
/// and manages the loading state and internet connection checks.
///
/// Variables:
/// - [selectedLinkCapacity]: Holds the capacity link selected by the user.
/// - [_divisionID]: The ID of the selected division.
/// - [_districtID]: The ID of the selected district.
/// - [_upazilaID]: The ID of the selected upazila.
/// - [_unionID]: The ID of the selected union.
/// - [_NTTNID]: The NTTN ID associated with the connection.
/// - [_NTTNPhoneNumber]: The phone number of the selected NTTN provider.
/// - [_providerInfo]: Widget displaying provider information.
///
/// - [apiService]: Instance of [SearchRegionAPIService] for API interactions.
///
/// - [divisions]: List holding division search results.
/// - [districts]: List holding district search results.
/// - [upazilas]: List holding upazila search results.
/// - [unions]: List holding union search results.
/// - [nttnProviders]: List holding NTTN provider search results.
/// - [selectedDivision]: The currently selected division.
/// - [selectedDistrict]: The currently selected district.
/// - [selectedUpazila]: The currently selected upazila.
/// - [selectedUnion]: The currently selected union.
/// - [selectedNTTNProvider]: The currently selected NTTN provider.
/// - [_isLoading]: Indicates whether the overall loading state is active.
/// - [_isInternetAvailable]: Indicates the internet connection status.
/// - [isLoadingDivision]: Indicates whether divisions are being loaded.
/// - [isLoadingDistrict]: Indicates whether districts are being loaded.
/// - [isLoadingUpzila]: Indicates whether upazilas are being loaded.
/// - [isLoadingUnion]: Indicates whether unions are being loaded.
/// - [isLoadingNTTNProvider]: Indicates whether NTTN providers are being loaded.
///
/// - [filteredConnections]: List holding filtered connection results.
class SearchUI extends StatefulWidget {
  const SearchUI({super.key});

  @override
  State<SearchUI> createState() => _SearchUIState();
}

class _SearchUIState extends State<SearchUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLinkCapacity;
  late String? _divisionID = '';
  late String? _districtID = '';
  late String? _upazilaID = '';
  late String? _unionID = '';
  late String _NTTNID;
  late String _NTTNPhoneNumber;
  Widget? _providerInfo;

  late SearchRegionAPIService apiService;

  Future<SearchRegionAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await SearchRegionAPIService.create(token);
    return apiService;
  }

  List<DivisionSearch>? divisions = [];
  List<DistrictSearch>? districts = [];
  List<UpazilaSearch>? upazilas = [];
  List<UnionSearch>? unions = [];
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
      selectedDistrict = null;
      selectedUpazila = null;
      selectedUnion = null;
      selectedNTTNProvider = null;
      districts = null;
      upazilas = null;
      unions = null;
      nttnProviders = [];
      _divisionID = null;
      _districtID = null;
      _upazilaID = null;
      _unionID = null;
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
        selectedDistrict = null;
        selectedUpazila = null;
        selectedUnion = null;
        selectedNTTNProvider = null;
        districts = null;
        upazilas = null;
        unions = null;
        nttnProviders = [];
        _divisionID = null;
        _districtID = null;
        _upazilaID = null;
        _unionID = null;
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
      selectedUpazila = null;
      selectedUnion = null;
      selectedNTTNProvider = null;
      upazilas = null;
      unions = null;
      nttnProviders = [];
      _districtID = null;
      _upazilaID = null;
      _unionID = null;
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
        selectedUpazila = null;
        selectedUnion = null;
        selectedNTTNProvider = null;
        upazilas = null;
        unions = null;
        nttnProviders = [];
        isLoadingDistrict = false;
        _districtID = null;
        _upazilaID = null;
        _unionID = null;
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
      selectedUnion = null;
      selectedNTTNProvider = null;
      unions = null;
      nttnProviders = [];
      _upazilaID = null;
      _unionID = null;
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
        selectedUnion = null;
        selectedNTTNProvider = null;
        unions = null;
        nttnProviders = [];
        isLoadingUpzila = false;
        _upazilaID = null;
        _unionID = null;
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
      selectedNTTNProvider = null;
      nttnProviders = [];
      _unionID = null;
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
        selectedNTTNProvider = null;
        nttnProviders = [];
        isLoadingUnion = false;
        _unionID = null;
      });
    } catch (e) {
      print('Error fetching unions: $e');
    }
  }

  /// Fetches the list of NTTN providers for the selected union from the API and updates the state.
  Future<void> fetchNTTNProviders(String unionId) async {
    setState(() {
      _isLoading = true;
      selectedNTTNProvider = null;
      nttnProviders = [];
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

    return InternetConnectionChecker(
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
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
                                dropdownItems: divisions != null
                                    ? divisions!
                                        .map((division) => division.name)
                                        .toList()
                                    : null,
                                initialValue: selectedDivision,
                                onChanged: (newValue) {
                                  setState(() {
                                    //It Takes Name String
                                    selectedDistrict = null;
                                    selectedUpazila = null;
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    districts = null;
                                    upazilas = null;
                                    unions = null;
                                    nttnProviders = [];
                                    _districtID = null;
                                    _upazilaID = null;
                                    _unionID = null;
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
                                        divisions!.firstWhere(
                                      (division) => division.name == newValue,
                                    );
                                    if (selectedDivisionObject != null) {
                                      _divisionID =
                                          selectedDivisionObject.id.toString();
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchDistricts(
                                          selectedDivisionObject.id.toString());
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
                                dropdownItems: districts != null
                                    ? districts!
                                        .map((district) => district.name)
                                        .toList()
                                    : null,
                                initialValue: selectedDistrict,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUpazila = null;
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    upazilas = null;
                                    unions = null;
                                    nttnProviders = [];
                                    _upazilaID = null;
                                    _unionID = null;
                                    selectedDistrict = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    DistrictSearch selectedDistrictObject =
                                        districts!.firstWhere(
                                      (district) => district.name == newValue,
                                    );
                                    if (selectedDistrictObject != null) {
                                      _districtID =
                                          selectedDistrictObject.id.toString();
                                      fetchUpazilas(
                                          selectedDistrictObject.id.toString());
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
                                dropdownItems: upazilas != null
                                    ? upazilas!
                                        .map((upazila) => upazila.name)
                                        .toList()
                                    : null,
                                initialValue: selectedUpazila,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    unions = null;
                                    nttnProviders = [];
                                    _unionID = null;
                                    selectedUpazila = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    UpazilaSearch selectedUpazilaObject =
                                        upazilas!.firstWhere(
                                      (upazila) => upazila.name == newValue,
                                    );
                                    if (selectedUpazilaObject != null) {
                                      _upazilaID =
                                          selectedUpazilaObject.id.toString();
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchUnions(
                                          selectedUpazilaObject.id.toString());
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
                                dropdownItems: unions != null
                                    ? unions!
                                        .map((union) => union.name)
                                        .toList()
                                    : null,
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
                                        unions!.firstWhere(
                                      (union) => union.name == newValue,
                                    );
                                    if (selectedUnionObject != null) {
                                      _unionID =
                                          selectedUnionObject.id.toString();
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
                                          'Provider and ISP Information',
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
                                                        'No Provider Found!');
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
          print('Provider type: ${request['provider']?.runtimeType}');
          print('Contract Name type: ${request['contract_name']?.runtimeType}');
          print('Contract Phone type: ${request['contract_phone']?.runtimeType}');
          print('Contract Email type: ${request['contract_email']?.runtimeType}');
          print('Connections type: ${request['connections']?.runtimeType}');
          return SearchConnectionsInfoCard(
            Provider: request['provider'].toString(),
            ContactName: request['contract_name'].toString(),
            ContactMobileNo: request['contract_phone'].toString()!,
            ContactEmail: request['contract_email'].toString(),
            Connections: (request['connections'] is List)
                ? (request['connections'] as List).map((connection) {
              if (connection is Map<String, dynamic>) {
                // Return the map directly as is, without forcing it to Map<String, String>
                return connection;
              } else {
                return <String, dynamic>{}; // Return empty map if it's not a valid Map<String, dynamic>
              }
            }).toList()
                : [], // Default to empty list if it's not a valid List

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
