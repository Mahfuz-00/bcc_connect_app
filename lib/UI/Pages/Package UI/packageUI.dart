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
import '../../Widgets/packagecard.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../ISP Dashboard/ispDashboard.dart';

class PackageUI extends StatefulWidget {
  const PackageUI({super.key});

  @override
  State<PackageUI> createState() => _PackageUIState();
}

class _PackageUIState extends State<PackageUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PackageAPIService apiService;

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

  @override
  void initState() {
    super.initState();
    fetchPackages().then((_) {
      // When fetchPackages finishes, set loading to false
      setState(() {
        isLoading = false;
      });
    });
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
      child: isLoading
          ? Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
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
                  'Packages',
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
                          child: Text('Packages',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default')),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Text('Available Packages for ISP Connection',
                              style: TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 18,
                                  fontFamily: 'default')),
                        ),
                        SizedBox(height: 20),
                        Text('Package List',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontFamily: 'default')),
                        SizedBox(height: 10),
                        // Check if the packages are loading
                        if (isLoading)
                          Center(child: CircularProgressIndicator())
                        else if (packages.isEmpty)
                          buildNoRequestsWidget(
                              screenWidth, 'No Packages Available')
                        else
                          // Display the list of PackageCard widgets
                          ListView.builder(
                            shrinkWrap: true,
                            // To prevent ListView from taking up too much space
                            physics: NeverScrollableScrollPhysics(),
                            // Prevent scrolling inside this ListView
                            itemCount: packages.length,
                            itemBuilder: (context, index) {
                              final package = packages[index];
                              return PackageCard(
                                id: package.id.toString(),
                                name: package.name ?? 'No Name',
                                // Provide a default value if name is null
                                packageName:
                                    package.packageName ?? 'No Package Name',
                                // Provide a default value if packageName is null
                                packageDescription:
                                    package.packageDescription ??
                                        'No Description',
                                // Provide a default value if packageDescription is null
                                charge: double.tryParse(
                                        package.charge?.toString() ?? '0.0') ??
                                    0.0, // Provide a default value if charge is null
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
