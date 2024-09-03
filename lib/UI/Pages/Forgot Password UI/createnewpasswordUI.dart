import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Forgot Password)/apiServiceCreateNewPassword.dart';
import '../../Bloc/email_cubit.dart';
import 'passwordchangedUI.dart';

/// [CreateNewPasswordUI] is a [StatefulWidget] that allows users to create a new password
/// as part of the password recovery process. It manages the input fields for the new
/// password and confirmation, validates the input, and interacts with the API to update
/// the password.
///
/// This widget includes:
/// - [_newPasswordcontroller]: Controller for the new password input field.
/// - [_confirmPasswordcontroller]: Controller for the confirm password input field.
/// - [_isLoading]: Indicates if the data is loading.
/// - [_pageloading]: Indicates if the password creation process is ongoing.
/// - [_isObscuredPassword]: Controls the visibility of the new password field.
/// - [_isObscuredConfirmPassword]: Controls the visibility of the confirm password field.
///
/// It features:
/// - A loading indicator while data is being fetched.
/// - Input validation to ensure passwords match and are not empty.
/// - Error handling for API responses with snack bars for user feedback.
///
/// Usage:
/// - Upon successful password update, it navigates to the [PasswordChangedUI] screen.
class CreateNewPasswordUI extends StatefulWidget {
  const CreateNewPasswordUI({super.key});

  @override
  State<CreateNewPasswordUI> createState() => _CreateNewPasswordUIState();
}

class _CreateNewPasswordUIState extends State<CreateNewPasswordUI> {
  bool _isLoading = true; // Indicates whether data is loading
  late TextEditingController _newPasswordcontroller = TextEditingController();
  late TextEditingController _confirmPasswordcontroller =
      TextEditingController();
  bool _pageloading = false;
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;

  /// Returns the icon for the new password field based on its obscurity state.
  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  /// Returns the icon for the confirm password field based on its obscurity state.
  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void initState() {
    super.initState();
    // Simulates a loading period before the UI is displayed
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Method to handle the creation of a new password
  Future<void> _createNewPassword(
      String email, String password, String confirmPassword) async {
    setState(() {
      _pageloading = true;
    });
    final apiService = await CreateNewPasswordAPIService.create();
    apiService.NewPassword(email, password, confirmPassword).then((response) {
      if (response == 'Password Update Successfully') {
        setState(() {
          _pageloading = false;
        });
        // Navigate to the PasswordChanged screen if password update is successful
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PasswordChangedUI()));
      }
    }).catchError((error) {
      setState(() {
        _pageloading = false;
      });
      print(error);
      const snackBar = SnackBar(
        content: Text('There was an error. Try again'),
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
        : InternetConnectionChecker(
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
                                  width: 2,
                                  color: Color.fromRGBO(25, 192, 122, 1)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios,
                                  color: Color.fromRGBO(25, 192, 122, 1)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Navigate back to the previous screen
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
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
                                  padding: const EdgeInsets.only(
                                      left: 30.0, right: 30.0),
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
                                  width: screenWidth * 0.9,
                                  height: 70,
                                  child: TextFormField(
                                    controller: _newPasswordcontroller,
                                    obscureText: _isObscuredPassword,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(247, 248, 250, 1),
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter your new password',
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
                                            _isObscuredPassword = !_isObscuredPassword;
                                            _newPasswordcontroller.text = _newPasswordcontroller.text;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  width: screenWidth * 0.9,
                                  height: 70,
                                  child: TextFormField(
                                    controller: _confirmPasswordcontroller,
                                    obscureText: _isObscuredConfirmPassword,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor:
                                          Color.fromRGBO(247, 248, 250, 1),
                                      border: OutlineInputBorder(),
                                      labelText: 'Confirm new password',
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
                                            _confirmPasswordcontroller.text =
                                                _confirmPasswordcontroller.text;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      // Check if both password fields are not empty
                                      if (_newPasswordcontroller
                                              .text.isNotEmpty &&
                                          _confirmPasswordcontroller
                                              .text.isNotEmpty) {
                                        if (_newPasswordcontroller.text !=
                                            _confirmPasswordcontroller.text) {
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'Password and Confirm Password did not Match'),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
                                          final email = (context
                                                  .read<EmailCubit>()
                                                  .state as EmailSaved)
                                              .email;
                                          print(
                                              'Retrieved email from Cubit: $email');
                                          print(email);
                                          _createNewPassword(
                                              email,
                                              _newPasswordcontroller.text,
                                              _confirmPasswordcontroller.text);
                                        }
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
                                    child: _pageloading
                                        ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                        : const Text('Submit',
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
