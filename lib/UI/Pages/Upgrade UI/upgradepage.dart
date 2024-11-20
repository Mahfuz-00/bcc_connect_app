import 'package:bcc_connect_app/UI/Pages/Upgrade%20UI/upgradeUI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Data Sources/API Service (Packages)/apiservicepackages.dart';
import '../../../Data/Data Sources/API Service (Upgrade Connection)/apiServiceUpgradeConnection.dart';
import '../../../Data/Models/package.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/TamplateTextField.dart';
import '../../Widgets/dropdownfieldConnectionForm.dart';

class UpgradePage extends StatefulWidget {
  final String? Capacity;
  final int? ContactDuration;
  final num? NetPayment;
  final String FRNumber;

  UpgradePage({
    required this.FRNumber,
    this.Capacity,
    this.ContactDuration,
    this.NetPayment,
  });

  @override
  _UpgradePageState createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  late TextEditingController customCapacityController;
  late TextEditingController _contractDurationController;
  late TextEditingController _discountController;
  late TextEditingController _priceController;
  late TextEditingController _netPaymentController;
  late TextEditingController remarkController;

  late String _packageID;
  late PackageAPIService apiService;
  List<Package> packages = [];
  String? selectedPackage;
  bool isLoading = false;
  bool isLoadingPackage = false;
  bool isRequestLoading = false;
  double packageRate = 0;
  double discount = 0;
  List<String> PaymentOptions = ['Cash', 'Online'];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    customCapacityController = TextEditingController();
    _contractDurationController = TextEditingController();
    _discountController = TextEditingController();
    _priceController = TextEditingController();
    _netPaymentController = TextEditingController();
    remarkController = TextEditingController();
    // Add listeners to update the calculation automatically
    _priceController.addListener(_calculateNetPayment);
    _discountController.addListener(_calculateNetPayment);
    _contractDurationController.addListener(_calculateNetPayment);

    customCapacityController.text = widget.Capacity ?? '';
    _contractDurationController.text = widget.ContactDuration?.toString() ?? '';
    _netPaymentController.text = widget.NetPayment.toString() ?? '';
    fetchPackages();
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
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching packages: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<PackageAPIService> initializeApiService() async {
    final authCubit = context.read<AuthCubit>();
    final token = (authCubit.state as AuthAuthenticated).token;
    apiService = await PackageAPIService.create(token);
    return apiService;
  }

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
        netPayment =
            (packageRate - (packageRate * discount)) * contractDuration;
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Add listeners to update the calculation automatically
    _priceController.addListener(_calculateNetPayment);
    _discountController.addListener(_calculateNetPayment);
    _contractDurationController.addListener(_calculateNetPayment);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
            // Background color of the app bar.
            leadingWidth: 40,
            titleSpacing: 10,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Navigates back to the previous screen.
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ) // Back arrow icon.
                ),
            title: const Text(
              'Upgrade Connection', // Title of the app bar.
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
            centerTitle: true, // Centers the title in the app bar.
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Upgrade Connection',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Enter new details to upgrade your connection.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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
                    SizedBox(height: 10),
                    CustomTextInput(
                      controller: _contractDurationController,
                      label: 'Contract Duration (Month)',
                      keyboardType: TextInputType.number,
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter contract duration';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
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
                                    color:
                                        const Color.fromRGBO(25, 192, 122, 1),
                                  ),
                                ),
                            ],
                          )),
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 10),
                    CustomTextInput(
                      controller: _discountController,
                      label: 'Discount',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter the discount amount or percentage';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 10),
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
                    SizedBox(height: 10),
                    CustomTextInput(
                      controller: remarkController,
                      label: 'Enter Remark',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter a remark';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.35,
                              MediaQuery.of(context).size.height * 0.075,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(25, 192, 122, 1),
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.35,
                              MediaQuery.of(context).size.height * 0.075,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await _SubmitData(context);
                          },
                          child: Text('Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // The loading overlay
        if (isRequestLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              // Semi-transparent background
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _SubmitData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isRequestLoading = true; // Show the loading indicator
      });
      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      String linkCapacity = customCapacityController.text;
      String contractDuration = _contractDurationController.text;
      String packageID = _packageID;
      String netPayment = _netPaymentController.text;
      String discount = _discountController.text;
      String price = _priceController.text;
      String remark = remarkController.text;

      try {
        final authCubit = context.read<AuthCubit>();
        final token = (authCubit.state as AuthAuthenticated).token;
        UpgradeConnectionAPIService apiService =
            await UpgradeConnectionAPIService.create(token);
        var response = await apiService.updateConnection(
          id: widget.FRNumber,
          requestType: 'Upgrade',
          linkCapacity: linkCapacity,
          remark: remark,
          contractDuration: contractDuration,
          packageid: packageID,
          discount: discount,
          netPaymnet: netPayment,
        );

        if (response != null) {
          setState(() {
            isRequestLoading = false;
          });
        }

        const snackBar = SnackBar(
          content: Text('Successfully Submitted Upgrade Request'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UpgradeUI(
              shouldRefresh: true,
            ),
          ),
        );
      } catch (e) {
        const snackBar = SnackBar(
          content: Text('Upgrade Request is not Submitted'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Error: $e');
      }
    }
  }
}
