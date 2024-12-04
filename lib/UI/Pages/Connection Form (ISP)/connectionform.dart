import 'package:bcc_connect_app/UI/Bloc/form_data_cubit.dart';
import 'package:bcc_connect_app/UI/Pages/Work%20Order/workOrder.dart';
import 'package:bcc_connect_app/UI/Widgets/labelText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Connection From)/apiserviceconnection.dart';
import '../../../Data/Data Sources/API Service (Regions)/apiserviceregions.dart';
import '../../../Data/Models/connectionmodel.dart';
import '../../../Data/Models/regionmodels.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Bloc/form_data_cubit.dart';
import '../../Widgets/TamplateTextField.dart';
import '../../Widgets/dropdownfieldConnectionForm.dart';
import '../../Widgets/dropdownservice.dart';
import '../../Widgets/labelTextTemplate.dart';
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
/// - [bool] [isLoading], [isLoadingDistrict], [isLoadingUpzila], [isLoadingUnion], [isLoadingNTTNProvider]: Track whether the respective data is being loaded.
///
/// Other important variables include:
/// - [TextEditingController] [_linkcapcitycontroller]: Manages the input for link capacity when 'Others' is selected.
/// - [String] [userName], [organizationName], [photoUrl]: Store user information retrieved from the API.
/// - [bool] [_isButtonClicked]: Tracks if the submit button has been clicked.
/// - [String] [providerValues]: Stores the selected NTTN provider's value.
/// - [bool] [isSelected]: Tracks if a particular form field has been selected.
///
/// The [initializeApiService] method initializes the [RegionAPIService] with the user's authentication token.
/// Various [fetch] methods (e.g., [fetchPackages], [fetchDistricts], [fetchUpazilas], [fetchUnions], [fetchNTTNProviders]) are used to retrieve data from the API.
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
  String? selectedRackSpace;
  String? selectedUnit;
  String fullLinkCapacity = "";
  late ConnectionRequestModel _connectionRequest;
  late TextEditingController _fullNameController = TextEditingController();
  late TextEditingController _addressController = TextEditingController();
  late TextEditingController _latitudeLongtitudeController =
      TextEditingController();
  late String _requestType = '';
  late String _divisionID = '';
  late String _districtID = '';
  late String _upazilaID = '';
  late String _unionID = '';
  late int _NTTNID = 0;
  String _selectedService = '';
  late String _NTTNPhoneNumber;
  late String _linkCapacityID = '';
  late String _selectedServiceType = '';
  late String _errormsg;
  late TextEditingController _remark = TextEditingController();
  bool _isButtonEnabled = false;

  final Set<String> linkCapacityOptions = {'5 MB', '10 MB', '15 MB', 'Others'};

  late RegionAPIService apiService;

  // Define possible dropdown items for Service type
  List<String> dropdownItems = ["Data", "Core", "Co-Location"];

// Additional dropdown options for Rack Space
  List<String> rackSpaceOptions = ["1", "2", "3", "4", "5", "6"];

  Future<RegionAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await RegionAPIService.create(token);
    return apiService;
  }

  List<Division>? divisions = [];
  List<District>? districts = [];
  List<Upazila>? upazilas = [];
  List<Union>? unions = [];
  List<NTTNProvider> nttnProviders = [];
  String? selectedDivision;
  String? selectedDistrict;
  String? selectedUpazila;
  String? selectedUnion;
  String? selectedNTTNProvider;
  String? selectedServiceType;
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
      selectedDistrict = null;
      selectedUpazila = null;
      selectedUnion = null;
      selectedNTTNProvider = null;
      districts = null;
      upazilas = null;
      unions = null;
      nttnProviders = [];
      _divisionID = '';
      _districtID = '';
      _upazilaID = '';
      _unionID = '';
      _NTTNID = 0;
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
        selectedDistrict = null;
        selectedUpazila = null;
        selectedUnion = null;
        selectedNTTNProvider = null;
        districts = null;
        upazilas = null;
        unions = null;
        nttnProviders = [];
        _divisionID = '';
        _districtID = '';
        _upazilaID = '';
        _unionID = '';
        _NTTNID = 0;
        isLoadingDivision = false;
      });
    } catch (e) {
      print('Error fetching divisions: $e');
    }
  }

  Future<void> fetchDistricts(String divisionId) async {
    setState(() {
      isLoadingDistrict = true;
      selectedUpazila = null;
      selectedUnion = null;
      selectedNTTNProvider = null;
      upazilas = null;
      unions = null;
      nttnProviders = [];
      _districtID = '';
      _upazilaID = '';
      _unionID = '';
      _NTTNID = 0;
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
        selectedUpazila = null;
        selectedUnion = null;
        selectedNTTNProvider = null;
        upazilas = null;
        unions = null;
        nttnProviders = [];
        _districtID = '';
        _upazilaID = '';
        _unionID = '';
        _NTTNID = 0;
        isLoadingDistrict = false;
      });
    } catch (e) {
      print('Error fetching districts: $e');
    }
  }

  Future<void> fetchUpazilas(String districtId) async {
    setState(() {
      isLoadingUpzila = true;
      selectedUnion = null;
      selectedNTTNProvider = null;
      unions = null;
      nttnProviders = [];
      _upazilaID = '';
      _unionID = '';
      _NTTNID = 0;
    });
    try {
      final List<Upazila> fetchedUpazilas =
          await apiService.fetchUpazilas(districtId);
      setState(() {
        upazilas = fetchedUpazilas;
        for (Upazila upazila in fetchedUpazilas) {
          print('Upzila Name: ${upazila.name}');
        }
        selectedUnion = null;
        selectedNTTNProvider = null;
        unions = null;
        nttnProviders = [];
        _upazilaID = '';
        _unionID = '';
        _NTTNID = 0;
        isLoadingUpzila = false;
      });
    } catch (e) {
      print('Error fetching upazilas: $e');
    }
  }

  Future<void> fetchUnions(String upazilaId) async {
    setState(() {
      isLoadingUnion = true;
      selectedNTTNProvider = null;
      nttnProviders = [];
      _unionID = '';
      _NTTNID = 0;
    });
    try {
      final List<Union> fetchedUnions = await apiService.fetchUnions(upazilaId);
      setState(() {
        unions = fetchedUnions;
        for (Union union in fetchedUnions) {
          print('Union Name: ${union.name}');
          print('Union ID: ${union.id}');
        }
        selectedNTTNProvider = null;
        nttnProviders = [];
        _unionID = '';
        _NTTNID = 0;
        isLoadingUnion = false;
      });
    } catch (e) {
      print('Error fetching unions: $e');
    }
  }

  Future<void> fetchNTTNProviders(String unionId) async {
    setState(() {
      isLoadingNTTNProvider = true;
      selectedNTTNProvider = null;
      nttnProviders = [];
      _NTTNID = 0;
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
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('FR/Link Request Form',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default')),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text('Please fill up the form',
                        style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 18,
                            fontFamily: 'default')),
                  ),
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
                  LabeledTextWithAsterisk(
                    text: "Service Type",
                  ),
                  SizedBox(height: 5,),
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
                          hintText: 'Select Service Type',
                          dropdownItems: dropdownItems.toList(),
                          initialValue: selectedServiceType,
                          onChanged: (newValue) {
                            setState(() {
                              selectedServiceType = newValue;
                              _selectedServiceType = newValue ?? '';
                              print(_selectedServiceType);
                            });
                          },
                        )),
                  ),
                  if (selectedServiceType != null) ...[
                    SizedBox(height: 10),
                    LabeledTextWithAsterisk(
                      text: selectedServiceType == "Data"
                          ? "Bandwidth"
                          : selectedServiceType == "Core"
                          ? "Core"
                          : "Rack Space",
                    ),
                    SizedBox(height: 5),
                    if (selectedServiceType == "Co-Location") ...[
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
                            hintText: 'Select Rack Space',
                            dropdownItems: rackSpaceOptions,
                            initialValue: selectedRackSpace,
                            onChanged: (newValue) {
                              setState(() {
                                selectedRackSpace = newValue;
                                _linkcapcitycontroller.text = newValue!;
                                fullLinkCapacity = '$newValue U';
                              });
                            },
                          ),
                        ),
                      ),
                    ] else if (selectedServiceType == "Data") ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.075,
                              child: TextFormField(
                                controller: _linkcapcitycontroller,
                                onChanged: (value) {
                                  setState(() {
                                    fullLinkCapacity = "${value.trim()} $selectedUnit";
                                  });
                                },
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Please enter your required Bandwidth';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Enter Bandwidth',
                                  labelStyle: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    fontFamily: 'default',
                                  ),
                                  alignLabelWithHint: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: screenWidth * 0.9,
                                height: screenHeight * 0.075,
                                padding: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: selectedUnit,
                                  items: ["MB", "GB"].map((unit) {
                                    return DropdownMenuItem(
                                      value: unit,
                                      child: Text(
                                        unit,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (newUnit) {
                                    setState(() {
                                      selectedUnit = newUnit!;
                                      fullLinkCapacity = "${_linkcapcitycontroller.text} $selectedUnit";
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none, // No border for the dropdown field.
                                    hintText: 'Unit', // Placeholder text when no item is selected.
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12), // Padding for the dropdown field.
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _linkcapcitycontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your required Core';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Enter your required Core',
                            labelStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'default',
                            ),
                            suffixText: "Core",
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              fullLinkCapacity = "$value Core";
                            });
                          },
                        ),
                      ),
                    ]
                  ],
                  SizedBox(height: 10),
                  LabeledTextWithoutAsterisk(
                    text: "Latitude and Longitude of The Location",
                  ),
                  SizedBox(height: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 100,
                    child: TextFormField(
                      controller: _latitudeLongtitudeController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true), // Ensure proper input
                      decoration: InputDecoration(
                        labelText: 'Latitude and Longitude of The Location',
                        hintText: 'e.g., 12.3456,65.4321',
                        helperText: 'Enter in format: latitude, longitude',
                        filled: true,
                        fillColor: Colors.white,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter latitude and longitude'; // Form-level error message
                        }

                        // Regular expression to validate latitude, longitude format
                        final latLongRegExp = RegExp(
                            r'^-?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*-?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');

                        if (!input.contains(',')) {
                          return 'Please use a comma to separate latitude and longitude'; // Error if comma is missing
                        }

                        if (!latLongRegExp.hasMatch(input)) {
                          return 'Invalid format. Use "latitude, longitude"'; // Error if format doesn't match
                        }

                        return null; // If all validations pass, return null
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text('Select Location:',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 18,
                            fontFamily: 'default')),
                  ),
                  SizedBox(height: 10),
                  LabeledTextWithAsterisk(text: 'Division'),
                  SizedBox(height: 5),
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
                              dropdownItems: divisions != null
                                  ? divisions!
                                      .map((division) => division.name)
                                      .toList()
                                  : null,
                              initialValue: selectedDivision,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDistrict = null;
                                  selectedUpazila = null;
                                  selectedUnion = null;
                                  selectedNTTNProvider = null;
                                  districts = null;
                                  upazilas = null;
                                  unions = null;
                                  nttnProviders = [];
                                  _districtID = '';
                                  _upazilaID = '';
                                  _unionID = '';
                                  _NTTNID = 0;
                                  selectedDivision = newValue;
                                });
                                if (newValue != null) {
                                  // Find the selected division object
                                  Division selectedDivisionObject =
                                      divisions!.firstWhere(
                                    (division) => division.name == newValue,
                                  );
                                  if (selectedDivisionObject != null) {
                                    _divisionID =
                                        selectedDivisionObject.id.toString();
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
                                  color: const Color.fromRGBO(25, 192, 122, 1),
                                ),
                              ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabeledTextWithAsterisk(text: 'District'),
                  SizedBox(height: 5),
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
                              dropdownItems: districts != null
                                  ? districts!
                                      .map((district) => district.name)
                                      .toList()
                                  : null,
                              initialValue: selectedDistrict,
                              onChanged: (newValue) {
                                setState(() {
                                  print(selectedDistrict);
                                  selectedUpazila = null;
                                  selectedUnion = null;
                                  selectedNTTNProvider = null;
                                  upazilas = null;
                                  unions = null;
                                  nttnProviders = [];
                                  _upazilaID = '';
                                  _unionID = '';
                                  _NTTNID = 0;
                                  selectedDistrict = newValue;
                                });
                                if (newValue != null) {
                                  // Find the selected division object
                                  District selectedDistrictObject =
                                      districts!.firstWhere(
                                    (district) => district.name == newValue,
                                  );
                                  if (selectedDistrictObject != null) {
                                    _districtID =
                                        selectedDistrictObject.id.toString();
                                    // Pass the ID of the selected division to fetchDistricts
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
                                  color: const Color.fromRGBO(25, 192, 122, 1),
                                ),
                              ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabeledTextWithAsterisk(text: 'Upzilla'),
                  SizedBox(height: 5),
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
                                  _unionID = '';
                                  _NTTNID = 0;
                                  selectedUpazila = newValue;
                                });
                                if (newValue != null) {
                                  // Find the selected division object
                                  Upazila selectedUpazilaObject =
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
                                  color: const Color.fromRGBO(25, 192, 122, 1),
                                ),
                              ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LabeledTextWithAsterisk(text: 'Union'),
                  SizedBox(height: 5),
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
                              dropdownItems: unions != null
                                  ? unions!.map((union) => union.name).toList()
                                  : null,
                              initialValue: selectedUnion,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedNTTNProvider = null;
                                  nttnProviders = [];
                                  _NTTNID = 0;
                                  selectedUnion = newValue;
                                  isSelected = true;
                                  print(isSelected);
                                });
                                if (newValue != null) {
                                  // Find the selected division object
                                  Union selectedUnionObject =
                                      unions!.firstWhere(
                                    (union) => union.name == newValue,
                                  );
                                  if (selectedUnionObject != null) {
                                    _unionID =
                                        selectedUnionObject.id.toString();
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
                                  color: const Color.fromRGBO(25, 192, 122, 1),
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
                        LabeledTextWithAsterisk(text: 'NTTN Providers in this area'),
                        SizedBox(height: 5),
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenHeight * 0.075,
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius:
                                  BorderRadius.circular(5.0), // Rounded corners
                            ),
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
                    height: 15,
                  ),
                  LabeledTextWithAsterisk(text: 'Remark'),
                  SizedBox(height: 5),
                  Container(
                    width: screenWidth * 0.9,
                    height: 120,
                    child: TextFormField(
                      controller: _remark,
                      enabled: providerValues != null,
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 145),
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
                        child: const Text('Next',
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
        content: Text('Proceeding to next page'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('triggered Validation');
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;

      final pageOneCubit = context.read<FormDataCubit>();

      pageOneCubit.updatePageOneData(
        divisionId: _divisionID,
        districtId: _districtID,
        upazilaId: _upazilaID,
        unionId: _unionID,
        serviceType: _selectedServiceType,
        latlong: _latitudeLongtitudeController.text,
        nttnProvider: _NTTNID,
        linkCapacity: fullLinkCapacity,
        remark: _remark.text,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkOrderUI()),
      );
    } else {
      const snackBar = SnackBar(
        content: Text('Please fill up all fields properly'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool ErrorMsg() {
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    } else {
      return false;
    }
  }


  bool _validateAndSave() {
    final divisionIdIsValid = _divisionID.isNotEmpty;
    final districtIdIsValid = _districtID.isNotEmpty;
    final upazilaIdIsValid = _upazilaID.isNotEmpty;
    final unionIdIsValid = _unionID.isNotEmpty;
    final nttNIdIsValid = _NTTNID != 0;
    final linkCapacityIsValid = fullLinkCapacity.isNotEmpty;
    final remarkIsValid = _remark.text.isNotEmpty;
    final serviceTypeisValid = _selectedServiceType.isNotEmpty;
    /*final latitudeLongitudeIsValid = (_formKey.currentState?.validate() ?? false) ? true : false;*/
    ErrorMsg();

    print(linkCapacityIsValid);

    if(selectedServiceType == null){
      return false;
    }



    if (selectedServiceType == "Data") {
      if(selectedUnit == null)
        return false;
      if(_linkcapcitycontroller.text.isEmpty)
        return false;
    }

    if(selectedServiceType == "Core"){
      if(_linkcapcitycontroller.text.isEmpty)
        return false;
    }

    if(selectedServiceType == "Co-Location"){
      if(_linkcapcitycontroller.text.isEmpty)
        return false;
    }

    // Check if all fields are valid
    final allFieldsAreValid = divisionIdIsValid &&
        districtIdIsValid &&
        upazilaIdIsValid &&
        unionIdIsValid &&
        nttNIdIsValid &&
        linkCapacityIsValid &&
        serviceTypeisValid &&
        /*latitudeLongitudeIsValid &&*/
        remarkIsValid;

    return allFieldsAreValid;
  }
}
