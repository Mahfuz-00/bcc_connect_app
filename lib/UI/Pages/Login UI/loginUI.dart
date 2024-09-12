import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footer/footer.dart';
import '../../../Data/Data Sources/API Service (Login)/apiservicelogin.dart';
import '../../../Data/Data Sources/API Service (Profile)/apiserviceprofile.dart';
import '../../../Data/Models/loginmodels.dart';
import '../../../Data/Models/profilemodel.dart';
import '../../Bloc/auth_cubit.dart';
import '../BCC Dashboard/bccDashboard.dart';
import '../Forgot Password UI/forgotpasswordUI.dart';
import '../ISP Dashboard/ispDashboard.dart';
import '../NTTN Dashboard/nttnDashboard.dart';
import '../Sign Up UI/signupUI.dart';

/// This [LoginUI] class represents the user interface for logging into the application.
///
/// Variables:
/// * [bool _isObscured] - Controls the visibility of the password text field.
/// * [TextEditingController _passwordController] - Manages the text input for the password.
/// * [TextEditingController _emailController] - Manages the text input for the email.
/// * [LoginRequestmodel _loginRequest] - Holds the email and password for the login request.
/// * [GlobalKey<ScaffoldState> globalKey] - Key for the [Scaffold] widget, used for accessing the scaffold.
/// * [GlobalKey<FormState> globalfromkey] - Key for the [Form] widget, used for validating the form.
/// * [String userType] - Stores the type of user after a successful login.
/// * [bool _isLoading] - Indicates whether a login request is in progress.
/// * [bool _isButtonClicked] - Tracks if the login button has been clicked to display a loading indicator.
/// * [AuthCubit authCubit] - Manages the authentication state of the application.
///
/// Actions:
/// * [_getIcon()] - Returns the appropriate icon based on the [_isObscured] value.
/// * [_checkLoginRequest()] - Verifies the [LoginRequestmodel] to ensure email and password are set.
/// * [initState()] - Initializes the login request model, controllers, and checks the login request.
/// * [dispose()] - Disposes of the controllers to free up resources.
/// * [build()] - Builds the login UI, including form fields for email and password, and a login button.
/// * [validateAndSave()] - Validates the form, sends the login request, handles the response, and manages the navigation based on the user type.
/// * [showTopToast()] - Displays a toast message at the top of the screen with the provided [message].
class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  bool _isObscured = true;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late LoginRequestmodel _loginRequest;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();
  late String userType;
  bool _isLoading = false;
  bool _isButtonClicked = false;
  late AuthCubit authCubit;

  IconData _getIcon() {
    return _isObscured ? Icons.visibility_off : Icons.visibility;
  }

  void _checkLoginRequest() {
    if (_loginRequest != null) {
      _loginRequest.Email;
      _loginRequest.Password;
    }
  }

  @override
  void initState() {
    super.initState();
    _loginRequest = LoginRequestmodel(Email: '', Password: '');
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _checkLoginRequest();
    authCubit = context.read<AuthCubit>();
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
    return Scaffold(
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
                                  width: screenWidth * 0.9,
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
                                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                      if (!emailRegex.hasMatch(input)) {
                                        print(emailRegex.hasMatch(input));
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    decoration: const InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(247, 248, 250, 1),
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
                                  width: screenWidth * 0.9,
                                  height: 85,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        onSaved: (input) =>
                                            _loginRequest.Password = input!,
                                        validator: (input) => input!.length < 8
                                            ? "Password should be more than 7 characters"
                                            : null,
                                        controller: _passwordController,
                                        obscureText: _isObscured,
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 15,
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
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
                              padding: EdgeInsets.only(right: (screenWidth*0.1-20)),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordUI()));
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
                            height: 50,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isButtonClicked =
                                      true;
                                });
                                if (await validateAndSave(
                                    globalfromkey, context)) {
                                  print('Checking $userType');
                                  if (userType != null) {
                                    if (userType == 'isp_staff') {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ISPDashboardUI(
                                                shouldRefresh: true)),
                                              (route) => false
                                      );
                                    }
                                    else if (userType == 'bcc_staff') {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BCCDashboardUI(
                                                shouldRefresh: true)),
                                              (route) => false
                                      );
                                    }
                                    else if (userType == 'nttn_sbl_staff') {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NTTNDashboardUI(
                                                shouldRefresh: true)),
                                              (route) => false
                                      );
                                    }
                                    else if (userType == 'nttn_adsl_staff') {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NTTNDashboardUI(
                                                shouldRefresh: true)),
                                              (route) => false
                                      );
                                    } else{
                                      String errorMessage = 'Invalid User!, Please enter a valid email address.';
                                      showTopToast(context, errorMessage);
                                    }
                                  }
                                }
                                setState(() {
                                  _isButtonClicked =
                                      false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(25, 192, 122, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: Size(screenWidth * 0.9, 70),
                              ),
                              child: _isButtonClicked
                                  ? CircularProgressIndicator()
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
                                      builder: (context) => const SignupUI()));
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
    );
  }

  Future<bool> validateAndSave(
      GlobalKey<FormState> formKey, BuildContext context) async {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      final apiService = LoginAPIService();
      final loginRequestModel = LoginRequestmodel(
        Email: _emailController.text,
        Password: _passwordController.text,
      );
      try {
        final response = await apiService.login(loginRequestModel);
        if (response != null) {
          userType = response.userType;
          print('UserType :: $userType');
          _fetchUserProfile(response.token);
          return true;
        }
      } catch (e) {
        String errorMessage = 'Incorrect Email and Password.';
        if (e.toString().contains('Invalid User')) {
          errorMessage = 'Invalid User!, Please enter a valid email address.';
        } else if (e.toString().contains('Invalid Credentials')) {
          errorMessage = 'Incorrect Password. Try again.';
        } else if (e.toString().contains('The email field is required') ||
            e.toString().contains('The password field is required')) {
          errorMessage =
              'Email or password is empty. Please fill in both fields.';
        }
        showTopToast(context, errorMessage);
        return false;
      }
    }
    return false;
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

  late String AuthenToken;
  late final String? UserName;
  late final String? OrganizationName;
  late final String? PhotoURL;

  Future<void> _fetchUserProfile(String token) async {
    try {
      final apiService = await ProfileAPIService();
      if (!mounted) return;
      print('Mounted');

      final profile = await apiService.fetchUserProfile(token);
      final userProfile = UserProfile.fromJson(profile);
      print('Mounted Again');

      authCubit.login(userProfile, token, userType);
      print('Cubit UserType:: $userType');
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
}
