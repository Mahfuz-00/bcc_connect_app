import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceForgotPassword.dart';
import '../Login UI/loginUI.dart';
import 'otpverficationUI.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode(String email) async {
    final apiService = await APIServiceForgotPassword.create();
/*    apiService.sendForgotPasswordOTP(email);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OPTVerfication()),
    );*/
    apiService.sendForgotPasswordOTP(email).then((response) {
      if (response == 'Forget password otp send successfully') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OPTVerfication()),
        );
      } else if (response == 'validation error') {
        const snackBar = SnackBar(
          content: Text('Invalid Email'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      // Handle registration error
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
                          // Handle back button press here
                          Navigator.pop(
                              context); // This will pop the current route off the navigator stack
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
                              width: screenWidth*0.9,
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
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('email', email);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(25, 192, 122, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize: Size(screenWidth*0.9, 70),
                              ),
                              child: const Text(
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
