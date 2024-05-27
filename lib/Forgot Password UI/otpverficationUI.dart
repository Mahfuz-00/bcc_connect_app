import '../API Service (Forgot Password)/apiServiceOTPVerification.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Connection Checker/internetconnectioncheck.dart';
import 'createnewpasswordUI.dart';

class OPTVerfication extends StatefulWidget {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _sendOTP(String email, String OTP) async {
    final apiService = await APIServiceOTPVerification.create();
    apiService.OTPVerification(email, OTP).then((response) {
      if (response == 'Otp Verified Successfully') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateNewPassword())
        );
      } else if (response == 'Otp not match. Please resend forget password otp') {
        const snackBar = SnackBar(
          content: Text('OTP did not Match. Try again!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((error) {
      // Handle registration error
      print(error);
      const snackBar = SnackBar(
        content: Text('OTP did not Match. Try again!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    // Navigate to OTP verification screen
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Show circular loading indicator while waiting
        child: CircularProgressIndicator(),
      ),
    )
        :InternetChecker(
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
                      borderRadius:
                          BorderRadius.circular(10), // Optional: Rounded border
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
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30.0),
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
                                padding:
                                    const EdgeInsets.only(left: 30, right: 30),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 75,
                                      height: 70,
                                      child: TextFormField(
                                        controller: _firstdigitcontroller,
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                        decoration: const InputDecoration(
                                          /*filled: true,
                                              fillColor: Color.fromRGBO(247,248,250,255),*/
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: '',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 75,
                                      height: 70,
                                      child: TextFormField(
                                        controller: _seconddigitcontroller,
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: '',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 75,
                                      height: 70,
                                      child: TextFormField(
                                        controller: _thirddigitcontroller,
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: '',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 75,
                                      height: 70,
                                      child: TextFormField(
                                        controller: _forthdigitcontroller,
                                        style: const TextStyle(
                                          color:
                                              Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        ),
                                        decoration: const InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  25, 192, 122, 1),
                                              width: 2.0,
                                            ),
                                          ),
                                          labelText: '',
                                        ),
                                      ),
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
                                if (_firstdigitcontroller.text.isNotEmpty &&
                                    _seconddigitcontroller.text.isNotEmpty &&
                                    _thirddigitcontroller.text.isNotEmpty &&
                                    _forthdigitcontroller.text.isNotEmpty) {
                                  String OTP = _firstdigitcontroller.text +
                                      _seconddigitcontroller.text +
                                      _thirddigitcontroller.text +
                                      _forthdigitcontroller.text;
                                  print(OTP);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  String email =
                                      await prefs.getString('email') ?? '';
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
                                fixedSize: Size(350, 70),
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
                            onTap: () {
                              /*Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Login()));*/
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
