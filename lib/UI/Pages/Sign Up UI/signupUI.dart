import 'dart:io';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footer/footer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Sign Up)/apiserviceregister.dart';
import '../../../Data/Models/registermodels.dart';
import '../../Widgets/TamplateTextField.dart';
import '../../Widgets/dropdownfield.dart';
import '../../Widgets/overlaytext.dart';
import '../Login UI/loginUI.dart';

/// [SignupUI] that represents the sign-up user interface.
/// This widget allows users to register by entering their details such as
/// full name, organization, designation, email, phone number, and password.
///
/// Variables:
/// - [_isObscuredPassword]: Controls the visibility of the password field.
/// - [_isObscuredConfirmPassword]: Controls the visibility of the confirm password field.
/// - [_registerRequest]: Holds the registration request data model.
/// - [_fullNameController]: Controller for the full name input field.
/// - [_organizationController]: Controller for the organization name input field.
/// - [_designationController]: Controller for the designation input field.
/// - [_emailController]: Controller for the email input field.
/// - [_phoneController]: Controller for the phone number input field.
/// - [_passwordController]: Controller for the password input field.
/// - [_confirmPasswordController]: Controller for the confirm password input field.
/// - [_selectedUserType]: Holds the selected user type from a dropdown.
/// - [_licenseNumberController]: Controller for the license number input field.
/// - [_imageFile]: Holds the selected image file.
/// - [globalKey]: Global key for the scaffold.
/// - [globalfromkey]: Global key for the form.
/// - [_isLoading]: Indicates whether the form is loading.
/// - [_isButtonLoading]: Indicates whether the button is in a loading state.
/// - [_imageHeight]: Stores the height of the selected image.
/// - [_imageWidth]: Stores the width of the selected image.
class SignupUI extends StatefulWidget {
  const SignupUI({super.key});

  @override
  State<SignupUI> createState() => _SignupUIState();
}

class _SignupUIState extends State<SignupUI> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  late RegisterRequestmodel _registerRequest;
  late TextEditingController _fullNameController;
  late TextEditingController _organizationController;
  late TextEditingController _organizationTypeController;
  late TextEditingController _addressController;
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
  bool _isButtonLoading = false;
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
      organiazationType: '',
      organiazationAddress: '',
    );
    _fullNameController = TextEditingController();
    _organizationController = TextEditingController();
    _designationController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _licenseNumberController = TextEditingController();
    _organizationTypeController = TextEditingController();
    _addressController = TextEditingController();
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
    return InternetConnectionChecker(
      child: PopScope(
        /*  canPop: false,*/
        child: Scaffold(
          backgroundColor: Colors.grey[100],
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
                              CustomTextInput(
                                controller: _fullNameController,
                                label: 'Full Name',
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              CustomTextInput(
                                controller: _organizationController,
                                label: 'Organization Name',
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Please enter your organization name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              DropdownFormField(
                                hintText: 'Type of Organization',
                                dropdownItems: types,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUserType = value ?? '';
                                    _organizationTypeController.text =
                                        _selectedUserType;
                                    //print('New: $_selectedUserType');
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              CustomTextInput(
                                controller: _addressController,
                                label: 'Organization Address',
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Please enter your organization name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              CustomTextInput(
                                controller: _designationController,
                                label: 'Designation',
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
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
                                    border: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
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
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your mobile number name';
                                    }
                                    if (input.length != 11) {
                                      return 'Mobile number must be 11 digits';
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
                                    border: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
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
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  onTap: () {
                                    showCustomOverlay(context,
                                        "Password should be more than 7 characters and must include an uppercase letter, a lowercase letter, a number, and a special character.");
                                  },
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input) => _registerRequest.password = input!,
                                  validator: (input) {
                                    if (input!.length < 8) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Password should be more than 7 characters"),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                      return "Password should be more than 7 characters";
                                    } else if (!RegExp(
                                            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
                                        .hasMatch(input)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Password must include an uppercase letter, a lowercase letter, a number, and a special character."),
                                          duration: Duration(seconds: 3),
                                        ),
                                      );
                                      return "Password must contain uppercase, lowercase, number, and special character";
                                    }
                                    return null;
                                  },
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
                                    border: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
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
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  onTap: () {
                                    showCustomOverlay(context,
                                        "Password should be more than 7 characters and must include an uppercase letter, a lowercase letter, a number, and a special character.");
                                  },
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input) => _registerRequest.password = input!,
                                  validator: (input) {
                                    if (input!.length < 8) {
                                      return "Password should be more than 7 characters";
                                    } else if (!RegExp(
                                            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
                                        .hasMatch(input)) {
                                      return "Password must contain uppercase, lowercase, number, and special character";
                                    }
                                    return null;
                                  },
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
                                    border: const OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
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
                              CustomTextInput(
                                controller: _licenseNumberController,
                                label: 'License Number',
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return 'Please enter your license number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: (_imageWidth != 0
                                    ? (_imageWidth + 10)
                                        .clamp(0, screenWidth * 0.9)
                                    : screenWidth * 0.9),
                                height: (_imageHeight != 0
                                    ? (_imageHeight + 10).clamp(0, 200)
                                    : 80),
                                child: InkWell(
                                  onTap: _selectImage,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: Divider.createBorderSide(
                                              context)),
                                      labelText: 'Add Profile Picture',
                                      labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'default',
                                      ),
                                      errorMaxLines: null,
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
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
                                        VerticalDivider(
                                          thickness: 5,
                                        ),
                                        Text(
                                          'Upload',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(25, 192, 122, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'default',
                                          ),
                                        ),
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
                              fixedSize: Size(screenWidth * 0.9, 70),
                            ),
                            child: _isButtonLoading
                                ? CircularProgressIndicator()
                                : const Text('Register',
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
                                            builder: (context) => LoginUI()));
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
    print('Full Name: ${_fullNameController.text}');
    print('Organization: ${_organizationController.text}');
    print('Designation: ${_designationController.text}');
    print('Email: ${_emailController.text}');
    print('Phone: ${_phoneController.text}');
    print('Password: ${_passwordController.text}');
    print('Confirm Password: ${_confirmPasswordController.text}');
    print('Org Type: ${_organizationTypeController.text}');
    setState(() {
      _isButtonLoading = true;
    });
    if (validateAndSave() && checkConfirmPassword()) {
      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final registerRequest = RegisterRequestmodel(
        fullName: _fullNameController.text,
        organization: _organizationController.text,
        designation: _designationController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        userType: _organizationTypeController.text,
        licenseNumber: _licenseNumberController.text,
        organiazationAddress: _addressController.text,
        organiazationType: _organizationTypeController.text,
      );

      final apiService = UserRegistrationAPIService();
      // Call register method passing registerRequestModel, _imageFile, and authToken
      apiService.register(registerRequest, _imageFile).then((response) {
        print("Submitted");
        if (response != null &&
            response ==
                "Registration is completed. Your account is under verification.") {
          setState(() {
            _isButtonLoading = false;
          });
          clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginUI()),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Registration Submitted',
                  style: TextStyle(
                    color: Color.fromRGBO(25, 192, 122, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 22,
                  ),
                ),
                content: Text(
                  'Your registration has been submitted successfully. Please wait for approval before logging in.',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 16,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Color.fromRGBO(25, 192, 122, 1),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (response != null &&
            response == "The email has already been taken.") {
          setState(() {
            _isButtonLoading = false;
          });
          showTopToast(context, 'The Email is Taken!, Please Try entering a different Email');
        } else if (response != null &&
            response == "The phone has already been taken.") {
          setState(() {
            _isButtonLoading = false;
          });
          showTopToast(context, 'The Phone Number is Taken!, Please Try a different Number');
        } else {
          setState(() {
            _isButtonLoading = false;
          });
          showTopToast(context, 'Registration Failed!');
        }
      }).catchError((error) {
        setState(() {
          _isButtonLoading = false;
        });
        print(error);
        showTopToast(context, 'Registration Failed! Please try again later.');
      });
    } else {
      setState(() {
        _isButtonLoading = false;
      });
      if (_passwordController.text != _confirmPasswordController.text) {
        showTopToast(context, 'Passwords do not match!');
      } else if (validateAndSave() == false) {
        showTopToast(context, 'Please Fill all Fields!');
      }
    }
  }

  void showTopToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top +
            10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlayState?.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Choose an option',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(25, 192, 122, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
                fontSize: 22,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 18,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    // Check the file size
                    final file = File(pickedFile.path);
                    final fileSize = await file.length();
                    if (fileSize <= 5 * 1024 * 1024) {
                      // 5 MB
                      setState(() {
                        _imageFile = file;
                      });
                      await _getImageDimensions();
                    } else {
                      _showErrorDialog("Image must be less than 5 MB.");
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                    fontSize: 18,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    // Check the file size
                    final file = File(pickedFile.path);
                    final fileSize = await file.length();
                    if (fileSize <= 5 * 1024 * 1024) {
                      // 5 MB
                      setState(() {
                        _imageFile = file;
                      });
                      await _getImageDimensions();
                    } else {
                      _showErrorDialog("Image must be less than 5 MB.");
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Error",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(25, 192, 122, 1),
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
              fontSize: 22,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
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
    _addressController.clear();
    _organizationTypeController.clear();
    setState(() {
      _selectedUserType = '';
      _imageFile = null;
    });
  }
}
