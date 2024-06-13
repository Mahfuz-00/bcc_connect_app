import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceCreateNewPassword.dart';
import 'passwordchangedUI.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  bool _isLoading = true;
  late TextEditingController _newPasswordcontroller = TextEditingController();
  late TextEditingController _confirmPasswordcontroller = TextEditingController();

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

  Future<void> _createNewPassword(String email, String password, String confirmPassword) async {
    final apiService = await APIServiceCreateNewPassword.create();
    apiService.NewPassword(email, password, confirmPassword).then((response) {
      if (response == 'Password Update Successfully') {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordChanged())
        );
      }
    }).catchError((error) {
      // Handle registration error
      print(error);
      const snackBar = SnackBar(
        content: Text('There was an error. Try again'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    // Navigate to OTP verification screen
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
        :InternetChecker(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Container(
                          padding: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: Color.fromRGBO(25, 192, 122, 1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                                color: Color.fromRGBO(25, 192, 122, 1)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Expanded(
                      child: Center(
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                'Enter new password',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: Color.fromRGBO(25, 192, 122, 1),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default'),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                child: Text(
                                  'Please enter a new password. Your new password must be different from any of your previous password',
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
                                  controller: _newPasswordcontroller,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(247,248,250,1),
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter your new password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth*0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _confirmPasswordcontroller,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(247,248,250,1),
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm new password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 50,),
                              ElevatedButton(
                                  onPressed: () async {
                                    if (_newPasswordcontroller.text.isNotEmpty &&
                                        _confirmPasswordcontroller.text.isNotEmpty) {
                                      if(_newPasswordcontroller.text != _confirmPasswordcontroller.text){
                                        const snackBar = SnackBar(
                                          content: Text('Password and Confirm Password did not Match'),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      } else{
                                        final prefs =
                                        await SharedPreferences.getInstance();
                                        String email =
                                            await prefs.getString('email') ?? '';
                                        print(email);
                                        _createNewPassword(email, _newPasswordcontroller.text, _confirmPasswordcontroller.text);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(25, 192, 122, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: Size(screenWidth*0.9, 70),
                                  ),
                                  child: const Text('Submit',
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
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
