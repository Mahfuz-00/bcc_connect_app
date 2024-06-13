import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footer/footer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Login)/apiservicelogin.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Models/loginmodels.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Bloc/user_bloc.dart';
import '../BCC Dashboard/bccDashboard.dart';
import '../Forgot Password UI/forgotpasswordUI.dart';
import '../ISP Dashboard/ispDashboard.dart';
import '../NTTN Dashboard/nttnDashboard.dart';
import '../Sign Up UI/signupUI.dart';


class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscured = true;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late LoginRequestmodel _loginRequest;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();
  late String userType;
  bool _isLoading = false;
  bool _isButtonClicked = false;

  IconData _getIcon() {
    return _isObscured ? Icons.visibility_off : Icons.visibility;
  }

  void _checkLoginRequest() {
    if (_loginRequest != null) {
      _loginRequest.Email; // no error
      _loginRequest.Password; // no error
    }
  }

  @override
  void initState() {
    super.initState();
    _loginRequest = LoginRequestmodel(Email: '', Password: '');
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _checkLoginRequest();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
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
          key: globalKey,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          //alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Text(
                                'Welcome Again!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromRGBO(25, 192, 122, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default'),
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
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        onSaved: (input) =>
                                        _loginRequest.Email = input!,
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
                                          fillColor: Color.fromRGBO(
                                              247, 248, 250, 1),
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter your Email',
                                          labelStyle: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    Container(
                                      width: screenWidth*0.9,
                                      height: 85,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            keyboardType: TextInputType.text,
                                            onSaved: (input) =>
                                            _loginRequest.Password = input!,
                                            validator: (input) =>
                                            input!.length < 8
                                                ? "Password should be more than 7 characters"
                                                : null,
                                            controller: _passwordController,
                                            obscureText: _isObscured,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  143, 150, 158, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: const Color.fromRGBO(
                                                  247, 248, 250, 1),
                                              border: const OutlineInputBorder(),
                                              labelText: 'Enter your password',
                                              labelStyle: TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                fontFamily: 'default',
                                              ),
                                              suffixIcon: IconButton(
                                                icon: Icon(_getIcon()),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscured = !_isObscured;
                                                    _passwordController.text =
                                                        _passwordController.text;
                                                  });
                                                },
                                              ),
                                              errorStyle: TextStyle(height: 0),
                                            ),
                                          ),
                                          if (_passwordController.text.isNotEmpty &&
                                              _passwordController.text.length < 8)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                "Password should be more than 7 characters",
                                                style: TextStyle(color: Colors.red),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 30.0),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (
                                                    context) => ForgotPassword()));
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isButtonClicked = true; // Button clicked, show circular progress indicator
                                    });
                                    if (await validateAndSave(
                                        globalfromkey, context)) {
                                      //print(_loginRequest.toJSON());
                                      print('Checking $userType');
                                      if(userType != null){
                                        if (userType == 'isp_staff') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => ISPDashboard(shouldRefresh: true)),
                                          );
                                        }
                                        else if (userType == 'bcc_staff') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => BCCDashboard(shouldRefresh: true,)),
                                          );
                                        }
                                        else if (userType == 'nttn_sbl_staff') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => NTTNDashboard(shouldRefresh: true)),
                                          );
                                        }
                                        else if (userType == 'nttn_adsl_staff') {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => NTTNDashboard(shouldRefresh: true)),
                                          );
                                        }
                                        else {
                                          showTopToast(context, 'User is Invalid.');
                                        }
                                      }
                                    }
                                    setState(() {
                                      _isButtonClicked = false; // Validation complete, hide circular progress indicator
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromRGBO(
                                        25, 192, 122, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: Size(screenWidth*0.9, 70),
                                  ),
                                  child: _isButtonClicked
                                      ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                      : const Text('Login',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'default',
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //SizedBox(height: 20),
                    Footer(
                      backgroundColor: const Color.fromRGBO(246, 246, 246, 255),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?  ',
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
                                          builder: (context) => Signup()));
                                },
                                child: const Text(
                                  'Register now',
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
    );
  }

  Future<bool> validateAndSave(GlobalKey<FormState> formKey, BuildContext context) async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      final apiService = APIService();
      final loginRequestModel = LoginRequestmodel(
        Email: _emailController.text,
        Password: _passwordController.text,
      );
      try {
        final response = await apiService.login(loginRequestModel);
        if (response != null) {
          // Handle successful login
          UserDataBloc userDataBloc = context.read<UserDataBloc>();
          storeTokenLocally(response.token);
          _fetchUserProfile(response.token);
          /*_fetchUserProfile(response.token, userDataBloc);*/
          userType = response.userType;
          print('UserType :: $userType');
          return true;
        } else {
          showTopToast(context, 'Email or password is not valid.');
          // Handle unsuccessful login
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email or password is not valid.'),
            ),
          );*/
          return false;
        }
      } catch (e) {
        // Handle login error
        String errorMessage = 'Incorrect Email and Password.';
        if (e.toString().contains('Invalid User') || !e.toString().contains('isp_staff') || e.toString().contains('bcc_staff') || e.toString().contains('nttn_sbl_staff') || e.toString().contains('nttn_adsl_staff') ) {
          errorMessage = 'Please enter a valid email address.';
        }
        else if (e.toString().contains('Invalid Credentials')) {
          errorMessage = 'Incorrect Password. Try again.';
        }
        else if (e.toString().contains('The email field is required') || e.toString().contains('The password field is required')) {
          errorMessage = 'Email or password is empty. Please fill in both fields.';
        }

        showTopToast(context, errorMessage);

        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
          ),
        );*/
        return false;
      }
    }
    // Return false if form validation fails
    return false;
  }


  void showTopToast(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10, // 10 is for a little margin from the top
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

    // Remove the overlay entry after some time (e.g., 3 seconds)
    Future.delayed(Duration(seconds: 3)).then((_) {
      overlayEntry.remove();
    });
  }


  late String AuthenToken;
  late final String? UserName;
  late final String? OrganizationName;
  late final String? PhotoURL;
  late final String? Id;

  Future<void> storeTokenLocally(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print(prefs.getString('token'));

/*
    UserDataBloc userDataBloc = context.read<UserDataBloc>();
    userDataBloc.saveToken(token);

    final apiService = await APIProfileService();
    final profile = await apiService.fetchUserProfile(token);
    final userProfile = UserProfile.fromJson(profile);
    userDataBloc.saveName(userProfile.name);
    userDataBloc.saveOrganizationName(userProfile.organization);
    userDataBloc.savePhoto(userProfile.photo);
    userDataBloc.saveId(userProfile.Id.toString());*/
  }

  Future<void> _fetchUserProfile(String token) async {
    try {
      final apiService = await APIProfileService();
      final profile = await apiService.fetchUserProfile(token);
      final userProfile = UserProfile.fromJson(profile);

      // Save user profile data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      try {
        await prefs.setString('userName', userProfile.name);
        await prefs.setString('organizationName', userProfile.organization);
        await prefs.setString('photoUrl', userProfile.photo);
        await prefs.setString('id', userProfile.Id.toString());
        UserName = prefs.getString('userName');
        OrganizationName = prefs.getString('organizationName');
        PhotoURL = prefs.getString('photoUrl');
        Id = prefs.getString('id');
        print('User Name: $UserName');
        print('Organization Name: $OrganizationName');
        print('Photo URL: $PhotoURL');
        print('User ID: $Id');
        print('User profile saved successfully');
      } catch (e) {
        print('Error saving user profile: $e');
      }

    } catch (e) {
      print('Error fetching user profile: $e');
      // Handle error as needed
    }
  }

}
