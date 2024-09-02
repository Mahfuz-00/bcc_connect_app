import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:footer/footer.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceForgotPassword.dart';
import '../../Bloc/email_cubit.dart';
import '../Login UI/loginUI.dart';
import 'otpverficationUI.dart';

/// This StatefulWidget represents the Forgot Password screen of the application.
/// It allows users to enter their email address to receive an OTP for password reset.
///
/// It uses [APIServiceForgotPassword] to handle the API calls for sending the OTP.
/// It utilizes the [EmailCubit] to manage the email state across the application.
///
/// Key features include:
/// - User input for email address
/// - Error handling for invalid email submissions
/// - Loading indicator while the OTP is being sent
/// - Navigation to OTP verification screen upon successful OTP request
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailController = TextEditingController();
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(); // Initialize email controller
  }

  @override
  void dispose() {
    _emailController
        .dispose(); // Dispose of email controller to free up resources
    super.dispose();
  }

  // Method to send OTP for password reset
  Future<void> _sendCode(String email) async {
    setState(() {
      _isloading = true;
    });
    final apiService = await APIServiceForgotPassword.create();
    apiService.sendForgotPasswordOTP(email).then((response) {
      if (response == 'Forget password otp send successfully') {
        // Navigate to OTP verification screen if OTP is sent successfully
        setState(() {
          _isloading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OPTVerfication()),
        );
      } else if (response == 'validation error') {
        setState(() {
          _isloading = false;
        });
        // Show snackbar if there is a validation error
        const snackBar = SnackBar(
          content: Text('Invalid Email'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      setState(() {
        _isloading = false;
      });
      // Handle any errors that occur during the API call
      print(error);
      const snackBar = SnackBar(
        content: Text('Invalid Email'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    // Navigate to OTP verification screen
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetChecker(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(25, 192, 122, 1), width: 2),
                        // Border properties
                        borderRadius: BorderRadius.circular(
                            10), // Optional: Rounded border
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Navigate back to the previous screen
                        },
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 30,
                        padding: EdgeInsets.all(10),
                        splashRadius: 30,
                        color: Color.fromRGBO(25, 192, 122, 1),
                        splashColor: Colors.grey,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'Forgot Password?',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromRGBO(25, 192, 122, 1),
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, right: 30.0),
                              child: Text(
                                'Don\'t worry! it occurs. Please Enter the Email address linked with your account',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            Container(
                              width: screenWidth * 0.9,
                              height: 70,
                              child: TextFormField(
                                controller: _emailController,
                                style: const TextStyle(
                                  color: Color.fromRGBO(143, 150, 158, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromRGBO(247, 248, 250, 1),
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
                            SizedBox(height: 50),
                            ElevatedButton(
                              onPressed: () async {
                                String email = _emailController.text;
                                _sendCode(email);
                                final emailCubit = context.read<EmailCubit>();
                                emailCubit.saveEmail(email);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(25, 192, 122, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: Size(screenWidth * 0.9, 70),
                              ),
                              child: _isloading
                                  ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                  : const Text(
                                      'Send Code',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'default',
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                            Text(
                              'Remember Password?  ',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigate to login screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Text(
                                'Login',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
    );
  }
}
