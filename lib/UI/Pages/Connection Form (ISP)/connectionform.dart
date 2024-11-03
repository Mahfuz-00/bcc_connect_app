import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Connection From)/apiserviceconnection.dart';
import '../../../Data/Data Sources/API Service (Regions)/apiserviceregions.dart';
import '../../../Data/Models/connectionmodel.dart';
import '../../../Data/Models/regionmodels.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/dropdownfieldConnectionForm.dart';
import '../ISP Dashboard/ispDashboard.dart';

/// [ConnectionFormUI] is a [StatefulWidget] that represents a form for users to fill out
/// connection requests in a user interface.
///
/// This class manages the state of various form elements such as divisions, districts,
/// upazilas, unions, NTTN providers, and other form fields related to the connection request.
///
/// The [GlobalKey<ScaffoldState>] [_scaffoldKey] is used to manage the scaffold of the form UI.
/// The [_connectionRequest] holds the connection request details that are filled in the form.
///
/// Key state variables include:
/// - [String?] [selectedLinkCapacity]: Holds the selected link capacity option.
/// - [ConnectionRequestModel] [_connectionRequest]: Stores the connection request data.
/// - [String] [_requestType]: Holds the type of request (e.g., new connection, upgrade).
/// - [String] [_divisionID], [_districtID], [_upazilaID], [_unionID]: Hold the IDs of selected division, district, upazila, and union.
/// - [int] [_NTTNID]: Stores the ID of the selected NTTN provider.
/// - [TextEditingController] [_remark]: Manages the input of remarks by the user.
/// - [bool] [_isButtonEnabled]: Tracks whether the submit button should be enabled based on user input.
///
/// Dropdown options and selected values for various form fields are stored in the following variables:
/// - [Set<String>] [linkCapacityOptions]: Available options for link capacity.
/// - [List<Division>] [divisions]: List of available divisions.
/// - [List<District>] [districts]: List of available districts.
/// - [List<Upazila>] [upazilas]: List of available upazilas.
/// - [List<Union>] [unions]: List of available unions.
/// - [List<NTTNProvider>] [nttnProviders]: List of available NTTN providers.
/// - [String?] [selectedDivision], [selectedDistrict], [selectedUpazila], [selectedUnion], [selectedNTTNProvider]: Store selected values for each dropdown.
///
/// Loading states are managed by:
/// - [bool] [isLoadingDivision], [isLoadingDistrict], [isLoadingUpzila], [isLoadingUnion], [isLoadingNTTNProvider]: Track whether the respective data is being loaded.
///
/// Other important variables include:
/// - [TextEditingController] [_linkcapcitycontroller]: Manages the input for link capacity when 'Others' is selected.
/// - [String] [userName], [organizationName], [photoUrl]: Store user information retrieved from the API.
/// - [bool] [_isButtonClicked]: Tracks if the submit button has been clicked.
/// - [String] [providerValues]: Stores the selected NTTN provider's value.
/// - [bool] [isSelected]: Tracks if a particular form field has been selected.
///
/// The [initializeApiService] method initializes the [RegionAPIService] with the user's authentication token.
/// Various [fetch] methods (e.g., [fetchDivisions], [fetchDistricts], [fetchUpazilas], [fetchUnions], [fetchNTTNProviders]) are used to retrieve data from the API.
///
/// The [initState] method initializes the form with default values and sets up listeners for user input.
/// The [dispose] method cleans up resources when the widget is removed from the widget tree.
class ConnectionFormUI extends StatefulWidget {
  const ConnectionFormUI({super.key});

  @override
  State<ConnectionFormUI> createState() => _ConnectionFormUIState();
}

class _ConnectionFormUIState extends State<ConnectionFormUI> {
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
  bool _isButtonEnabled = false;

  final Set<String> linkCapacityOptions = {'5 MB', '10 MB', '15 MB', 'Others'};

  late RegionAPIService apiService;

  Future<RegionAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await RegionAPIService.create(token);
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

  @override
  void initState() {
    super.initState();
    _connectionRequest = ConnectionRequestModel(
      divisionId: "",
      districtId: "",
      upazilaId: "",
      unionId: "",
      nttnProvider: 0,
      linkCapacity: "",
      remark: "",
    );
    _remark = TextEditingController();
    _remark.addListener(() {
      setState(() {
        _isButtonEnabled = _remark.text.isNotEmpty;
      });
    });
    fetchDivisions();
  }

  @override
  void dispose() {
    _remark.dispose();
    super.dispose();
  }

  Future<void> fetchDivisions() async {
    setState(() {
      isLoadingDivision = true;
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
        isLoadingDivision = false;
      });
    } catch (e) {
      print('Error fetching divisions: $e');
    }
  }

  Future<void> fetchDistricts(String divisionId) async {
    setState(() {
      isLoadingDistrict = true;
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
        isLoadingDistrict = false;
      });
    } catch (e) {
      print('Error fetching districts: $e');
    }
  }

  Future<void> fetchUpazilas(String districtId) async {
    setState(() {
      isLoadingUpzila = true;
    });
    try {
      final List<Upazila> fetchedUpazilas =
          await apiService.fetchUpazilas(districtId);
      setState(() {
        upazilas = fetchedUpazilas;
        for (Upazila upazila in fetchedUpazilas) {
          print('Upzila Name: ${upazila.name}');
        }
        isLoadingUpzila = false;
      });
    } catch (e) {
      print('Error fetching upazilas: $e');
    }
  }

  Future<void> fetchUnions(String upazilaId) async {
    setState(() {
      isLoadingUnion = true;
    });
    try {
      final List<Union> fetchedUnions = await apiService.fetchUnions(upazilaId);
      setState(() {
        unions = fetchedUnions;
        for (Union union in fetchedUnions) {
          print('Union Name: ${union.name}');
          print('Union ID: ${union.id}');
        }
        isLoadingUnion = false;
      });
    } catch (e) {
      print('Error fetching unions: $e');
    }
  }

  Future<void> fetchNTTNProviders(String unionId) async {
    setState(() {
      isLoadingNTTNProvider = true;
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
          isLoadingNTTNProvider = false;
        }
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
                    */
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
                                hintText: 'Select Division',
                                dropdownItems: divisions
                                    .map((division) => division.name)
                                    .toList(),
                                initialValue: selectedDivision,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedDistrict = null;
                                    selectedUpazila = null;
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    selectedDivision = newValue;
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Division selectedDivisionObject =
                                        divisions.firstWhere(
                                      (division) => division.name == newValue,
                                    );
                                    if (selectedDivisionObject != null) {
                                      _divisionID = selectedDivisionObject.id.toString();
                                      fetchDistricts(selectedDivisionObject.id.toString());
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
                                hintText: 'Select District',
                                dropdownItems: districts
                                    .map((district) => district.name)
                                    .toList(),
                                initialValue: selectedDistrict,
                                onChanged: (newValue) {
                                  setState(() {
                                    print(selectedDistrict);
                                    selectedUpazila = null;
                                    selectedUnion = null;
                                    selectedNTTNProvider = null;
                                    selectedDistrict = newValue;
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    District selectedDistrictObject =
                                        districts.firstWhere(
                                      (district) => district.name == newValue,
                                    );
                                    if (selectedDistrictObject != null) {
                                      _districtID = selectedDistrictObject.id.toString();
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchUpazilas(selectedDistrictObject.id.toString());
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
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Upazila selectedUpazilaObject =
                                        upazilas.firstWhere(
                                      (upazila) => upazila.name == newValue,
                                    );
                                    if (selectedUpazilaObject != null) {
                                      _upazilaID = selectedUpazilaObject.id.toString();
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchUnions(selectedUpazilaObject.id.toString());
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
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Union selectedUnionObject =
                                        unions.firstWhere(
                                      (union) => union.name == newValue,
                                    );
                                    if (selectedUnionObject != null) {
                                      _unionID = selectedUnionObject.id.toString();
                                      // Pass the ID of the selected division to fetchDistricts
                                      fetchNTTNProviders(
                                          selectedUnionObject.id.toString());
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
                                ],
                              ),
                            ),
                          ),
                        ]
                      ]
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
                            child: DropdownFormField(
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
                          onPressed: _isButtonEnabled
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
        divisionId: _divisionID,
        districtId: _districtID,
        upazilaId: _upazilaID,
        unionId: _unionID,
        nttnProvider: _NTTNID,
        linkCapacity: _linkCapacityID,
        remark: _remark.text,
      );
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;

      // Perform any additional actions before sending the request
      // Send the connection request using API service
      ConnectionAPIService.create(token)
          .postConnectionRequest(_connectionRequest)
          .then((response) {
        // Handle successful request
        print('Connection request sent successfully!!');
        if (response == 'Connection Request Already Exist') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ISPDashboardUI(
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ISPDashboardUI(
                      shouldRefresh: true,
                    )),
                  (route) => false
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
    final divisionIdIsValid = _divisionID.isNotEmpty;
    final districtIdIsValid = _districtID.isNotEmpty;
    final upazilaIdIsValid = _upazilaID.isNotEmpty;
    final unionIdIsValid = _unionID.isNotEmpty;
    final nttNIdIsValid = _NTTNID != 0;
    final linkCapacityIsValid = _linkCapacityID.isNotEmpty;
    final remarkIsValid = _remark.text.isNotEmpty;

    print(linkCapacityIsValid);

    // Check if all fields are valid
    final allFieldsAreValid =
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
