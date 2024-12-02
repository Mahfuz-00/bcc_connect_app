import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Data Sources/API Service (Packages)/apiservicepackages.dart';
import '../../Data/Data Sources/API Service (Upgrade Connection)/apiServiceUpgradeConnection.dart';
import '../../Data/Models/package.dart';
import '../Bloc/auth_cubit.dart';
import '../Pages/Upgrade UI/upgradepage.dart';
import 'TamplateTextField.dart';
import 'dropdownfieldConnectionForm.dart';

/// A widget that displays detailed information about a connection upgrade request.
///
/// This widget is used to show detailed information related to a connection upgrade request
/// and allows users to submit an upgrade request through a dialog.
///
/// [UserID] is the ID of the user requesting the upgrade.
/// [ConnectionType] is the type of connection being upgraded.
/// [NTTNProvider] is the name of the NTTN provider.
/// [FRNumber] is the unique ID of the application.
/// [Division] is the division where the connection is located.
/// [District] is the district where the connection is located.
/// [Upazila] is the Upazila where the connection is located.
/// [Union] is the union where the connection is located.
class UpgradeConnectionInfoCard extends StatefulWidget {
  final String UserID;
  final String ConnectionType;
  final String NTTNProvider;
  final String FRNumber;
  final String Division;
  final String District;
  final String Upazila;
  final String Union;
  final String? ServiceType;
  final String? Capacity;
  final String? WorkOrderNumber;
  final int? ContactDuration;
  final num? NetPayment;

  const UpgradeConnectionInfoCard({
    Key? key,
    required this.UserID,
    required this.ConnectionType,
    required this.NTTNProvider,
    required this.FRNumber,
    required this.Division,
    required this.District,
    required this.Upazila,
    required this.Union,
    this.ServiceType,
    this.Capacity,
    this.WorkOrderNumber,
    this.ContactDuration,
    this.NetPayment,
  }) : super(key: key);

  @override
  _UpgradeConnectionInfoCardState createState() =>
      _UpgradeConnectionInfoCardState();
}

class _UpgradeConnectionInfoCardState extends State<UpgradeConnectionInfoCard> {
  final _formKey = GlobalKey<FormState>();
  String? selectedCapacity;
  bool showCustomCapacityField = false;
  final TextEditingController customCapacityController =
      TextEditingController();
  final TextEditingController remarkController = TextEditingController();

  @override
  void initState() {
    super.initState(); // Call the parent class's initState first

    // Add listeners to update the calculation automatically
    _priceController.addListener(_calculateNetPayment);
    _discountController.addListener(_calculateNetPayment);

    // Fetch initial data
    fetchPackages();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Connection Type', widget.ConnectionType),
            _buildRow('FR Number', widget.FRNumber),
            _buildRow('NTTN Provider', widget.NTTNProvider),
            _buildRow('District', widget.District),
            _buildRow('Division', widget.Division),
            _buildRow('Upazila', widget.Upazila),
            _buildRow('Union', widget.Union),
            if (widget.WorkOrderNumber != null)
              _buildRow('Work Order Number', widget.WorkOrderNumber!),
            _buildRow('Service Type', widget.ServiceType ?? ' '),
            _buildRow('Capacity', widget.Capacity ?? ' '),
            if (widget.ContactDuration != null)
              _buildRow('Contact Duration',
                  '${widget.ContactDuration.toString()} Months'!),
            if (widget.NetPayment != null)
              _buildRow('Net Payment', '${widget.NetPayment.toString()} TK'!),
            SizedBox(
              height: 15,
            ),
            Center(
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.5,
                      MediaQuery.of(context).size.height * 0.075,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Navigate to the new upgrade page with the existing data
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpgradePage(
                          FRNumber: widget.FRNumber,
                          Capacity: widget.Capacity,
                          ContactDuration: widget.ContactDuration,
                          NetPayment: widget.NetPayment,
                        ),
                      ),
                    );
                  },
                  child: const Text('Upgrade',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  late TextEditingController _contractDurationController =
      TextEditingController();
  late TextEditingController _discountController = TextEditingController();
  late TextEditingController _priceController = TextEditingController();
  late TextEditingController _netPaymentController = TextEditingController();
  final Set<String> paymentMethodOptions = {};
  late String _packageID;
  late String _PaymentMode = '';
  late PackageAPIService apiService;
  List<Package> packages = [];
  String? selectedPackage;
  bool isLoading = false;
  bool isLoadingPackage = false;
  String? selectedPaymentMode;
  double packageRate = 0;
  double discount = 0;
  List<String> PaymentOptions = ['Cash', 'Online'];

  Future<PackageAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await PackageAPIService.create(token);
    return apiService;
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

  // Method to calculate Net Payment
  void _calculateNetPayment() {
    setState(() {
      int contractDuration = int.parse(_contractDurationController.text);
      print(contractDuration);
      // Parse the package rate and discount to double, if valid
      packageRate = double.tryParse(_priceController.text) ?? 0;
      discount = _parseDiscount(_discountController.text);

      print('Package Rate: $packageRate');
      print('Discount: $discount');

      // Apply the discount based on its type (percentage or absolute)
      double netPayment = discount == null
          ? contractDuration *
              packageRate // If no discount, the net payment is the full price
          : (discount > 1
              ? packageRate - discount
              : (packageRate - (packageRate * discount)) *
                  contractDuration); // Applies contract duration

      if (discount != null && discount > 0) {
        double discountAmount = discount > 1
            ? discount // Fixed discount amount
            : packageRate * discount; // Percentage-based discount

        print('Discount Amount: $discountAmount');
      }
      print('Net Payment: $netPayment');

      // Update the net payment controller
      _netPaymentController.text =
          netPayment.toStringAsFixed(2); // Round to 2 decimal places
    });
  }

  // Helper function to parse the discount and figure out its type (absolute or percentage)
  double _parseDiscount(String discountText) {
    print('Parsing discount: $discountText');

    if (discountText.contains('%')) {
      // If discount contains a %, treat it as a percentage
      String percentageText = discountText.replaceAll('%', '').trim();
      double percentage = double.tryParse(percentageText) ?? 0;
      print('Parsed percentage: $percentage');
      return percentage / 100; // Convert to decimal (20% => 0.2)
    } else {
      // Otherwise, treat it as an absolute currency discount
      double absoluteDiscount = double.tryParse(discountText) ?? 0;
      print('Parsed absolute discount: $absoluteDiscount');
      return absoluteDiscount;
    }
  }

  /// Shows a dialog allowing the user to submit an upgrade request.
  ///
  /// The dialog contains form fields for entering link capacity and remarks,
  /// and handles form submission by interacting with the API service.
  void _showUpgradeDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Add listeners to update the calculation automatically
    _priceController.addListener(_calculateNetPayment);
    _discountController.addListener(_calculateNetPayment);

    customCapacityController.text = widget.Capacity ?? '';
    _contractDurationController.text = widget.ContactDuration?.toString() ?? '';
    _priceController.text = widget.NetPayment.toString() ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upgrade Connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextInput(
                    controller: customCapacityController,
                    label: 'Enter Link Capacity',
                    keyboardType: TextInputType.phone,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter link capacity';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
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
                          return 'Package Rate';
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
                        return 'Please enter the discount amount or percentage';
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
                  CustomTextInput(
                    controller: remarkController,
                    label: 'Enter Remark',
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please you remark';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      const snackBar = SnackBar(
                        content: Text('Processing'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      String linkCapacity = customCapacityController.text;
                      String contractDuration =
                          _contractDurationController.text;
                      String packageID = _packageID;
                      String netPayment = _netPaymentController.text;
                      String discount = _discountController.text;
                      String price = _priceController.text;
                      String remark = remarkController.text;

                      print('Upgrade Type: $linkCapacity');
                      print('Contract Duration: $contractDuration');
                      print('Package ID: $packageID');
                      print('Net Payment: $netPayment');
                      print('Discount: $discount');
                      print('Price: $price');
                      print('Remark: $remark');

                      try {
                        final authCubit = context.read<AuthCubit>();
                        final token =
                            (authCubit.state as AuthAuthenticated).token;
                        UpgradeConnectionAPIService apiService =
                            await UpgradeConnectionAPIService.create(token);
                        var response = await apiService.updateConnection(
                          id: widget.FRNumber,
                          requestType: 'Upgrade',
                          linkCapacity: linkCapacity,
                          remark: remark,
                          contractDuration: contractDuration,
                          packageid: packageID,
                          netPaymnet: netPayment,
                        );
                        print('Response: $response');
                        const snackBar = SnackBar(
                          content:
                              Text('Successfully Submitted Upgrade Request'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      } catch (e) {
                        const snackBar = SnackBar(
                          content: Text('Upgrade Request is not Submitted'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        print('Error: $e');
                      }
                    }
                  },
                  child: Text('Submit',
                      style: TextStyle(
                        color: Color.fromRGBO(25, 192, 122, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  /// Builds a row displaying a label and its corresponding value.
  ///
  /// [label] is the text label to display.
  /// [value] is the value associated with the label.
  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
