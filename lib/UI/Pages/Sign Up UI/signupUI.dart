import 'dart:io';
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footer/footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Sign Up)/apiserviceregister.dart';
import '../../../Data/Models/registermodels.dart';
import '../../Widgets/dropdownfield.dart';
import '../Login UI/loginUI.dart';


class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  late RegisterRequestmodel _registerRequest;
  late TextEditingController _fullNameController;
  late TextEditingController _organizationController;
  late TextEditingController _designationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String _selectedUserType = '';
  late TextEditingController _licenseNumberController;
  File? _imageFile;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();
  bool _isLoading = false;
  double _imageHeight = 0;
  double _imageWidth = 0;

  // Function to load image dimensions
  Future<void> _getImageDimensions() async {
    if (_imageFile != null) {
      final data = await _imageFile!.readAsBytes();
      final image = await decodeImageFromList(data);
      setState(() {
        _imageHeight = image.height.toDouble();
        _imageWidth = image.width.toDouble();
      });
    }
  }

  List<DropdownMenuItem<String>> types = [
    DropdownMenuItem(child: Text("Nationwide"), value: "Nationwide"),
    DropdownMenuItem(child: Text("Divisional"), value: "Divisional"),
    DropdownMenuItem(child: Text("District"), value: "District"),
    DropdownMenuItem(child: Text("Upazila"), value: "Upazila"),
    DropdownMenuItem(child: Text("Others"), value: "Others"),
  ];

  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      setState(() {
        _isLoading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _registerRequest = RegisterRequestmodel(
      fullName: '',
      organization: '',
      designation: '',
      email: '',
      phone: '',
      password: '',
      confirmPassword: '',
      userType: '',
      licenseNumber: '',
    );
    _fullNameController = TextEditingController();
    _organizationController = TextEditingController();
    _designationController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _licenseNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Column(children: [
                        const Text(
                          'Hello! Register to get started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(25, 192, 122, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Sign in to see how we manage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 50),
                        Form(
                          key: globalfromkey,
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _fullNameController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _organizationController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your organization name';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Organization Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _designationController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your designation';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Designation',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return 'Please enter your email address';
                                    }
                                    final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(input)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    // Only allow digits
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your mobile number name';
                                    }
                                    if (input.length != 11) {
                                      return 'Mobile number must be 11 digits';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Mobile Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input) => _registerRequest.password = input!,
                                  validator: (input) => input!.length < 8
                                      ? "Password should be more than 7 characters"
                                      : null,
                                  controller: _passwordController,
                                  obscureText: _isObscuredPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredPassword =
                                              !_isObscuredPassword;
                                          _passwordController.text =
                                              _passwordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input) => _registerRequest.password = input!,
                                  validator: (input) => input!.length < 8
                                      ? "Password should be more than 7 characters"
                                      : null,
                                  controller: _confirmPasswordController,
                                  obscureText: _isObscuredConfirmPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconConfirmPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredConfirmPassword =
                                              !_isObscuredConfirmPassword;
                                          _confirmPasswordController.text =
                                              _confirmPasswordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              DropdownFormField(
                                hintText: 'Type of User',
                                dropdownItems: types,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUserType = value ?? '';
                                    //print('New: $_selectedUserType');
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _licenseNumberController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your license number';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'License Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: (_imageWidth != 0 ? (_imageWidth + 10).clamp(0, screenWidth*0.9) : screenWidth*0.9),
                                height: (_imageHeight != 0 ? (_imageHeight + 10).clamp(0, 200) : 80),
                                child: InkWell(
                                  onTap: _selectImage,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide:
                                              Divider.createBorderSide(context)),
                                      labelText: 'Add Profile Picture',
                                      labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'default',
                                      ),
                                      errorMaxLines: null,
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .red), // Customize error border color
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _imageFile != null
                                              ? Image.file(
                                                  _imageFile!,
                                                  width: null,
                                                  height: null,
                                                  fit: BoxFit.contain,
                                                )
                                              : Icon(Icons.image,
                                                  size: 60, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        VerticalDivider(thickness: 5,),
                                        Text('Upload',
                                          style: TextStyle(
                                            color: Color.fromRGBO(25, 192, 122, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'default',
                                          ),),
                                        // Customize upload text style
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(screenWidth*0.9, 70),
                            ),
                            child: const Text('Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'default',
                                ))),
                      ])),
                      Footer(
                        backgroundColor: Color.fromRGBO(246, 246, 246, 255),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login()));
                                  },
                                  child: const Text(
                                    'Login now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(25, 192, 122, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() {
    if (validateAndSave() && checkConfirmPassword()) {
      const snackBar = SnackBar(
        content: Text(
            'Processing'),
      );
      final registerRequest = RegisterRequestmodel(
        fullName: _fullNameController.text,
        organization: _organizationController.text,
        designation: _designationController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        userType: _selectedUserType,
        licenseNumber: _licenseNumberController.text,
      );

      final apiService = APIService();
      // Call register method passing registerRequestModel, _imageFile, and authToken
      apiService.register(registerRequest, _imageFile).then((response) {
        print("Submitted");
        if (response != null && response == "User Registration Successfully") {
          clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
          const snackBar = SnackBar(
            content: Text('Registration Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        // Handle registration error
        print(error);
        const snackBar = SnackBar(
          content: Text('Registration failed!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  bool validateAndSave() {
    final form = globalfromkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool checkConfirmPassword() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _getImageDimensions();
    }
  }

  void clearForm() {
    _fullNameController.clear();
    _organizationController.clear();
    _designationController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _licenseNumberController.clear();
    setState(() {
      _selectedUserType = '';
      _imageFile = null;
    });
  }

}
