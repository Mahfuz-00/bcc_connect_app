import 'dart:io';
import 'package:bcc_connect_app/Data/Models/package.dart';
import 'package:bcc_connect_app/UI/Bloc/form_data_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Connection From)/apiserviceconnection.dart';
import '../../../Data/Data Sources/API Service (Packages)/apiservicepackages.dart';
import '../../../Data/Data Sources/API Service (Regions)/apiserviceregions.dart';
import '../../../Data/Models/connectionmodel.dart';
import '../../../Data/Models/regionmodels.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/TamplateTextField.dart';
import '../../Widgets/dropdownfieldConnectionForm.dart';
import '../../Widgets/dropdownservice.dart';
import '../ISP Dashboard/ispDashboard.dart';

/// [WorkOrderUI] is a [StatefulWidget] that represents a form for users to fill out
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
/// - [String] [_packageID], [_districtID], [_upazilaID], [_unionID]: Hold the IDs of selected division, district, upazila, and union.
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
class WorkOrderUI extends StatefulWidget {
  const WorkOrderUI({super.key});

  @override
  State<WorkOrderUI> createState() => _WorkOrderUIState();
}

class _WorkOrderUIState extends State<WorkOrderUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedPaymentMode;
  late ConnectionRequestModel _connectionRequest;
  late TextEditingController _contractDurationController =
      TextEditingController();
  late TextEditingController _capacityController = TextEditingController();
  late TextEditingController _discountController = TextEditingController();
  late TextEditingController _priceController = TextEditingController();
  late TextEditingController _netPaymentController = TextEditingController();
  late TextEditingController _linkcapcitycontroller = TextEditingController();
  late TextEditingController _workOrderRemarkController =
      TextEditingController();
  late String _packageID;
  late String _PaymentMode = '';
  bool _isPicked = false;
  File? _file;

  final Set<String> paymentMethodOptions = {};

  late PackageAPIService apiService;

  List<String> PaymentOptions = ['Cash', 'Online'];

  Future<PackageAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await PackageAPIService.create(token);
    return apiService;
  }

  List<Package> packages = [];
  String? selectedPackage;
  bool isLoading = false;
  bool isLoadingPackage = false;
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  late String providerValues = '';
  bool isSelected = false;

  // Variables for calculations
  double packageRate = 0;
  double discount = 0;

  void _calculateNetPayment() {
    setState(() {
      int contractDuration = int.parse(_contractDurationController.text);
      packageRate = double.tryParse(_priceController.text) ?? 0;
      discount = _parseDiscount(_discountController.text);

      double netPayment;
      if (discount == 0) {
        // No discount
        netPayment = contractDuration * packageRate;
      } else if (discount > 1) {
        // Absolute discount
        netPayment = (contractDuration * packageRate) - discount;
      } else {
        // Percentage discount
        netPayment = (packageRate - (packageRate * discount)) * contractDuration;
      }

      _netPaymentController.text = netPayment.toStringAsFixed(2);
    });
  }

  double _parseDiscount(String discountText) {
    // Check if the discount is a percentage
    if (discountText.contains('%')) {
      String percentageText = discountText.replaceAll('%', '').trim();
      double percentage = double.tryParse(percentageText) ?? 0;
      return percentage / 100; // Return as a fraction
    } else {
      // If no percentage sign, treat it as an absolute discount
      return double.tryParse(discountText) ?? 0;
    }
  }

  late String divisionId;
  late String districtId;
  late String upazilaId;
  late String unionId;
  late String serviceType;
  late String latlong;
  late int nttnProvider;
  late String requestRemark;

  @override
  void initState() {
    // Using WidgetsBinding to safely access context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final datafromfirstpageCubit = context.read<FormDataCubit>();
      String? capacity = datafromfirstpageCubit.state.linkCapacity;
      _capacityController.text = capacity!;
      divisionId = datafromfirstpageCubit.state.divisionId!;
      districtId = datafromfirstpageCubit.state.districtId!;
      upazilaId = datafromfirstpageCubit.state.upazilaId!;
      unionId = datafromfirstpageCubit.state.unionId!;
      serviceType = datafromfirstpageCubit.state.serviceType!;
      latlong = datafromfirstpageCubit.state.latlong!;
      nttnProvider = datafromfirstpageCubit.state.nttnProvider!;
      requestRemark = datafromfirstpageCubit.state.remark!;
    });
    super.initState();
    // Add listeners to update the calculation automatically
    _priceController.addListener(_calculateNetPayment);
    _discountController.addListener(_calculateNetPayment);
    _contractDurationController.addListener(_calculateNetPayment);
    _connectionRequest = ConnectionRequestModel(
      divisionId: "",
      districtId: "",
      upazilaId: "",
      unionId: "",
      nttnProvider: 0,
      linkCapacity: "",
      remark: "",
      serviceType: '',
      latlong: '',
    );
    fetchPackages();
  }

  @override
  void dispose() {
    _workOrderRemarkController.dispose();
    super.dispose();
  }

  Future<void> fetchPackages() async {
    setState(() {
      isLoading = true;
    });
    try {
      await initializeApiService();
      final List<Package> fetchedPackages = await apiService.fetchPackages();
      setState(() {
        packages = fetchedPackages;
        for (Package package in fetchedPackages) {
          print('Service Name: ${package.name}');
          print('Package ID: ${package.id}');
          print('Package Name: ${package.packageName}');
          print('Package Description: ${package.packageDescription}');
          print('Package Price: ${package.charge}');
        }
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching divisions: $e');
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Work Order',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default')),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                        'Please fill up the form. \n If you do not have a work order, please submit the form without it.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 18,
                            fontFamily: 'default')),
                  ),
                  SizedBox(height: 40),
                  CustomTextInput(
                    controller: _contractDurationController,
                    label: 'Contact Duration (Month)',
                    keyboardType: TextInputType.phone,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter your contact duration (month)';
                      }
                      return null;
                    },
                  ),
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
                                hintText: 'Select Package',
                                dropdownItems: packages
                                    .map((package) => package.packageName)
                                    .where((packageName) =>
                                        packageName !=
                                        null) // Filter out null values
                                    .cast<String>() // Cast to List<String>
                                    .toList(),
                                initialValue: selectedPackage,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedPackage = newValue;
                                  });
                                  if (newValue != null) {
                                    // Find the selected division object
                                    Package selectedPackageObject =
                                        packages.firstWhere(
                                      (package) =>
                                          package.packageName == newValue,
                                    );
                                    if (selectedPackageObject != null) {
                                      _packageID =
                                          selectedPackageObject.id.toString();
                                      _priceController.text =
                                          selectedPackageObject.charge
                                              .toString();
                                    }
                                  }
                                }),
                            if (isLoading)
                              Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: const Color.fromRGBO(25, 192, 122, 1),
                                ),
                              ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 70,
                    child: TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: const OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        labelText: 'Package Rate',
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        prefixText: 'TK ',
                      ),
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter your contact duration (month)';
                        }
                        return null;
                      },
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextInput(
                    controller: _discountController,
                    label: 'Discount',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter your organization name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomTextInput(
                    controller: _capacityController,
                    label: 'Capacity',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter your organization name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 70,
                    child: TextFormField(
                      controller: _netPaymentController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        labelText: 'Net Payment',
                        labelStyle: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        prefixText: 'TK ',
                      ),
                      style: TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(height: 5),
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
                          hintText: 'Select Payment Method',
                          dropdownItems: PaymentOptions.toList(),
                          initialValue: selectedPaymentMode,
                          onChanged: (newValue) {
                            setState(() {
                              selectedPaymentMode = newValue;
                              _PaymentMode = newValue ?? '';
                              print(_PaymentMode);
                            });
                          },
                        )),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: screenWidth * 0.9,
                    height: 120,
                    child: TextFormField(
                      controller: _workOrderRemarkController,
                      enabled: selectedPaymentMode != null,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(25, 192, 122, 1),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  MediaQuery.of(context).size.height * 0.075),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: _isPicked ? null : _pickFile,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isPicked) ...[
                                  CircularProgressIndicator(
                                    color: Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ] else if (_file == null) ...[
                                  Icon(
                                    Icons.document_scanner,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Pick File',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ],
                                if (_file != null) ...[
                                  Text('File Picked',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      )),
                                ]
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
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
                        onPressed: _connectionRequestForm,
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
    );
  }

  void _connectionRequestForm() {
    print('Service Type $serviceType');
    print('Latititude and Longtitude: $latlong');
    print('Division: $divisionId');
    print('District: $districtId');
    print('Upazila: $upazilaId');
    print('Union: $unionId');
    print('NTTN: $nttnProvider');
    print('Link Capacity: ${_capacityController.text}');
    print('Request Remark: $requestRemark');
    print('Contract Duration: ${_contractDurationController.text}');
    print('Package: $selectedPackage');
    print('Discount: ${_discountController.text}');
    print('Net Payment: ${_netPaymentController.text}');
    print('Payment Mode: $selectedPaymentMode');
    print('Work Order Remark: ${_workOrderRemarkController.text}');

    // Validate and save form data
    if (_validateAndSave()) {
      const snackBar = SnackBar(
        content: Text('Processing. Please wait...'),
        duration: Duration(seconds: 10),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('triggered Validation');
      // Initialize connection request model
      _connectionRequest = ConnectionRequestModel(
        divisionId: divisionId,
        districtId: districtId,
        upazilaId: upazilaId,
        unionId: unionId,
        nttnProvider: nttnProvider,
        linkCapacity: _capacityController.text,
        remark: requestRemark,
        serviceType: serviceType,
        latlong: latlong,
        contractDuration: _contractDurationController.text,
        packageName:  _packageID,
        discount: _discountController.text,
        netPayment: _netPaymentController.text,
        paymentMode: selectedPaymentMode,
      );
      final authCubit = context.read<AuthCubit>();
      final token = (authCubit.state as AuthAuthenticated).token;

      // Perform any additional actions before sending the request
      // Send the connection request using API service
      ConnectionAPIService.create(token)
          .postConnectionRequest(_connectionRequest, _file)
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
              (route) => false);
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
    final contactDurationIsValid = _contractDurationController.text.isNotEmpty;
    final packageNameIsValid =  _packageID.isNotEmpty;
    final discountIsValid = _discountController.text.isNotEmpty;
    final netPaymentIsValid = _netPaymentController.text.isNotEmpty;
    final paymentmodeIsValid = _PaymentMode.isNotEmpty;
    final packageIdIsValid = _packageID.isNotEmpty;
    final linkCapacityIsValid = _PaymentMode.isNotEmpty;
    final remarkIsValid = _workOrderRemarkController.text.isNotEmpty;

    print(linkCapacityIsValid);

    // Check if all fields are valid
    final allFieldsAreValid = contactDurationIsValid &&
        packageNameIsValid! &&
        discountIsValid &&
        netPaymentIsValid &&
        paymentmodeIsValid &&
        packageIdIsValid &&
        linkCapacityIsValid &&
        remarkIsValid && _file != null;

    return allFieldsAreValid;
  }

  Future<void> _pickFile() async {
    setState(() {
      _isPicked = true;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'bmg'
        ],
      );

      if (result != null) {
        String? fileExtension = result.files.single.extension;

        List<String> allowedExtensions = [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'xls',
          'xlsx',
          'bmg'
        ];

        if (fileExtension != null &&
            allowedExtensions.contains(fileExtension.toLowerCase())) {
          if (result.files.single.size <= 21000 * 1024) {
            setState(() {
              _file = File(result.files.single.path!);
              _isPicked = false;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text("File exceeds the maximum allowed size of 21 MB."),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Invalid file extension. Allowed types: pdf, doc, docx, ppt, pptx, xls, xlsx."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No file selected."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }
}
