import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/API Service (Connection From)/apiserviceconnection.dart';
import '../../Data/API Service (Regions)/apiserviceregions.dart';
import '../../Data/Models/connectionSearchModel.dart';
import '../../Data/Models/connectionmodel.dart';
import '../../Data/Models/regionmodels.dart';
import '../ISP Dashboard/ispDashboard.dart';
import '../Widgets/Connection Checker/internetconnectioncheck.dart';
import '../Widgets/dropdownfieldConnectionForm.dart';
import '../Widgets/radiooption.dart';

class ConnectionForm extends StatefulWidget {
  const ConnectionForm({super.key});

  @override
  State<ConnectionForm> createState() => _ConnectionFormState();
}

class _ConnectionFormState extends State<ConnectionForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedLinkCapacity;
  late ConnectionRequestModel _connectionRequest;
  late String _requestType = '';
  late String _divisionID;
  late String _districtID;
  late String _upazilaID;
  late String _unionID;
  late int _NTTNID = 0;
  late String _NTTNPhoneNumber;
  late String _linkCapacityID = '';
  late TextEditingController _remark = TextEditingController();

  final Set<String> linkCapacityOptions = {'5 MB', '10 MB', '15 MB', 'Others'};

  late APIService apiService;

  Future<APIService> initializeApiService() async {
    apiService = await APIService.create();
    return apiService;
  }

  List<Division> divisions = [];
  List<District> districts = [];
  List<Upazila> upazilas = [];
  List<Union> unions = [];
  List<NTTNProvider> nttnProviders = [];
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUnion;
  String? selectedNTTNProvider;
  bool isLoadingDivision = false;
  bool isLoadingDistrict = false;
  bool isLoadingUpzila = false;
  bool isLoadingUnion = false;
  bool isLoadingNTTNProvider = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  bool _isButtonClicked = false;
  late String providerValues = '';
  bool isSelected = false;
  late TextEditingController _linkcapcitycontroller = TextEditingController();

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
    super.initState();
    loadUserProfile();
    _connectionRequest = ConnectionRequestModel(
/*      requestType: "",*/
      divisionId: "",
      districtId: "",
      upazilaId: "",
      unionId: "",
      nttnProvider: 0,
      linkCapacity: "",
      remark: "",
    );
    _remark = TextEditingController();
    fetchDivisions();
  }

  Future<void> fetchDivisions() async {
    setState(() {
      isLoadingDivision =
          true; // Set isLoading to false when fetching completes (whether successfully or with error)
    });
    try {
      await initializeApiService();
      final List<Division> fetchedDivisions = await apiService.fetchDivisions();
      setState(() {
        divisions = fetchedDivisions;
        for (Division division in fetchedDivisions) {
          print('Division Name: ${division.name}');
          print('Division ID: ${division.id}');
        }
        isLoadingDivision =
            false; // Set isLoading to false when fetching completes (whether successfully or with error)
      });
    } catch (e) {
      print('Error fetching divisions: $e');
      // Handle error
    }
  }

  Future<void> fetchDistricts(String divisionId) async {
    setState(() {
      isLoadingDistrict =
          true; // Set isLoading to false when fetching completes (whether successfully or with error)
    });
    try {
      final List<District> fetchedDistricts =
          await apiService.fetchDistricts(divisionId);
      setState(() {
        districts = fetchedDistricts;
        for (District district in fetchedDistricts) {
          print('District Name: ${district.name}');
        }
        print(districts);
        isLoadingDistrict =
            false; // Set isLoading to false when fetching completes (whether successfully or with error)
      });
    } catch (e) {
      print('Error fetching districts: $e');
      // Handle error
    }
  }

  Future<void> fetchUpazilas(String districtId) async {
    setState(() {
      isLoadingUpzila =
          true; // Set isLoading to false when fetching completes (whether successfully or with error)
    });
    try {
      final List<Upazila> fetchedUpazilas =
          await apiService.fetchUpazilas(districtId);
      setState(() {
        upazilas = fetchedUpazilas;
        for (Upazila upazila in fetchedUpazilas) {
          print('Upzila Name: ${upazila.name}');
        }
        isLoadingUpzila =
            false; // Set isLoading to false when fetching completes (whether successfully or with error)
      });
    } catch (e) {
      print('Error fetching upazilas: $e');
      // Handle error
    }
  }

  Future<void> fetchUnions(String upazilaId) async {
    setState(() {
      isLoadingUnion =
          true; // Set isLoading to false when fetching completes (whether successfully or with error)
    });
    try {
      final List<Union> fetchedUnions = await apiService.fetchUnions(upazilaId);
      setState(() {
        unions = fetchedUnions;
        for (Union union in fetchedUnions) {
          print('Union Name: ${union.name}');
          print('Union ID: ${union.id}');
        }
        isLoadingUnion =
            false; // Set isLoading to false when fetching completes (whether successfully or with error)
      });
    } catch (e) {
      print('Error fetching unions: $e');
      // Handle error
    }
  }

  Future<void> fetchNTTNProviders(String unionId) async {
    setState(() {
      isLoadingNTTNProvider =
          true; // Set isLoading to false when fetching completes (whether successfully or with error)
    });
    try {
      final List<NTTNProvider> fetchedNTTNProviders =
          await apiService.fetchNTTNProviders(unionId);
      print(fetchedNTTNProviders);
      setState(() {
        nttnProviders = fetchedNTTNProviders;
        if (fetchedNTTNProviders.isNotEmpty) {
          providerValues = fetchedNTTNProviders.first.provider;
          _NTTNID = fetchedNTTNProviders.first.id;
        } else {
          providerValues = 'zero';
        }

        for (NTTNProvider NTTN in fetchedNTTNProviders) {
          print('NTTN Providers Name: ${NTTN.provider}');
          print('NTTN ID: ${NTTN.id}');
          selectedNTTNProvider = providerValues;
          print(selectedNTTNProvider);
          /* print('NTTN Phone: ${NTTN.phonenumber}');*/
          isLoadingNTTNProvider =
              false; // Set isLoading to false when fetching completes (whether successfully or with error)
        }
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
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Connection Form',
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
                    Text('Connection Request',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default')),
                    SizedBox(height: 5),
                    Text('Please fill up the form',
                        style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 18,
                            fontFamily: 'default')),
                    SizedBox(height: 40),
                    /*     Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Request Type',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default')),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                      child: RadioListTileGroup(
                        options: ['New Connection', 'Upgrade', 'Others'],
                        selectedOption: _requestType,
                        onChanged: (String value) {
                          setState(() {
                            _requestType = value ?? '';
                            print('Selected option: $_requestType');
                          });
                          // You can perform any other actions here based on the selected option
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),*/
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
                          child: /*DropdownButtonFormField<String>(
                          value: selectedDivision,
                          items: districtOptions.keys.map((String division) {
                            return DropdownMenuItem<String>(
                              value: division,
                              child: Text(division,
                                style: TextStyle(
                                  color: Colors.black ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDivision = newValue;
                              selectedDistrict = null; // Reset district on division change
                            });
                          },
                          decoration: InputDecoration(labelText: 'Division',border: InputBorder.none,),
                        ),*/
                              Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Select Division',
                                dropdownItems: divisions
                                    .map((division) => division.name)
                                    .toList(),
                                initialValue: selectedDivision,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDistrict = null; // Reset
                                    selectedUpazila = null; // Reset
                                    selectedUnion = null; // Reset
                                    selectedNTTNProvider = null; // Reset
                                    selectedDivision = newValue;
                                    districts.clear();
                                    districts = [];
                                    //It Takes Name String
                                    /*_divisionID = newValue ?? '';
                                                                                            print(_divisionID);*/
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Division selectedDivisionObject =
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
                          child: /* DropdownButtonFormField<String>(
                          value: selectedDistrict,
                          items: selectedDivision != null
                              ? districtOptions[selectedDivision]!.map((String district) {
                            return DropdownMenuItem<String>(
                              value: district,
                              child: Text(district,
                                style: TextStyle(
                                  color: Colors.black ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),),
                            );
                          }).toList()
                              : [],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDistrict = newValue;
                              selectedUpazila = null; // Reset thana on district change
                            });
                          },
                          decoration: InputDecoration(labelText: 'District', border: InputBorder.none,),
                        ),*/
                              Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Select District',
                                dropdownItems: districts
                                    .map((district) => district.name)
                                    .toList(),
                                initialValue: selectedDistrict,
                                onChanged: (newValue) {
                                  setState(() {
                                    print(selectedDistrict);
                                    selectedUpazila = null; // Reset
                                    selectedUnion = null; // Reset
                                    selectedNTTNProvider = null; // Reset
                                    selectedDistrict = newValue;
                                    /*_districtID = newValue ?? '';
                                                                                            print(_districtID);*/
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    District selectedDistrictObject =
                                        districts.firstWhere(
                                      (district) => district.name == newValue,
                                      /*orElse: () => null,*/
                                    );
                                    if (selectedDistrictObject != null) {
                                      _districtID = selectedDistrictObject.id;
                                      // Pass the ID of the selected division to fetchDistricts
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
                          child: /*DropdownButtonFormField<String>(
                          value: selectedUpazila,
                          items: selectedDistrict != null
                              ? upazilaOptions[selectedDistrict]!.map((String thana) {
                            return DropdownMenuItem<String>(
                              value: thana,
                              child: Text(thana,
                                style: TextStyle(
                                  color: Colors.black ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),),
                            );
                          }).toList()
                              : [],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUpazila = newValue;
                              selectedUnion = null; // Reset union on thana change
                            });
                          },
                          decoration: InputDecoration(labelText: 'Upazila', border: InputBorder.none,),
                        ),*/
                              Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Select Upazila',
                                dropdownItems: upazilas
                                    .map((upazila) => upazila.name)
                                    .toList(),
                                initialValue: selectedUpazila,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUnion = null; // Reset
                                    selectedNTTNProvider = null; // Reset
                                    selectedUpazila = newValue;
                                    /* _upazilaID = newValue ?? '';
                                                                                            print(_upazilaID);*/
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Upazila selectedUpazilaObject =
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
                          child: /*DropdownButtonFormField<String>(
                          value: selectedUnion,
                          items: selectedUpazila != null
                              ? unionOptions[selectedUpazila]!.map((String union) {
                            return DropdownMenuItem<String>(
                              value: union,
                              child: Text(union,
                                style: TextStyle(
                                  color: Colors.black ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),),
                            );
                          }).toList()
                              : [],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedUnion = newValue;
                              selectedNTTNProvider = null;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Union', border: InputBorder.none,),
                        ),*/
                              Stack(
                            children: [
                              DropdownFormField(
                                hintText: 'Select Union',
                                dropdownItems:
                                    unions.map((union) => union.name).toList(),
                                initialValue: selectedUnion,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedNTTNProvider = null; // Reset
                                    selectedUnion = newValue;
                                    isSelected = true;
                                    print(isSelected);
                                    /*_unionID = newValue ?? '';
                                                                                            print(_unionID);*/
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Union selectedUnionObject =
                                        unions.firstWhere(
                                      (union) => union.name == newValue,
                                      /*orElse: () => null,*/
                                    );
                                    if (selectedUnionObject != null) {
                                      _unionID = selectedUnionObject.id;
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchNTTNProviders(
                                          selectedUnionObject.id);
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
                      height: 10,
                    ),
                    /*   if (isSelected == false) ...[
                      Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.075,
                          child: Stack(
                            children: [
                              TextFormField(
                                style: const TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                                decoration: InputDecoration(
                                  labelText: '    NTTN Provider',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'default',
                                  ),
                                  //alignLabelWithHint: true,
                                  //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: screenHeight * 0.15),
                                  border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                ),
                              ),
                              if (isLoadingNTTNProvider)
                                Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],*/
                    if (isSelected == true) ...[
                      if (providerValues.isNotEmpty) ...[
                        if (providerValues == 'zero') ...[
                          Builder(
                            builder: (context) {
                              Future.delayed(Duration.zero, () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'There are no NTTN Providers in this area'),
                                  ),
                                );
                              });
                              return SizedBox
                                  .shrink(); // Returning an empty SizedBox as a placeholder
                            },
                          ),
                        ] else if (providerValues != 'zero') ...[
                          Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.075,
                              /*padding: EdgeInsets.only(
                            left: 10, top: 5
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                          ),*/
                              child: Stack(
                                children: [
                                  TextFormField(
                                    initialValue: providerValues,
                                    readOnly: true,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    decoration: InputDecoration(
                                      labelText: '    NTTN Provider',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'default',
                                      ),
                                      alignLabelWithHint: true,
                                      //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: screenHeight * 0.15),
                                      border: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                  /*if (isLoadingNTTNProvider)
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color:
                                          const Color.fromRGBO(25, 192, 122, 1),
                                    ),
                                  ),*/
                                ],
                              ), /*DropdownButtonFormField<String>(
                          value: selectedNTTNProvider,
                          items: selectedUnion != null
                              ? nttnProviderOptions[selectedUnion]!.map((String provider) {
                            return DropdownMenuItem<String>(
                              value: provider,
                              child: Text(provider,
                                style: TextStyle(
                                  color: Colors.black ,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                              ),
                            );
                          }).toList()
                              : [],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedNTTNProvider = newValue;
                            });
                          },
                          decoration: InputDecoration(labelText: 'NTTN Provider', border: InputBorder.none,),
                        ),*/

                              /*    DropdownFormField(
                            hintText: 'Select NTTN Provider',
                            dropdownItems: nttnProviders
                                .map((nttnProvider) => nttnProvider.provider)
                                .toList(),
                            initialValue: selectedNTTNProvider,
                            onChanged: (newValue) {
                              setState(() {
                                selectedNTTNProvider = newValue;
                                print(selectedNTTNProvider);
                                */ /*  _NTTNID = newValue ?? '';
                              print(_NTTNID);*/ /*
                                selectedLinkCapacity = null; // Reset
                              });
                              if (newValue == null) {
                                print('I am null');
                              }
                              print('NTTN Provider I Need ${providerValues}');
                              if (newValue != null) {
                                print(newValue);
                                NTTNProvider selectedNTTNProviderObject =
                                    nttnProviders.firstWhere(
                                  (nttnProvider) => nttnProvider.provider == newValue,
                                );
                                print(
                                    'Selected NTTN Provider ID: ${selectedNTTNProviderObject.id}');
                                if (selectedNTTNProviderObject != null) {
                                  print(
                                      'Selected NTTN Provider ID: ${selectedNTTNProviderObject.id}');
                                  setState(() {
                                    _NTTNID = selectedNTTNProviderObject.id;
                                  });
                                 */ /* _NTTNPhoneNumber = selectedNTTNProviderObject
                                      .phonenumber; // Update _NTTNID*/ /*
                                }
                              }
                            },
                          )*/
                            ),
                          ),
                        ]
                      ]
                      /*      else ...[
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.075,
                            child: Stack(
                              children: [
                                TextFormField(
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    labelText: '    NTTN Provider',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    //alignLabelWithHint: true,
                                    //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: screenHeight * 0.15),
                                    border: const OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ),
                                ),
                                if (isLoadingNTTNProvider)
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color:
                                      const Color.fromRGBO(25, 192, 122, 1),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],*/
                    ],
                    SizedBox(
                      height: 10,
                    ),
                    if (selectedNTTNProvider != null)
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
                            child: /* DropdownButtonFormField<String>(
                          value: selectedLinkCapacity,
                          items: selectedNTTNProvider != null
                              ? linkCapacityOptions.map((String capacity) {
                            return DropdownMenuItem<String>(
                              value: capacity,
                              child: Text(
                                capacity,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                              ),
                            );
                          }).toList()
                              : [],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLinkCapacity = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Link Capacity',
                            border: InputBorder.none,
                          ),
                        ),*/
                                DropdownFormField(
                              hintText: 'Select Link Capacity',
                              dropdownItems: linkCapacityOptions.toList(),
                              initialValue: selectedLinkCapacity,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedLinkCapacity = newValue;
                                  _linkCapacityID = newValue ?? '';
                                  print(_linkCapacityID);
                                });
                              },
                            )),
                      ),
                    if (_linkCapacityID == 'Others') ...[
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenWidth * 0.2,
                        child: TextFormField(
                          controller: _linkcapcitycontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your required link capacity';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Enter your required Link Capacity',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 80),
                            border: const OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                          ),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      width: screenWidth * 0.9,
                      height: 120,
                      child: TextFormField(
                        controller: _remark,
                        enabled: selectedLinkCapacity != null,
                        validator: (input) {
                          if (input == null || input.isEmpty) {
                            return 'Please enter some remarks';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Remarks',
                          labelStyle: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 145),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
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
                          onPressed: _remark.text.isNotEmpty
                              ? () {
                                  _connectionRequestForm();
                                }
                              : null,
                          child: const Text('Submit',
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _connectionRequestForm() {
/*    print('Type: $_requestType');*/
    print('Division: $_divisionID');
    print('District: $_districtID');
    print('Upazila: $_upazilaID');
    print('Union: $_unionID');
    print('NTTN: $_NTTNID');
    print('Remark: ${_remark.text}');

    if (_linkCapacityID == 'Others') {
      _linkCapacityID = _linkcapcitycontroller.text;
    }

    print('Capacity: $_linkCapacityID');

    // Validate and save form data
    if (_validateAndSave()) {
      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('triggered Validation');
      // Initialize connection request model
      _connectionRequest = ConnectionRequestModel(
        /*  requestType: _requestType,*/
        divisionId: _divisionID,
        districtId: _districtID,
        upazilaId: _upazilaID,
        unionId: _unionID,
        nttnProvider: _NTTNID,
        linkCapacity: _linkCapacityID,
        remark: _remark.text,
      );

      // Perform any additional actions before sending the request
      // Send the connection request using API service
      APIServiceConnection()
          .postConnectionRequest(_connectionRequest)
          .then((response) {
        // Handle successful request
        print('Connection request sent successfully!!');
        if (response == 'Connection Request Already Exist') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ISPDashboard(
                      shouldRefresh: true,
                    )),
          );
          const snackBar = SnackBar(
            content: Text(
                'Request already Sumbitted, please wait for it to be reviewed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (response == 'Please at first request a connection request') {
          const snackBar = SnackBar(
            content: Text('Create New Connection First!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (response != null && response == "Connection Request Submitted") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ISPDashboard(
                      shouldRefresh: true,
                    )),
          );
          const snackBar = SnackBar(
            content: Text('Request Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        // Handle error
        print('Error sending connection request: $error');
      });
    }
  }

  bool _validateAndSave() {
/*    final requestTypeIsValid = _requestType.isNotEmpty;*/
    final divisionIdIsValid = _divisionID.isNotEmpty;
    final districtIdIsValid = _districtID.isNotEmpty;
    final upazilaIdIsValid = _upazilaID.isNotEmpty;
    final unionIdIsValid = _unionID.isNotEmpty;
    final nttNIdIsValid = _NTTNID != 0;
    final linkCapacityIsValid = _linkCapacityID.isNotEmpty;
    final remarkIsValid = _remark.text.isNotEmpty;

    print(linkCapacityIsValid);

    // Perform any additional validation logic if needed

    // Check if all fields are valid
    final allFieldsAreValid = /*requestTypeIsValid &&*/
        divisionIdIsValid &&
            districtIdIsValid &&
            upazilaIdIsValid &&
            unionIdIsValid &&
            nttNIdIsValid &&
            linkCapacityIsValid &&
            remarkIsValid;

    return allFieldsAreValid;
  }
}
