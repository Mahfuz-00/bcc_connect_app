import 'package:flutter/services.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceForgotPassword.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceOTPVerification.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/otpbox.dart';
import 'createnewpasswordUI.dart';

/// A screen for OTP (One Time Password) verification.
///
/// This screen allows users to enter the OTP sent to their email address.
/// Once the OTP is verified, users are navigated to the 'CreateNewPassword' screen.
///
/// The screen also includes a loading indicator that is displayed while
/// the initial setup is being completed.
class OPTVerfication extends StatefulWidget {
  /// Creates an instance of [OPTVerfication].
  const OPTVerfication({super.key});

  @override
  State<OPTVerfication> createState() => _OPTVerficationState();
}

class _OPTVerficationState extends State<OPTVerfication> {
  bool _isLoading = true;
  late TextEditingController _firstdigitcontroller = TextEditingController();
  late TextEditingController _seconddigitcontroller = TextEditingController();
  late TextEditingController _thirddigitcontroller = TextEditingController();
  late TextEditingController _forthdigitcontroller = TextEditingController();

  Future<void> _sendCode(String email) async {
    final apiService = await APIServiceForgotPassword();
    apiService.sendForgotPasswordOTP(email).then((response) {
      if (response == 'Forget password otp send successfully') {
        const snackBar = SnackBar(
          content: Text('Code Sent to your Email.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (response == 'validation error') {
        const snackBar = SnackBar(
          content: Text('Invalid Email'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      print(error);
      const snackBar = SnackBar(
        content: Text('Invalid Email'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
    super.initState();
    // Simulates a loading delay before showing the actual UI
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  /// Sends the OTP for verification.
  ///
  /// Calls the API to verify the OTP entered by the user. If successful, navigates to
  /// the 'CreateNewPassword' screen. If the OTP is incorrect, shows an error message.
  ///
  /// [email] - The email address associated with the OTP.
  /// [OTP] - The OTP entered by the user.
  Future<void> _sendOTP(String email, String OTP) async {
    final apiService = await APIServiceOTPVerification.create();
    apiService.OTPVerification(email, OTP).then((response) {
      if (response == 'Otp Verified Successfully') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateNewPassword()));
      } else if (response ==
          'Otp not match. Please resend forget password otp') {
        const snackBar = SnackBar(
          content: Text('OTP did not Match. Try again!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      print(error);
      const snackBar = SnackBar(
        content: Text('OTP did not Match. Try again!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              // Show circular loading indicator while waiting
              child: CircularProgressIndicator(),
            ),
          )
        : InternetChecker(
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
                                color: Color.fromRGBO(25, 192, 122, 1),
                                width: 2),
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
                                  'OTP Verification',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(25, 192, 122, 1),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default'),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
                                  child: Text(
                                    'Enter the Verification code we just sent on your email address',
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
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomTextFormField(
                                            textController:
                                                _firstdigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          CustomTextFormField(
                                            textController:
                                                _seconddigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          CustomTextFormField(
                                            textController:
                                                _thirddigitcontroller,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          CustomTextFormField(
                                            textController:
                                                _forthdigitcontroller,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      // Verify the entered OTP
                                      if (_firstdigitcontroller.text.isNotEmpty &&
                                          _seconddigitcontroller
                                              .text.isNotEmpty &&
                                          _thirddigitcontroller
                                              .text.isNotEmpty &&
                                          _forthdigitcontroller
                                              .text.isNotEmpty) {
                                        String OTP =
                                            _firstdigitcontroller.text +
                                                _seconddigitcontroller.text +
                                                _thirddigitcontroller.text +
                                                _forthdigitcontroller.text;
                                        print(OTP);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        String email =
                                            await prefs.getString('email') ??
                                                '';
                                        print(email);
                                        _sendOTP(email, OTP);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(25, 192, 122, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      fixedSize: Size(screenWidth * 0.9, 70),
                                    ),
                                    child: const Text('Verify',
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
                      SizedBox(height: 20),
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
                                  'Didn\'t recived code?  ',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final String? email =
                                        await prefs.getString('email');
                                    _sendCode(email!);
                                  },
                                  child: Text(
                                    'Resend',
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
              )),
            ),
          );
  }
}
