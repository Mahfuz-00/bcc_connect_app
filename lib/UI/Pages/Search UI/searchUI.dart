import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Search)/apiservicefilter.dart';
import '../../../Data/Data Sources/API Service (Search)/apiservicesearchregion.dart';
import '../../../Data/Models/connectionSearchModel.dart';
import '../../../Data/Models/searchmodel.dart';
import '../../Widgets/dropdownfieldConnectionForm.dart';
import '../../Widgets/searchResultTile.dart';
import '../../Widgets/templateerrorcontainer.dart';


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

  late APIService apiService;

  Future<APIService> initializeApiService() async {
    apiService = await APIService.create();
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

  // Store the response data in a list
  List<Connections> filteredConnections = [];

  @override
  void initState() {
    super.initState();
    fetchDivisions();
  }

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
      // Handle error
    }
  }

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
      // Handle error
    }
  }

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
      // Handle error
    }
  }

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
      // Handle error
    }
  }

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
      // Handle error
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
                                    selectedDistrict = null; // Reset
                                    districts.clear();
                                    print(selectedDistrict);
                                    print(districts);
                                    selectedUpazila = null; // Reset
                                    selectedUnion = null; // Reset
                                    selectedNTTNProvider = null; // Reset
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
                                      /*orElse: () => null,*/
                                    );
                                    if (selectedDivisionObject != null) {
                                      //It Takes ID Int
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
                                    print(districts);
                                    print(selectedDistrict);
                                    selectedUpazila = null; // Reset
                                    selectedUnion = null; // Reset
                                    selectedNTTNProvider = null; // Reset
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
                                      /*orElse: () => null,*/
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
                                    selectedUnion = null; // Reset
                                    selectedUpazila = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                    /* _upazilaID = newValue ?? '';
                              print(_upazilaID);*/
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    UpazilaSearch selectedUpazilaObject =
                                        upazilas.firstWhere(
                                      (upazila) => upazila.name == newValue,
                                      /*orElse: () => null,*/
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
                                    selectedNTTNProvider = null; // Reset
                                    selectedUnion = newValue;
                                    if (_isLoading) {
                                      CircularProgressIndicator();
                                    }
                                    /*_unionID = newValue ?? '';
                              print(_unionID);*/
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    UnionSearch selectedUnionObject =
                                        unions.firstWhere(
                                      (union) => union.name == newValue,
                                      /*orElse: () => null,*/
                                    );
                                    if (selectedUnionObject != null) {
                                      _unionID = selectedUnionObject.id;
                                      // Pass the ID of the selected division to fetchDistricts
                                      /*fetchNTTNProviders(selectedUnionObject.id);*/
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
                                                  // Return a loading indicator while waiting for data
                                                  return Container(
                                                    height: 200,
                                                    // Adjust height as needed
                                                    width: screenWidth,
                                                    // Adjust width as needed
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
                                                  // Handle errors
                                                  return buildNoRequestsWidget(
                                                      screenWidth,
                                                      'Error: ${snapshot.error}');
                                                } else if (snapshot
                                                        .connectionState ==
                                                    ConnectionState.done) {
                                                  if (searchresults
                                                      .isNotEmpty) {
                                                    // If data is loaded successfully, display the ListView
                                                    return Container(
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount: /*pendingConnectionRequests.length > 10
                                        ? 10
                                        :*/
                                                            searchresults
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          // Display each connection request using ConnectionRequestInfoCard
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
                                                    // Handle the case when there are no pending connection requests
                                                    return buildNoRequestsWidget(
                                                        screenWidth,
                                                        'No Connection Found!');
                                                  }
                                                }
                                                // Return a default widget if none of the conditions above are met
                                                return SizedBox(); // You can return an empty SizedBox or any other default widget
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

  Future<void> filterNTTNConnections() async {
    // Create an instance of the NTNNConnectionAPIService class
    final apiService = await SearchFilterAPIService.create();
    print(_divisionID);
    print(_districtID);
    print(_upazilaID);
    print(_unionID);

// Define the request data
    final Map<String, dynamic> requestData = {};

// Add division_id if available
    if (_divisionID != null) {
      requestData['division_id'] = _divisionID;
    }

// Add district_id if available
    if (_districtID != null) {
      requestData['district_id'] = _districtID;
    }

// Add upazila_id if available
    if (_upazilaID != null) {
      requestData['upazila_id'] = _upazilaID;
    }

// Add union_id if available
    if (_unionID != null) {
      requestData['union_id'] = _unionID;
    }

    print(requestData);

    try {
      // Call the API service method to filter NTTN connections
      print('Request:: $requestData');
      final Map<String, dynamic> filteredData =
          await apiService.filterNTTNConnection(requestData);
      // Process the filtered data as needed
      print('Filtered NTTN connections: $filteredData');

      // Check if the 'records' field exists in the response data
      if (filteredData.containsKey('records')) {
        // Extract the list of connections from the 'records' field
        List<dynamic> connections = filteredData['records'];
        print('Connections:: $connections');
        // Map pending requests to widgets
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
          //filteredConnections.add(connection);
        });

        //print('Fetched Connection:: $filteredConnections');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error filtering NTTN connections: $e');
    }
  }
}
